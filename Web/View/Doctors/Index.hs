module Web.View.Doctors.Index where
import Web.View.Prelude

data IndexView = IndexView { doctors :: [ Doctor ]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewDoctorAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            {forEach doctors renderDoctor}
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Doctors" DoctorsAction
                ]

renderDoctor :: Doctor -> Html
renderDoctor doctor = [hsx|

    <ul class="list-group mb-3">
        <li class="list-group-item d-flex justify-content-between lh-condensed">
            <div>
                <h6 class="my-0">Actions</h6>
                <a href={ShowDoctorAction (get #id doctor)}>Show </a>
                <a href={EditDoctorAction (get #id doctor)} class="text-muted">Edit </a>
                <a href={DeleteDoctorAction (get #id doctor)} class="js-delete text-muted">Delete </a>
            </div>
        </li>
        <li class="list-group-item d-flex justify-content-between lh-condensed">
            <div>
            <h6 class="my-0">Realm</h6>
            <small class="text-muted">{(get #realm doctor)}</small>
            </div>
        </li>
        <li class="list-group-item d-flex justify-content-between lh-condensed">
            <div>
            <h6 class="my-0">License Number</h6>
            <small class="text-muted">{(get #licenseNumber doctor)}</small>
            </div>
        </li>
    </ul>
|]