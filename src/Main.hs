module Main where

import Db.Db as Db

import Domain
import Views

import Controller.ProfilesController
import Controller.PatientsController

import qualified Data.Configurator as C
import qualified Data.Configurator.Types as C
import qualified Data.Text.Lazy as TL
import Data.Pool(createPool)
import Data.Aeson

import Web.Scotty
import Web.Scotty.Internal.Types (ActionT)

import Database.PostgreSQL.Simple

import Control.Monad.IO.Class

import Network.Wai.Middleware.Static
import Network.Wai.Middleware.RequestLogger (logStdout)
import Network.HTTP.Types.Status

-- Parse file "application.conf" and get the DB connection info
makeDbConfig :: C.Config -> IO (Maybe Db.DbConfig)
makeDbConfig conf = do
    dbConfname <- C.lookup conf "database.name" :: IO (Maybe String)
    dbConfUser <- C.lookup conf "database.user" :: IO (Maybe String)
    dbConfPassword <- C.lookup conf "database.password" :: IO (Maybe String)
    dbConfHost <- C.lookup conf "database.host" :: IO (Maybe String)
    return $ DbConfig <$> dbConfname
                    <*> dbConfUser
                    <*> dbConfPassword
                    <*> dbConfHost


main :: IO ()
main = do
    loadedConf <- C.load [C.Required "application.conf"]
    dbConf <- makeDbConfig loadedConf
    
    case dbConf of
        Nothing -> putStrLn "No database configuration found, terminating..."
        Just conf -> do      
            pool <- createPool (newConn conf) close 1 40 10
            scotty 3000 $ do
                middleware $ staticPolicy (noDots >-> addBase "static") -- serve static files
                middleware $ logStdout    


                -- AUTH
                post   "/api/prevent/accounts/login" $ do 
                                            b <- body
                                            login <- return $ (decode b :: Maybe Login)
                                            result <- liftIO $ findUserByLogin pool (TL.unpack (getUserName login))
                                            case result of 
                                                Nothing -> do 
                                                            jsonResponse (ErrorMessage "User not found")
                                                            status forbidden403
                                                Just a -> 
                                                            if (userPassword a) == (getPassword login) 
                                                            then jsonResponse a
                                                            else do 
                                                                    jsonResponse (ErrorMessage "Wrong password") 
                                                                    status forbidden403


                -- PROFILES
                post "/api/prevent/profile" $ createProfile pool
                get "/api/prevent/profile/:id" $ do 
                                                idd <- param "id" :: ActionM TL.Text
                                                getProfile pool idd

                -- PATIENTS
                post "/api/prevent/patient" $ createPatient pool
                get "/api/prevent/patients" $ listPatient pool