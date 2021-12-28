module Web.Controller.Patients where

import Web.Controller.Prelude
import Web.View.Patients.Index
import Web.View.Patients.New
import Web.View.Patients.Edit
import Web.View.Patients.Show
import Web.View.Patients.NewPatient
import qualified Data.Time.Format as LT

instance Controller PatientsController where
    action NewProfilePatientAction { profileId } = do

        case profileId of
            Id a -> do 
                    patients <- query @Patient
                        |> filterWhere (#profileId, a)
                        |> fetch
                    if Web.Controller.Prelude.null patients then do
                            let patient = newRecord
                                    |> set #profileId a
                            render NewPatientView { .. }
                        else do
                            setSuccessMessage "User is already a patient"
                            allPatients <- query @Patient |> fetch
                            render IndexView { .. }  
            _ ->  do
                    let patient = newRecord
                    render NewView { .. }    

    action PatientsAction = do
        patients <- query @Patient |> fetch
        render IndexView { .. }

    action NewPatientAction = do
        let patient = newRecord
        render NewView { .. }

    action ShowPatientAction { patientId } = do
        patient <- fetch patientId

        let patienBirthday = LT.formatTime LT.defaultTimeLocale "%0Y-%m-%d" (get #birthday patient)

        render ShowView { .. }

    action EditPatientAction { patientId } = do
        patient <- fetch patientId
        render EditView { .. }

    action UpdatePatientAction { patientId } = do
        patient <- fetch patientId
        patient
            |> buildPatient
            |> ifValid \case
                Left patient -> render EditView { .. }
                Right patient -> do
                    patient <- patient |> updateRecord
                    setSuccessMessage "Patient updated"
                    redirectTo EditPatientAction { .. }

    action CreatePatientAction = do
        let patient = newRecord @Patient
        patient
            |> buildPatient
            |> ifValid \case
                Left patient -> render NewView { .. } 
                Right patient -> do
                    patient <- patient |> createRecord
                    setSuccessMessage "Patient created"
                    redirectTo PatientsAction

    action DeletePatientAction { patientId } = do
        patient <- fetch patientId
        deleteRecord patient
        setSuccessMessage "Patient deleted"
        redirectTo PatientsAction

buildPatient patient = patient
    |> fill @["insuranceType","preferredContactMethod","profileId","nationalId","birthday"]