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
Resource    ../../../../resources/steps/zed_payment_methods_steps.robot

*** Test Cases ***
Minimum_Order_Value
    [Documentation]    checks that global minimum and maximun order thresholds can be applied
    [Setup]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate all discounts from Overview page
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: change global threshold settings:
    ...    || store & currency | minimum hard value | minimum hard en message  | minimum hard de message  | maximun hard value | maximun hard en message | maximun hard de message | soft threshold                | soft threshold value | soft threshold fixed fee | soft threshold en message | soft threshold de message ||
    ...    || DE - Euro [EUR]  | 5                  | EN minimum {{threshold}} | DE minimum {{threshold}} | 150                | EN max {{threshold}}    | DE max {{threshold}}    | Soft Threshold with fixed fee | 100000               | 9                        | EN fixed {{fee}} fee      | DE fixed {{fee}} fee      ||
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${available_never_out_of_stock_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: soft threshold surcharge is added in the cart:    €9.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_user_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Standard
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: soft threshold surcharge is added on summary page:    €9.00
    Yves: hard threshold is applied with the following message:    €150.00
    Yves: go to the 'Home' page
    Yves: go to b2c shopping cart
    Yves: delete product from the shopping cart with sku:    ${available_never_out_of_stock_concrete_sku}
    Yves: soft threshold surcharge is added in the cart:    €9.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: soft threshold surcharge is added on summary page:    €9.00
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €83.90
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    	Free mobile phone    20% off cameras products    Free Acer M2610 product    Free delivery    10% off Intel products    5% off white products    Tuesday & Wednesday $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Zed: change global threshold settings:
    ...    || store & currency | minimum hard value | minimum hard en message | minimum hard de message | maximun hard value | maximun hard en message                                                                                   | maximun hard de message                                                                                                              | soft threshold | soft threshold value | soft threshold en message | soft threshold de message ||
    ...    || DE - Euro [EUR]  | ${SPACE}           | ${SPACE}                | ${SPACE}                | 10000.00           | The cart value cannot be higher than {{threshold}}. Please remove some items to proceed with the order    | Der Warenkorbwert darf nicht höher als {{threshold}} sein. Bitte entfernen Sie einige Artikel, um mit der Bestellung fortzufahren    | None           | ${EMPTY}             | ${EMPTY}                  | ${EMPTY}                  ||

Zed_navigation_ordering_and_naming
    [Tags]    smoke
    [Documentation]    Verifies each left navigation node can be opened. DMS ON: https://spryker.atlassian.net/browse/FRW-7394
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: verify first navigation root menus
    Zed: verify root menu icons
    Zed: verify second navigation root menus

Glossary
    [Documentation]    Create + edit glossary translation in BO
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Administration    Glossary  
    Zed: click button in Header:    Create Translation
    Zed: fill glossary form:
    ...    || Name                     | EN_US                        | DE_DE                             ||
    ...    || cart.price.test${random} | This is a sample translation | Dies ist eine Beispielübersetzung ||
    Zed: submit the form
    Zed: table should contain:    cart.price.test${random}
    Zed: go to second navigation item level:    Administration    Glossary 
    Zed: click Action Button in a table for row that contains:    ${glossary_name}    Edit
    Zed: fill glossary form:
    ...    || DE_DE                    | EN_US                              ||
    ...    || ${original_DE_text}-Test | ${original_EN_text}-Test-${random} ||
    Zed: submit the form
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: validate the page title:    ${original_EN_text}-Test-${random}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: undo the changes in glossary translation:    ${glossary_name}     ${original_DE_text}    ${original_EN_text}
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: validate the page title:    ${original_EN_text}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: undo the changes in glossary translation:    ${glossary_name}     ${original_DE_text}    ${original_EN_text}
    ...    AND    Trigger p&s

Payment_method_update
    [Documentation]    Deactivate payment method, unset payment method for stores in zed and check its impact on yves.
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:    020
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart    
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: fill in the following new shipping address:
    ...    ||      firstName                    |           lastName                  |    street           |    houseNumber     |    city      |    postCode    |    phone        ||
    ...    || ${yves_second_user_first_name}    |     ${yves_second_user_last_name}   |    ${random}        |    ${random}       |    Berlin    |   ${random}    |    ${random}    ||
    Yves: billing address same as shipping address:    true
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:     Standard: €4.90
    Yves: check that the payment method is/not present in the checkout process:    ${checkout_payment_invoice_locator}    true
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: activate/deactivate payment method:    Dummy Payment    Invoice    False
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to b2c shopping cart    
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: fill in the following new shipping address:
    ...    ||      firstName                    |           lastName                  |    street           |    houseNumber     |    city     |    postCode    |    phone        ||
    ...    || ${yves_second_user_first_name}    |     ${yves_second_user_last_name}   |    ${random}        |    ${random}       |    Berlin   |   ${random}    |    ${random}    ||
    Yves: billing address same as shipping address:    true
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:     Standard: €4.90
    Yves: check that the payment method is/not present in the checkout process:     ${checkout_payment_invoice_locator}    false
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate/deactivate payment method:    Dummy Payment    Invoice    True
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
