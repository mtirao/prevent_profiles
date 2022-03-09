{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Controller.PatientsController where

import Domain
import Views
import Db.Patients
import Db.Db

import Web.Scotty
import Web.Scotty.Internal.Types (ActionT)


import Control.Monad.IO.Class
import Database.PostgreSQL.Simple
import Data.Pool(Pool, createPool, withResource)
import qualified Data.Text.Lazy as TL
import qualified Data.Text.Lazy.Encoding as TL
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Text as T

import GHC.Int
import GHC.Generics (Generic)

import Network.Wai.Middleware.Static
import Network.Wai.Middleware.RequestLogger (logStdout)
import Network.HTTP.Types.Status

import Data.Aeson

---CREATE
createPatient pool = do
                        b <- body
                        patient <- return $ (decode b :: Maybe Patient)
                        case patient of
                            Nothing -> status status400
                            Just _ -> patientResponse pool patient

patientResponse pool patient = do 
                                dbPatient <- liftIO $ insert pool patient
                                case dbPatient of
                                        Nothing -> status status400
                                        Just a -> dbPatientResponse 
                                                where dbPatientResponse  = do
                                                                        jsonResponse a
                                                                        status status201
--- GET & LIST
listPatient pool =  do
                        patients <- liftIO $ (vlist pool :: IO [PatientView])
                        jsonResponse patients