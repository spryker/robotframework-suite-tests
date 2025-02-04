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
    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: table should contain:    Video King
    Zed: table should contain:    Spryker
    Zed: table should contain:    Sony Experts
    [Teardown]    Delete dynamic admin user from DB

Merchant_Profile_Update
    [Documentation]    Checks that merchant profile could be updated from merchant portal and that changes will be displayed on Yves
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: create dynamic merchant user:    Video King
    Yves: go to URL:    en/merchant/Video-king
    Yves: assert merchant profile fields:
    ...    || name | email            | phone           | delivery time | data privacy                                         ||
    ...    ||      | hi@video-king.nl | +31 123 345 777 | 2-4 days      | Video King values the privacy of your personal data. ||
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Profile  
    MP: open profile tab:    Online Profile
    MP: update profile fields with following data:
    ...    || email                  | phone           | delivery time | data privacy              ||
    ...    || updated@office-king.nl | +11 222 333 444 | 2-4 weeks     | Data privacy updated text ||
    MP: click submit button
    Trigger multistore p&s
    Yves: go to URL:    en/merchant/video-king
    Yves: assert merchant profile fields:
    ...    || name | email                  | phone           | delivery time | data privacy              ||
    ...    ||      | updated@office-king.nl | +11 222 333 444 | 2-4 weeks     | Data privacy updated text ||
    [Teardown]    Run Keywords    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    ...    AND    MP: open navigation menu tab:    Profile
    ...    AND    MP: open profile tab:    Online Profile  
    ...    AND    MP: update profile fields with following data:
    ...    || email            | phone           | delivery time | data privacy                                         ||
    ...    || hi@video-king.nl | +31 123 345 777 | 2-4 days      | Video King values the privacy of your personal data. ||
    ...    AND    MP: click submit button
    ...    AND    Trigger multistore p&s
    ...    AND    Zed: delete merchant user:    ${dynamic_king_merchant}
    ...    AND    Delete dynamic admin user from DB

