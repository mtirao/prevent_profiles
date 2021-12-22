module Web.View.Profiles.Edit where
import Web.View.Prelude

data EditView = EditView { profile :: Profile }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Profile</h1>
        {renderForm profile}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Profiles" ProfilesAction
                , breadcrumbText "Edit Profile"
                ]

renderForm :: Profile -> Html
renderForm profile = formFor profile [hsx|
    {(textField #lastName)}
    {(textField #firstName)}
    {(textField #email)}
    {(hiddenField #userRole)}
    {(textField #userName)}
    {(textField #userPassword)}
    {submitButton}

|]