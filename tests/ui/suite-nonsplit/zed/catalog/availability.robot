Edit_Product_Stock
    [Documentation]    Checks possibility to create new product attribute
    Log into Zed
    Open Availability screen
    Click View on availability row
    Click Edit Stock on variant availability row
    Update quantity for warehouse2
    Set 'never out of stock'=true
    Click Save
    Check that message shown 'Stock successfully updated.'
    Click 'Back to product' button on top
    Assert values of current stock and 'never out of stock'
    Open Products page
    Find the product for which stock was updated
    Click Edit
    Open variants tab
    Click Edit on Variant
    Go to Price&Stock tab
    Check that stock for warehouse2 is same as saved previously
    Update stock to new value 
    Click Save
    Open Availability screen
    Check that stock was updated
