*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Test Teardown     TestTeardown
Suite Teardown    SuiteTeardown
Test Tags    robot:recursive-stop-on-failure
Resource    ../../../resources/common/common.robot
Resource    ../../../resources/steps/header_steps.robot
Resource    ../../../resources/common/common_yves.robot
Resource    ../../../resources/common/common_zed.robot
Resource    ../../../resources/steps/pdp_steps.robot
Resource    ../../../resources/steps/shopping_lists_steps.robot
Resource    ../../../resources/steps/checkout_steps.robot
Resource    ../../../resources/steps/order_history_steps.robot
Resource    ../../../resources/steps/product_set_steps.robot
Resource    ../../../resources/steps/catalog_steps.robot
Resource    ../../../resources/steps/agent_assist_steps.robot
Resource    ../../../resources/steps/company_steps.robot
Resource    ../../../resources/steps/customer_account_steps.robot
Resource    ../../../resources/steps/configurable_bundle_steps.robot
Resource    ../../../resources/steps/zed_users_steps.robot
Resource    ../../../resources/steps/products_steps.robot
Resource    ../../../resources/steps/orders_management_steps.robot
Resource    ../../../resources/steps/zed_customer_steps.robot
Resource    ../../../resources/steps/zed_discount_steps.robot
Resource    ../../../resources/steps/zed_availability_steps.robot
Resource    ../../../resources/steps/zed_cms_page_steps.robot
Resource    ../../../resources/steps/zed_root_menus_steps.robot
Resource    ../../../resources/steps/minimum_order_value_steps.robot
Resource    ../../../resources/steps/availability_steps.robot
Resource    ../../../resources/steps/glossary_steps.robot
Resource    ../../../resources/steps/order_comments_steps.robot
Resource    ../../../resources/steps/zed_order_steps.robot
Resource    ../../../resources/steps/configurable_product_steps.robot

*** Test Cases ***
Guest_User_Access_Restrictions
    [Documentation]    Checks that guest users are not able to see: Prices, Availability, Quick Order, "My Account" features
    Yves: header contains/doesn't contain:    false    ${priceModeSwitcher}    ${currencySwitcher}[${env}]     ${quickOrderIcon}    ${accountIcon}    ${shoppingListIcon}    ${shoppingCartIcon}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku} 
    Yves: PDP contains/doesn't contain:     false    ${pdpPriceLocator}    ${addToCartButton}
    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    Yves: header contains/doesn't contain:    true    ${priceModeSwitcher}    ${currencySwitcher}[${env}]    ${quickOrderIcon}    ${accountIcon}    ${shoppingListIcon}    ${shoppingCartIcon}
    Yves: company menu 'should' be available for logged in user
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}    ${addToCartButton}
    Yves: go to company menu item:    Users
    Yves: 'Company Users' page is displayed

Quick_Order
    [Documentation]    Checks Quick Order, checkout and Reorder
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    quickOrderCart+${random}
    ...    AND    Yves: create new 'Shopping List' with name:    quickOrderList+${random}
    Yves: go to 'Quick Order' page through the header
    Yves: 'Quick Order' page is displayed
    Yves: add the following articles into the form through quick order text area:    401627,1\n520561,3\n421340,21\n419871,1\n419869,11\n425073,1\n425084,2
    Yves: add products to the shopping cart from quick order page
    Yves: go to the shopping cart through the header with name:    quickOrderCart+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    401627    520561    421340    419871    419869    425073    425084
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to 'Quick Order' page through the header
    Yves: add the following articles into the form through quick order text area:    401627,1\n520561,3\n421340,21\n419871,1\n419869,11\n425073,1\n425084,2
    Yves: add products to the shopping list from quick order page with name:    quickOrderList+${random}
    Yves: 'Shopping List' page is displayed
    Yves: shopping list contains the following products:    401627    520561    421340    419871    419869    425073    425084
    Yves: go to the shopping cart through the header with name:    quickOrderCart+${random}
    ### Order placement ###
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    ### Order History ###
    Yves: go to the 'Home' page
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page is displayed
    ### Reorder ###
    Yves: reorder all items from 'Order Details' page
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    401627    520561    421340    419871    419869    425073    425084
    [Teardown]    Yves: delete 'Shopping List' with name:    quickOrderList+${random}

