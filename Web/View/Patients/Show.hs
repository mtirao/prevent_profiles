module Web.View.Patients.Show where
import Web.View.Prelude

data ShowView = ShowView { patient :: Patient, patienBirthday :: [Char] }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
         <ul class="list-group mb-3">
            <li class="list-group-item d-flex justify-content-between lh-condensed">
              <div>
                <h6 class="my-0">Issurance</h6>
                <small class="text-muted">{(get #insuranceType patient)}</small>
              </div>
            </li>
            <li class="list-group-item d-flex justify-content-between lh-condensed">
              <div>
                <h6 class="my-0">Preferred Contact Method</h6>
                <small class="text-muted">{(get #preferredContactMethod patient)}</small>
              </div>
            </li>
            <li class="list-group-item d-flex justify-content-between lh-condensed">
              <div>
                <h6 class="my-0">Nationa ID Number</h6>
                <small class="text-muted">{(get #nationalId patient)}</small>
              </div>
            </li>
             <li class="list-group-item d-flex justify-content-between lh-condensed">
              <div>
                <h6 class="my-0">Birthday</h6>
                <small class="text-muted">{patienBirthday}</small>
              </div>
            </li>
        </ul>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Patients" PatientsAction
                            , breadcrumbText "Show Patient"
                            ]