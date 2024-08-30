*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_two
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/steps/header_steps.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/common/common_zed.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/shopping_lists_steps.robot
Resource    ../../../../resources/steps/checkout_steps.robot
Resource    ../../../../resources/steps/order_history_steps.robot
Resource    ../../../../resources/steps/product_set_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/agent_assist_steps.robot
Resource    ../../../../resources/steps/company_steps.robot
Resource    ../../../../resources/steps/customer_account_steps.robot
Resource    ../../../../resources/steps/zed_users_steps.robot
Resource    ../../../../resources/steps/products_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/steps/zed_customer_steps.robot
Resource    ../../../../resources/steps/zed_discount_steps.robot
Resource    ../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../resources/steps/zed_cms_page_steps.robot
Resource    ../../../../resources/steps/merchant_profile_steps.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/steps/mp_profile_steps.robot
Resource    ../../../../resources/steps/mp_orders_steps.robot
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/mp_products_steps.robot
Resource    ../../../../resources/steps/mp_account_steps.robot
Resource    ../../../../resources/steps/mp_dashboard_steps.robot
Resource    ../../../../resources/steps/zed_root_menus_steps.robot
Resource    ../../../../resources/steps/minimum_order_value_steps.robot
Resource    ../../../../resources/steps/availability_steps.robot
Resource    ../../../../resources/steps/glossary_steps.robot
Resource    ../../../../resources/steps/order_comments_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot
Resource    ../../../../resources/steps/dynamic_entity_steps.robot

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
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: table should contain:    Restrictions Merchant
    Zed: table should contain:    Prices Merchant
    Zed: table should contain:    Products Restrictions Merchant

Merchant_Profile_Update
    [Documentation]    Checks that merchant profile could be updated from merchant portal and that changes will be displayed on Yves
    Yves: go to URL:    en/merchant/office-king
    Yves: assert merchant profile fields:
    ...    || name | email             | phone           | delivery time | data privacy                                          ||
    ...    ||      | hi@office-king.nl | +31 123 345 777 | 2-4 days      | Office King values the privacy of your personal data. ||
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Profile  
    MP: open profile tab:    Online Profile
    MP: update profile fields with following data:
    ...    || email                  | phone           | delivery time | data privacy              ||
    ...    || updated@office-king.nl | +11 222 333 444 | 2-4 weeks     | Data privacy updated text ||
    MP: click submit button
    Trigger p&s
    Yves: go to URL:    en/merchant/office-king
    Yves: assert merchant profile fields:
    ...    || name | email                  | phone           | delivery time | data privacy              ||
    ...    ||      | updated@office-king.nl | +11 222 333 444 | 2-4 weeks     | Data privacy updated text ||
    [Teardown]    Run Keywords    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    ...    AND    MP: open navigation menu tab:    Profile
    ...    AND    MP: open profile tab:    Online Profile  
    ...    AND    MP: update profile fields with following data:
    ...    || email             | phone           | delivery time | data privacy                                          ||
    ...    || hi@office-king.nl | +31 123 345 777 | 2-4 days      | Office King values the privacy of your personal data. ||
    ...    AND    MP: click submit button
    ...    AND    Trigger p&s

Merchant_Profile_Set_to_Offline_from_MP
    [Documentation]    Checks that merchant is able to set store offline and then his profile, products and offers won't be displayed on Yves
    [Setup]    Run Keywords    
    ...    MP: login on MP with provided credentials:    ${merchant_computer_experts_email}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer395 | 10             | true                  ||
    ...    AND    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer193 | 10             | true                  ||
    ...    AND    Trigger p&s
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Profile
    MP: open profile tab:    Online Profile
    MP: change store status to:    offline
    Yves: go to URL:    en/merchant/office-king
    Yves: try reloading page if element is/not appear:    ${merchant_profile_main_content_locator}    false
    Yves: perform search by:    Office King
    Yves: go to the PDP of the first available product on open catalog page
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    false
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    false
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    false
    [Teardown]    Run Keywords    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    ...    AND    MP: open navigation menu tab:    Profile
    ...    AND    MP: open profile tab:    Online Profile
    ...    AND    MP: change store status to:    online
    ...    AND    Repeat Keyword    3    Trigger multistore p&s
    ...    AND    Yves: go to the 'Home' page
    ...    AND    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    ...    AND    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
    ...    AND    Yves: go to URL:    en/merchant/office-king
    ...    AND    Yves: go to newly created page by URL:    url=en/merchant/office-king    delay=5s    iterations=26

