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
        res <- fetch pool ((cellPhone a), (email a), (firstName a), (lastName a), (phone a), (userName a), (userPassword a), (userRole a)) 
                            "INSERT INTO profiles(cell_phone, email, first_name, last_name, phone, user_name, user_password, user_role) VALUES(?,?,?,?,?,?,?,?) RETURNING  cell_phone, email, first_name, last_name, phone, user_name, user_password, user_role, id" :: IO [(TL.Text, TL.Text,TL.Text,TL.Text,TL.Text,TL.Text,TL.Text,TL.Text, Maybe Integer)]
        return $ oneAgent res
            where oneAgent ((cellPhone, email, firstName, lastName, phone, userName, userPassword, userRole, id) : _) = Just $ Profile cellPhone email firstName lastName phone userName userPassword userRole id
                  oneAgent _ = Nothing
    
    update pool (Just a) id= do
        res <- fetch pool ((cellPhone a), (email a), (firstName a), (lastName a), (phone a), (userName a), (userPassword a), (userRole a), id) 
                            "UPDATE profiles SET cell_phone=?, email=?, first_name=?, last_name=?, phone=?, user_name=?, user_password=?, user_role=?  WHERE id=?" :: IO [(TL.Text,TL.Text, TL.Text,TL.Text,TL.Text,TL.Text,TL.Text,TL.Text, Maybe Integer)]
        return $ oneAgent res
            where oneAgent ((cellPhone, email, firstName, lastName, phone, userName, userPassword, userRole, id) : _) = Just $ Profile cellPhone email firstName lastName phone userName userPassword userRole id
                  oneAgent _ = Nothing

    find  pool id = do 
                        res <- fetch pool (Only id) "SELECT cell_phone, email, first_name, last_name, phone, user_name, user_password, user_role, id FROM profiles WHERE id=?" :: IO [(TL.Text,TL.Text,TL.Text,TL.Text,TL.Text,TL.Text,TL.Text,TL.Text, Maybe Integer)]
                        return $ oneAgent res
                           where oneAgent ((cellPhone, email, firstName, lastName, phone, userName, userPassword, userRole, id) : _) = Just $ Profile cellPhone email firstName lastName phone userName userPassword userRole id
                                 oneAgent _ = Nothing
    
    list  pool = do
                    res <- fetchSimple pool "SELECT cell_phone, email, first_name, last_name, phone, user_name, user_password, user_role, id FROM profiles" :: IO [(TL.Text,TL.Text,TL.Text,TL.Text,TL.Text,TL.Text,TL.Text,TL.Text, Maybe Integer)]
                    return $ map (\(cellPhone, email, firstName, lastName, phone, userName, userPassword, userRole, id) -> Profile cellPhone email firstName lastName phone userName userPassword userRole id) res