Volume_Prices
    [Documentation]    Checks that volume prices are applied in cart
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    VolumePriceCart+${random}
    Yves: go to PDP of the product with sku:    M21189
    Yves: change quantity on PDP:    5
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    VolumePriceCart+${random}
    Yves: shopping cart contains product with unit price:    420685    Post-it stick note Super Sticky Meeting Notes 6445-4SS 4 pieces/pack    4.20
    [Teardown]    Yves: delete 'Shopping Cart' with name:    VolumePriceCart+${random}

Default_Merchants
    [Documentation]    Checks that default merchants are present in Zed
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: table should contain:    Restrictions Merchant
    Zed: table should contain:    Prices Merchant
    Zed: table should contain:    Products Restrictions Merchant

Product_Restrictions
    [Documentation]    Checks White and Black lists
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: perform search by:    Soennecken
    Yves: 'Catalog' page should show products:    18
    Yves: go to URL:    en/office-furniture/storage/lockers
    Yves: 'Catalog' page should show products:    34
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_restriction_customer_email_1}
    Yves: perform search by:    Soennecken
    Yves: 'Catalog' page should show products:    0
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_restriction_customer_email_2}
    Yves: go to URL:    en/office-furniture/storage/lockers
    Yves: 'Catalog' page should show products:    0
    Yves: go to URL:    en/transport/lift-carts
    Yves: 'Catalog' page should show products:    16
    Yves: go to URL:    en/transport/sack-trucks
    Yves: 'Catalog' page should show products:    10

Customer_Specific_Prices
    [Documentation]    Checks that product price can be different for different customers
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: perform search by:    ${one_variant_product_abstract_name}
    Yves: product with name in the catalog should have price:    ${one_variant_product_abstract_name}    ${one_variant_product_default_price}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: product price on the PDP should be:    ${one_variant_product_default_price}
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_special_prices_customer_email}
    Yves: create new 'Shopping Cart' with name:    customerPrices+${random}
    Yves: perform search by:    ${one_variant_product_abstract_name}
    Yves: product with name in the catalog should have price:    ${one_variant_product_abstract_name}    ${one_variant_product_merchant_price}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: product price on the PDP should be:    ${one_variant_product_merchant_price}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    customerPrices+${random}
    Yves: shopping cart contains product with unit price:    403125    EUROKRAFT hand truck - with open shovel - load capacity 400 kg    188.34
    [Teardown]    Yves: delete 'Shopping Cart' with name:    customerPrices+${random}

Agent_Assist
    [Documentation]    Checks Agent creation and that it can login under customer.
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change123${random}    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent+${random}@spryker.com    change123${random}
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    ${yves_company_user_special_prices_customer_firstname}
    Yves: agent widget contains:    ${yves_company_user_special_prices_customer_email}
    Yves: as an agent login under the customer:    ${yves_company_user_special_prices_customer_email}
    Yves: perform search by:    ${one_variant_product_abstract_name}
    Yves: product with name in the catalog should have price:    ${one_variant_product_abstract_name}    ${one_variant_product_merchant_price}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: product price on the PDP should be:    ${one_variant_product_merchant_price}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    agent+${random}@spryker.com

