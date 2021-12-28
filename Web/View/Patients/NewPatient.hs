module Web.View.Patients.NewPatient where
import Web.View.Prelude

data NewPatientView = NewPatientView { patient :: Patient }

instance View NewPatientView where
    html NewPatientView { .. } = [hsx|
        {breadcrumb}
        <h1>New Patient</h1>
        {renderForm patient}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Patients" PatientsAction
                , breadcrumbText "New Patient"
                ]

renderForm :: Patient -> Html
renderForm patient = formFor patient [hsx|
    {(textField #insuranceType)}
    {(textField #preferredContactMethod)}
    {(hiddenField #profileId)}
    {(textField #nationalId)}
    {(dateField #birthday)}
    {submitButton}

|]