Merchant_Profile_Set_to_Inactive_from_Backoffice
    [Documentation]    Checks that backoffice admin is able to deactivate merchant and then it's profile, products and offers won't be displayed on Yves
    [Setup]    Run Keywords    
    ...    MP: login on MP with provided credentials:    ${merchant_computer_experts_email}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer395 | 10             | true                  ||
    ...    AND    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer193 | 10             | true                  ||
    ...    AND    Trigger p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants  
    Zed: click Action Button in a table for row that contains:     Office King     Deactivate
    Repeat Keyword    3    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to URL:    en/merchant/office-king
    Yves: try reloading page if element is/not appear:    ${merchant_profile_main_content_locator}    false
    Yves: perform search by:    Office King
    Yves: go to the PDP of the first available product on open catalog page
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    false
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    false
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    false
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Marketplace    Merchants  
    ...    AND    Zed: click Action Button in a table for row that contains:     Office King     Activate
    ...    AND    Repeat Keyword    3    Trigger multistore p&s

Manage_Merchants_from_Backoffice
    [Documentation]    Checks that backoffice admin is able to create, approve, edit merchants
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new Merchant with the following data:
    ...    || merchant name        | merchant reference            | e-mail                      | store | store | en url                  | de url                  ||
    ...    || NewMerchant${random} | NewMerchantReference${random} | merchant+${random}@test.com | DE    | DE    | NewMerchantURL${random} | NewMerchantURL${random} ||
    Zed: perform search by:    NewMerchant${random}
    Zed: table should contain non-searchable value:    Inactive
    Zed: table should contain non-searchable value:    Waiting for Approval
    Zed: table should contain non-searchable value:    DE
    Zed: click Action Button in a table for row that contains:    NewMerchant${random}    Activate
    Zed: click Action Button in a table for row that contains:    NewMerchant${random}    Approve Access
    Zed: perform search by:    NewMerchant${random}
    Zed: table should contain non-searchable value:    Active
    Zed: table should contain non-searchable value:    Approved
    Zed: click Action Button in a table for row that contains:    NewMerchant${random}    Edit
    Zed: update Merchant on edit page with the following data:
    ...    || merchant name               | merchant reference | e-mail  | store | store | en url | de url ||
    ...    || NewMerchantUpdated${random} |                    |         |       |       |        |        ||
    Trigger p&s
    Yves: go to newly created page by URL:    en/merchant/NewMerchantURL${random}
    Yves: assert merchant profile fields:
    ...    || name                         | email| phone | delivery time | data privacy ||
    ...    || NewMerchantUpdated${random}  |      |       |               |              ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:    NewMerchantUpdated${random}    Edit
    Zed: update Merchant on edit page with the following data:
    ...    || merchant name | merchant reference | e-mail  | uncheck store | en url | de url ||
    ...    ||               |                    |         | DE            |        |        ||
    Trigger p&s
    Yves: go to URL and refresh until 404 occurs:    ${yves_url}en/merchant/NewMerchantURL${random}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Marketplace    Merchants  
    ...    AND    Zed: click Action Button in a table for row that contains:     NewMerchantUpdated${random}     Deactivate
    ...    AND    Trigger multistore p&s

Manage_Merchant_Users
    [Documentation]    Checks that backoffice admin is able to create, activate, edit and delete merchant users
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Office King     Edit
    Zed: create new Merchant User with the following data:
    ...    || e-mail                         | first name     | last name      ||
    ...    || sonia+mu+${random}@spryker.com | FName${random} | LName${random} ||
    Zed: perform merchant user search by:     sonia+mu+${random}@spryker.com
    Zed: table should contain non-searchable value:    Deactivated
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Activate
    Zed: table should contain non-searchable value:    Active
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Edit
    Zed: update Merchant User on edit page with the following data:
    ...    || e-mail | first name           | last name ||
    ...    ||        | UpdatedName${random} |           ||
    Zed: perform merchant user search by:    sonia+mu+${random}@spryker.com
    Zed: table should contain non-searchable value:    UpdatedName${random}
    Zed: update Zed user:
    ...    || oldEmail                       | newEmail | password      | firstName | lastName ||
    ...    || sonia+mu+${random}@spryker.com |          | Change123!321 |           |          ||
    MP: login on MP with provided credentials:    sonia+mu+${random}@spryker.com    Change123!321
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Office King     Edit
    Zed: go to tab:     Users
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Deactivate
    Zed: table should contain non-searchable value:    Deactivated
    MP: login on MP with provided credentials and expect error:    sonia+mu+${random}@spryker.com    Change123!321
    [Teardown]    Run Keywords     Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Marketplace    Merchants
    ...    AND    Zed: click Action Button in a table for row that contains:     Office King     Edit
    ...    AND    Zed: go to tab:     Users
    ...    AND    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Delete
    ...    AND    Zed: submit the form
    ...    AND    Trigger p&s

