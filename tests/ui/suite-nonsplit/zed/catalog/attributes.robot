Create_Product_Attribute
    [Documentation]    Checks possibility to create new product attribute
    Log into Zed
    Open Attributes screen
    Click 'Create Product Attribute' button
    Fill attribute key (should be in lower case)
    Select text as input type
    Add 2 predefined values
    Check 'Allow input any value'
    Check that message shown 'Product attribute was created successfully.'
    Fill translation
    Click Save
    Check that message shown 'Translation was updated successfully.'
    Assert values on view attribute page: key, input type, super attribute, values, allow input, translations
    Go to products page
    Click Manage Attributes on any product
    Check that new attribute could be found

Edit_Attribute
    [Documentation]    Checks possibility to update product attribute
    Log into Zed
    Open Attributes screen
    Click Edit on attribute row
    Remove predefined value
    Add new predefined value
    Update 'Allow input any value'
    Click Save
    Check that message shown 'Product attribute was updated successfully.'
    Change translation
    Click Save
    Check that message shown 'Product attribute was updated successfully.'
    Assert values on view attribute page: values, allow input, translations

