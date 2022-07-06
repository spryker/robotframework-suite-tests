Create_Product_Single_Variant
    [Documentation]    Checks possibility to create single-SKU product
    Log into Zed
    Open Products screen
    Click Create Product button
    In stores relation left only DE
    Fill SKU prefix
    Fill Name for all locales
    Click Next
    On price & tax tab fill Gross and Net values for DE/EUR
    Select Tax Set
    Go to SEO tab
    Fill Title, Keywords, description for EN locale
    Click Save
    Check that message shown 'The product ${SKU} was added successfully.'
    Go to products list
    Find created product
    Assert Name, SKU, Tax set, variants (1), approval (draft), status (deactivated), types (product), stores
    Click View
    Assert filled values: stores relation, SKU, Name, Prices, Tax set, SEO Title/Keywords/Description
    Check that Variants table contains only 1 row
    Assert that variant values are same as abstract: SKU, Name, Status, Is Bundle
    Click Edit on variant row
    Open Price & Stock tab
    Check that price is same as for abstract
    Check that stock is 0 for default warehouses


Create_Product_Multi_Variants
    [Documentation]    Checks possibility to create multi-SKU product
    Log into Zed
    Open Products screen
    Click Create Product button
    Fill SKU prefix
    Fill Name for all locales
    Click Next
    On price & tax tab fill default Gross value for DE/EUR
    Select Tax Set
    Go to Variants tab
    Pick Color attribute
    Fill values yellow, blue
    Click Save
    Check that message shown 'The product ${SKU} was added successfully.'
    Go to products list
    Find created product
    Assert Name, SKU, Tax set, variants (2), approval (draft), status (deactivated), types (product), stores
    Click View
    Assert filled values: stores relation, SKU, Name, Prices, Tax set
    Check that Variants table contains 2 rows
    Check that variants SKU are builded of abstract SKU and attribute values
    Assert that variant values are same as abstract: Name, Status, Is Bundle
    Click Edit on 2nd variant row
    Check that super attributes section is displayed and contains corresponding value
    Open Price & Stock tab
    Check that price is same as for abstract
    Check that stock is 0 for default warehouses


Create_Bundle_Product
    [Documentation]    Checks possibility to create bundle product
    Log into Zed
    Open Products screen
    Click Create Bundle Product button
    Fill SKU prefix
    Fill Name for all locales
    Click Next
    On price & tax tab fill default Gross value for DE/EUR
    Select Tax Set
    Go to Variants tab
    Check that text is displayed 'Product bundle does not have variants!'
    Click Save
    Check that message shown 'The product ${SKU} was added successfully.'
    On variants tab check that 1 variant is present now
    Click Edit on variant row
    Go to 'Assign bundled products' tab
    Pick 2 products
    Fill quantity for each
    Click Save
    Check that message shown 'The product ${SKU} was saved successfully.'
    Check that 'Bundle availability based on assigned products:' is calculated based on both products availabilities/quantity
    Go to Price & Stock tab
    Check that there are no warehouses displayed


Add_Variant_to_Existing_Product
    [Documentation]    Checks possibility to add new variant to existing product
    Log into Zed
    Open Products screen
    Find product that has >1 variant
    Click Edit
    Click Add Variant
    Fill custom SKU value
    Select super attribute value
    Fill Name for all locales
    Go to Price&Stock tab
    Fill default Gross value for DE/EUR
    Click Save
    Check that message shown 'The product ${SKU} was saved successfully.'
    Click Edit Product Abstract
    Open Variants tab
    Check that new variant was added
    Assert name and SKU

Update_Product_Abstract
    [Documentation]    Checks possibility to update abstract product
    Log into Zed
    Open Products screen
    Click Edit on abstract product row
    On General tab pdate fields: Name, Description
    On Price & Tax tab update price and select other tax set
    On SEO tab fill Title, Keywords, Description
    Click Save
    Check that message shown 'The product ${SKU} was saved successfully.'
    Return to products list
    Check that Name and Tax Set have new values
    CLick View 
    Assert Name, Descriprion, Price, Tax set, SEO data

Update_Product_Concrete
    [Documentation]    Checks possibility to update concrete product
    Log into Zed
    Open Products screen
    Click Edit on abstract product row
    Open Variants tab
    Click Edit on variant row
    On General tab update fields: Name, Description
    On Price & Stock tab update price
    On Product alternatives tab pick alternative product
    Click Save
    Check that message shown 'The product ${SKU} was saved successfully.'
    Click Edit Abstract
    Open Variants tab
    Check that name was updated
    Click Edit to open concrete
    Assert Name, Description, Prices, Assigned alternative


Manage_Abstract_Attributes
    [Documentation]    Checks possibility to add and remove abstract product attributes
    Log into Zed
    Open Products screen
    Click Manage Attributes on abstract product row
    Find Attribute by key
    Click Add
    Fill default and locale values
    Find other attribute
    Click Add
    Fill default and locale values
    Click Save
    Check that pop-up appeared 'Product abstract attributes saved'
    Check that table contains both attributes with selected values
    Click Remove on 2nd attribute
    Click Save
    Check that table contains only 1st attribute
    

Manage_Concrete_Attributes
    [Documentation]    Checks possibility to add and remove concrete product attributes
    Log into Zed
    Open Products screen
    Click Edit on abstract product row
    Open Variants tab
    Click Manage Attributes on variant row
    Find Attribute by key
    Click Add
    Fill default and locale values
    Find other attribute
    Click Add
    Fill default and locale values
    Click Save
    Check that pop-up appeared 'Product abstract attributes saved'
    Check that table contains both attributes with selected values
    Click Remove on 2nd attribute
    Click Save
    Check that table contains only 1st attribute

Product_Approval_Flow
    [Documentation]    Checks possibility to move product through approval process states
    Log into Zed
    Open Products screen
    Find product in Approved state
    Click 'Deny' button
    Check that message shown 'The approval status was updated'
    heck that approval status became 'Denied'
    Click 'Back to Draft' button  
    Check that approval status became 'Draft'
    Click 'Send for Approval'
    Check that approval status became 'Waiting for Approval'
    Click 'Approve'
    Check that approval status became 'Approved'

Volume_Prices
    [Documentation]    Checks possibility to add and remove volume prices for product
    Log into Zed
    Open Products screen
    Click Edit on abstract product row
    Open Price&Tax tab
    Click Add volume price button in table
    Check that Price Type, Currency and Store are same as for single price that you clicked
    Fill second row, put quantity 2, gross price and net price
    Click 'Save and add more rows'
    Check that new empty row was added
    Fill prices in another row for quantity 3
    Click Save and Exit
    Click 'Edit volume price'
    Check that added prices are present there


Discontinue_Product
    [Documentation]    Checks possibility to set product discontinued and select alternative one
    Log into Zed
    Open Products screen
    Click Edit on abstract product row
    Open Variants tab
    Click Edit on variant row
    Open Discontinue tab
    Click Discontinue
    Check that message shown 'Product has been marked as discontinued.'
    Add note
    Click Save
    Click Restore
    Check that message shown 'Product has been unmarked as discontinued.'
    Check that discontinued notes are not displaying