Create_and_Approve_New_Merchant_Product
    [Documentation]    Checks that merchant is able to create new multi-SKU product and marketplace operator is able to approve it in BO
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku  | product name        | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || SKU${random} | NewProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    NewProduct${random}
    MP: click on a table row that contains:     NewProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE     | store | tax set        ||
    ...    || NewProduct${random} | DE    | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number | customer | store | currency | gross default ||
    ...    || abstract     | 1          | Default  | DE    | EUR      | 100           ||
    MP: save abstract product 
    MP: click on a table row that contains:    NewProduct${random}
    MP: open concrete drawer by SKU:    SKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    MP: save abstract product 
    Trigger p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     NewProduct${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}   
    Yves: go to PDP of the product with sku:     SKU${random}    wait_for_p&s=true
    Save current URL
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     NewProduct${random}     Deny
    Trigger p&s
    Yves: go to the 'Home' page
    Yves: go to URL and refresh until 404 occurs:    ${url}

Create_New_Offer
    [Documentation]    Checks that merchant is able to create new offer and it will be displayed on Yves
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku         | product name            | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || SprykerSKU${random} | SprykerProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    SprykerProduct${random} 
    MP: click on a table row that contains:     SprykerSKU${random}
    MP: fill abstract product required fields:
    ...    || product name DE         | store | tax set        ||
    ...    || SprykerProduct${random} | DE    | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number | customer | store | currency | gross default ||
    ...    || abstract     | 1          | Default  | DE    | EUR      | 100           ||
    MP: save abstract product 
    MP: click on a table row that contains:    SprykerSKU${random}
    MP: open concrete drawer by SKU:    SprykerSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     SprykerSKU${random}     Approve
    Trigger p&s
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    SprykerSKU${random}-2
    MP: click on a table row that contains:    SprykerSKU${random}-2  
    MP: fill offer fields:
    ...    || is active | merchant sku         | store | stock quantity ||
    ...    || true      | merchantSKU${random} | DE    | 100            ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | CHF      | 100           ||
    MP: save offer
    MP: perform search by:    merchantSKU${random}
    MP: click on a table row that contains:    merchantSKU${random} 
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 200           ||
    MP: save offer
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    newOfferCart${random}
    Yves: go to PDP of the product with sku:     SprykerSKU${random}-2    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
    Yves: merchant's offer/product price should be:    Office King    €200.00
    Yves: select xxx merchant's offer:    Office King
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to the shopping cart through the header with name:    newOfferCart${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: assert merchant of product in cart or list:    SprykerSKU${random}-2    Office King
    Yves: shopping cart contains product with unit price:    SprykerSKU${random}-2    SprykerProduct${random}    200
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete 'Shopping Cart' with name:    newOfferCart${random}
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     SprykerProduct${random}     Deny
    ...    AND    Trigger p&s

Approve_Offer
    [Documentation]    Checks that marketplace operator is able to approve or deny merchant's offer and it will be available or not in store due to this status
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Offers
    Zed: select merchant in filter:    Office King
    Zed: click Action Button in a table for row that contains:     ${product_with_multiple_offers_concrete_sku}     Deny
    Trigger p&s
    Yves: go to the 'Home' page
    Yves: go to PDP of the product with sku:     ${product_with_multiple_offers_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    false
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Offers
    Zed: select merchant in filter:    Office King
    Zed: click Action Button in a table for row that contains:     ${product_with_multiple_offers_concrete_sku}    Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
    Yves: merchant's offer/product price should be:    Office King    ${product_with_multiple_offers_office_king_price}
    Yves: select xxx merchant's offer:    Office King
    Yves: product price on the PDP should be:     ${product_with_multiple_offers_office_king_price}

Fulfill_Order_from_Merchant_Portal
    [Documentation]    Checks that merchant is able to process his order through OMS from merchant portal
    [Setup]    Run Keywords    
    ...    MP: login on MP with provided credentials:    ${merchant_computer_experts_email}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer395 | 10             | true                  ||
    ...    AND    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer193 | 10             | true                  ||
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer220 | 10             | true                  ||
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    MerchantOrder${random}
    ...    AND    Trigger p&s
    Yves: go to PDP of the product with sku:     ${product_with_multiple_offers_abstract_sku}
    Yves: add product to the shopping cart
    Yves: select xxx merchant's offer:    Computer Experts
    Yves: add product to the shopping cart
    Yves: select xxx merchant's offer:    Office King
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:     M22660
    Yves: select xxx merchant's offer:    Office King
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    MerchantOrder${random}
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}     Office King
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}     Computer Experts
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method for the shipment:    1    DHL    Standard    
    Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
    Yves: select the following shipping method for the shipment:    3    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay 
    Zed: wait for order item to be in state:    ${product_with_multiple_offers_concrete_sku}    sent to merchant    2
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Orders    
    MP: wait for order to appear:    ${lastPlacedOrder}--${merchant_office_king_reference}
    MP: click on a table row that contains:    ${lastPlacedOrder}--${merchant_office_king_reference}
    MP: order grand total should be:    €32.78
    MP: update order state using header button:    Ship
    MP: order states on drawer should contain:    Shipped
    MP: switch to the tab:    Items
    MP: change order item state on:    423172    Deliver
    MP: switch to the tab:    Items
    MP: order item state should be:    427915    shipped
    MP: order item state should be:    423172    delivered
    MP: update order state using header button:    Deliver
    MP: order states on drawer should contain:    Delivered
    MP: switch to the tab:    Items
    MP: order item state should be:    427915    delivered
    MP: order item state should be:    423172    delivered
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all user addresses

