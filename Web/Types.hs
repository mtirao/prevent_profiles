module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController = WelcomeAction deriving (Eq, Show, Data)

data ProfilesController
    = ProfilesAction
    | NewProfileAction
    | ShowProfileAction { profileId :: !(Id Profile) }
    | CreateProfileAction
    | EditProfileAction { profileId :: !(Id Profile) }
    | UpdateProfileAction { profileId :: !(Id Profile) }
    | DeleteProfileAction { profileId :: !(Id Profile) }
    deriving (Eq, Show, Data)

data DoctorsController
    = DoctorsAction
    | NewDoctorAction
    | ShowDoctorAction { doctorId :: !(Id Doctor) }
    | CreateDoctorAction
    | EditDoctorAction { doctorId :: !(Id Doctor) }
    | UpdateDoctorAction { doctorId :: !(Id Doctor) }
    | DeleteDoctorAction { doctorId :: !(Id Doctor) }
    | NewProfileDoctorAction { profileId :: !(Id Profile) }
    deriving (Eq, Show, Data)

data PatientsController
    = PatientsAction
    | NewPatientAction
    | ShowPatientAction { patientId :: !(Id Patient) }
    | CreatePatientAction
    | EditPatientAction { patientId :: !(Id Patient) }
    | UpdatePatientAction { patientId :: !(Id Patient) }
    | DeletePatientAction { patientId :: !(Id Patient) }
    | NewProfilePatientAction { profileId :: !(Id Profile) }
    deriving (Eq, Show, Data)

data DoctorsApiController
    = DoctorApiAction
    deriving (Eq, Show, Data)

data ProfilesApiController
    = ProfileApiAction
    deriving (Eq, Show, Data)