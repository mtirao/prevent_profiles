module Web.View.Doctors.Show where
import Web.View.Prelude

data ShowView = ShowView { doctor :: Doctor }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show Doctor</h1>
        <ul class="list-group mb-3">
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
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Doctors" DoctorsAction
                            , breadcrumbText "Show Doctor"
                            ]