Shopping_List_Contains_Offers
    [Documentation]    Checks that customer is able to add merchant products and offers to list and merchant relation won't be lost in list and afterwards in cart
    [Setup]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
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
    [Teardown]    Yves: delete 'Shopping List' with name:    shoppingListName${random}

Merchant_Portal_Customer_Specific_Prices
    [Documentation]    Checks that customer will see product/offer prices specified by merchant for his business unit
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Products
    MP: perform search by:    ${one_variant_product_of_main_merchant_abstract_sku}
    MP: click on a table row that contains:    ${one_variant_product_of_main_merchant_abstract_sku}
    MP: open concrete drawer by SKU:    ${one_variant_product_of_main_merchant_concrete_sku}
    MP: fill product price values:
    ...    || product type | row number | customer                  | store | currency | gross default ||
    ...    || concrete     | 1          | 5 - Spryker Systems GmbH  | DE    | EUR      | 100           ||
    MP: save concrete product
    Trigger p&s
    Yves: login on Yves with provided credentials:     ${yves_company_user_custom_merchant_prices_email}
    Yves: go to PDP of the product with sku:    ${one_variant_product_of_main_merchant_abstract_sku}
    Yves: merchant's offer/product price should be:    Spryker     €100.00
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Products
    MP: perform search by:    ${one_variant_product_of_main_merchant_abstract_sku}
    MP: click on a table row that contains:    ${one_variant_product_of_main_merchant_abstract_sku}
    MP: open concrete drawer by SKU:    ${one_variant_product_of_main_merchant_concrete_sku}
    MP: delete product price row that contains text:    5 - Spryker Systems GmbH
    MP: save concrete product
    Trigger p&s
    Yves: login on Yves with provided credentials:     ${yves_company_user_custom_merchant_prices_email}
    Yves: go to PDP of the product with sku:    ${one_variant_product_of_main_merchant_abstract_sku}
    Yves: merchant's offer/product price should be:    Spryker     €632.12

Search_for_Merchant_Offers_and_Products
    [Documentation]    Checks that through search customer is able to see the list of merchant's products and offers
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: perform search by:    Office King
    Yves: go to the PDP of the first available product on open catalog page
    Yves: select random varian if variant selector is available
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
    Yves: perform search by:    Spryker
    Yves: change sorting order on catalog page:    Sort by name ascending
    Yves: go to the PDP of the first available product on open catalog page
    Yves: select random varian if variant selector is available
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: perform search by:    ${EMPTY}
    Yves: select filter value:    Merchant    Budget Stationery
    Yves: go to the PDP of the first available product on open catalog page
    Yves: select random varian if variant selector is available
    Yves: merchant is (not) displaying in Sold By section of PDP:    Budget Stationery    true

