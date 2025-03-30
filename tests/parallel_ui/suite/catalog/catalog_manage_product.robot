*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one
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
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/steps/zed_root_menus_steps.robot
Resource    ../../../../resources/steps/minimum_order_value_steps.robot
Resource    ../../../../resources/steps/availability_steps.robot
Resource    ../../../../resources/steps/glossary_steps.robot
Resource    ../../../../resources/steps/order_comments_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot
Resource    ../../../../resources/steps/dynamic_entity_steps.robot
Resource    ../../../../resources/steps/merchants_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot
Resource    ../../../../resources/pages/yves/yves_product_configurator_page.robot
Resource    ../../../../resources/pages/yves/yves_product_details_page.robot
Resource    ../../../../resources/pages/zed/zed_order_details_page.robot

*** Test Cases ***
Manage_Product
    [Tags]    smoke
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    [Documentation]    checks that BO user can manage abstract and concrete products + create new
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: start new abstract product creation:
    ...    || sku                   | store | name en                | name de                  | new from   | new to     ||
    ...    || zedManageSKU${random} | DE    | manageProduct${random} | DEmanageProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 | attribute 2 | attribute value 2 ||
    ...    || color       | grey              | color       | blue              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set           ||
    ...    || DE    | gross | default | €        | 100.00 | Smart Electronics ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract       | productConcrete                  | active | searchable en | searchable de ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-grey | true   | true          | true          ||
    Zed: change concrete product data:
    ...    || productAbstract       | productConcrete                  | active | searchable en | searchable de ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-blue | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract       | productConcrete                  | store | mode  | type    | currency | amount ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-blue | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract       | productConcrete                  | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-grey | Warehouse1   | 100              | true                            ||
    Zed: change concrete product stock:
    ...    || productAbstract       | productConcrete                  | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-blue | Warehouse1   | 100              | false                           ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract       | name de                        ||
    ...    || zedManageSKU${random} | DEmanageProduct${random} force ||
    Trigger multistore p&s
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     zedManageSKU${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    zedManageSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change variant of the product on PDP on:    grey
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    blue
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: add new concrete product to abstract:
    ...    || productAbstract       | sku                               | autogenerate sku | attribute 1 | name en                  | name de                  | use prices from abstract ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-black | false            | black       | ENaddedConcrete${random} | DEaddedConcrete${random} | true                     ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract       | productConcrete                   | active | searchable en | searchable de ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-black | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract       | productConcrete                   | store | mode  | type    | currency | amount ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-black | DE    | gross | default | €        | 25.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract       | productConcrete                   | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-black | Warehouse1   | 5                | false                           ||
    Zed: update abstract product price on:
    ...    || productAbstract       | store | mode  | type    | currency | amount | tax set           ||
    ...    || zedManageSKU${random} | DE    | gross | default | €        | 150.00 | Smart Electronics ||
    Zed: save abstract product:    zedManageSKU${random}
    Trigger multistore p&s
    Zed: update abstract product price on:
    ...    || productAbstract       | store | mode  | type    | currency | amount | tax set           ||
    ...    || zedManageSKU${random} | DE    | gross | default | €        | 150.00 | Smart Electronics ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract       | name en                         | name de                         ||
    ...    || zedManageSKU${random} | ENUpdatedmanageProduct${random} | DEUpdatedmanageProduct${random} ||
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    zedManageSKU${random}    wait_for_p&s=true
    Yves: product name on PDP should be:    ENUpdatedmanageProduct${random}
    Yves: product price on the PDP should be:    €150.00    wait_for_p&s=true
    Yves: change variant of the product on PDP on:    grey
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    blue
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    black
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product name on PDP should be:    ENaddedConcrete${random}
    Yves: product price on the PDP should be:    €25.00    wait_for_p&s=true
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item zedManageSKU${random}-color-black only has availability of 5.
    Yves: go to PDP of the product with sku:    zedManageSKU${random}
    Yves: change variant of the product on PDP on:    black
    Yves: change quantity on PDP:    3
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    zedManageSKU${random}-color-black    ENaddedConcrete${random}    25.00
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     manageProduct${random}     View
    Zed: view product page is displayed
    Zed: view abstract product page contains:
    ...    || store | sku                   | name                          | variants count ||
    ...    || DE AT | zedManageSKU${random} | UpdatedmanageProduct${random} | 3              ||
    [Teardown]    Delete dynamic admin user from DB