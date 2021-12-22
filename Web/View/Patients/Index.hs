module Web.View.Patients.Index where
import Web.View.Prelude

data IndexView = IndexView { patients :: [ Patient ]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewPatientAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Patient</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach patients renderPatient}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Patients" PatientsAction
                ]

renderPatient :: Patient -> Html
renderPatient patient = [hsx|
    <tr>
        <td>{patient}</td>
        <td><a href={ShowPatientAction (get #id patient)}>Show</a></td>
        <td><a href={EditPatientAction (get #id patient)} class="text-muted">Edit</a></td>
        <td><a href={DeletePatientAction (get #id patient)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]