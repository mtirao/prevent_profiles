module Web.View.Profiles.New where
import Web.View.Prelude

data NewView = NewView { profile :: Profile }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Profile</h1>
        {renderForm profile}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Profiles" ProfilesAction
                , breadcrumbText "New Profile"
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