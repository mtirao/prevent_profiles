{-# LANGUAGE OverloadedStrings #-}

module Web.Controller.ProfilesApi where

import Web.Controller.Prelude
import Data.Attoparsec.Char8
import Control.Applicative


instance CanRoute ProfilesApiController where
    parseRoute' = string "/api/v1/profiles" <* endOfInput >> pure ProfileApiAction

instance HasPath ProfilesApiController where
    pathTo ProfileApiAction = "/api/v1/profiles"
    

instance ToJSON Profile where
    toJSON profile = object
        [ "id" .= get #id profile
        , "mobile" .= get #cellPhone profile
        , "firstname" .= get #firstName profile
        , "lastname" .= get #lastName profile
        , "phone" .= get #phone profile
        , "username" .= get #userName profile
        , "userrole" .= get #userRole profile
        , "email" .= get #email profile
        ]

instance Controller ProfilesApiController  where
    action  ProfileApiAction = do
        testCaseApi <-query @Profile |> fetch
        renderJson (toJSON testCaseApi)
