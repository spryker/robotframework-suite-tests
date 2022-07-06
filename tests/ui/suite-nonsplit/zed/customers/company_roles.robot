Add_and_Update_Company_Role
    [Documentation]    Checks possibility to create and update company role
    Log into Zed
    Open Company Roles page
    Click 'Add company user role' button
    Select company
    Fill name
    Pick some permissions
    Click Submit
    Check that message shown 'Company role has been successfully created'
    Find role in list
    Assert name and company
    Go to Company Users page
    Find user in same company as the role
    Click Edit
    Check that new role is displayed in list of unassigned roles
    Return to Roles page
    Click Edit on role
    Update name
    Pick new permission
    Click Submit
    Check that name was updated in roles list


Delete_Company_Role
    [Documentation]    Checks that not assigned company role could be deleted and assigned couldn't
    Log into Zed
    Open Company Roles page
    Click 'Add company user role' button
    Select company
    Fill name
    Pick some permissions
    Click Submit
    Go to Company Users page
    Find user in same company as the role
    Click Edit
    Pick new role
    Click Save
    Return to Roles page
    Click Delete on role
    On confirmation page click 'Delete company role'
    Check that error shown 'Company role can not be removed'
    Check that role still exists
    Go to Company Users page
    Find user that has this role assigned
    Click Edit
    Uncheck role
    Click Save
    Return to Roles page 
    Click Delete on role
    On confirmation page click 'Delete company role'
    Check that message shown 'Company role has been successfully removed'
    Check that 0 results are found for this role name

