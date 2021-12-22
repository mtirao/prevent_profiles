module Web.View.Patients.Edit where
import Web.View.Prelude

data EditView = EditView { patient :: Patient }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Patient</h1>
        {renderForm patient}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Patients" PatientsAction
                , breadcrumbText "Edit Patient"
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