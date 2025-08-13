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
Offer_Availability_Calculation
    [Documentation]    check offer availability
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: create dynamic merchant user:    Office King
    ...    AND    Zed: create dynamic merchant user:    Spryker
    ...    AND    Zed: create dynamic merchant user:    merchant=Spryker    merchant_user_group=Root group
    ...    AND    Repeat Keyword    3    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Products
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku      | product name          | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || offAvKU${random} | offAvProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
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
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:     offAvProduct${random}     Approve
    Trigger multistore p&s
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
    Repeat Keyword    2    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     offAvKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: merchant's offer/product price should be:    Spryker    €200.00
    Yves: select xxx merchant's offer:    Spryker
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: assert merchant of product in cart or list:    offAvKU${random}-1    Spryker
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method for the shipment:    1    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 2.
    Zed: login on Zed with provided credentials:    ${dynamic_spryker_second_merchant}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Cancel
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: assert merchant of product in cart or list:    offAvKU${random}-1    Spryker
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products
    ...    AND    Zed: click Action Button in a table for row that contains:      offAvProduct${random}     Deny
    ...    AND    Delete dynamic admin user from DB