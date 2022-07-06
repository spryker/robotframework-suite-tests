Create_Company_Unit_Address
    [Documentation]    Checks possibility to create business unit address and attach to BU
    Log into Zed
    Open Company Unit Addresses screen
    Click Create Company Unit Address button
    Select company
    Select country
    Fill city, zip, street, number, addition, comment
    Select label
    Click Save
    Check that message shown 'Company unit address has been successfully created.'
    Find address in list
    Assert fields: country, city, zip, company, address(street), number, addition, labels


Update_Company_Unit_Address
    [Documentation]    Checks possibility to update business unit address
    Log into Zed
    Open Company Unit Addresses page
    Click Edit Business Unit Address in address row
    Select other country
    Update values in fields: city, zip, street, number, addition, comment
    Pick new label
    Click Save
    Check that message shown 'Company unit address has been successfully updated.'
    Assert fields: country, city, zip, company, address(street), number, addition, labels

Attach_Address_to_Business_Unit
    [Documentation]    Checks possibility to attach business unit address to BU
    Setup: BU address exists with known company and values
    Log into Zed
    Open Company Units page
    Find BU in same company as address has
    Click Edit
    Pick address in corresponding field
    Click Save 
    Check that message shown 'Company unit address has been successfully updated.'
    On BU list find updated one
    Assert value in address column
