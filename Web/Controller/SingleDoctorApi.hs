{-# LANGUAGE OverloadedStrings #-}

module Web.Controller.SingleDoctorApi where

import Web.Controller.Prelude
import Data.Attoparsec.Char8
import Control.Applicative
import Web.Controller.Doctors


instance CanRoute SingleDoctorApiController where
    parseRoute' = do 
        doctorId <- string "/api/v1/doctor/" *> parseId <* "/"
        pure SingleDoctorApiAction{ doctorId }

instance HasPath SingleDoctorApiController where
    pathTo SingleDoctorApiAction { doctorId } = "/api/v1/doctor/" <> tshow doctorId <> "/"

instance Controller SingleDoctorApiController  where
    action SingleDoctorApiAction { doctorId }  = do
        doctor <- fetch doctorId
        renderJson (toJSON doctor )