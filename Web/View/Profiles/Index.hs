module Web.View.Profiles.Index where
import Web.View.Prelude

data IndexView = IndexView { profiles :: [ Profile ]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewProfileAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Profile</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach profiles renderProfile}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Profiles" ProfilesAction
                ]

renderProfile :: Profile -> Html
renderProfile profile = [hsx|
    <tr>
        <td>{(get #firstName profile)}, {(get #lastName profile)}</td>
        <td><a href={NewProfileDoctorAction (get #id profile)}>Doctor</a></td>
        <td><a href={NewProfilePatientAction (get #id profile)}>Patient</a></td>
        <td><a href={ShowProfileAction (get #id profile)}>Show</a></td>
        <td><a href={EditProfileAction (get #id profile)} class="text-muted">Edit</a></td>
        <td><a href={DeleteProfileAction (get #id profile)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]