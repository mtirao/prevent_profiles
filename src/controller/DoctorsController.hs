{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module DoctorsController where

import Domain
import Views
import Doctors
import Db

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
createDoctor pool = do
                        b <- body
                        doctor <- return $ (decode b :: Maybe Doctor)
                        case doctor of
                            Nothing -> status status400
                            Just _ -> doctorResponse pool doctor

doctorResponse pool doctor = do 
                                dbDoctor <- liftIO $ insert pool doctor
                                case dbDoctor of
                                        Nothing -> status status400
                                        Just a -> dbDoctorResponse 
                                                where dbDoctorResponse  = do
                                                                        jsonResponse a
                                                                        status status201

---UPDTAE
updateDoctor pool id = do
                        b <- body
                        doctor <- return $ (decode b :: Maybe Doctor)
                        case doctor of
                            Nothing -> status status404
                            Just _ -> updatDoctorResponse pool doctor id

updatDoctorResponse pool doctor id  = do
                                        dbDoctor <- liftIO $  update pool doctor id
                                        case dbDoctor of
                                                Nothing -> status status400
                                                Just a -> dbDoctorResponse 
                                                        where dbDoctorResponse  = do
                                                                                jsonResponse a
                                                                                status status201

-- GET & LIST
listDoctor pool =  do
                        doctors <- liftIO $ (vlist pool :: IO [DoctorView])
                        jsonResponse doctors