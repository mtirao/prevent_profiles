{-# LANGUAGE OverloadedStrings #-}

module Web.Controller.AuthenticateApi where

import Web.Controller.Prelude
import Data.Attoparsec.Char8
import Control.Applicative
import Web.Controller.Profiles
import Network.HTTP.Types

data LoginMessage = LoginMessage 
    {
        message :: Text
    }

instance ToJSON LoginMessage where
    toJSON message = object
        [ "message" .= get #message message
        ]

data Login  = Login
    { username :: Text
    , password  :: Text
    } 

instance FromJSON Login where
    parseJSON (Object v) = Login <$>
        v .:  "username" <*>
        v .:  "password"

instance CanRoute AuthenticateApiController where
    parseRoute' = string "/api/v1/authenticate" <* endOfInput >> pure AuthenticateApiAction


instance HasPath AuthenticateApiController where
    pathTo AuthenticateApiAction = "/api/v1/authenticate"

instance Controller AuthenticateApiController  where
    action  AuthenticateApiAction = do
        body <- getRequestBody
        loginRequest <- return $ (decode body :: Maybe Login)

        case loginRequest of
            Nothing -> renderJsonWithStatusCode status400 (toJSON (LoginMessage "Invalid request"))
            Just a -> do 
                        profileApi <- query @Profile
                            |> filterWhere (#userName, username a)
                            |> filterWhere (#userPassword, password a)
                            |> fetch
                        case profileApi of
                            [] -> renderJsonWithStatusCode status403 (toJSON (LoginMessage "Authenticate Failed"))
                            (a:as) -> renderJson (toJSON a)