module Web.View.Patients.Index where
import Web.View.Prelude

data IndexView = IndexView { patients :: [ Patient ]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewPatientAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            {forEach patients renderPatient}
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Patients" PatientsAction
                ]

renderPatient :: Patient -> Html
renderPatient patient = [hsx|
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
                <small class="text-muted">{(get #birthday patient)}</small>
              </div>
            </li>
        </ul>
|]