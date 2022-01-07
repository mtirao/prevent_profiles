{-# LANGUAGE OverloadedStrings #-}

module Web.Controller.ProfilesApi where

import Web.Controller.Prelude
import Data.Attoparsec.Char8
import Control.Applicative
import Web.Controller.Profiles

instance CanRoute ProfilesApiController where
    parseRoute' = string "/api/v1/profiles" <* endOfInput >> pure ProfileApiAction

instance HasPath ProfilesApiController where
    pathTo ProfileApiAction = "/api/v1/profiles"
    

instance Controller ProfilesApiController  where
    action  ProfileApiAction = do
        testCaseApi <-query @Profile |> fetch
        renderJson (toJSON testCaseApi)
