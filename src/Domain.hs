{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE RecordWildCards       #-}


module Domain where

import Data.Text.Lazy
import Data.Text.Lazy.Encoding
import Data.Aeson
import Control.Applicative
import GHC.Generics
import Data.Time.LocalTime


-- Login
data Login = Login Text Text -- username password
    deriving (Show)

instance ToJSON Login where
    toJSON (Login username password) = object
        [
            "username" .= username,
            "password" .= password
        ]

instance FromJSON Login where
    parseJSON (Object v) = Login <$>
        v .:  "username" <*>
        v .:  "password"

-- Profile
data Profile = Profile
    {cellPhone :: Text
    , email :: Text
    , firstName :: Text
    , lastName :: Text
    , phone :: Text
    , userName :: Text
    , userPassword :: Text
    , userRole :: Text
    , profileId :: Integer
    }deriving (Show)

instance ToJSON Profile where
    toJSON Profile {..} = object [
        [
            "cellphone" .= cellPhone,
            "email" .= email,
            "firstname" .= firstName,
            "lastname" .= lastName,
            "phone" .= phone,
            "username" .= userName,
            "userrole" .= userRole,
            "profileid" .= profileId
        ]

-- Doctor
data Doctor = Doctor
    {
        doctorId :: Integer
        , licenseNumber :: Text
        , relDoctorProfileId :: Integer
        , realm :: Text
    }

instance ToJSON Doctor where
    toJSON Doctor {..} = object [
        [
            "doctorid" .= doctorId,
            "lincesenumber" .= licenseNumber,
            "profileid" .= relDoctorProfileId,
            "realm" .= realm

-- Patient
data Patient = Patient
    {
        birthday :: LocalTime
        , patientId :: Integer
        , insuranceType :: Text
        , nationalId :: Text
        , preferredContactMethod :: Text
        , relPatientProfileId :: Integer
    }

instance ToJSON Patient where
    toJSON Patient {..} object [
        "birthday" .= doctorId,
        "patientid" .= licenseNumber,
        "insurancetype" .= insuranceType,
        "nationalId" .= nationalId,
        "preferredContactMethod" .= preferredContactMethod,
        "profileid" .= relPatientProfileId
    ]