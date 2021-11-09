*** Settings ***
Library    BuiltIn
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Resource    ../../Resources/Common/Common.robot
Resource    ../../Resources/Steps/Header_steps.robot
Resource    ../../Resources/Common/Common_Yves.robot
Resource    ../../Resources/Common/Common_Zed.robot
Resource    ../../Resources/Steps/PDP_steps.robot
Resource    ../../Resources/Steps/Shopping_Lists_steps.robot
Resource    ../../Resources/Steps/Checkout_steps.robot
Resource    ../../Resources/Steps/Customer_Registration_steps.robot
Resource    ../../Resources/Steps/Order_History_steps.robot
Resource    ../../Resources/Steps/Product_Set_steps.robot
Resource    ../../Resources/Steps/Catalog_steps.robot
Resource    ../../Resources/Steps/Agent_Assist_steps.robot
Resource    ../../Resources/Steps/Company_steps.robot
Resource    ../../Resources/Steps/Customer_Account_steps.robot
Resource    ../../Resources/Steps/Configurable_Bundle_steps.robot
Resource    ../../Resources/Steps/Zed_Users_steps.robot
Resource    ../../Resources/Steps/Products_steps.robot
Resource    ../../Resources/Steps/Orders_Management_steps.robot
Resource    ../../Resources/Steps/Wishlist_steps.robot
Resource    ../../Resources/Steps/Zed_Availability_steps.robot
Resource    ../../Resources/Steps/Zed_Discount_steps.robot
Resource    ../../Resources/Steps/Zed_CMS_Page_steps.robot
Resource    ../../Resources/Steps/Zed_Customer_steps.robot

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
