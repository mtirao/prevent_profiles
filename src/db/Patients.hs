{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Patients where

import Db
import Domain

import Web.Scotty.Internal.Types (ActionT)
import GHC.Generics (Generic)
import Control.Monad.IO.Class
import Database.PostgreSQL.Simple
import Data.Pool(Pool, createPool, withResource)
import qualified Data.Text.Lazy as TL
import qualified Data.Text.Lazy.Encoding as TL
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Text as T
import GHC.Int
import Data.Time.LocalTime
import Data.Time.Clock
import Data.Time.Calendar


instance DbOperation Patient where
    insert pool (Just a) = do
        res <- fetch pool ((birthday a), (insuranceType a), (nationalId a), (preferredContactMethod a), (relPatientProfileId a)) 
                            "INSERT INTO patients(birthday, insurance_type, national_id, preferred_contact_method, profile_id) VALUES(?,?,?,?,?) RETURNING  birthday, id, insurance_type, national_id, preferred_contact_method, profile_id" :: IO [(LocalTime, Maybe Integer, TL.Text, TL.Text, TL.Text, Integer)]
        return $ oneAgent res
            where oneAgent ((birthday, patientId, insuranceType, nationalId, preferredContactMethod, relPatientProfileId) : _) = Just $ Patient birthday patientId insuranceType nationalId preferredContactMethod relPatientProfileId
                  oneAgent _ = Nothing
    
    update pool (Just a) id= do
        res <- fetch pool ((birthday a), (insuranceType a), (nationalId a), (preferredContactMethod a), (relPatientProfileId a)) 
                            "UPDATE agents SET agenttype=?, ip=?  WHERE id=?" :: IO [(LocalTime, Maybe Integer, TL.Text, TL.Text, TL.Text, Integer)]
        return $ oneAgent res
            where oneAgent ((birthday, patientId, insuranceType, nationalId, preferredContactMethod, relPatientProfileId) : _) = Just $ Patient birthday patientId insuranceType nationalId preferredContactMethod relPatientProfileId
                  oneAgent _ = Nothing

    find  pool id = do 
                        res <- fetch pool (Only id) "SELECT birthday, id, insuranceType, nationalId, preferredContactMethod, relPatientProfileId FROM patients WHERE id=?" :: IO [(LocalTime, Maybe Integer, TL.Text, TL.Text, TL.Text, Integer)]
                        return $ oneAgent res
                            where oneAgent ((birthday, patientId, insuranceType, nationalId, preferredContactMethod, relPatientProfileId) : _) = Just $ Patient birthday patientId insuranceType nationalId preferredContactMethod relPatientProfileId
                                  oneAgent _ = Nothing

    list  pool = do
                    res <- fetchSimple pool "SELECT birthday, id, insuranceType, nationalId, preferredContactMethod, relPatientProfileId FROM patients" :: IO [(LocalTime, Maybe Integer, TL.Text, TL.Text, TL.Text, Integer)]
                    return $ map (\(birthday, patientId, insuranceType, nationalId, preferredContactMethod, relPatientProfileId) -> Patient birthday patientId insuranceType nationalId preferredContactMethod relPatientProfileId) res


instance DbViewOperation PatientView where
    vlist pool = do
                    res <- fetchSimple pool "SELECT birthday, id, last_name, first_name, profile_id FROM patient_view" :: IO [(LocalTime, Integer, TL.Text, TL.Text, Integer)]
                    return $ map (\(birthday, patientId, lastName, firstName, profileid) -> PatientView birthday patientId firstName lastName profileid) res

    vfind pool id = do 
                        res <- fetch pool (Only id) "SELECT birthday, id, last_name, first_name, profile_id FROM patient_view WHERE id=?" :: IO [(LocalTime, Integer, TL.Text, TL.Text, Integer)]
                        return $ oneAgent res
                            where oneAgent ((birthday, patientId, lastName, firstName, profileid) : _) = Just $ PatientView birthday patientId firstName lastName profileid
                                  oneAgent _ = Nothing