Approval_Process
    [Documentation]    Checks role permissions on checkout and Approval process
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_with_limit_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    approvalCart+${random}
    Yves: go to PDP of the product with sku:    M49320
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    approvalCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_with_limit_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: select approver on the 'Summary' page:    Lilu Dallas (€1,000.00)
    Yves: 'send the request' on the summary page
    Yves: 'Summary' page is displayed
    Yves: 'Summary' page contains/doesn't contain:    true    ${cancelRequestButton}    ${alertWarning}    ${quoteStatus}
    Yves: go to the 'Home' page
    Yves: go to the shopping cart through the header with name:    approvalCart+${random}
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${lockedCart}
    Yves: create new 'Shopping Cart' with name:    newApprovalCart+${random}
    Yves: go to PDP of the product with sku:    M58314
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    newApprovalCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:            ${yves_company_user_buyer_with_limit_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: create new 'Shopping Cart' with name:    anotherApprovalCart+${random}
    Yves: go to PDP of the product with sku:    M58314
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    anotherApprovalCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:            ${yves_company_user_buyer_with_limit_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: select approver on the 'Summary' page:    Lilu Dallas (€1,000.00)
    Yves: 'send the request' on the summary page
    Yves: 'Summary' page is displayed
    Yves: 'Summary' page contains/doesn't contain:    true    ${cancelRequestButton}    ${alertWarning}    ${quoteStatus}
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_approver_email}
    Yves: go to user menu item in header:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu item in the left bar:    Shopping carts
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    approvalCart+${random}    Read-only
    Yves: the following shopping cart is shown:    anotherApprovalCart+${random}    Read-only
    Yves: shopping cart with name xxx has the following status:    approvalCart+${random}    Waiting
    Yves: shopping cart with name xxx has the following status:    anotherApprovalCart+${random}    Waiting
    Yves: go to the shopping cart through the header with name:    approvalCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: 'Summary' page is displayed
    Yves: 'approve the cart' on the summary page
    Yves: 'Summary' page is displayed
    Yves: 'Summary' page contains/doesn't contain:    false    ${cancelRequestButton}    ${alertWarning}
    Yves: go to the 'Home' page
    Yves: go to user menu item in header:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu item in the left bar:    Shopping carts
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    approvalCart+${random}    Read-only
    Yves: the following shopping cart is shown:    anotherApprovalCart+${random}    Read-only
    Yves: shopping cart with name xxx has the following status:    approvalCart+${random}    Approved
    Yves: shopping cart with name xxx has the following status:    anotherApprovalCart+${random}    Waiting
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_with_limit_email}
    Yves: go to user menu item in the left bar:    Shopping carts
    Yves: shopping cart with name xxx has the following status:    approvalCart+${random}    Approved
    Yves: go to the shopping cart through the header with name:    approvalCart+${random}
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${lockedCart}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: 'Summary' page is displayed
    Yves: Accept the Terms and Conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Request_for_Quote
    [Documentation]    Checks user can request and receive quote.
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: create new Zed user with the following data:    agent_quote+${random}@spryker.com    change123${random}    Request    Quote    Root group    This user is an agent    en_US
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: create new 'Shopping Cart' with name:    RfQCart+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M1018212
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    RfQCart+${random}
    Yves: submit new request for quote
    Yves: click 'Send to Agent' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent_quote+${random}@spryker.com    change123${random}
    Yves: header contains/doesn't contain:    true    ${quoteRequestsWidget}
    Yves: go to 'Quote Requests' page through the header
    Yves: 'Quote Requests' page is displayed
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Waiting
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: 'Quote Request Details' page is displayed
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: change price for the product in the quote request with sku xxx on:    403125    500
    Yves: click 'Send to Customer' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Quote Requests
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Ready
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: click 'Edit Items' button on the 'Quote Request Details' page
    Yves: delete product from the shopping cart with sku:    102121
    Yves: click 'Save and Back to Edit' button on the 'Quote Request Details' page
    Yves: add the following note to the quote request:    Spryker rocks
    Yves: click 'Save' button on the 'Quote Request Details' page
    Yves: click 'Send to Agent' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent_quote+${random}@spryker.com    change123${random}
    Yves: move mouse over header menu item:     ${quoteRequestsWidget}
    Yves: 'Quote Requests' widget is shown
    Yves: go to the quote request through the header with reference:    ${lastCreatedRfQ}
    Yves: 'Quote Request Details' page contains the following note:   Spryker rocks
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: set 'Valid Till' date for the quote request, today +:    1 day
    Yves: change price for the product in the quote request with sku xxx on:    403125    500
    Yves: click 'Send to Customer' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Quote Requests
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Ready
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: click 'Convert to Cart' button on the 'Quote Request Details' page
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains product with unit price:    403125    EUROKRAFT hand truck - with open shovel - load capacity 400 kg    500
    Yves: shopping cart doesn't contain the following products:    102121
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: shopping cart contains product with unit price:    403125    EUROKRAFT hand truck - with open shovel - load capacity 400 kg    500
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    agent_quote+${random}@spryker.com
    
