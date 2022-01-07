module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)

-- Controller Imports
import Web.Controller.Patients
import Web.Controller.Doctors
import Web.Controller.Profiles
import Web.Controller.Static
import Web.Controller.DoctorsApi
import Web.Controller.ProfilesApi
import Web.Controller.SingleDoctorApi
import Web.Controller.SingleProfileApi

instance FrontController WebApplication where
    controllers = 
        [ startPage WelcomeAction
        -- Generator Marker
        , parseRoute @PatientsController
        , parseRoute @DoctorsController
        , parseRoute @ProfilesController
        , parseRoute @DoctorsApiController
        , parseRoute @ProfilesApiController
        , parseRoute @SingleDoctorApiController
        , parseRoute @SingleProfileApiController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
