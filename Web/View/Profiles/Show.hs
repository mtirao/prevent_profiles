module Web.View.Profiles.Show where
import Web.View.Prelude

data ShowView = ShowView { profile :: Profile }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}

        <ul class="list-group mb-3">
            <li class="list-group-item d-flex justify-content-between lh-condensed">
              <div>
                <h6 class="my-0">Name</h6>
                <small class="text-muted">{(get #firstName profile)}, {(get #lastName profile)}</small>
              </div>
            </li>
            <li class="list-group-item d-flex justify-content-between lh-condensed">
              <div>
                <h6 class="my-0">Email</h6>
                <small class="text-muted">{(get #email profile)}</small>
              </div>
            </li>
            <li class="list-group-item d-flex justify-content-between lh-condensed">
              <div>
                <h6 class="my-0">Phone</h6>
                <small class="text-muted">{(get #phone profile)}</small>
              </div>
            </li>
             <li class="list-group-item d-flex justify-content-between lh-condensed">
              <div>
                <h6 class="my-0">Cell Phone</h6>
                <small class="text-muted">{(get #cellPhone profile)}</small>
              </div>
            </li>
            <li class="list-group-item d-flex justify-content-between lh-condensed">
              <div>
                <h6 class="my-0">User Name</h6>
                <small class="text-muted">{(get #userName profile)}</small>
              </div>
            </li>
        </ul>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Profiles" ProfilesAction
                            , breadcrumbText "Show Profile"
                            ]