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
Product_Availability_Calculation
    [Documentation]    Check product availability + multistore
    [Setup]    Run Keywords    Repeat Keyword    3    Trigger multistore p&s
    ...    AND    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: update warehouse:    
    ...    || warehouse  | store || 
    ...    || Warehouse1 | AT    ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: start new abstract product creation:
    ...    || sku                      | store | store 2 | name en                      | name de                        | new from   | new to     ||
    ...    || availabilitySKU${random} | DE    | AT      | availabilityProduct${random} | DEavailabilityProduct${random} | 01.01.2020 | 01.01.2030 ||
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
    ...    || productAbstract          | productConcrete                     | active | searchable en | searchable de ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-color-grey | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract          | productConcrete                     | store | mode  | type    | currency | amount ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-color-grey | DE    | gross | default | €        | 50.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract          | productConcrete                     | store | mode  | type    | currency | amount ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-color-grey | AT    | gross | default | €        | 75.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract          | productConcrete                     | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-color-grey | Warehouse1   | 5                | false                           ||
    Trigger multistore p&s
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     availabilitySKU${random}     Approve
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-color-grey only has availability of 5.
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: change quantity on PDP:    3
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed    
    Trigger oms
    Yves: get the last placed order ID by current customer
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-color-grey only has availability of 2.
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Cancel
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-color-grey only has availability of 5.
    Yves: go to AT store 'Home' page if other store not specified:
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: update warehouse:    
    ...    || warehouse  | unselect store || 
    ...    || Warehouse1 | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to AT store 'Home' page if other store not specified:
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: update warehouse:    
    ...    || warehouse  | unselect store || 
    ...    || Warehouse1 | AT             ||
    ...    AND    Repeat Keyword    3    Trigger multistore p&s
    ...    AND    Delete dynamic admin user from DB