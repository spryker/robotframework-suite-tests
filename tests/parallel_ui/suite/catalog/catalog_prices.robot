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
Volume_Prices
    [Documentation]    Checks that volume prices are applied in cart
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: check and restore product availability in Zed:    ${volume_prices_product_abstract_sku}    Available    ${volume_prices_product_concrete_sku}    ${dynamic_admin_user}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${volume_prices_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    5
    Yves: product price on the PDP should be:    €16.50
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    sku=${volume_prices_product_concrete_sku}    productName=${volume_prices_product_name}    productPrice=16.50
    [Teardown]    Delete dynamic admin user from DB

Product_Original_Price
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    [Documentation]    checks that Original price is displayed on the PDP and in Catalog
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: start new abstract product creation:
    ...    || sku                     | store | name en                  | name de                    | new from   | new to     ||
    ...    || zedOriginalSKU${random} | DE    | originalProduct${random} | DEoriginalProduct${random} | 01.01.2020 | 01.01.2030 ||
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
    ...    || productAbstract         | productConcrete                    | active | searchable en | searchable de ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-grey | true   | true          | true          ||
    Zed: change concrete product data:
    ...    || productAbstract         | productConcrete                    | active | searchable en | searchable de ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-blue | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract         | productConcrete                    | store | mode  | type    | currency | amount ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-blue | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract         | productConcrete                    | store | mode  | type     | currency | amount ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-blue | DE    | gross | original | €        | 50.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract         | productConcrete                    | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-grey | Warehouse1   | 100              | true                            ||
    Zed: change concrete product stock:
    ...    || productAbstract         | productConcrete                    | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-blue | Warehouse1   | 100              | false                           ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract         | name de                        ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random} forced ||
    Trigger multistore p&s
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     zedOriginalSKU${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to URL:    en/search?q=zedOriginalSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: 1st product card in catalog (not)contains:     Original Price    €200.00
    Yves: go to PDP of the product with sku:    zedOriginalSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €200.00
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change variant of the product on PDP on:    blue
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €50.00
    [Teardown]    Delete dynamic admin user from DB

Customer_Specific_Prices
    [Documentation]    Checks that product price can be different for different customers
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic customer in DB    based_on=${yves_test_company_user_email}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: perform search by:    ${product_with_merchant_price_abstract_sku}
    Yves: product with name in the catalog should have price:    ${product_with_merchant_price_product_name}    ${product_with_merchant_price_default_price}
    Yves: go to PDP of the product with sku:    ${product_with_merchant_price_abstract_sku}
    Yves: product price on the PDP should be:    ${product_with_merchant_price_default_price}
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${dynamic_second_customer}
    Yves: perform search by:    ${product_with_merchant_price_abstract_sku}
    Yves: product with name in the catalog should have price:    ${product_with_merchant_price_product_name}    ${product_with_merchant_price_merchant_price}
    Yves: go to PDP of the product with sku:    ${product_with_merchant_price_abstract_sku}
    Yves: product price on the PDP should be:    ${product_with_merchant_price_merchant_price}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    sku=${product_with_merchant_price_concrete_sku}    productName=${product_with_merchant_price_product_name}    productPrice=${product_with_merchant_price_merchant_price}