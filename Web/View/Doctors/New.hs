module Web.View.Doctors.New where
import Web.View.Prelude

data NewView = NewView { doctor :: Doctor}

instance View NewView where
    html NewView { .. } = [hsx|
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