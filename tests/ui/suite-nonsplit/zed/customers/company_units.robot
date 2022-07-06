Create_Update_Delete_Business_Unit
    [Documentation]    Checks possibility to create, update and delete business units
    Log into Zed
    Open Company Units screen
    Click Create Company Business Unit button
    Select Company
    Select parent business unit
    Fill Name, IBAN, BIC
    Click Save
    Check that message shown 'Company Business Unit "{Test}" has been created.'
    Find created BU in list
    Assert fields: company, BU parent, Name, IBAN, BIC
    Click Edit
    Update parent, Name, IBAN, BIC
    Click Save
    On BU list check that fields updated: BU parent, Name, IBAN, BIC
    Click Delete button
    Check that message shown 'Company Business Unit "TestBU" was deleted.'
    Try to find BU and assert that 0 results shown

