{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Db.Patients where

import Db.Db
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


instance DbOperation Patient where
    insert pool (Just a) = do
        res <- fetch pool ((birthday a), (insuranceType a), (nationalId a), (preferredContactMethod a), (relPatientProfileId a)) 
                            "INSERT INTO patients(birthday, insuranceType, nationalId, preferredContactMethod, relPatientProfileId) VALUES(?,?,?,?,?) RETURNING  birthday, patientId, insuranceType, nationalId, preferredContactMethod, relPatientProfileId" :: IO [(LocalTime, Integer, TL.Text, TL.Text, TL.Text, Integer)]
        return $ oneAgent res
            where oneAgent ((birthday, patientId, insuranceType, nationalId, preferredContactMethod, relPatientProfileId) : _) = Just $ Patient birthday patientId insuranceType nationalId preferredContactMethod relPatientProfileId
                  oneAgent _ = Nothing
    
    update pool (Just a) id= do
        res <- fetch pool ((birthday a), (insuranceType a), (nationalId a), (preferredContactMethod a), (relPatientProfileId a)) 
                            "UPDATE agents SET agenttype=?, ip=?  WHERE id=?" :: IO [(LocalTime, Integer, TL.Text, TL.Text, TL.Text, Integer)]
        return $ oneAgent res
            where oneAgent ((birthday, patientId, insuranceType, nationalId, preferredContactMethod, relPatientProfileId) : _) = Just $ Patient birthday patientId insuranceType nationalId preferredContactMethod relPatientProfileId
                  oneAgent _ = Nothing

    find  pool id = do 
                        res <- fetch pool (Only id) "SELECT id,birthday, insuranceType, nationalId, preferredContactMethod, relPatientProfileId FROM patients WHERE id=?" :: IO [(LocalTime, Integer, TL.Text, TL.Text, TL.Text, Integer)]
                        return $ oneAgent res
                            where oneAgent ((birthday, patientId, insuranceType, nationalId, preferredContactMethod, relPatientProfileId) : _) = Just $ Patient birthday patientId insuranceType nationalId preferredContactMethod relPatientProfileId
                                  oneAgent _ = Nothing

    list  pool = do
                    res <- fetchSimple pool "SELECT id, birthday, insuranceType, nationalId, preferredContactMethod, relPatientProfileId FROM patients" :: IO [(LocalTime, Integer, TL.Text, TL.Text, TL.Text, Integer)]
                    return $ map (\(birthday, patientId, insuranceType, nationalId, preferredContactMethod, relPatientProfileId) -> Patient birthday patientId insuranceType nationalId preferredContactMethod relPatientProfileId) res
