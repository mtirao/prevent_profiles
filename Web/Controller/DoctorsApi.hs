{-# LANGUAGE OverloadedStrings #-}

module Web.Controller.DoctorsApi where

import Web.Controller.Prelude
import Data.Attoparsec.Char8
import Control.Applicative
import Web.Controller.Doctors


instance CanRoute DoctorsApiController where
    parseRoute' = string "/api/v1/doctors/" <* endOfInput >> pure DoctorApiAction

instance HasPath DoctorsApiController where
    pathTo DoctorApiAction  = "/api/v1/doctors/"

instance Controller DoctorsApiController  where
    action  DoctorApiAction = do
        testCaseApi <-query @Doctor |> fetch
        renderJson (toJSON testCaseApi)