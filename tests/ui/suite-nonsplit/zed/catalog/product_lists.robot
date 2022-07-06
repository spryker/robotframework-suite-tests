Create_and_Delete_Product_List
    [Documentation]    Checks possibility to add new product list and remove it
    Log into Zed
    Open Product Lists screen
    Click 'Create a product list' button
    Fill title
    Select type
    On Assign Categories tab pick category
    Click Save
    Check that message shown 'Product List "&{ListName}" has been successfully created.'
    Return to Product Lists page
    Find created list
    Assert title, type
    Click Remove
    Check that list was actually removed

Edit_Product_List
    Setup: list exists with assigned category
    [Documentation]    Checks possibility to edit product list assigned items
    Log into Zed
    Open Product Lists screen
    Click 'Edit List' button in row
    Open 'Assign Categories' tab
    Remove selected category
    Pick other category
    Open 'Assign Products' tab
    Pick 2 products
    Click Save
    Check that message shown 'Product List "&{ListName}" has been successfully updated.'
    Check that selected products are present in 'Products in this list' table
    Check that selected products are absent in 'Select Products to assign' table
    Open 'Assign Products' tab
    Check that selected category is displaying

