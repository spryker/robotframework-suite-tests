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
Manage_Merchant_Product
    [Documentation]    Checks that MU and BO user can manage merchant abstract and concrete products + add new concrete product
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: create dynamic merchant user:    Office King
    ...    AND    Repeat Keyword    3    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku        | product name           | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || manageSKU${random} | manageProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    manageProduct${random}
    MP: click on a table row that contains:     manageProduct${random}
    MP: fill abstract product required fields:
    ...    || product name           | store | tax set        ||
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
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     manageProduct${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
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
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    manageSKU${random}-2    manageProduct${random}    10.00
    Yves: assert merchant of product in cart or list:    manageSKU${random}-2    Office King
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
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
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
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
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     manageSKU${random}
    Yves: product name on PDP should be:    ENUpdatedmanageProduct${random}
    Yves: product price on the PDP should be:    €110.00    wait_for_p&s=true
    Yves: change variant of the product on PDP on:    5-pack
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     manageSKU${random}     Deny
    ...    AND    Delete dynamic admin user from DB
    
Merchant_Product_Original_Price
    [Documentation]    checks that Original price is displayed on the PDP and in Catalog
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: create dynamic merchant user:    Office King
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku          | product name             | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || originalSKU${random} | originalProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    originalProduct${random}
    MP: click on a table row that contains:     originalProduct${random}
    MP: fill abstract product required fields:
    ...    || product name             | store | tax set        ||
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
    MP: save concrete product
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     originalProduct${random}     Approve
    Zed: save abstract product:    originalProduct${random}
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
    ...    AND    Delete dynamic admin user from DB