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
Business_Unit_Address_on_Checkout
    [Documentation]    Checks that business unit address can be used during checkout
    Create dynamic customer in DB    based_on=${yves_company_user_buyer_email}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    M64933
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    Mr Dynamic Customer, Gurmont Str. 23, 8002 Barcelona
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: go to user menu:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page is displayed
    Yves: shipping address on the order details page is:    Mr. Dynamic Customer Spryker Systems GmbH Gurmont Str. 23 8002 Barcelona, Spain 3490284322
    [Teardown]    Delete dynamic customer via API

Approval_Process
    [Documentation]    Checks role permissions on checkout and Approval process
    Create dynamic customer in DB    based_on=${yves_company_user_buyer_with_limit_email}
    Create dynamic customer in DB    based_on=${yves_company_user_approver_email}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: create new 'Shopping Cart' with name:    approvalCart+${random}
    Yves: go to PDP of the product with sku:    M49320
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: select approver on the 'Summary' page:    Lilu Dallas (€1,000.00)
    Yves: 'send the request' on the summary page
    Yves: 'Summary' page is displayed
    Yves: 'Summary' page contains/doesn't contain:    true    ${cancelRequestButton}    ${alertWarning}    ${quoteStatus}
    Yves: go to the 'Home' page
    Yves: go to shopping cart page
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${lockedCart}
    Yves: create new 'Shopping Cart' with name:    newApprovalCart+${random}
    Yves: go to PDP of the product with sku:    M58314
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    newApprovalCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: create new 'Shopping Cart' with name:    anotherApprovalCart+${random}
    Yves: go to PDP of the product with sku:    M58314
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    anotherApprovalCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: select approver on the 'Summary' page:    Lilu Dallas (€1,000.00)
    Yves: 'send the request' on the summary page
    Yves: 'Summary' page is displayed
    Yves: 'Summary' page contains/doesn't contain:    true    ${cancelRequestButton}    ${alertWarning}    ${quoteStatus}
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_approver_email}
    Yves: go to user menu:    Overview
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
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu item in the left bar:    Shopping carts
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    approvalCart+${random}    Read-only
    Yves: the following shopping cart is shown:    anotherApprovalCart+${random}    Read-only
    Yves: shopping cart with name xxx has the following status:    approvalCart+${random}    Approved
    Yves: shopping cart with name xxx has the following status:    anotherApprovalCart+${random}    Waiting
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu item in the left bar:    Shopping carts
    Yves: shopping cart with name xxx has the following status:    approvalCart+${random}    Approved
    Yves: go to the shopping cart through the header with name:    approvalCart+${random}
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${lockedCart}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: 'Summary' page is displayed
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Run Keywords    Delete dynamic customer via API
    ...    AND    Delete dynamic customer via API    ${dynamic_second_customer}

Request_for_Quote
    [Documentation]    Checks user can request and receive quote
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M1018212
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: submit new request for quote
    Yves: click 'Send to Agent' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    ${dynamic_admin_user}
    Yves: header contains/doesn't contain:    true    ${quoteRequestsWidget}
    Yves: go to 'Agent Quote Requests' page through the header
    Yves: 'Quote Requests' page is displayed
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Waiting
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: 'Quote Request Details' page is displayed
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: change price for the product in the quote request with sku xxx on:    403125    500
    Yves: click 'Send to Customer' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Quote Requests
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
    Yves: login on Yves with provided credentials:    ${dynamic_admin_user}
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
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Quote Requests
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Ready
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: click 'Convert to Cart' button on the 'Quote Request Details' page
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains product with unit price:    403125    EUROKRAFT hand truck - with open shovel - load capacity 400 kg    500
    Yves: shopping cart doesn't contain the following products:    102121
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: shopping cart contains product with unit price:    403125    EUROKRAFT hand truck - with open shovel - load capacity 400 kg    500
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Run Keywords    Delete dynamic customer via API
    ...    AND    Delete dynamic admin user from DB

