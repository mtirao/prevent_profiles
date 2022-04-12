{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Db.Profiles where


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


instance DbOperation Profile where
    insert pool (Just a) = do
        res <- fetch pool ((cellPhone a), (email a), (firstName a), (lastName a), (phone a), (userName a), (userPassword a), (userRole a), (gender a), (address a), (city a)) 
                            "INSERT INTO profiles(cell_phone, email, first_name, last_name, phone, user_name, user_password, user_role, gender, address, city) VALUES(?,?,?,?,?,?,?,?,?,?,?) RETURNING  cell_phone, email, first_name, last_name, phone, user_name, user_password, user_role, id, gender, address, city" :: IO [(TL.Text, TL.Text,TL.Text,TL.Text,TL.Text, Maybe TL.Text, Maybe TL.Text, Maybe TL.Text, Maybe Integer, TL.Text, TL.Text, TL.Text)]
        return $ oneAgent res
            where oneAgent ((cellPhone, email, firstName, lastName, phone, userName, userPassword, userRole, id, gender, address, city) : _) = Just $ Profile cellPhone email firstName lastName phone userName userPassword userRole id gender address city
                  oneAgent _ = Nothing
    
    update pool (Just a) id= do
        res <- fetch pool ((cellPhone a), (email a), (firstName a), (lastName a), (phone a), (gender a), (address a), (city a), id) 
                            "UPDATE profiles SET cell_phone=?, email=?, first_name=?, last_name=?, phone=?, gender=?, address=?, city=? WHERE id=? RETURNING  cell_phone, email, first_name, last_name, phone, user_name, user_password, user_role, id, gender, address, city" :: IO [(TL.Text, TL.Text,TL.Text,TL.Text,TL.Text, Maybe TL.Text, Maybe TL.Text, Maybe TL.Text, Maybe Integer, TL.Text, TL.Text, TL.Text)]
        return $ oneAgent res
            where oneAgent ((cellPhone, email, firstName, lastName, phone, userName, userPassword, userRole, id, gender, address, city) : _) = Just $ Profile cellPhone email firstName lastName phone userName userPassword userRole id gender address city
                  oneAgent _ = Nothing

    find  pool id = do 
                        res <- fetch pool (Only id) "SELECT cell_phone, email, first_name, last_name, phone, user_name, user_password, user_role, id, gender, address, city FROM profiles WHERE id=?" :: IO [(TL.Text, TL.Text,TL.Text,TL.Text,TL.Text, Maybe TL.Text, Maybe TL.Text, Maybe TL.Text, Maybe Integer, TL.Text, TL.Text, TL.Text)]
                        return $ oneAgent res
                           where oneAgent ((cellPhone, email, firstName, lastName, phone, userName, userPassword, userRole, id, gender, address, city) : _) = Just $ Profile cellPhone email firstName lastName phone userName userPassword userRole id gender address city
                                 oneAgent _ = Nothing
    
    list  pool = do
                    res <- fetchSimple pool "SELECT cell_phone, email, first_name, last_name, phone, user_name, user_password, user_role, id, gender, address, city FROM profiles" :: IO [(TL.Text, TL.Text,TL.Text,TL.Text,TL.Text, Maybe TL.Text, Maybe TL.Text, Maybe TL.Text, Maybe Integer, TL.Text, TL.Text, TL.Text)]
                    return $ map (\(cellPhone, email, firstName, lastName, phone, userName, userPassword, userRole, id, gender, address, city) -> Profile cellPhone email firstName lastName phone userName userPassword userRole id gender address city) res




instance DbViewOperation ProfileView where
    vlist pool = do
                    res <- fetchSimple pool "SELECT birthday, cell_phone, email, first_name, profile_id, last_name, phone, user_role, preferred_contact_method, doctor_id, realm, license_number, patient_id, city, address  FROM profile_view" :: IO [(Maybe LocalTime,  TL.Text, TL.Text,  TL.Text, Integer, TL.Text, TL.Text, TL.Text, Maybe TL.Text, Maybe Integer, Maybe TL.Text, Maybe TL.Text, Maybe Integer, TL.Text, TL.Text)]
                    return $ map (\(birthday, cellPhone, email, firstName, id, lastName, phone, userRole, preferredContactMethod, doctorId, realm, licenseNumber, patientId, city, address) -> ProfileView birthday cellPhone email firstName id lastName phone userRole preferredContactMethod doctorId realm licenseNumber patientId city address) res

    vfind pool id = do 
                        res <- fetch pool (Only id) "SELECT birthday, cell_phone, email, first_name, profile_id, last_name, phone, user_role, preferred_contact_method, doctor_id, realm, license_number, patient_id, city, address FROM profile_view WHERE profile_id=?" :: IO [(Maybe LocalTime,  TL.Text, TL.Text,  TL.Text, Integer, TL.Text, TL.Text, TL.Text, Maybe TL.Text, Maybe Integer, Maybe TL.Text, Maybe TL.Text, Maybe Integer, TL.Text, TL.Text)]
                        return $ oneAgent res
                            where oneAgent ((birthday, cellPhone, email, firstName, id, lastName, phone, userRole, preferredContactMethod, doctorId, realm, licenseNumber, patientId, city, address) : _) = Just $ ProfileView birthday cellPhone email firstName id lastName phone userRole preferredContactMethod doctorId realm licenseNumber patientId city address
                                  oneAgent _ = Nothing
