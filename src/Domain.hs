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


--ErrorMessage
data ErrorMessage = ErrorMessage Text
    deriving (Show)

instance ToJSON ErrorMessage where
    toJSON (ErrorMessage message) = object
        [
            "error" .= message
        ]


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
    , profileId :: Maybe Integer
    , gender :: Text
    , address :: Text
    , city :: Text
    } deriving (Show)

instance ToJSON Profile where
    toJSON Profile {..} = object [
            "cellphone" .= cellPhone,
            "email" .= email,
            "firstname" .= firstName,
            "lastname" .= lastName,
            "phone" .= phone,
            "username" .= userName,
            "userrole" .= userRole,
            "profileid" .= profileId,
            "gender" .= gender,
            "address" .= address,
            "city" .= city
        ]

instance FromJSON Profile where
    parseJSON (Object v) = Profile <$>
        v .:  "cellphone" <*>
        v .:  "email" <*>
        v .:  "firstname" <*>
        v .:  "lastname" <*>
        v .:  "phone" <*>
        v .:  "username" <*>
        v .:  "userpassword" <*>
        v .:  "userrole" <*>
        v .:?  "profileid" <*>
        v .: "gender" <*>
        v .: "address" <*>
        v .: "city"

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
            "doctorid" .= doctorId,
            "lincesenumber" .= licenseNumber,
            "profileid" .= relDoctorProfileId,
            "realm" .= realm
        ]

instance FromJSON Doctor where
    parseJSON (Object v) = Doctor <$>
        v .:  "doctorid" <*>
        v .:  "lincesenumber" <*>
        v .:  "profileid" <*>
        v .:  "realm"

-- Patient
data Patient = Patient
    {
        birthday :: LocalTime
        , patientId :: Maybe Integer
        , insuranceType :: Text
        , nationalId :: Text
        , preferredContactMethod :: Text
        , relPatientProfileId :: Integer
    }

instance ToJSON Patient where
    toJSON Patient {..} = object [
            "birthday" .= birthday,
            "patientid" .= patientId,
            "insurancetype" .= insuranceType,
            "nationalid" .= nationalId,
            "preferredcontactmethod" .= preferredContactMethod,
            "profileid" .= relPatientProfileId
        ]

instance FromJSON Patient where
    parseJSON (Object v) = Patient <$>
            v .: "birthday" <*>
            v .:? "patientid" <*>
            v .: "insurancetype" <*>
            v .: "nationalid" <*>
            v .: "preferredcontactmethod" <*>
            v .: "profileid"

-- Getters
getUserName :: Maybe Login -> Text
getUserName a = case a of
                Nothing -> ""
                Just (Login u p) -> u   

getPassword :: Maybe Login -> Text
getPassword a = case a of
                Nothing -> ""
                Just (Login u p) -> p

--- Patient view
data PatientView = PatientView
    {
        v_birthday :: LocalTime
        , v_patientId :: Integer
        , v_first_name :: Text
        , v_last_name :: Text
        , v_profileid :: Integer
    }

instance ToJSON PatientView where
    toJSON PatientView {..} = object [
            "birthday" .= v_birthday,
            "patientid" .= v_patientId,
            "firstname" .= v_first_name,
            "lastname" .= v_last_name,
            "profileid" .= v_profileid
        ]

--- Profile view
data ProfileView = ProfileView 
    {
        v_birthday_profile :: LocalTime
        , v_cell_phone :: Text
        , v_email :: Text
        , v_first_name_profile :: Text
        , v_id :: Integer
        , v_last_name_profile :: Text
        , v_phone :: Text
        , v_preferred_contact_method :: Text
        , v_profile_id :: Integer
    }

instance ToJSON ProfileView where
    toJSON ProfileView {..} = object [
            "birthday" .= v_birthday_profile,
            "patientid" .= v_id,
            "firstname" .= v_first_name_profile,
            "lastname" .= v_last_name_profile,
            "profileid" .= v_profile_id,
            "email" .= v_email,
            "cellphone" .= v_cell_phone,
            "phone" .= v_phone,
            "preferredcontactmethod" .= v_preferred_contact_method
        ]