Merchant_Portal_Product_Volume_Prices
    [Documentation]    Checks that merchant is able to create new multi-SKU product with volume prices. Falback to default price after delete.
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku    | product name          | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || VPSKU${random} | VPNewProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    VPNewProduct${random}
    MP: click on a table row that contains:     VPNewProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE     | store | tax set          ||
    ...    || VPNewProduct${random} | DE    | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number | customer | store | currency | gross default ||
    ...    || abstract     | 1          | Default  | DE    | EUR      | 100           ||
    MP: fill product price values:
    ...    || product type | row number | customer | store | currency | gross default | quantity ||
    ...    || abstract     | 2          | Default  | DE    | EUR      | 10            | 2        ||
    MP: save abstract product 
    MP: click on a table row that contains:    VPNewProduct${random}
    MP: open concrete drawer by SKU:    VPSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     VPNewProduct${random}     Approve
    Zed: save abstract product:    VPNewProduct${random}
    Repeat Keyword   3    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}  
    Yves: delete all shopping carts
    Yves: create new 'Shopping Cart' with name:    MPVolumePriceCart+${random}
    Yves: go to PDP of the product with sku:     VPSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Reload
    Yves: change quantity on PDP:    2
    Yves: product price on the PDP should be:    €10.00
    Yves: merchant's offer/product price should be:    Office King     €10.00
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    MPVolumePriceCart+${random}
    Yves: shopping cart contains product with unit price:    VPSKU${random}-2    VPNewProduct${random}    10.00
    Yves: assert merchant of product in cart or list:    VPSKU${random}-2    Office King
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Products
    MP: perform search by:    VPNewProduct${random}
    MP: click on a table row that contains:    VPNewProduct${random}
    MP: delete product price row that contains quantity:    2
    MP: save abstract product
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to PDP of the product with sku:     VPSKU${random}
    Yves: change quantity on PDP:    2
    Yves: product price on the PDP should be:    €100.00
    Yves: merchant's offer/product price should be:    Office King     €100.00
    Yves: go to the shopping cart through the header with name:    MPVolumePriceCart+${random}
    Yves: shopping cart contains product with unit price:    VPSKU${random}-2    VPNewProduct${random}    100.00
    [Teardown]    Run Keywords    Yves: delete 'Shopping Cart' with name:    MPVolumePriceCart+${random}
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     VPNewProduct${random}     Deny

