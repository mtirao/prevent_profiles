{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE RecordWildCards #-}

module Doctors where

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


instance DbOperation Doctor where
    insert pool (Just a) = do
        res <- fetch pool ((licenseNumber a), (relDoctorProfileId a), (realm a)) 
                            "INSERT INTO doctors(license_number, profile_id, realm) VALUES(?, ?,?) RETURNING  id, license_number, profile_id, realm" :: IO [(Maybe Integer, TL.Text, Integer, TL.Text)]
        return $ oneAgent res
            where oneAgent ((id, license_number, profileId, realm) : _) = Just $ Doctor id license_number profileId realm
                  oneAgent _ = Nothing
    
    update pool (Just a) id= do
        res <- fetch pool ((realm a), (licenseNumber a), id) 
                            "UPDATE doctors SET realm=?, license_number=?  WHERE id=? RETURNING  id, license_number, profile_id, realm" :: IO [(Maybe Integer, TL.Text, Integer, TL.Text)]
        return $ oneAgent res
             where oneAgent ((id, license_number, profileId, realm) : _) = Just $ Doctor id license_number profileId realm
                   oneAgent _ = Nothing

    find  pool id = do 
                        res <- fetch pool (Only id) "SELECT id, license_number, pprofile_id, realm FROM doctors WHERE id=?" :: IO [(Maybe Integer, TL.Text, Integer, TL.Text)]
                        return $ oneAgent res
                            where oneAgent ((id, license_number, profileId, realm) : _) = Just $ Doctor id license_number profileId realm
                                  oneAgent _ = Nothing

    list  pool = do
                    res <- fetchSimple pool "SELECT id, license_number, profile_id, realm FROM doctors" :: IO [(Maybe Integer, TL.Text, Integer, TL.Text)]
                    return $ map (\(id, license_number, profileId, realm) -> Doctor id license_number profileId realm) res


instance DbViewOperation DoctorView where
    vlist pool = do
                    res <- fetchSimple pool "SELECT realm, id, first_name, last_name, profile_id FROM doctor_view" :: IO [(TL.Text, Integer, TL.Text, TL.Text, Integer)]
                    return $ map (\(realm, doctorId, firstName, lastName, profileid) -> DoctorView realm doctorId firstName lastName profileid) res

    vfind pool id = do 
                        res <- fetch pool (Only id) "SELECT realm, id, first_name, last_name, profile_id FROM doctor_view WHERE id=?" :: IO [(TL.Text, Integer, TL.Text, TL.Text, Integer)]
                        return $ oneAgent res
                            where oneAgent ((realm, doctorId, firstName, lastName, profileid) : _) = Just $ DoctorView realm doctorId firstName lastName profileid
                                  oneAgent _ = Nothing
