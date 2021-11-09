*** Settings ***
Library    BuiltIn
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Resource    ../../resources/common/common.robot
Resource    ../../resources/steps/header_steps.robot
Resource    ../../resources/common/common_yves.robot
Resource    ../../resources/common/common_zed.robot
Resource    ../../resources/steps/pdp_steps.robot
Resource    ../../resources/steps/shopping_lists_steps.robot
Resource    ../../resources/steps/checkout_steps.robot
Resource    ../../resources/steps/customer_registration_steps.robot
Resource    ../../resources/steps/order_history_steps.robot
Resource    ../../resources/steps/product_set_steps.robot
Resource    ../../resources/steps/catalog_steps.robot
Resource    ../../resources/steps/agent_assist_steps.robot
Resource    ../../resources/steps/company_steps.robot
Resource    ../../resources/steps/customer_account_steps.robot
Resource    ../../resources/steps/configurable_bundle_steps.robot
Resource    ../../resources/steps/zed_users_steps.robot
Resource    ../../resources/steps/products_steps.robot
Resource    ../../resources/steps/orders_management_steps.robot
Resource    ../../resources/steps/wishlist_steps.robot
Resource    ../../resources/steps/zed_availability_steps.robot
Resource    ../../resources/steps/zed_discount_steps.robot
Resource    ../../resources/steps/zed_cms_page_steps.robot
Resource    ../../resources/steps/zed_customer_steps.robot

*** Test Cases ***


Split_Delivery
    [Documentation]    Checks split delivery in checkout
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    011
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    012
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select delivery to multiple addresses
    Yves: select new delivery address for a product:    Canon IXUS 285    true    no    Mr    Product    285    Kirncher Str.    7    10247    Berlin    Germany
    Yves: select new delivery address for a product:    Canon IXUS 180    true    no    Mr    Product    180    Kirncher Str.    7    10247    Berlin    Germany
    Yves: select new delivery address for a product:    Canon IXUS 165    true    no    Mr    Product    165    Kirncher Str.    7    10247    Berlin    Germany
    Yves: fill in the following billing address:    Mr    Product    165    Kirncher Str.    7    10247    Berlin    Germany
    Yves: click checkout button:    Next
    Yves: select the following shipping method for product:    Canon IXUS 285    Express
    Yves: select the following shipping method for product:    Canon IXUS 180    Standard
    Yves: select the following shipping method for product:    Canon IXUS 165    Express
    Click    ${submit_checkout_form_button}
        
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Yves: check if cart is not empty and clear it