Return_Management
    [Documentation]    Checks OMS and that Yves and Zed users can create returns.
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    returnCart+${random}
    Yves: go to PDP of the product with sku:    M90802
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M21711
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M90737
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    returnCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Trigger oms
    Zed: trigger all matching states inside this order:    Skip timeout
    Trigger oms
    Zed: trigger all matching states inside this order:    Ship
    Trigger oms
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    410083
    Trigger oms
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    410083
    Trigger oms
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: create a return for the following order and product in it:    ${lastPlacedOrder}    421426
    Trigger oms
    Zed: create new Zed user with the following data:    return+agent+${random}@spryker.com    change123${random}    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    return+agent+${random}@spryker.com    change123${random}
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    ${yves_company_user_buyer_email}
    Yves: agent widget contains:    ${yves_company_user_buyer_email}
    Yves: as an agent login under the customer:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Order History
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    108278
    Trigger oms
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    108278
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Execute return
    Trigger oms
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: 'Order History' page contains the following order with a status:    ${lastPlacedOrder}    Returned
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    return+agent+${random}@spryker.com

User_Account
    [Documentation]    Checks user account pages work + address management
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu item in header:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: go to user menu item in header:    Profile
    Yves: 'Profile' page is displayed
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: delete all user addresses
    Yves: go to user menu item in the left bar:    Newsletter
    Yves: 'Newsletter' page is displayed
    Yves: go to user menu item in the left bar:    Returns
    Yves: 'Returns' page is displayed
    Yves: create a new customer address in profile:    Ms    ${yves_user_first_name} ${random}    ${yves_user_last_name} ${random}   Kirncher Str. ${random}    7    ${random}    Berlin    Germany
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    true    ${yves_user_first_name} ${random}    ${yves_user_last_name} ${random}    Kirncher Str. ${random}    7    ${random}    Berlin    Germany
    Yves: delete user address:    Kirncher Str. ${random}
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    false    ${yves_user_first_name} ${random}    ${yves_user_last_name} ${random}    Kirncher Str. ${random}    7    ${random}    Berlin    Germany
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create a new customer address in profile:
    ...    || email              | salutation | first name                       | last name                       | address 1          | address 2           | address 3           | city            | zip code  | country | phone     | company          ||
    ...    || ${yves_user_email} | Ms         | ${yves_user_first_name}${random} | ${yves_user_last_name}${random} | address 1${random} | address 2 ${random} | address 3 ${random} | Berlin${random} | ${random} | Austria | 123456789 | Spryker${random} ||
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu item in header:    Overview
    Yves: go to user menu item in the left bar:    Addresses
    Yves: check that user has address exists/doesn't exist:    true    ${yves_user_first_name}${random}    ${yves_user_last_name}${random}    address 1${random}    address 2 ${random}    ${random}    Berlin${random}    Austria
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND     Yves: delete all user addresses
    
Product_labels
    [Documentation]    Checks that products have labels on PLP and PDP
    Yves: go to first navigation item level:    Sale %
    Yves: 1st product card in catalog (not)contains:     Sale label    true
    Yves: go to the PDP of the first available product on open catalog page
    Yves: PDP contains/doesn't contain:    true    ${pdp_sales_label}[${env}]
    Yves: go to first navigation item level:    New
    Yves: 1st product card in catalog (not)contains:     New label    true
    Yves: go to the PDP of the first available product on open catalog page
    Yves: PDP contains/doesn't contain:    true    ${pdp_new_label}[${env}] 

