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
Product_Original_Price
    [Documentation]    checks that Original price is displayed on the PDP and in Catalog
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: start new abstract product creation:
    ...    || sku                  | store | name en                  | name de                    | new from   | new to     ||
    ...    || originalSKU${random} | DE    | originalProduct${random} | DEoriginalProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 | attribute 2 | attribute value 2 ||
    ...    || color       | grey              | color       | blue              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set           ||
    ...    || DE    | gross | default | €        | 100.00 | Smart Electronics ||
    Zed: update abstract product price on:
    ...    || store | mode  | type     | currency | amount | tax set           ||
    ...    || DE    | gross | original | €        | 200.00 | Smart Electronics ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract      | productConcrete                 | active | searchable en | searchable de ||
    ...    || originalSKU${random} | originalSKU${random}-color-grey | true   | true          | true          ||
    Zed: change concrete product data:
    ...    || productAbstract      | productConcrete                 | active | searchable en | searchable de ||
    ...    || originalSKU${random} | originalSKU${random}-color-blue | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract      | productConcrete                 | store | mode  | type    | currency | amount ||
    ...    || originalSKU${random} | originalSKU${random}-color-blue | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract      | productConcrete                 | store | mode  | type     | currency | amount ||
    ...    || originalSKU${random} | originalSKU${random}-color-blue | DE    | gross | original | €        | 50.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract      | productConcrete                 | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || originalSKU${random} | originalSKU${random}-color-grey | Warehouse1   | 100              | true                            ||
    Zed: change concrete product stock:
    ...    || productAbstract      | productConcrete                 | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || originalSKU${random} | originalSKU${random}-color-blue | Warehouse1   | 100              | false                           ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract      | name de                     ||
    ...    || originalSKU${random} | originalSKU${random} forced ||
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to URL:    en/search?q=originalSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: 1st product card in catalog (not)contains:     Original Price    €200.00
    Yves: go to PDP of the product with sku:    originalSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €200.00
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change variant of the product on PDP on:    blue
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €50.00
    [Teardown]    Delete dynamic admin user from DB