module Web.Controller.Doctors where

import Web.Controller.Prelude
import Web.View.Doctors.Index
import Web.View.Doctors.New
import Web.View.Doctors.NewDoctor
import Web.View.Doctors.Edit
import Web.View.Doctors.Show
import Data.UUID

instance Controller DoctorsController where

    action NewProfileDoctorAction { profileId } = do
        
        case profileId of
            Id a -> do 
                    doctors <- query @Doctor
                        |> filterWhere (#profileId, a)
                        |> fetch
                    if Web.Controller.Prelude.null doctors then do
                            let doctor = newRecord
                                            |> set #profileId a
                            render NewDoctor { .. }
                        else do
                            setSuccessMessage "User is already a doctor"
                            allDoctors <- query @Doctor |> fetch
                            render IndexView { .. }  
            _ ->  do
                    let doctor = newRecord
                    render NewView { .. }  
        

    action DoctorsAction = do
        doctors <- query @Doctor |> fetch
        render IndexView { .. }

    action NewDoctorAction = do
        let doctor = newRecord
        render NewView { .. }

    action ShowDoctorAction { doctorId } = do
        doctor <- fetch doctorId
        render ShowView { .. }

    action EditDoctorAction { doctorId } = do
        doctor <- fetch doctorId
        render EditView { .. }

    action UpdateDoctorAction { doctorId } = do
        doctor <- fetch doctorId
        doctor
            |> buildDoctor
            |> ifValid \case
                Left doctor -> render EditView { .. }
                Right doctor -> do
                    doctor <- doctor |> updateRecord
                    setSuccessMessage "Doctor updated"
                    redirectTo EditDoctorAction { .. }

    action CreateDoctorAction = do
        let doctor = newRecord @Doctor
        doctor
            |> buildDoctor
            |> ifValid \case
                Left doctor -> render NewView { .. } 
                Right doctor -> do
                    doctor <- doctor |> createRecord
                    setSuccessMessage "Doctor created"
                    redirectTo DoctorsAction

    action DeleteDoctorAction { doctorId } = do
        doctor <- fetch doctorId
        deleteRecord doctor
        setSuccessMessage "Doctor deleted"
        redirectTo DoctorsAction

buildDoctor doctor = doctor
    |> fill @["realm","licenseNumber","profileId"]
