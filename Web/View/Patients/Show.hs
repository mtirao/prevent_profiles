module Web.View.Patients.Show where
import Web.View.Prelude

data ShowView = ShowView { patient :: Patient }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show Patient</h1>
        <p>{patient}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Patients" PatientsAction
                            , breadcrumbText "Show Patient"
                            ]