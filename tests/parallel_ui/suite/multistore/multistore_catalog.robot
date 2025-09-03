*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree
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
Resource    ../../../../resources/steps/zed_store_steps.robot
Resource    ../../../../resources/steps/zed_cms_block_steps.robot
Resource    ../../../../resources/steps/customer_registration_steps.robot

*** Test Cases ***
Multistore_Product
    [Documentation]    check product multistore functionality
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: start new abstract product creation:
    ...    || sku               | store | store 2 | name en               | name de                 | new from   | new to     ||
    ...    || multiSKU${random} | DE    | AT      | multiProduct${random} | DEmultiProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 ||
    ...    || color       | grey              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set           ||
    ...    || DE    | gross | default | €        | 100.00 | Smart Electronics ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set           ||
    ...    || AT    | gross | default | €        | 200.00 | Smart Electronics ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract   | productConcrete              | active | searchable en | searchable de ||
    ...    || multiSKU${random} | multiSKU${random}-color-grey | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract   | productConcrete              | store | mode  | type    | currency | amount ||
    ...    || multiSKU${random} | multiSKU${random}-color-grey | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract   | productConcrete              | store | mode  | type    | currency | amount ||
    ...    || multiSKU${random} | multiSKU${random}-color-grey | AT    | gross | default | €        | 25.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract   | productConcrete              | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || multiSKU${random} | multiSKU${random}-color-grey | Warehouse2   | 100              | true                            ||
    Zed: update abstract product data:
    ...    || productAbstract   | name de                        ||
    ...    || multiSKU${random} | DEmultiProduct${random} forced ||
    Trigger multistore p&s
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     multiSKU${random}     Approve
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to URL:    en/search?q=multiSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: go to PDP of the product with sku:    multiSKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Yves: go to AT store 'Home' page if other store not specified:
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to AT store URL if other store not specified:    en/search?q=multiSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €200.00
    Yves: go to PDP of the product with sku:    multiSKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €25.00    wait_for_p&s=true
    Save current URL
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    multiSKU${random}-color-grey    multiProduct${random}    25.00
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: update abstract product data:
    ...    || productAbstract   | unselect store ||
    ...    || multiSKU${random} | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract   | unselect store ||
    ...    || multiSKU${random} | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Yves: navigate to specified AT store URL if no other store is specified and refresh until 404 occurs:    ${url}
    [Teardown]    Delete dynamic admin user from DB

Multistore_Product_Offer
    [Tags]    smoke
    [Documentation]    check product and offer multistore functionality.
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Zed: create dynamic merchant user:    Spryker
    ...    AND    Zed: create dynamic merchant user:    Video King
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku            | product name               | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || multistoreSKU${random} | multistoreProduct${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    multistoreProduct${random}
    MP: click on a table row that contains:     multistoreProduct${random}
    MP: fill abstract product required fields:
    ...    || product name               | store | store 2 |  tax set       ||
    ...    || multistoreProduct${random} | DE    | AT      | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 90             ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 2           | AT    | EUR      | 300           | 90             ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    multistoreProduct${random}
    MP: open concrete drawer by SKU:    multistoreSKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    MP: open concrete drawer by SKU:    multistoreSKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 2          | AT    | EUR      | 55            ||
    MP: save concrete product
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     multistoreProduct${random}     Approve
    Zed: save abstract product:    multistoreProduct${random}
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}  
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: product price on the PDP should be:    €50.00    wait_for_p&s=true
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    multistoreSKU${random}-1
    MP: click on a table row that contains:    multistoreSKU${random}-1
    MP: fill offer fields:
    ...    || is active | merchant sku                   | store | store 2 | stock quantity ||
    ...    || true      | multistoreMerchantSKU${random} | DE    | AT      | 100            ||
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
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: merchant's offer/product price should be:    Spryker    €200.00
    Yves: go to AT store 'Home' page if other store not specified:
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: product price on the PDP should be:    €55.00    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: merchant's offer/product price should be:    Spryker    €10.00
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Offers
    MP: perform search by:    multistoreSKU${random}-1
    MP: click on a table row that contains:    multistoreSKU${random}-1
    MP: fill offer fields:
    ...    || is active | unselect store ||
    ...    || true      | AT             ||         
    MP: save offer
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to AT store 'Home' page if other store not specified:
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    false
    Save current URL
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: update abstract product data:
    ...    || productAbstract        | unselect store ||
    ...    || multistoreSKU${random} | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract        | unselect store ||
    ...    || multistoreSKU${random} | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Yves: navigate to specified AT store URL if no other store is specified and refresh until 404 occurs:    ${url}
    [Teardown]    Delete dynamic admin user from DB

Multistore_CMS
    [Documentation]    check CMS multistore functionality
    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create a cms page and publish it:    Multistore Page${random}    multistore-page${random}    Multistore Page    Page text
    Trigger multistore p&s
    Yves: go to newly created page by URL on AT store if other store not specified:    en/multistore-page${random}
    Save current URL
    Yves: page contains CMS element:    CMS Page Title    Multistore Page
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: update cms page and publish it:
    ...    || cmsPage                  | unselect store ||
    ...    || Multistore Page${random} | AT             ||
    Yves: navigate to specified AT store URL if no other store is specified and refresh until 404 occurs:    ${url}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Content    Pages
    ...    AND    Zed: click Action Button in a table for row that contains:    Multistore Page${random}    Deactivate