Unique_URL
    [Documentation]    Bug: CC-12380.
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: create new 'Shopping Cart' with name:    externalCart+${random}
    Yves: go to PDP of the product with sku:    M90806
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    externalCart+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: get link for external cart sharing
    Yves: logout on Yves as a customer
    Yves: go to external URL:    ${externalURL}
    Yves: 'Shopping Cart' page is displayed
    Yves: Shopping Cart title should be equal:    Preview: externalCart+${random}
    Yves: shopping cart contains the following products:    108302
    [Teardown]    Delete dynamic customer via API

Split_Delivery
    [Documentation]    Checks split delivery in checkout with new addresses
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${multi_color_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
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
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    [Teardown]    Run Keywords    Delete dynamic customer via API
    ...    AND    Delete dynamic admin user from DB

Multiple_Merchants_Order
    [Documentation]    Checks that order with products and offers of multiple merchants could be placed and it will be splitted per merchant
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: create dynamic merchant user:    Computer Experts
    ...    AND    Zed: create dynamic merchant user:    Office King
    ...    AND    MP: login on MP with provided credentials:    ${dynamic_expert_merchant}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer395 | 10             | true                  ||
    ...    AND    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer193 | 10             | true                  ||
    ...    AND    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_of_main_merchant_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:     ${product_with_multiple_offers_abstract_sku}
    Yves: merchant's offer/product price should be:    Computer Experts    ${product_with_multiple_offers_computer_experts_price}
    Yves: merchant's offer/product price should be:    Office King    ${product_with_multiple_offers_office_king_price}
    Yves: select xxx merchant's offer:    Computer Experts
    Yves: product price on the PDP should be:    ${product_with_multiple_offers_computer_experts_price}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: assert merchant of product in cart or list:    ${one_variant_product_of_main_merchant_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${one_variant_product_concrete_sku}    Office King
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Computer Experts
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
    Yves: select the following shipping method for the shipment:    3    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    [Teardown]    Run Keywords    Delete dynamic customer via API
    ...    AND    Delete dynamic admin user from DB

Checkout_Address_Management
    [Documentation]    Bug: CC-30439. Checks that user can change address during the checkout and save new into the address book
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    false
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: save new billing address to address book:    false
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: return to the previous checkout step:    Address
    Yves: billing address same as shipping address:    false
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | New       | Billing  | Changed Street | 098         | 09876    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: save new billing address to address book:    false
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName | lastName | street          | houseNumber | postCode | city   | country    | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Shipping Street | 7           | 10247    | Geneva | Switzerland| Spryker | 123456789 | Additional street ||
    Yves: save new deviery address to address book:    true
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: check that user has address exists/doesn't exist:    true    First    Last    Shipping Street    7    10247    Geneva    Switzerland
    Yves: check that user has address exists/doesn't exist:    false    New    Billing    Changed Street    098    09876    Berlin    Germany
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: billing address for the order should be:    New Billing, Changed Street 098, 09876 Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    1    Mr First, Last, Shipping Street, 7, Additional street, Spryker, 10247, Geneva, Switzerland
    [Teardown]    Run Keywords    Delete dynamic customer via API
    ...    AND    Delete dynamic admin user from DB

Comments_in_Cart
    [Documentation]    Add comments to cart and verify comments in Yves and Zed
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: add comment on cart:    abc${random}
    Yves: check comments are visible or not in cart:    true    abc${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: go to order details page to check comment:    abc${random}    ${lastPlacedOrder}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: check comment appears at order detailed page in zed:    abc${random}    ${lastPlacedOrder}
    [Teardown]    Run Keywords    Delete dynamic customer via API
    ...    AND    Delete dynamic admin user from DB

Comment_Management_in_the_Cart
    [Documentation]    Editing and deleting comments in carts
    [Setup]    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: add comment on cart:    abc${random}
    Yves: check comments are visible or not in cart:    true    abc${random}
    Yves: edit comment on cart:    xyz${random}
    Yves: check comments are visible or not in cart:    true    xyz${random}
    Yves: delete comment on cart
    Yves: check comments are visible or not in cart:    false    xyz${random}
    [Teardown]    Delete dynamic customer via API