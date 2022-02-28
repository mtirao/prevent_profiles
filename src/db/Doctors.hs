{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE RecordWildCards #-}

module Db.Doctors where

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


instance DbOperation Doctor where
    insert pool (Just a) = do
        res <- fetch pool ((licenseNumber a), (relDoctorProfileId a), (realm a)) 
                            "INSERT INTO doctors(license_number profileId realm) VALUES(? ?,?) RETURNING  id, license_number profileId realm" :: IO [(Integer, TL.Text, Integer, TL.Text)]
        return $ oneAgent res
            where oneAgent ((id, license_number, profileId, realm) : _) = Just $ Doctor id license_number profileId realm
                  oneAgent _ = Nothing
    
    update pool (Just a) id= do
        res <- fetch pool ((licenseNumber a), (relDoctorProfileId a), (realm a)) 
                            "UPDATE agents SET agenttype=?, ip=?  WHERE id=?" :: IO [(Integer, TL.Text, Integer, TL.Text)]
        return $ oneAgent res
             where oneAgent ((id, license_number, profileId, realm) : _) = Just $ Doctor id license_number profileId realm
                   oneAgent _ = Nothing

    find  pool id = do 
                        res <- fetch pool (Only id) "SELECT id, license_number, profileId, realm FROM doctors WHERE id=?" :: IO [(Integer, TL.Text, Integer, TL.Text)]
                        return $ oneAgent res
                            where oneAgent ((id, license_number, profileId, realm) : _) = Just $ Doctor id license_number profileId realm
                                  oneAgent _ = Nothing

    list  pool = do
                    res <- fetchSimple pool "SELECT id, license_number, profileId, realm FROM agents" :: IO [(Integer, TL.Text, Integer, TL.Text)]
                    return $ map (\(id, license_number, profileId, realm) -> Doctor id license_number profileId realm) res