Catalog
    [Documentation]    Checks that catalog options and search work
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: perform search by:    claire
    Yves: 'Catalog' page should show products:    15
    Yves: catalog page contains filter:    Product Ratings     Product Labels     Brand    Color
    Yves: select filter value:    Color    blue
    Yves: 'Catalog' page should show products:    1
    Yves: go to first navigation item level:    Stationery
    Yves: 'Catalog' page should show products:    114
    Yves: page contains CMS element:    CMS Block    Build a Space That Spurs Creativity
    Yves: page contains CMS element:    CMS Block    Tackle Your To-Do's
    Yves: change sorting order on catalog page:    Sort by price ascending
    Yves: 1st product card in catalog (not)contains:     Price    0.48
    Yves: change sorting order on catalog page:    Sort by price descending
    Yves: 1st product card in catalog (not)contains:      Price    €41.68
    Yves: go to catalog page:    2
    Yves: catalog page contains filter:    Product Ratings     Product Labels     Brand    Color
    Yves: select filter value:    Color    blue
    Yves: 'Catalog' page should show products:    3

Catalog_Actions
    [Documentation]    Checks quick add to cart and product groups
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    catalogActions+${random}
    Yves: perform search by:    Verbatim USB stick OTG
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: quick add to cart for first item in catalog
    Yves: perform search by:    New Clairefontaine Collegeblock 8272C DIN A5, 90 sheets
    Yves: 1st product card in catalog (not)contains:     Add to Cart    false
    Yves: perform search by:    ${multi_color_product_abstract_sku}
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: 1st product card in catalog (not)contains:      Color selector   true
    Yves: select product color:    Blue
    Yves: quick add to cart for first item in catalog
    Yves: go to the shopping cart through the header with name:    catalogActions+${random}
    Yves: shopping cart contains the following products:    420573    107255
    [Teardown]    Yves: delete 'Shopping Cart' with name:    catalogActions+${random}

Discounts
    [Documentation]    Discounts, Promo Products, and Coupon Codes
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate all discounts from Overview page
    ...    AND    Zed: change product stock:    M21777    421538    true    10
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Merchandising    Discount
    Zed: create a discount and activate it:    voucher    Percentage    5    sku = '*'    test${random}    discountName=Voucher Code 5% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    10    sku = '*'    discountName=Cart Rule 10% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    100    discountName=Promotional Product 100% ${random}    promotionalProductDiscount=True    promotionalProductAbstractSku=M29503    promotionalProductQuantity=2
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    discounts+${random}
    Yves: go to PDP of the product with sku:    M21777
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    discounts+${random}
    Yves: apply discount voucher to cart:    test${random}
    Yves: discount is applied:    voucher    Voucher Code 5% ${random}    - €0.72
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €1.44
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    discounts+${random}
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €125.46
    Yves: promotional product offer is/not shown in cart:    true
    Yves: change quantity of promotional product and add to cart:    +    1
    Yves: shopping cart contains the following products:    419873    421538    000101
    Yves: discount is applied:    cart rule    Promotional Product 100% ${random}    - €123.10
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,072.31
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Merchandising    Discount
    ...    AND    Zed: Deactivate Following Discounts From Overview Page:    Voucher Code 5% ${random}    Cart Rule 10% ${random}    Promotional Product 100% ${random}
    ...    AND    Zed: activate following discounts from Overview page:    Free chair    Tu & Wed $5 off 5 or more    10% off $100+    Free marker    20% off storage    	Free office chair    Free standard delivery    	10% off Safescan    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order

