module Web.View.Doctors.NewDoctor where
import Web.View.Prelude

data NewDoctor = NewDoctor { doctor :: Doctor}

instance View NewDoctor where
    html NewDoctor { .. } = [hsx|
        {breadcrumb}
        <h1>New Doctor</h1>
        {renderForm doctor}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Doctors" DoctorsAction
                , breadcrumbText "New Doctor"
                ]

renderForm :: Doctor -> Html
renderForm doctor = formFor doctor [hsx|
    {(textField #realm)}
    {(textField #licenseNumber)}
    {(textField #profileId)}
    {submitButton}
|]