module Web.View.Patients.New where
import Web.View.Prelude

data NewView = NewView { patient :: Patient }

instance View NewView where
    html NewView { .. } = [hsx|
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
    {(textField #profileId)}
    {(textField #nationalId)}
    {(textField #birthday)}
    {submitButton}

|]