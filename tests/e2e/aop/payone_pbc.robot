*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Test Teardown     TestTeardown
Suite Teardown    SuiteTeardown
Resource    ../../../resources/common/common_aop.robot
Resource    ../../../resources/common/common.robot
Resource    ../../../resources/common/common_yves.robot
Resource    ../../../resources/common/common_zed.robot
Resource    ../../../resources/steps/aop_catalog_steps.robot
Resource    ../../../resources/steps/payone_steps.robot
Resource    ../../../resources/steps/pdp_steps.robot
Resource    ../../../resources/steps/shopping_carts_steps.robot
Resource    ../../../resources/steps/checkout_steps.robot
Resource    ../../../resources/steps/zed_payment_methods_steps.robot
Resource    ../../../resources/steps/order_history_steps.robot
Resource    ../../../resources/steps/orders_management_steps.robot

*** Test Cases ***
Payone_E2E
    [Documentation]    Checks that payone pbc can be connected in the backoffice and is reflected to the storefront
    [Setup]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Payone: create Beeceptor relay
    Zed: go to first navigation item level:    Apps
    Zed: AOP catalog page should contain apps:    Payone    BazaarVoice
    Zed: go to the PBC details page:    Payone
    Zed: PBC details page should contain elements:    ${appTitle}    ${appShortDescription}    ${appAuthor}   ${appLogo}
    Zed: click button on the PBC details page:    connect
    Zed: PBC details page should contain elements:    ${appPendingStatus}
    Zed: click button on the PBC details page:    configure
    Zed: configure payone pbc with data:
    ...    || credentialsKey   | merchantId | subAccountId | paymentPortalId | mode | methods            ||
    ...    || s6RUCzClrUaHQcDH | 32481      | 32893        | 2024080         | Test | Credit Card,PayPal ||
    Zed: submit pbc configuration form
    Zed: PBC details page should contain elements:    ${appConnectedStatus}
    Zed: activate/deactivate payment method:    Payone    Credit Card

    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}

    # Cancel order scenario
    Yves: create new 'Shopping Cart' with name:    payone+${random}
    Yves: go to PDP of the product with sku:    136
    Yves: add product to the shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | Robot     | payone   | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select shipping method on checkout and go next:    Air Sonic
    Yves: select payment method on checkout and go next:    Credit Card    Payone
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Payone: cancel payment
    Yves: 'Payment cancellation' page is displayed

    # Pay order scenario
    Yves: create new 'Shopping Cart' with name:    payone+${random}
    Yves: go to PDP of the product with sku:    136
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    142
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    150
    Yves: add product to the shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | Robot     | payone   | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select shipping method on checkout and go next:    Air Sonic
    Yves: select payment method on checkout and go next:    Credit Card    Payone
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Payone: submit credit card with data:
    ...    || cardType | cardNumber       | nameOnCard | expireYear | expireMonth | cvc ||
    ...    || V        | 4111111111111111 | Robot      | 2030       | 1           | 111 ||
    Wait Until Page Contains Element    ${success_page_main_container_locator}[${env}]
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger matching state of order item inside xxx shipment:    136    invoice customer
    Zed: trigger matching state of order item inside xxx shipment:    136    Ship
    Zed: trigger matching state of order item inside xxx shipment:    136    request payment
    Zed: trigger matching state of order item inside xxx shipment:    142    cancel reservation
    Zed: wait for order item to be in state:    142    reservation cancellation pending
    Zed: trigger matching state of order item inside xxx shipment:    150    invoice customer
    Zed: trigger matching state of order item inside xxx shipment:    150    Ship
    Zed: trigger matching state of order item inside xxx shipment:    150    request payment
    Zed: wait for order item to be in state:    136    payment confirmed
    Zed: wait for order item to be in state:    150    payment confirmed
    Zed: wait for order item to be in state:    142    reservation cancelled
    Zed: trigger matching state of order item inside xxx shipment:    142    Close
    Zed: wait for order item to be in state:    142    canceled
    Zed: trigger matching state of order item inside xxx shipment:    136    deliver

    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    136
    Yves: 'Return Details' page is displayed

    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: wait for order item to be in state:    136    waiting for return
    Zed: trigger matching state of order item inside xxx shipment:    136    Execute return
    Zed: trigger matching state of order item inside xxx shipment:    136    Refund
    Zed: wait for order item to be in state:    136    payment refunded
    Zed: trigger matching state of order item inside xxx shipment:    136    Close
    Zed: wait for order item to be in state:    136    canceled
    Zed: trigger matching state of order item inside xxx shipment:    150    deliver
    Zed: trigger matching state of order item inside xxx shipment:    150    Close
    Zed: wait for order item to be in state:    150    closed

    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to first navigation item level:    Apps
    ...    AND    Zed: go to the PBC details page:    Payone
    ...    AND    Zed: Disconnect pbc
