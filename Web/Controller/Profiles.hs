module Web.Controller.Profiles where

import Web.Controller.Prelude
import Web.View.Profiles.Index
import Web.View.Profiles.New
import Web.View.Profiles.Edit
import Web.View.Profiles.Show

instance Controller ProfilesController where
    action ProfilesAction = do
        profiles <- query @Profile |> fetch
        render IndexView { .. }

    action NewProfileAction = do
        let profile = newRecord
                    |> set #userRole "general"
        render NewView { .. }

    action ShowProfileAction { profileId } = do
        profile <- fetch profileId
        render ShowView { .. }

    action EditProfileAction { profileId } = do
        profile <- fetch profileId
        render EditView { .. }

    action UpdateProfileAction { profileId } = do
        profile <- fetch profileId
        profile
            |> buildProfile
            |> ifValid \case
                Left profile -> render EditView { .. }
                Right profile -> do
                    profile <- profile |> updateRecord
                    setSuccessMessage "Profile updated"
                    redirectTo EditProfileAction { .. }

    action CreateProfileAction = do
        let profile = newRecord @Profile
        profile
            |> buildProfile
            |> ifValid \case
                Left profile -> render NewView { .. } 
                Right profile -> do
                    profile <- profile |> createRecord
                    setSuccessMessage "Profile created"
                    redirectTo ProfilesAction

    action DeleteProfileAction { profileId } = do
        profile <- fetch profileId
        deleteRecord profile
        
        setSuccessMessage "Profile deleted"
        redirectTo ProfilesAction

buildProfile profile = profile
    |> fill @["lastName","email","userRole","userName","userPassword", "firstName"]
