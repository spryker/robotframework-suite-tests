New_Customer
    [Documentation] Checks possibility to create new customer with full info, view it and delete
    Log into Zed
    Open Customers screen
    CLick Add Customer button
    Fill valid data into all fields: email, salutation, first name, last name, gender, date of birth, phone, locale
    Click Save
    On Customers screen assert values of new row: date, email, last name, first name
    Chech that status is Unverified
    Click View on new customer row
    Assert values on customer screen: salutation, first name, last name, email, gender, date of birth, phone, locale
    Check that Billing Address and Shipping Address dropdowns are displayed
    Click Delete button on top
    Confirm account deletion
    Check that message shown 'Customer successfully deleted'
    Try to find customer by email and check that 0 results found


Edit_Customer
    [Documentation] Checks possibility to update customer's fields and add notes
    Log into Zed
    Open Customers screen
    CLick Edit on customer row
    Change values of all editable fields: salutation, first name, last name, gender, date of birth, phone, locale
    Click Save
    Check that message shown 'Customer was updated successfully.'
    Assert values on View Customer screen:  salutation, first name, last name, email, gender, date of birth, phone, locale
    Type some text in Notes message box
    Click Add Note
    Check that message shown 'Comment successfully added.'
    Check that note text is displaying




Attach_to_Company
    [Documentation] Checks that customer could be attached to company and company user is creating with correct values
    Log into Zed
    Open Customers screen
    CLick Attach to Company on customer row
    Select the company that customer is not attached yet
    Select business unit
    Select Admin and Buyer(checked by default) roles
    Click Save
    Check that message shown 'Company user has been created.'
    Find created entity in company users list
    Assert Company name, company user name, roles, business unit, status


Customer_billing_shipping_addresses
    [Documentation] Checks that billing and shipping addresses could be added for customer
    Setup: customer exists and has no address
    Log into Zed
    Open Customers screen
    CLick View on customer row
    Click Add new Address
    Fill data in: salutation, first name, last name, address line 1, city, zip code, country
    Click Save
    Check that new address was displayed
    Check that it's marked as Billing and Shipping
    Click Add new Address
    Fill values other than in 1st address in: salutation, first name, last name, address line 1, city, zip code, country
    Click Save
    Check that new address was displayed
    Check that it has no Billing/Shipping labels
    Click Edit Customer
    Check that billing and shipping dropdowns contain 1st address
    Select 2nd address in shipping dropdown
    Click Save
    Check that address1 is labeled as billing
    Check that address2 is labeled as shipping


Customer_address_editing
    [Documentation] Checks that billing and shipping addresses could be added for customer
    Log into Zed
    Open Customers screen
    CLick View on customer row
    Click Add new Address
    Fill data in: salutation, first name, last name, address line 1, line2, line 3, city, zip code, country
    Click Save
    Click Edit on address row
    Update values in fields: salutation, first name, last name, address line 1, line2, line 3, city, zip code, country
    Click Save
    Assert in grid that all updated fields have new values