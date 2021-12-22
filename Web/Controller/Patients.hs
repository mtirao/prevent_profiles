module Web.Controller.Patients where

import Web.Controller.Prelude
import Web.View.Patients.Index
import Web.View.Patients.New
import Web.View.Patients.Edit
import Web.View.Patients.Show

instance Controller PatientsController where
    action PatientsAction = do
        patients <- query @Patient |> fetch
        render IndexView { .. }

    action NewPatientAction = do
        let patient = newRecord
        render NewView { .. }

    action ShowPatientAction { patientId } = do
        patient <- fetch patientId
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
