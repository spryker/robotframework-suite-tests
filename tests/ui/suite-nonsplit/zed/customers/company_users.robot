Create_and_Delete_New_User
    [Documentation]    Checks possibility to create new company user and delete it
    Log into Zed
    Open Company Users page
    Click Create New User button
    Fill email, salutation, first name, last name, gender, date of birth, phone
    Select Company
    Select business unit
    Pick role
    Click Save
    Check that message shown 'Company user has been created.'
    Find created user in list
    Assert company name, user name, roles, BU, status
    Go to Customers page
    Find created customer
    Assert email, last name, first name
    Check that status is 'Unverified'
    Return to company users page
    Click Delete in created user row
    On confirmation page click 'Delete company user'
    Check that message shown 'Company user successfully removed.'
    Go to Customers page
    Check that related customer still exists



Edit_and_Disable_Company_User
    [Documentation]    Checks possibility to update company user
    Log into Zed
    Open Company Users page
    Click Edit in user row
    Update first name, last name
    Select other company
    Select new business unit
    Pick additional role
    Click Save
    Check that message shown 'Company User has been updated.'
    Assert user's company, name, roles, business unit
    Click Disable button in row
    Check that status became 'Disabled'
    Click Enable button
    Check that status became 'Active'

Attach_User_to_Business_Unit
    [Documentation]    Checks possibility to attach company user to other business unit
    Log into Zed
    Open Company Users page
    Click 'Attach to BU' in user row
    Check that BU list contains only units of user's company 
    Select other business unit
    Click Save
    Check that message shown 'Customer has been assigned to business unit.'
    Return to users list
    Find rows of assigned user (there will be 2 ones)
    Check that both have same company and user name
    Check that one has old business unit and other new one