Merchant_Profile_Set_to_Offline_from_MP
    [Documentation]    Checks that merchant is able to set store offline and then his profile, products and offers won't be displayed on Yves
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create new Merchant with the following data:
    ...    || merchant name            | merchant reference                 | e-mail                             | store | store 2 | en url                   | de url                   | approved | contact_first_name  | contact_last_name  ||
    ...    || offline_from_MP${random} | offline_from_MP_reference${random} | offline_from_MP+${random}@test.com | DE    | AT      | offline-from-mp${random} | offline-from-mp${random} | true     | FirstOffMP${random} | LastOffMP${random} ||
    Zed: create dynamic merchant user:    offline_from_MP${random}    merchant_user_email=sonia+offline+mp${random}@spryker.com
    Zed: create dynamic merchant user:    Spryker
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku        | product name       | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || offlineMP${random} | offlineMP${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    offlineMP${random}
    MP: click on a table row that contains:     offlineMP${random}
    MP: fill abstract product required fields:
    ...    || product name       | store | tax set           ||
    ...    || offlineMP${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 100           ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default | quantity ||
    ...    || abstract     | 2          | DE    | EUR      | 10            | 2        ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    offlineMP${random}
    MP: open concrete drawer by SKU:    offlineMP${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    MP: login on MP with provided credentials:    sonia+offline+mp${random}@spryker.com    ${default_secure_password}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    offlineMP${random}-2
    MP: click on a table row that contains:    offlineMP${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku            | store | stock quantity ||
    ...    || true      | offlineMPoffer${random} | DE    | 100            ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | CHF      | 100           ||
    MP: save offer
    MP: perform search by:    offlineMPoffer${random}
    MP: click on a table row that contains:    offlineMPoffer${random}
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 200           ||
    MP: save offer
    Repeat Keyword    3    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     offlineMP${random}     Approve
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to newly created page by URL:    url=en/merchant/offline-from-mp${random}    delay=5s    iterations=26
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    offlineMP${random}
    Yves: merchant is (not) displaying in Sold By section of PDP:    offline_from_MP${random}    true
    MP: login on MP with provided credentials:    sonia+offline+mp${random}@spryker.com    ${default_secure_password}
    MP: open navigation menu tab:    Profile
    MP: open profile tab:    Online Profile
    MP: change store status to:    offline
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to URL:    en/merchant/offline-from-mp${random}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: try reloading page if element is/not appear:    ${merchant_profile_main_content_locator}    false
    Yves: go to PDP of the product with sku:    offlineMP${random}
    Yves: merchant is (not) displaying in Sold By section of PDP:    offline_from_MP${random}    false
    [Teardown]    Run Keywords    Delete dynamic admin user from DB
    ...    AND    Delete dynamic customer via API

Merchant_Profile_Set_to_Inactive_from_Backoffice
    [Documentation]    Checks that backoffice admin is able to deactivate merchant and then it's profile, products and offers won't be displayed on Yves
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create new Merchant with the following data:
    ...    || merchant name            | merchant reference                 | e-mail                             | store | store 2 | en url                   | de url                   | approved | contact_first_name  | contact_last_name  ||
    ...    || offline_from_BO${random} | offline_from_BO_reference${random} | offline_from_BO+${random}@test.com | DE    | AT      | offline-from-bo${random} | offline-from-bo${random} | true     | FirstOffBO${random} | LastOffBO${random} ||
    Zed: create dynamic merchant user:    offline_from_BO${random}    merchant_user_email=sonia+offline+bo${random}@spryker.com
    Zed: create dynamic merchant user:    Spryker
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku        | product name       | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || offlineBO${random} | offlineBO${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    offlineBO${random}
    MP: click on a table row that contains:     offlineBO${random}
    MP: fill abstract product required fields:
    ...    || product name       | store | tax set           ||
    ...    || offlineBO${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 100           ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default | quantity ||
    ...    || abstract     | 2          | DE    | EUR      | 10            | 2        ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    offlineBO${random}
    MP: open concrete drawer by SKU:    offlineBO${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    MP: login on MP with provided credentials:    sonia+offline+bo${random}@spryker.com    ${default_secure_password}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    offlineBO${random}-2
    MP: click on a table row that contains:    offlineBO${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku            | store | stock quantity ||
    ...    || true      | offlineBOoffer${random} | DE    | 100            ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | CHF      | 100           ||
    MP: save offer
    MP: perform search by:    offlineBOoffer${random}
    MP: click on a table row that contains:    offlineBOoffer${random}
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 200           ||
    MP: save offer
    Repeat Keyword    3    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     offlineBO${random}     Approve
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to newly created page by URL:    url=en/merchant/offline-from-bo${random}    delay=5s    iterations=26
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    offlineBO${random}
    Yves: merchant is (not) displaying in Sold By section of PDP:    offline_from_BO${random}    true
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Merchants  
    Zed: click Action Button in a table for row that contains:     offline_from_BO${random}     Deactivate
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to URL:    en/merchant/offline-from-mp${random}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: try reloading page if element is/not appear:    ${merchant_profile_main_content_locator}    false
    Yves: go to PDP of the product with sku:    offlineBO${random}
    Yves: merchant is (not) displaying in Sold By section of PDP:    offline_from_BO${random}    false
    [Teardown]    Run Keywords    Delete dynamic admin user from DB
    ...    AND    Delete dynamic customer via API

Manage_Merchants_from_Backoffice
    [Documentation]    Checks that backoffice admin is able to create, approve, edit merchants
    [Setup]    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create new Merchant with the following data:
    ...    || merchant name          | merchant reference              | e-mail                           | store | store 2 | en url                    | de url                    ||
    ...    || RobotMerchant${random} | RobotMerchantReference${random} | robotMerchant+${random}@test.com | DE    | AT      | RobotMerchantURL${random} | RobotMerchantURL${random} ||
    Zed: perform search by:    RobotMerchant${random}
    Zed: table should contain non-searchable value:    Inactive
    Zed: table should contain non-searchable value:    Waiting for Approval
    Zed: table should contain non-searchable value:    DE
    Zed: click Action Button in a table for row that contains:    RobotMerchant${random}    Activate
    Zed: click Action Button in a table for row that contains:    RobotMerchant${random}    Approve Access
    Zed: perform search by:    RobotMerchant${random}
    Zed: table should contain non-searchable value:    Active
    Zed: table should contain non-searchable value:    Approved
    Zed: click Action Button in a table for row that contains:    RobotMerchant${random}    Edit
    Zed: update Merchant on edit page with the following data:
    ...    || merchant name                 | merchant reference | e-mail  | store | en url | de url ||
    ...    || RobotMerchantUpdated${random} |                    |         |       |        |        ||
    Trigger multistore p&s
    Yves: go to newly created page by URL:    en/merchant/RobotMerchantURL${random}
    Yves: assert merchant profile fields:
    ...    || name                          | email | phone | delivery time | data privacy ||
    ...    || RobotMerchantUpdated${random} |       |       |               |              ||
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:    RobotMerchantUpdated${random}    Edit
    Zed: update Merchant on edit page with the following data:
    ...    || merchant name        | merchant reference | e-mail  | uncheck store | uncheck store 2 | en url | de url ||
    ...    || Deactivated${random} |                    |         | DE            | AT              |        |        ||
    Trigger multistore p&s
    Yves: go to URL and refresh until 404 occurs:    ${yves_url}en/merchant/RobotMerchantURL${random}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Marketplace    Merchants  
    ...    AND    Zed: click Action Button in a table for row that contains:     Deactivated${random}     Deactivate
    ...    AND    Trigger multistore p&s
    ...    AND    Delete dynamic admin user from DB

Manage_Merchant_Users
    [Documentation]    Checks that backoffice admin is able to create, activate, edit and delete merchant users. DMS-ON: https://spryker.atlassian.net/browse/FRW-7395
    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Video King     Edit
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
    ...    || sonia+mu+${random}@spryker.com |          | ${default_secure_password} |           |          ||
    MP: login on MP with provided credentials:    sonia+mu+${random}@spryker.com    ${default_secure_password}
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Video King     Edit
    Zed: go to tab by link href that contains:    merchant-user
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Deactivate
    Zed: table should contain non-searchable value:    Deactivated
    MP: login on MP with provided credentials and expect error:    sonia+mu+${random}@spryker.com    ${default_secure_password}
    [Teardown]    Run Keywords     Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Marketplace    Merchants
    ...    AND    Zed: click Action Button in a table for row that contains:     Video King     Edit
    ...    AND    Zed: go to tab by link href that contains:    merchant-user
    ...    AND    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Delete
    ...    AND    Zed: submit the form
    ...    AND    Delete dynamic admin user from DB

Approve_Offer
    [Documentation]    Checks that marketplace operator is able to approve or deny merchant's offer and it will be available or not in store due to this status
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: create dynamic merchant user:    Video King
    ...    AND    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer30 | 10             | true                  ||
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Offers
    Zed: select merchant in filter:    Video King
    Zed: click Action Button in a table for row that contains:     ${second_product_with_multiple_offers_concrete_sku}     Deny
    Trigger p&s
    Yves: go to the 'Home' page
    Yves: go to PDP of the product with sku:     ${second_product_with_multiple_offers_concrete_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    false
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Offers
    Zed: select merchant in filter:    Video King
    Zed: click Action Button in a table for row that contains:     ${second_product_with_multiple_offers_concrete_sku}    Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${second_product_with_multiple_offers_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: merchant's offer/product price should be:    Video King    ${second_product_with_multiple_offers_video_king_price}
    Yves: select xxx merchant's offer:    Video King
    Yves: product price on the PDP should be:     ${second_product_with_multiple_offers_video_king_price}
    [Teardown]    Run Keywords    Zed: delete merchant user:    ${dynamic_king_merchant}
    ...    AND    Delete dynamic admin user from DB
    ...    AND    Delete dynamic customer via API

Search_for_Merchant_Offers_and_Products
    [Documentation]    Checks that through search customer is able to see the list of merchant's products and offers
    Yves: go to the 'Home' page
    Yves: perform search by:    Video King
    Yves: go to the PDP of the first available product on open catalog page
    Yves: select random varian if variant selector is available
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: perform search by:    Spryker
    Yves: change sorting order on catalog page:    Sort by name ascending
    Yves: go to the PDP of the first available product on open catalog page
    Yves: select random varian if variant selector is available
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: perform search by:    ${EMPTY}
    Yves: select filter value:    Merchant    Budget Cameras
    Yves: go to the PDP of the first available product on open catalog page
    Yves: select random varian if variant selector is available
    Yves: merchant is (not) displaying in Sold By section of PDP:    Budget Cameras    true

Merchant_Portal_Product_Volume_Prices
    [Documentation]    Checks that merchant is able to create new multi-SKU product with volume prices. Falback to default price after delete
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: create dynamic merchant user:    Video King
    Repeat Keyword    3    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku    | product name          | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || VPSKU${random} | VPNewProduct${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    VPNewProduct${random}
    MP: click on a table row that contains:     VPNewProduct${random}
    MP: fill abstract product required fields:
    ...    || product name          | store | tax set           ||
    ...    || VPNewProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 100           ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default | quantity ||
    ...    || abstract     | 2          | DE    | EUR      | 10            | 2        ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    VPNewProduct${random}
    MP: open concrete drawer by SKU:    VPSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     VPNewProduct${random}     Approve
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     VPSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Reload
    Yves: change quantity on PDP:    4
    Yves: product price on the PDP should be:    €10.00
    Yves: merchant's offer/product price should be:    Video King     €10.00
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    sku=VPSKU${random}-2    productName=VPNewProduct${random}    productPrice=10.00
    Yves: assert merchant of product in cart or list:    VPSKU${random}-2    Video King
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Products
    MP: perform search by:    VPNewProduct${random}
    MP: click on a table row that contains:    VPNewProduct${random}
    MP: delete product price row that contains quantity:    2
    MP: save abstract product
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     VPSKU${random}
    Yves: change quantity on PDP:    4
    Yves: product price on the PDP should be:    €100.00
    Yves: merchant's offer/product price should be:    Video King     €100.00
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    sku=VPSKU${random}-2    productName=VPNewProduct${random}    productPrice=100.00
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     VPNewProduct${random}     Deny
    ...    AND    Trigger p&s
    ...    AND    Delete dynamic customer via API
    ...    AND    Delete dynamic admin user from DB

Merchant_Portal_Offer_Volume_Prices
    [Documentation]    Checks that merchant is able to create new offer with volume prices and it will be displayed on Yves. Falback to default price after delete.
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: create dynamic merchant user:    Video King
    ...    AND    Zed: create dynamic merchant user:    Spryker
    ...    AND    Repeat Keyword    3    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku       | product name             | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || OfferSKU${random} | OfferNewProduct${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    OfferNewProduct${random}
    MP: click on a table row that contains:     OfferNewProduct${random}
    MP: fill abstract product required fields:
    ...    || product name             | store | tax set           ||
    ...    || OfferNewProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 100           ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    OfferNewProduct${random}
    MP: open concrete drawer by SKU:    OfferSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     OfferNewProduct${random}     Approve
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}  
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:     OfferSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
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
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     OfferSKU${random}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: merchant's offer/product price should be:    Video King    €200.00
    Reload
    Yves: select xxx merchant's offer:    Video King
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    4
    Yves: product price on the PDP should be:    €10.00
    Yves: merchant's offer/product price should be:    Video King     €10.00
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: assert merchant of product in cart or list:    OfferSKU${random}-2    Video King
    Yves: shopping cart contains product with unit price:    sku=OfferSKU${random}-2    productName=OfferNewProduct${random}    productPrice=10.00
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Offers
    MP: perform search by:    OfferSKU${random}-2
    MP: click on a table row that contains:    volumeMerchantSKU${random}
    MP: delete offer price row that contains quantity:    2
    MP: save offer
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     OfferSKU${random}
    Reload
    Yves: select xxx merchant's offer:    Video King
    Yves: change quantity on PDP:    4
    Yves: product price on the PDP should be:    €200.00
    Yves: merchant's offer/product price should be:    Video King     €200.00
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    sku=OfferSKU${random}-2    productName=OfferNewProduct${random}    productPrice=200.00
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     OfferNewProduct${random}     Deny
    ...    AND    Trigger p&s
    ...    AND    Delete dynamic customer via API
    ...    AND    Delete dynamic admin user from DB

Merchant_Portal_Customer_Specific_Prices
    [Documentation]    Checks that customer will see product/offer prices specified by merchant for his business unit
    [Setup]    Run Keywords    Repeat Keyword    3    Trigger multistore p&s
    ...    AND    Zed: create dynamic merchant user:    Budget Cameras
    ...    AND    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Create dynamic customer in DB    based_on=${yves_test_company_user_email}
    MP: login on MP with provided credentials:    ${dynamic_budget_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku       | product name          | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || PriceSKU${random} | PriceProduct${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    PriceProduct${random}
    MP: click on a table row that contains:    PriceProduct${random}
    MP: fill abstract product required fields:
    ...    || product name          | store | tax set           ||
    ...    || PriceProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 500           ||
    MP: save abstract product 
    Repeat Keyword    3    Trigger p&s
    MP: click on a table row that contains:    riceProduct${random}
    MP: open concrete drawer by SKU:    PriceSKU${random}-2
    MP: fill product price values:
    ...    || product type | row number | customer               | store | currency | gross default ||
    ...    || concrete     | 1          | 2 - Hotel Tommy Berlin | DE    | EUR      | 100           ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 2          | DE    | EUR      | 500           ||
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    MP: save abstract product 
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     PriceSKU${random}     Approve
    Zed: save abstract product:    PriceSKU${random}
    Repeat Keyword    3    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract   | name de                       ||
    ...    || PriceSKU${random} | DEPriceProduct${random} force ||
    Repeat Keyword    3    Trigger multistore p&s
    Yves: login on Yves with provided credentials:     ${dynamic_second_customer}
    Yves: go to PDP of the product with sku:    PriceSKU${random}    wait_for_p&s=true
    Yves: merchant's offer/product price should be:    Budget Cameras     €100.00
    Yves: login on Yves with provided credentials:     ${dynamic_customer}
    Yves: go to PDP of the product with sku:    PriceSKU${random}
    Yves: merchant's offer/product price should be:    Budget Cameras     €500.00
    MP: login on MP with provided credentials:    ${dynamic_budget_merchant}
    MP: open navigation menu tab:    Products
    MP: perform search by:    PriceSKU${random}
    MP: click on a table row that contains:    PriceSKU${random}
    MP: open concrete drawer by SKU:    PriceSKU${random}-2
    MP: delete product price row that contains text:    2 - Hotel Tommy Berlin
    MP: save concrete product
    Repeat Keyword    3    Trigger p&s
    Yves: login on Yves with provided credentials:     ${dynamic_second_customer}
    Yves: go to PDP of the product with sku:    PriceSKU${random}
    Yves: merchant's offer/product price should be:    Budget Cameras     €500.00
    [Teardown]    Run Keywords    Delete dynamic customer via API    ${dynamic_second_customer}    
    ...    AND    Delete dynamic customer via API    ${dynamic_customer}    
    ...    AND    Delete dynamic admin user from DB

Merchant_Portal_My_Account
    [Documentation]    Checks that MU can edit personal data in MP. DMS-ON: https://spryker.atlassian.net/browse/FRW-7395
    [Setup]    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Sony Experts     Edit
    Zed: create new Merchant User with the following data:
    ...    || e-mail                             | first name     | last name      ||
    ...    || sonia+editmu+${random}@spryker.com | FName${random} | LName${random} ||
    Zed: perform merchant user search by:     sonia+editmu+${random}@spryker.com
    Zed: table should contain non-searchable value:    Deactivated
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+editmu+${random}@spryker.com    Activate
    Zed: table should contain non-searchable value:    Active
    Zed: update Zed user:
    ...    || oldEmail                           | newEmail | password      | firstName | lastName ||
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
    [Documentation]    Checks that merchant user is able to access the dashboard page. DMS-ON: https://spryker.atlassian.net/browse/FRW-7395
    [Setup]    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Sony Experts     Edit
    Zed: create new Merchant User with the following data:
    ...    || e-mail                               | first name      | last name       ||
    ...    || sonia+dahboard+${random}@spryker.com | DFName${random} | DLName${random} ||
    Zed: perform merchant user search by:     sonia+dahboard+${random}@spryker.com
    Zed: table should contain non-searchable value:    Deactivated
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+dahboard+${random}@spryker.com    Activate
    Zed: table should contain non-searchable value:    Active
    Zed: update Zed user:
    ...    || oldEmail                             | newEmail | password      | firstName | lastName ||
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
    ...    AND    Zed: create dynamic merchant user:    Video King
    ...    AND    Repeat Keyword    3    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku      | product name         | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || ViewSKU${random} | ViewProduct${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    ViewProduct${random}
    MP: click on a table row that contains:     ViewProduct${random}
    MP: fill abstract product required fields:
    ...    || product name         | store | tax set           ||
    ...    || ViewProduct${random} | DE    | Smart Electronics ||
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
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     ViewProduct${random}     Approve
    Trigger p&s
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
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 2          | DE    | EUR      | 200           | 1        ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 3          | DE    | EUR      | 10            | 2        ||
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
    Zed: filter by merchant:    Video King
    Zed: table should contain:    ViewSKU${random}-2
    Zed: click Action Button in a table for row that contains:     ViewSKU${random}-2     View
    Zed: view offer page is displayed
    Zed: view offer product page contains:
    ...    || approval status | status | store | sku                | name                 | merchant   | merchant sku             ||
    ...    || Approved        | Active | DE    | ViewSKU${random}-2 | ViewProduct${random} | Video King | viewMerchantSKU${random} ||
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     ViewProduct${random}     Deny
    ...    AND    Trigger p&s
    ...    AND    Zed: delete merchant user:    ${dynamic_spryker_merchant}
    ...    AND    Zed: delete merchant user:    ${dynamic_king_merchant}
    ...    AND    Delete dynamic admin user from DB

Manage_Merchant_Product
    [Documentation]    Checks that MU and BO user can manage merchant abstract and concrete products + add new concrete product
    [Setup]    Run Keywords    Repeat Keyword    3    Trigger multistore p&s
    ...    AND    Zed: create dynamic merchant user:    Budget Cameras
    ...    AND    Create dynamic customer in DB
    MP: login on MP with provided credentials:    ${dynamic_budget_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku        | product name           | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || manageSKU${random} | manageProduct${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    manageProduct${random}
    MP: click on a table row that contains:     manageProduct${random}
    MP: fill abstract product required fields:
    ...    || product name           | store | tax set           ||
    ...    || manageProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 90             ||
    MP: save abstract product 
    Trigger multistore p&s
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
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     manageProduct${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}   
    Yves: go to PDP of the product with sku:     manageSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: change variant of the product on PDP on:    white
    Yves: product price on the PDP should be:    €50.00    wait_for_p&s=true
    Yves: merchant's offer/product price should be:    Budget Cameras    €50.00
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    black
    Reload
    Yves: change quantity on PDP:    6
    Yves: product price on the PDP should be:    €10.00
    Yves: merchant's offer/product price should be:    Budget Cameras     €10.00
    Yves: try add product to the cart from PDP and expect error:    Item manageSKU${random}-2 only has availability of 3.
    Yves: go to PDP of the product with sku:     manageSKU${random}
    Yves: change variant of the product on PDP on:    black
    Yves: change quantity on PDP:    3
    Yves: product price on the PDP should be:    €10.00
    Yves: merchant's offer/product price should be:    Budget Cameras     €10.00
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    sku=manageSKU${random}-2    productName=manageProduct${random}    productPrice=10.00
    Yves: assert merchant of product in cart or list:    manageSKU${random}-2    Budget Cameras
    MP: login on MP with provided credentials:    ${dynamic_budget_merchant}
    MP: open navigation menu tab:    Products    
    MP: perform search by:    manageProduct${random}
    MP: click on a table row that contains:     manageProduct${random}
    MP: add new concrete product:
    ...    || first attribute | first attribute value | second attribute | second attribute value ||
    ...    || color           | Grey                  | series           | Ace Plus               ||
    MP: save abstract product
    MP: perform search by:    manageProduct${random}
    MP: click on a table row that contains:     manageProduct${random}
    MP: open concrete drawer by SKU:    manageSKU${random}-3
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 3              | true              | en_US         ||
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     manageProduct${random}     View
    Zed: view product page is displayed
    Zed: view abstract product page contains:
    ...    || merchant        | status   | store | sku                | name                   | variants count ||
    ...    || Budget Cameras  | Approved | DE    | manageSKU${random} | manageProduct${random} | 3              ||
    Zed: update abstract product price on:
    ...    || productAbstract    | store | mode  | type    | currency | amount ||
    ...    || manageSKU${random} | DE    | gross | default | €        | 110.00 ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract    | store | name en                         | name de                         | new from   | new to     ||
    ...    || manageSKU${random} | AT    | ENUpdatedmanageProduct${random} | DEUpdatedmanageProduct${random} | 01.01.2020 | 01.01.2030 ||
    Repeat Keyword    3    Trigger multistore p&s
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
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     manageSKU${random}
    Yves: product name on PDP should be:    ENUpdatedmanageProduct${random}
    Yves: product price on the PDP should be:    €110.00    wait_for_p&s=true
    Yves: change variant of the product on PDP on:    Grey
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     manageSKU${random}     Deny
    ...    AND    Trigger multistore p&s
    ...    AND    Delete dynamic admin user from DB
    ...    AND    Delete dynamic customer via API

Merchant_Product_Original_Price
    [Documentation]    checks that Orignal price is displayed on the PDP and in Catalog
    [Setup]    Run Keywords    Repeat Keyword    3    Trigger multistore p&s
    ...    AND    Zed: create dynamic merchant user:    Budget Cameras
    ...    AND    Create dynamic customer in DB
    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku          | product name             | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || originalSKU${random} | originalProduct${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    originalProduct${random}
    MP: click on a table row that contains:     originalProduct${random}
    MP: fill abstract product required fields:
    ...    || product name             | store | tax set           ||
    ...    || originalProduct${random} | DE    | Smart Electronics ||
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
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     originalProduct${random}     Approve
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}   
    Yves: go to URL:    en/search?q=originalSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: 1st product card in catalog (not)contains:     Original Price    €150.00
    Yves: go to PDP of the product with sku:     originalSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €150.00
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     originalSKU${random}     Deny
    ...    AND    Trigger p&s
    ...    AND    Delete dynamic admin user from DB
    ...    AND    Delete dynamic customer via API

Offer_Availability_Calculation
    [Tags]    smoke
    [Documentation]    check offer availability
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: create dynamic merchant user:    Video King
    ...    AND    Zed: create dynamic merchant user:    Spryker
    ...    AND    Zed: create dynamic merchant user:    merchant=Spryker    merchant_user_group=Root group
    ...    AND    Repeat Keyword    3    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku      | product name          | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || offAvKU${random} | offAvProduct${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    offAvProduct${random}
    MP: click on a table row that contains:     offAvProduct${random}
    MP: fill abstract product required fields:
    ...    || product name          | store | store 2 | tax set        ||
    ...    || offAvProduct${random} | DE    | AT      | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 90             ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 2           | AT    | EUR      | 200           | 90             ||
    MP: save abstract product 
    MP: click on a table row that contains:    offAvProduct${random}
    MP: open concrete drawer by SKU:    offAvKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 5              | true              | en_US         ||
    MP: open concrete drawer by SKU:    offAvKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 2          | AT    | EUR      | 50            || 
    MP: save concrete product
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     offAvProduct${random}     Approve
    Trigger p&s
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    offAvKU${random}-1
    MP: click on a table row that contains:    offAvKU${random}-1
    MP: fill offer fields:
    ...    || is active | merchant sku      | store | stock quantity ||
    ...    || true      | offAvMKU${random} | DE    | 5              ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | CHF      | 100           ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 2          | DE    | EUR      | 200           | 1        ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 3          | AT    | EUR      | 10            | 1        ||
    MP: save offer
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     offAvKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: merchant's offer/product price should be:    Spryker    €200.00
    Yves: select xxx merchant's offer:    Spryker
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 5.
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity on PDP:    3
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: assert merchant of product in cart or list:    offAvKU${random}-1    Spryker
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Standard
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 2.
    Zed: login on Zed with provided credentials:    ${dynamic_spryker_second_merchant}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Cancel
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 5.
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity on PDP:    3
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: assert merchant of product in cart or list:    offAvKU${random}-1    Spryker
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: delete merchant user:    ${dynamic_spryker_merchant}
    ...    AND    Zed: delete merchant user:    ${dynamic_king_merchant}
    ...    AND    Zed: delete merchant user:    ${dynamic_spryker_second_merchant}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:      offAvProduct${random}     Deny
    ...    AND    Trigger multistore p&s
    ...    AND    Delete dynamic admin user from DB
    ...    AND    Delete dynamic customer via API