{-# LANGUAGE OverloadedStrings #-}

module Web.Controller.DoctorsApi where

import Web.Controller.Prelude
import Data.Attoparsec.Char8
import Control.Applicative


instance CanRoute DoctorsApiController where
    parseRoute' = string "/api/v1/doctors" <* endOfInput >> pure DoctorApiAction

instance HasPath DoctorsApiController where
    pathTo DoctorApiAction  = "/api/v1/doctors"
    

instance ToJSON Doctor where
    toJSON doctor= object
        [ "id" .= get #id doctor
        , "profile" .= get #profileId doctor
        , "license" .= get #licenseNumber doctor
        , "realm" .= get #licenseNumber doctor
        ]

instance Controller DoctorsApiController  where
    action  DoctorApiAction = do
        testCaseApi <-query @Doctor |> fetch
        renderJson (toJSON testCaseApi)