Split_Delivery
    [Documentation]    Checks split delivery in checkout with new addresses
    [Setup]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    splitDelivery+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${multi_color_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    splitDelivery+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select delivery to multiple addresses
    Yves: fill in new delivery address for a product:
    ...    || product | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || 403125  | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product | salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || 107254  | Dr.        | First     | Last     | Second Street | 2           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || 419904  | Dr.        | First     | Last     | Third Street | 3           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Dr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: click checkout button:    Next
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
    Yves: select the following shipping method for the shipment:    3    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all user addresses

Refunds
    [Documentation]    Checks that refund can be created for an item and the whole order
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    20% off storage    10% off minimum order
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    refunds+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${multi_color_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    refunds+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,366.16
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Trigger oms
    Zed: trigger all matching states inside this order:    Skip timeout
    Trigger oms
    Zed: trigger matching state of order item inside xxx shipment:    107254    Ship
    Trigger oms
    Zed: trigger matching state of order item inside xxx shipment:    107254    Stock update
    Trigger oms
    Zed: trigger matching state of order item inside xxx shipment:    107254    Refund
    Trigger oms
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,162.87
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Ship
    Trigger oms
    Zed: trigger all matching states inside this order:    Stock update
    Trigger oms
    Zed: trigger all matching states inside this order:    Refund
    Trigger oms
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    20% off storage    10% off minimum order

Manage_Product
    [Documentation]    checks that BO user can manage abstract and concrete products + create new
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: start new abstract product creation:
    ...    || sku                | store | name en                | name de                  | new from   | new to     ||
    ...    || manageSKU${random} | DE    | manageProduct${random} | DEmanageProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 | attribute 2 | attribute value 2 ||
    ...    || farbe       | grey              | farbe       | blue              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set        ||
    ...    || DE    | gross | default | €        | 100.00 | Standard Taxes ||
    Zed: change concrete product data:
    ...    || productAbstract    | productConcrete               | active | searchable en | searchable de ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-grey | true   | true          | true          ||
    Zed: change concrete product data:
    ...    || productAbstract    | productConcrete               | active | searchable en | searchable de ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-blue | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract    | productConcrete               | store | mode  | type    | currency | amount ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-blue | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract    | productConcrete               | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-grey | Warehouse1   | 100              | true                            ||
    Zed: change concrete product stock:
    ...    || productAbstract    | productConcrete               | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-blue | Warehouse1   | 100              | false                           ||
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to URL:    en/search?q=manageSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: go to PDP of the product with sku:    manageSKU${random}
    Yves: product price on the PDP should be:    €100.00
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change variant of the product on PDP on:    grey
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €100.00
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    blue
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €15.00
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: add new concrete product to abstract:
    ...    || productAbstract    | sku                            | autogenerate sku | attribute 1 | name en                  | name de                  | use prices from abstract ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-black | false            | black       | ENaddedConcrete${random} | DEaddedConcrete${random} | true                     ||
    Zed: change concrete product data:
    ...    || productAbstract    | productConcrete                | active | searchable en | searchable de ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-black | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract    | productConcrete                | store | mode  | type    | currency | amount ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-black | DE    | gross | default | €        | 25.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract    | productConcrete                | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-black | Warehouse1   | 5                | false                           ||
    Zed: update abstract product price on:
    ...    || productAbstract    | store | mode  | type    | currency | amount | tax set        ||
    ...    || manageSKU${random} | DE    | gross | default | €        | 150.00 | Standard Taxes ||
    Zed: update abstract product data:
    ...    || productAbstract    | name en                         | name de                         ||
    ...    || manageSKU${random} | ENUpdatedmanageProduct${random} | DEUpdatedmanageProduct${random} ||
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    manageProductCart+${random}
    Yves: go to URL:    en/search?q=manageSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: go to PDP of the product with sku:    manageSKU${random}
    Yves: product name on PDP should be:    ENUpdatedmanageProduct${random}
    Yves: product price on the PDP should be:    €150.00
    Yves: change variant of the product on PDP on:    grey
    Yves: product price on the PDP should be:    €100.00
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    blue
    Yves: product price on the PDP should be:    €15.00
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    black
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product name on PDP should be:    ENaddedConcrete${random}
    Yves: product price on the PDP should be:    €25.00
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item manageSKU${random}-farbe-black only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    manageProductCart+${random}
    Yves: shopping cart contains product with unit price:    manageSKU${random}-farbe-black    ENaddedConcrete${random}    25.00
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     manageProduct${random}     View
    Zed: view product page is displayed
    Zed: view abstract product page contains:
    ...    || store | sku                | name                            | variants count ||
    ...    || DE AT | manageSKU${random} | ENUpdatedmanageProduct${random} | 3              ||
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts

Product_Original_Price
    [Documentation]    checks that Orignal price is displayed on the PDP and in Catalog
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: start new abstract product creation:
    ...    || sku                  | store | name en                  | name de                    | new from   | new to     ||
    ...    || originalSKU${random} | DE    | originalProduct${random} | DEoriginalProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 | attribute 2 | attribute value 2 ||
    ...    || farbe       | grey              | farbe       | blue              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set        ||
    ...    || DE    | gross | default | €        | 100.00 | Standard Taxes ||
    Zed: update abstract product price on:
    ...    || store | mode  | type     | currency | amount | tax set        ||
    ...    || DE    | gross | original | €        | 200.00 | Standard Taxes ||
    Zed: change concrete product data:
    ...    || productAbstract      | productConcrete                 | active | searchable en | searchable de ||
    ...    || originalSKU${random} | originalSKU${random}-farbe-grey | true   | true          | true          ||
    Zed: change concrete product data:
    ...    || productAbstract      | productConcrete                 | active | searchable en | searchable de ||
    ...    || originalSKU${random} | originalSKU${random}-farbe-blue | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract      | productConcrete                 | store | mode  | type    | currency | amount ||
    ...    || originalSKU${random} | originalSKU${random}-farbe-blue | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract      | productConcrete                 | store | mode  | type     | currency | amount ||
    ...    || originalSKU${random} | originalSKU${random}-farbe-blue | DE    | gross | original | €        | 50.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract      | productConcrete                 | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || originalSKU${random} | originalSKU${random}-farbe-grey | Warehouse1   | 100              | true                            ||
    Zed: change concrete product stock:
    ...    || productAbstract      | productConcrete                 | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || originalSKU${random} | originalSKU${random}-farbe-blue | Warehouse1   | 100              | false                           ||
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to URL:    en/search?q=originalSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: 1st product card in catalog (not)contains:     Original Price    €200.00
    Yves: go to PDP of the product with sku:    originalSKU${random}
    Yves: product price on the PDP should be:    €100.00
    Yves: product original price on the PDP should be:    €200.00
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change variant of the product on PDP on:    blue
    Yves: product price on the PDP should be:    €15.00
    Yves: product original price on the PDP should be:    €50.00

Zed_navigation_ordering_and_naming
    [Documentation]    Verifies each left navigation node can be opened
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: verify first navigation root menus
    Zed: verify root menu icons
    Zed: verify second navigation root menus

User_Control
    [Documentation]    Create a user with limited access
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new role with name:    controlRole${random}
    Zed: apply access permissions for user role:    ${full_access}    ${full_access}    ${full_access}   ${permission_allow}
    Zed: apply access permissions for user role:    ${bundle_access}    ${controller_access}    ${action_access}    ${permission_deny}
    Zed: create new group with role assigned:   controlGroup${random}    controlRole${random}
    Zed: create new Zed user with the following data:    sonia+control${random}@spryker.com   change${random}    First Control    Last Control    ControlGroup${random}    This user is an agent    en_US    
    Zed: login on Zed with provided credentials:   sonia+control${random}@spryker.com    change${random}
    Zed: go to second navigation item level:    Catalog    Attributes
    Zed: click button in Header:    Create Product Attribute
    Zed: validate the message when permission is restricted:    Access denied
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: deactivate the created user:    sonia+control${random}@spryker.com
    Zed: login with deactivated user/invalid data:    sonia+control${random}@spryker.com    change${random}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Users    User Roles
    ...    AND    Zed: click Action Button in a table for row that contains:    controlRole${random}    Delete