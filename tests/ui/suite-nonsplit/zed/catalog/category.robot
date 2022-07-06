Create_and_Delete_Category
    [Documentation]    Checks possibility to create new category and then delete it
    Log into Zed
    Open Category screen
    Click Create new Category button
    Fill key value
    Select parent category
    Pick DE store
    Select Catalog template
    Check 'Active'
    Fill name and meta title for all locales
    Click Save
    Check that message shown 'The category was added successfully.'
    Return to categories list
    Find created category
    Assert values in Name, Parent, Active, Visible, Searcheble, Template, Stores
    Click on Actions button
    Click Delete
    Check confirmation checkbox
    Click Delete
    Check that message shown 'The category was deleted successfully.'
    Try to find category and check that 0 results found


Update_Category
    [Documentation]    Checks possibility to update category data
    Log into Zed
    Open Category screen
    Click on Actions button in category row
    Click Edit
    Update Key, Parent, List of stores, template, Name
    Click Save
    Check that message shown 'The category was updated successfully.'
    Return to categoies list
    Check that name, parent, template, stores have new values

Assign_Products_to_Category
    [Documentation]    Checks possibility to assign products to category
    Log into Zed
    Open Category screen
    Click on Actions button in category row
    Click Assign Products
    Pick 3 products
    Check that they appeared on 'Products to be assigned' tab
    Click Remove on one of them
    Click Save
    Check that message shown 'The category was saved successfully.'
    Check that selected products are not in 'Select Products to assign' section anymore
    Check that 2 new products are now present on 'Products in this category' section
    Uncheck 'Selected' for both
    Click Save
    Check that products are gone from 'Products in this category' section
    Check that products returned to 'Select Products to assign' section


