*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_two
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/mp_account_steps.robot
Resource    ../../../../resources/steps/mp_dashboard_steps.robot
Resource    ../../../../resources/steps/mp_products_steps.robot
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/products_steps.robot

*** Test Cases ***
Merchant_Portal_Unauthorized_Access_Redirects_To_Login_Page
    [Documentation]    Check that when root URL for MerchantPortal is opened by unauthorized user he is redirected to login page.
    Delete All Cookies
    Go To    ${mp_root_url}
    Wait Until Page Contains Element    xpath=//div[@class='login']
    ${url}    Get Location
    Should Match    ${url}/    ${mp_url}

Default_Merchants
    [Documentation]    Checks that default merchants are present in Zed
    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: table should contain:    Restrictions Merchant
    Zed: table should contain:    Prices Merchant
    Zed: table should contain:    Products Restrictions Merchant
    [Teardown]    Delete dynamic admin user from DB

Shopping_List_Contains_Offers
    [Documentation]    Checks that customer is able to add merchant products and offers to list and merchant relation won't be lost in list and afterwards in cart
    [Setup]    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: create new 'Shopping List' with name:    shoppingListName${random}
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: add product to the shopping list:    shoppingListName${random}
    Yves: select xxx merchant's offer:    Computer Experts
    Yves: add product to the shopping list:    shoppingListName${random}
    Yves: view shopping list with name:    shoppingListName${random}
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Computer Experts
    Yves: add all available products from list to cart  
    Yves: 'Shopping Cart' page is displayed
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Computer Experts

Search_for_Merchant_Offers_and_Products
    [Documentation]    Checks that through search customer is able to see the list of merchant's products and offers
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: perform search by:    Office King
    Yves: go to the PDP of the first available product on current catalog page
    Yves: select random varian if variant selector is available
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
    Yves: perform search by:    Spryker
    Yves: change sorting order on catalog page:    Sort by name ascending
    Yves: go to the PDP of the first available product on current catalog page
    Yves: select random varian if variant selector is available
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: perform search by:    ${EMPTY}
    Yves: select filter value:    Merchant    Budget Stationery
    Yves: go to the PDP of the first available product on current catalog page
    Yves: select random varian if variant selector is available
    Yves: merchant is (not) displaying in Sold By section of PDP:    Budget Stationery    true

Merchant_Portal_My_Account
    [Documentation]    Checks that MU can edit personal data in MP
    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Oryx Merchant     Edit
    Zed: create new Merchant User with the following data:
    ...    || e-mail                             | first name     | last name      ||
    ...    || sonia+editmu+${random}@spryker.com | FName${random} | LName${random} ||
    Zed: perform merchant user search by:     sonia+editmu+${random}@spryker.com
    Zed: table should contain non-searchable value:    Deactivated
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+editmu+${random}@spryker.com    Activate
    Zed: table should contain non-searchable value:    Active
    Zed: update Zed user:
    ...    || oldEmail                           | newEmail | password                   | firstName | lastName ||
    ...    || sonia+editmu+${random}@spryker.com |          | ${default_secure_password} |           |          ||
    MP: login on MP with provided credentials:    sonia+editmu+${random}@spryker.com    ${default_secure_password}
    MP: update merchant personal details with data:
    ...    || firstName               | lastName                | email | currentPassword | newPassword          ||
    ...    || MPUpdatedFName${random} | MPUpdatedLName${random} |       | ${default_secure_password}   | Updated${default_secure_password} ||
    MP: click submit button
    MP: login on MP with provided credentials:    sonia+editmu+${random}@spryker.com    Updated${default_secure_password}
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Users    Users
    Zed: table should contain:    MPUpdatedFName${random}
    Zed: table should contain:    MPUpdatedLName${random}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: delete Zed user with the following email:    sonia+editmu+${random}@spryker.com
    ...    AND    Delete dynamic admin user from DB
    
Merchant_Portal_Dashboard
    [Documentation]    Checks that merchant user is able to access the dashboard page
    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Oryx Merchant     Edit
    Zed: create new Merchant User with the following data:
    ...    || e-mail                               | first name      | last name       ||
    ...    || sonia+dahboard+${random}@spryker.com | DFName${random} | DLName${random} ||
    Zed: perform merchant user search by:     sonia+dahboard+${random}@spryker.com
    Zed: table should contain non-searchable value:    Deactivated
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+dahboard+${random}@spryker.com    Activate
    Zed: table should contain non-searchable value:    Active
    Zed: update Zed user:
    ...    || oldEmail                             | newEmail | password                   | firstName | lastName ||
    ...    || sonia+dahboard+${random}@spryker.com |          | ${default_secure_password} |           |          ||
    Trigger multistore p&s
    MP: login on MP with provided credentials:    sonia+dahboard+${random}@spryker.com    ${default_secure_password}
    MP: click button on dashboard page and check url:    Manage Offers    /product-offers
    MP: click button on dashboard page and check url:    Add Offer    /product-list
    MP: click button on dashboard page and check url:    Manage Orders    /orders
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: delete Zed user with the following email:    sonia+dahboard+${random}@spryker.com
    ...    AND    Delete dynamic admin user from DB

Merchant_Product_Offer_in_Backoffice
    [Documentation]    Check View action and filtration for Mproduct and Moffer in backoffice
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Zed: create dynamic merchant user:    Spryker
    ...    AND    Zed: create dynamic merchant user:    Office King
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku      | product name         | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || ViewSKU${random} | ViewProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    ViewProduct${random}
    MP: click on a table row that contains:     ViewProduct${random}
    MP: fill abstract product required fields:
    ...    || product name         | store | tax set        ||
    ...    || ViewProduct${random} | DE    | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 100           ||
    MP: save abstract product 
    MP: click on a table row that contains:    ViewProduct${random}
    MP: open concrete drawer by SKU:    ViewSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     ViewProduct${random}     Approve
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    ViewSKU${random}-2
    MP: click on a table row that contains:    ViewSKU${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku             | store | stock quantity ||
    ...    || true      | viewMerchantSKU${random} | DE    | 100            ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | CHF      | 100           ||
    MP: save offer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: filter by merchant:    Spryker
    Zed: table should contain:    ViewSKU${random}
    Zed: click Action Button in a table for row that contains:     ViewProduct${random}     View
    Zed: view product page is displayed
    Zed: view abstract product page contains:
    ...    || merchant | status   | store | sku              | name                 ||
    ...    || Spryker  | Approved | DE    | ViewSKU${random} | ViewProduct${random} ||
    Zed: go to second navigation item level:    Marketplace    Offers
    Zed: filter by merchant:    Office King
    Zed: table should contain:    ViewSKU${random}-2
    Zed: click Action Button in a table for row that contains:     ViewSKU${random}-2     View
    Zed: view offer page is displayed
    Zed: view offer product page contains:
    ...    || approval status | status | store | sku                | name                 | merchant    | merchant sku             ||
    ...    || Approved        | Active | DE    | ViewSKU${random}-2 | ViewProduct${random} | Office King | viewMerchantSKU${random} ||
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     ViewProduct${random}     Deny
    ...    AND    Delete dynamic admin user from DB