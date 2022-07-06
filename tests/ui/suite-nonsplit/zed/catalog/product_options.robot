Create_Product_Option_Group
    [Documentation]    Checks possibility to create new product option group
    Log into Zed
    Open Product Options screen
    Click 'Create product option' button
    Fill group name value
    Select Tax Set
    Fill option name value
    Check that default SKU generated
    Add DE/EUR/Gross price
    Fill translations for group and option in all locales
    Open products tab
    Pick 2 products
    Click Save
    Check that message shown 'Product option group created.'
    Click 'List of product options' on top
    Find created option
    Assert group name, SKU, name, gross price, status (inactive)

Add_Option_to_Existing_Group
    [Documentation]    Checks possibility to add new option to existing group
    Log into Zed
    Open Product Options screen
    Click Edit on group row
    Click Add option
    Fill name
    Add DE/EUR/Gross price
    Fill option name translations in all locales
    Click Save
    Return to product options list
    Check that new option appeared in table
    Click View on group row
    Check that new option is displaying
    Check new option translations and price

Product_Option_Actions
    [Documentation]    Checks possibility to add update option status from table
    Log into Zed
    Open Product Options screen
    Find option in Active status
    Check that Actions column contains only Edit, View, Deactivate buttons
    Click Deactivate
    Check that status became Inactive
    Click Activate action button
    Check that status is Active