{-# LANGUAGE OverloadedStrings #-}

module Web.Controller.SingleProfileApi where

import Web.Controller.Prelude
import Data.Attoparsec.Char8
import Control.Applicative
import Web.Controller.Profiles


instance CanRoute SingleProfileApiController where
    parseRoute' = do 
        profileId <- string "/api/v1/profile/" *> parseId <* "/"
        pure SingleProfileApiAction{ profileId }

instance HasPath SingleProfileApiController where
    pathTo SingleProfileApiAction { profileId } = "/api/v1/profile/" <> tshow profileId <> "/"

instance Controller SingleProfileApiController  where
    action SingleProfileApiAction { profileId }  = do
        profile <- fetch profileId
        renderJson (toJSON profile )