Merchant_Portal_Offer_Volume_Prices
    [Documentation]    Checks that merchant is able to create new offer with volume prices and it will be displayed on Yves. Falback to default price after delete
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku       | product name             | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || OfferSKU${random} | OfferNewProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    OfferNewProduct${random}
    MP: click on a table row that contains:     OfferNewProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE          | store | tax set        ||
    ...    || OfferNewProduct${random} | DE    | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number | customer | store | currency | gross default ||
    ...    || abstract     | 1          | Default  | DE    | EUR      | 100           ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    OfferNewProduct${random}
    MP: open concrete drawer by SKU:    OfferSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     OfferNewProduct${random}     Approve
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}  
    Yves: delete all shopping carts
    Yves: create new 'Shopping Cart' with name:    MPVolumePriceCart+${random}
    Yves: go to PDP of the product with sku:     OfferSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    OfferSKU${random}-2
    MP: click on a table row that contains:    OfferSKU${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku               | store | stock quantity ||
    ...    || true      | volumeMerchantSKU${random} | DE    | 100            ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | CHF      | 100           ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 2          | DE    | EUR      | 200           | 1        ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 3          | DE    | EUR      | 10            | 2        ||
    MP: save offer
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    volumeOfferCart${random}
    Yves: go to PDP of the product with sku:     OfferSKU${random}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
    Yves: merchant's offer/product price should be:    Office King    €200.00
    Yves: select xxx merchant's offer:    Office King
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    2
    Yves: product price on the PDP should be:    €10.00
    Yves: merchant's offer/product price should be:    Office King     €10.00
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    volumeOfferCart${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: assert merchant of product in cart or list:    OfferSKU${random}-2    Office King
    Yves: shopping cart contains product with unit price:    OfferSKU${random}-2    OfferNewProduct${random}    10
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Offers
    MP: perform search by:    OfferSKU${random}-2
    MP: click on a table row that contains:    volumeMerchantSKU${random}
    MP: delete offer price row that contains quantity:    2
    MP: save offer
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to PDP of the product with sku:     OfferSKU${random}
    Yves: select xxx merchant's offer:    Office King
    Yves: change quantity on PDP:    2
    Yves: product price on the PDP should be:    €200.00
    Yves: merchant's offer/product price should be:    Office King     €200.00
    Yves: go to the shopping cart through the header with name:    volumeOfferCart${random}
    Yves: shopping cart contains product with unit price:    OfferSKU${random}-2    OfferNewProduct${random}    200
    [Teardown]    Run Keywords    Yves: delete 'Shopping Cart' with name:    volumeOfferCart${random}
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     OfferNewProduct${random}     Deny
    ...    AND    Trigger p&s

Merchant_Portal_My_Account
    [Documentation]    Checks that MU can edit personal data in MP
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
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
    ...    || oldEmail                           | newEmail | password      | firstName | lastName ||
    ...    || sonia+editmu+${random}@spryker.com |          | Change123!321 |           |          ||
    MP: login on MP with provided credentials:    sonia+editmu+${random}@spryker.com    Change123!321
    MP: update merchant personal details with data:
    ...    || firstName               | lastName                | email | currentPassword | newPassword          ||
    ...    || MPUpdatedFName${random} | MPUpdatedLName${random} |       | Change123!321   | UpdatedChange123!321 ||
    MP: click submit button
    MP: login on MP with provided credentials:    sonia+editmu+${random}@spryker.com    UpdatedChange123!321
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Users    Users
    Zed: table should contain:    MPUpdatedFName${random}
    Zed: table should contain:    MPUpdatedLName${random}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    sonia+editmu+${random}@spryker.com
    
Merchant_Portal_Dashboard
    [Documentation]    Checks that merchant user is able to access the dashboard page
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
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
    ...    || oldEmail                             | newEmail | password      | firstName | lastName ||
    ...    || sonia+dahboard+${random}@spryker.com |          | Change123!321 |           |          ||
    Trigger multistore p&s
    MP: login on MP with provided credentials:    sonia+dahboard+${random}@spryker.com    Change123!321
    MP: click button on dashboard page and check url:    Manage Offers    /product-offers
    MP: click button on dashboard page and check url:    Add Offer    /product-list
    MP: click button on dashboard page and check url:    Manage Orders    /orders
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    sonia+dahboard+${random}@spryker.com

Merchant_Product_Offer_in_Backoffice
    [Documentation]    Check View action and filtration for Mproduct and Moffer in backoffice
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku      | product name         | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || ViewSKU${random} | ViewProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    ViewProduct${random}
    MP: click on a table row that contains:     ViewProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE      | store | tax set        ||
    ...    || ViewProduct${random} | DE    | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 100           ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default | quantity ||
    ...    || abstract     | 2          | DE    | EUR      | 10            | 2        ||
    MP: save abstract product 
    MP: click on a table row that contains:    ViewProduct${random}
    MP: open concrete drawer by SKU:    ViewSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     ViewProduct${random}     Approve
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
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
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 2          | DE    | EUR      | 200           | 1        ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 3          | DE    | EUR      | 10            | 2        ||
    MP: save offer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
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
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     ViewProduct${random}     Deny

Manage_Merchant_Product
    [Documentation]    Checks that MU and BO user can manage merchant abstract and concrete products + add new concrete product
    Repeat Keyword    3    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku        | product name           | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || manageSKU${random} | manageProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    manageProduct${random}
    MP: click on a table row that contains:     manageProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE        | store | tax set        ||
    ...    || manageProduct${random} | DE    | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 90             ||
    MP: save abstract product 
    MP: click on a table row that contains:    manageProduct${random}
    MP: open concrete drawer by SKU:    manageSKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    MP: open concrete drawer by SKU:    manageSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 3              | true              | en_US         ||
    MP: open concrete drawer by SKU:    manageSKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: save concrete product
    MP: open concrete drawer by SKU:    manageSKU${random}-2
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 20            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default | quantity ||
    ...    || concrete     | 2          | DE    | EUR      | 10            | 2        ||
    MP: save concrete product
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     manageProduct${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}   
    Yves: delete all shopping carts
    Yves: create new 'Shopping Cart' with name:    manageMProduct+${random}
    Yves: go to PDP of the product with sku:     manageSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: change variant of the product on PDP on:    Item
    Yves: product price on the PDP should be:    €50.00    wait_for_p&s=true
    Yves: merchant's offer/product price should be:    Office King    €50.00
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    Box
    Reload
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: product price on the PDP should be:    €10.00
    Yves: merchant's offer/product price should be:    Office King     €10.00
    Yves: try add product to the cart from PDP and expect error:    Item manageSKU${random}-2 only has availability of 3.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: product price on the PDP should be:    €10.00
    Yves: merchant's offer/product price should be:    Office King     €10.00
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    manageMProduct+${random}
    Yves: shopping cart contains product with unit price:    manageSKU${random}-2    manageProduct${random}    10.00
    Yves: assert merchant of product in cart or list:    manageSKU${random}-2    Office King
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Products    
    MP: perform search by:    manageProduct${random}
    MP: click on a table row that contains:     manageProduct${random}
    MP: add new concrete product:
    ...    || first attribute | first attribute value | second attribute | second attribute value ||
    ...    || packaging_unit  | 5-pack                | material         | Aluminium              ||
    MP: save abstract product
    MP: perform search by:    manageProduct${random}
    MP: click on a table row that contains:     manageProduct${random}
    MP: open concrete drawer by SKU:    manageSKU${random}-3
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 3              | true              | en_US         ||
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     manageProduct${random}     View
    Zed: view product page is displayed
    Zed: view abstract product page contains:
    ...    || merchant     | status   | store | sku                | name                   | variants count ||
    ...    || Office King  | Approved | DE    | manageSKU${random} | manageProduct${random} | 3              ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: update abstract product price on:
    ...    || productAbstract    | store | mode  | type    | currency | amount ||
    ...    || manageSKU${random} | DE    | gross | default | €        | 110.00 ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract    | store | name en                         | name de                         | new from   | new to     ||
    ...    || manageSKU${random} | AT    | ENUpdatedmanageProduct${random} | DEUpdatedmanageProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: update abstract product price on:
    ...    || productAbstract    | store | mode  | type    | currency | amount ||
    ...    || manageSKU${random} | DE    | gross | default | €        | 110.00 ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: change concrete product price on:
    ...    || productAbstract    | productConcrete      | store | mode  | type   | currency | amount ||
    ...    || manageSKU${random} | manageSKU${random}-3 | DE    | gross | default| €        | 15.00  ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: go to second navigation item level:    Catalog    Products
    Zed: table should contain:    ENUpdatedmanageProduct${random}
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to PDP of the product with sku:     manageSKU${random}
    Yves: product name on PDP should be:    ENUpdatedmanageProduct${random}
    Yves: product price on the PDP should be:    €110.00    wait_for_p&s=true
    Yves: change variant of the product on PDP on:    5-pack
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     manageSKU${random}     Deny
    ...    AND    Trigger multistore p&s

Merchant_Product_Original_Price
    [Documentation]    checks that Orignal price is displayed on the PDP and in Catalog
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku          | product name             | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || originalSKU${random} | originalProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    originalProduct${random}
    MP: click on a table row that contains:     originalProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE          | store | tax set        ||
    ...    || originalProduct${random} | DE    | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original  ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 150             ||
    MP: save abstract product 
    MP: click on a table row that contains:    originalProduct${random}
    MP: open concrete drawer by SKU:    originalSKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    MP: open concrete drawer by SKU:    originalSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 3              | true              | en_US         ||
    MP: open concrete drawer by SKU:    originalSKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: save concrete product
    MP: open concrete drawer by SKU:    originalSKU${random}-2
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 20            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default | quantity ||
    ...    || concrete     | 2          | DE    | EUR      | 10            | 2        ||
    MP: save concrete product
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     originalProduct${random}     Approve
    Zed: save abstract product:    originalProduct${random}
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}   
    Yves: go to URL:    en/search?q=originalSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: 1st product card in catalog (not)contains:     Original Price    €150.00
    Yves: go to PDP of the product with sku:     originalSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €150.00
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     originalSKU${random}     Deny
    ...    AND    Trigger p&s
