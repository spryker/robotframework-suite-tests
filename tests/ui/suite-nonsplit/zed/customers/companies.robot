New_Company
    [Documentation]    Checks possibility to create new company and edit it's name
    Log into Zed
    Open Companies screen
    Click Create Company button
    Fill name and click Save
    Check that message shown 'Company has been created.'
    Find company in list
    Assert values in columns name, active, status (inactive/pending)
    Click Edit
    Update name
    Click Save
    Check that name was updated in list


Company_Status
    [Documentation]    Checks possibility to deactivate/activate and deny/approve company
    Setup: find/prepare company that is active and approved
    Log into Zed
    Open Companies screen
    On active approved company row click Deactivate
    Check that message shown 'Company has been deactivated.'
    Check that Inactive label is displaying now
    Click Deny button for this company
    Check that message shown 'Company has been denied.'
    Check that status label became Denied
    Click Activate button
    Check that message shown 'Company has been activated.'
    Check that label became Active
    Click Approve button
    Check that message shown 'Company has been approved.'
    Check that status label became Approved


