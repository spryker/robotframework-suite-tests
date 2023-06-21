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

Share_Shopping_Lists
    [Documentation]    Checks that shopping list can be shared
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: go to 'Shopping Lists' page
    Yves: 'Shopping Lists' page is displayed
    Yves: create new 'Shopping List' with name:    shoppingListName+${random}
    Yves: the following shopping list is shown:    shoppingListName+${random}    ${yves_company_user_shared_permission_owner_firstname} ${yves_company_user_shared_permission_owner_lastname}    Full access
    Yves: share shopping list with user:    shoppingListName+${random}    ${yves_company_user_shared_permission_receiver_firstname} ${yves_company_user_shared_permission_receiver_lastname}    Full access
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping list:    shoppingListName+${random}
    Create New Context
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_receiver_email}
    Yves: 'Shopping List' widget contains:    shoppingListName+${random}    Full access
    Yves: go to 'Shopping Lists' page
    Yves: 'Shopping Lists' page is displayed
    Yves: the following shopping list is shown:    shoppingListName+${random}    ${yves_company_user_shared_permission_owner_firstname} ${yves_company_user_shared_permission_owner_lastname}    Full access
    Yves: view shopping list with name:    shoppingListName+${random}
    Yves: add all available products from list to cart  
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    403125
    [Teardown]    Run Keywords    Close Context    CURRENT    AND    Yves: delete 'Shopping List' with name:    shoppingListName+${random}

Share_Shopping_Carts
    [Documentation]    Checks that cart can be shared and used for checkout
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: delete all shopping carts
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: create new 'Shopping Cart' with name:    shoppingCartName+${random}
    Yves: 'Shopping Carts' widget contains:    shoppingCartName+${random}    Owner access
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    shoppingCartName+${random}    Owner access
    ###    Check that cart can be shared with a user with full access    ###
    Yves: share shopping cart with user:    shoppingCartName+${random}    ${yves_company_user_shared_permission_receiver_lastname} ${yves_company_user_shared_permission_receiver_firstname}    Full access
    Yves: go to PDP of the product with sku:    M10569
    Yves: add product to the shopping cart
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_receiver_email}
    Yves: 'Shopping Carts' widget contains:    shoppingCartName+${random}    Full access
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    shoppingCartName+${random}    Full access
    Yves: go to the shopping cart through the header with name:    shoppingCartName+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    100414
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_shared_permission_receiver_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: go to the 'Home' page
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page is displayed
    ###    Check that cart can be shared with a user with read-only access    ###
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: create new 'Shopping Cart' with name:    readShoppingCartName+${random}
    Yves: 'Shopping Carts' widget contains:    readShoppingCartName+${random}    Owner access
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    readShoppingCartName+${random}    Owner access
    Yves: share shopping cart with user:    readShoppingCartName+${random}    ${yves_company_user_shared_permission_receiver_lastname} ${yves_company_user_shared_permission_receiver_firstname}    Read-only
    Yves: go to PDP of the product with sku:    ${concrete_avaiable_product_sku}
    Yves: add product to the shopping cart
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_receiver_email}
    Yves: 'Shopping Carts' widget contains:    readShoppingCartName+${random}    Read-only
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    readShoppingCartName+${random}    Read-only
    Yves: go to the shopping cart through the header with name:    readShoppingCartName+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    ${concrete_avaiable_product_sku}
    Yves: shopping cart contains product with unit price:    ${concrete_avaiable_product_sku}    ${concrete_avaiable_product_name}        ${concrete_avaiable_product_price}
    Yves: shopping cart contains/doesn't contain the following elements:   false    ${shopping_cart_checkout_button}

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

Discontinued_Alternative_Products
    [Documentation]    Checks that product can be discontinued in Zed
    Yves: go to PDP of the product with sku:  M21100
    Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: start new abstract product creation:
    ...    || sku                      | store | name en                      | name de                        | new from   | new to     ||
    ...    || discontinuedSKU${random} | DE    | discontinuedProduct${random} | DEdiscontinuedProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 ||
    ...    || farbe       | grey              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set        ||
    ...    || DE    | gross | default | €        | 100.00 | Standard Taxes ||
    Zed: change concrete product data:
    ...    || productAbstract          | productConcrete                     | active | searchable en | searchable de ||
    ...    || discontinuedSKU${random} | discontinuedSKU${random}-farbe-grey | true   | true          | true          ||
    Zed: add following alternative products to the concrete:    M22613
    Zed: concrete product has the following alternative products:    M22613
    Zed: discontinue the following product:    discontinuedSKU${random}    discontinuedSKU${random}-farbe-grey
    Zed: product is successfully discontinued

Measurement_Units
    [Documentation]    Checks checkout with Measurement Unit product
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    measurementUnitsCart+${random}
    Yves: go to PDP of the product with sku:    M23723
    Yves: select the following 'Sales Unit' on PDP:    Meter
    Yves: change quantity using '+' or '-' button № times:    +    1
    Yves: PDP contains/doesn't contain:    true    ${measurementUnitSuggestion}
    Yves: change quantity using '+' or '-' button № times:    -    1
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M1006871
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:  measurementUnitsCart+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    425079
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_manager_and_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Packaging_Units
    [Documentation]    Checks checkout with Packaging Unit product
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    packagingUnitsCart+${random}
    Yves: go to PDP of the product with sku:    M21766
    Yves: change variant of the product on PDP on:    Box
    Yves: change amount on PDP:    51
    Yves: PDP contains/doesn't contain:    true    ${packagingUnitSuggestion}
    Yves: change amount on PDP:    10
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M1006871
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    packagingUnitsCart+${random}
    Yves: shopping cart contains the following products:    421519_3
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_manager_and_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Product_Sets
    [Documentation]    Checks that product set can be added into cart
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    productSetsCart+${random}
    Yves: go to URL:    en/product-sets
    Yves: 'Product Sets' page contains the following sets:    The Presenter's Set    Basic office supplies    The ultimate data disposal set
    Yves: view the following Product Set:    Basic office supplies
    Yves: 'Product Set' page contains the following products:    Clairefontaine Collegeblock 8272C DIN A5, 90 sheets
    Yves: change variant of the product on CMS page on:    Clairefontaine Collegeblock 8272C DIN A5, 90 sheets    lined
    Yves: add all products to the shopping cart from Product Set
    Yves: shopping cart contains the following products:    421344    420687    421511    423452
    [Teardown]    Yves: delete 'Shopping Cart' with name:    productSetsCart+${random}

Product_Bundles
    [Documentation]    Checks checkout with Bundle product
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    productBundleCart+${random}
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    productBundleCart+${random}
    Yves: shopping cart contains the following products:    ${bundle_product_concrete_sku}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Product_Relations
    [Documentation]    Checks related product on PDP and upsell products in cart
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    productRelationCart+${random}
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: PDP contains/doesn't contain:    true    ${relatedProducts}
    Yves: go to PDP of the product with sku:    ${product_with_relations_upselling_sku}
    Yves: PDP contains/doesn't contain:    false    ${relatedProducts}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    productRelationCart+${random}
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${upSellProducts}
    [Teardown]    Yves: delete 'Shopping Cart' with name:    productRelationCart+${random}

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

Business_on_Behalf
    [Documentation]    Check that BoB user has possibility to change the business unit
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Customers    Company Users
    Zed: click Action Button in a table for row that contains:    Donald    Attach to BU
    Zed: attach company user to the following BU with role:    Spryker Systems Zurich (id: 25)    Admin
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_bob_email}
    Yves: go to URL:    en/company/user/select
    Yves: 'Select Business Unit' page is displayed
    Yves: 'Business Unit' dropdown contains:    Spryker Systems GmbH / Spryker Systems Berlin    Spryker Systems GmbH / Spryker Systems Zurich
    [Teardown]    Zed: delete company user xxx withing xxx company business unit:    Donald    Spryker Systems Zurich

Business_Unit_Address_on_Checkout
    [Documentation]    Checks that business unit address can be used during checkout
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    businessAddressCart+${random}
    Yves: go to PDP of the product with sku:    M64933
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    businessAddressCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page is displayed
    Yves: shipping address on the order details page is:    Mr. Armando Richi Spryker Systems GmbH Gurmont Str. 23 8002 Barcelona, Spain 3490284322

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

Unique_URL
    [Tags]    skip-due-to-issue
    [Documentation]    Fails due to Bug:CC-12380
    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    Yves: create new 'Shopping Cart' with name:    externalCart+${random}
    Yves: go to PDP of the product with sku:    M90806
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    externalCart+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: get link for external cart sharing
    Yves: logout on Yves as a customer
    Yves: go to URL:    ${externalURL}
    Yves: 'Shopping Cart' page is displayed
    Yves: Shopping Cart title should be equal:    Preview: externalCart+${random}
    Yves: shopping cart contains the following products:    108302
    [Teardown]    Yves: delete 'Shopping Cart' with name:    externalCart+${random}

Configurable_Bundle
    [Documentation]    Checks checkout with the configurable bundle
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    confBundle+${random}
    Yves: go to second navigation item level:    More    Configurable Bundle
    Yves: 'Choose Bundle to configure' page is displayed
    Yves: choose bundle template to configure:    Presentation bundle
    Yves: select product in the bundle slot:    Slot 5    408104
    Yves: select product in the bundle slot:    Slot 6    423172
    Yves: go to 'Summary' step in the bundle configurator
    Yves: add products to the shopping cart in the bundle configurator
    Yves: go to second navigation item level:    More    Configurable Bundle
    Yves: 'Choose Bundle to configure' page is displayed
    Yves: choose bundle template to configure:    Presentation bundle
    Yves: select product in the bundle slot:    Slot 5    421539
    Yves: select product in the bundle slot:    Slot 6    424551
    Yves: go to 'Summary' step in the bundle configurator
    Yves: add products to the shopping cart in the bundle configurator
    Yves: change quantity of the configurable bundle in the shopping cart on:    Presentation bundle    2
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_manager_and_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page is displayed
    Yves: 'Order Details' page contains the following product title N times:    Presentation bundle    3

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
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    410083
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: create a return for the following order and product in it:    ${lastPlacedOrder}    421426
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

Product_PDP
    [Documentation]    Checks that PDP contains required elements
    Yves: go to PDP of the product with sku:    ${multi_variant_product_abstract_sku}
    Yves: change variant of the product on PDP on:    500 x 930 x 400
    Yves: PDP contains/doesn't contain:    true    ${pdp_warranty_option}    ${pdp_insurance_option}
    Yves: PDP contains/doesn't contain:    false    ${pdpPriceLocator}   ${addToCartButton} 
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    ${multi_variant_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${pdp_add_to_cart_disabled_button}[${env}]    ${pdp_warranty_option}    ${pdp_insurance_option}
    Yves: change variant of the product on PDP on:    500 x 930 x 400
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${addToCartButton}    ${pdp_warranty_option}    ${pdp_insurance_option} 

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

Back_in_Stock_Notification
    [Documentation]    Back in stock notification is sent and availability check
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    true
    Zed: change product stock:    ${stock_product_abstract_sku}    ${stock_product_concrete_sku}    false    0
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    false
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:  ${stock_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    Yves: check if product is available on PDP:    ${stock_product_abstract_sku}    false
    Yves: submit back in stock notification request for email:    ${yves_user_email}
    Yves: unsubscribe from availability notifications
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: change product stock:    ${stock_product_abstract_sku}    ${stock_product_concrete_sku}    true    0  
    Zed: go to second navigation item level:    Catalog    Availability  
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    true
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:  ${stock_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: check if product is available on PDP:    ${stock_product_abstract_sku}    true
    [Teardown]    Zed: check and restore product availability in Zed:    ${stock_product_abstract_sku}    Available    ${stock_product_concrete_sku}

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

Content_Management
    [Documentation]    Checks cms content can be edited in zed and that correct cms elements are present on homepage   
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Content    Pages
    Zed: create a cms page and publish it:    Test Page${random}    test-page${random}    Page Title    Page text
    Trigger p&s
    Yves: go to the 'Home' page
    Yves: page contains CMS element:    Homepage Banners
    Yves: page contains CMS element:    Product Slider    Top Sellers
    Yves: page contains CMS element:    Homepage Inspirational block
    Yves: page contains CMS element:    Footer section
    Yves: go to newly created page by URL:    en/test-page${random}
    Yves: page contains CMS element:    CMS Page Title    Page Title
    Yves: page contains CMS element:    CMS Page Content    Page text
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Content    Pages
    ...    AND    Zed: click Action Button in a table for row that contains:    Test Page${random}    Deactivate

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

Checkout_Address_Management
    [Tags]    skip-due-to-issue
    [Documentation]    Bug:CC-24090. Checks that user can change address during the checkout and save new into the address book. 
    [Setup]    Run Keywords    
    ...    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: delete all shopping carts
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    checkoutAddress${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    checkoutAddress${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    false
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: save new billing address to address book:    false
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: return to the previous checkout step:    Address
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | New       | Billing  | Changed Street | 098         | 09876    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: save new billing address to address book:    false
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName | lastName | street          | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Shipping Street | 7           | 10247    | Vienna | Austria | Spryker | 123456789 | Additional street ||
    Yves: save new deviery address to address book:    true
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: go to user menu item in header:    Overview
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    true    First    Last    Shipping Street    7    10247    Vienna    Austria
    Yves: check that user has address exists/doesn't exist:    false    New    Billing    Changed Street    098    09876    Berlin    Germany
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: billing address for the order should be:    New Billing, Changed Street 098, Additional street, 09876 Berlin, Germany 987654321
    Zed: shipping address inside xxx shipment should be:    1    Mr First, Last, Shipping Street, 7, Additional street, Spryker, 10247, Vienna, Austria
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all user addresses

Manage_Shipments
    [Documentation]    Checks create/edit shipment functions from backoffice
    [Setup]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    manageShipment+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${multi_color_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    manageShipment+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select delivery to multiple addresses
    Yves: fill in new delivery address for a product:
    ...    || product | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || 403125  | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || 107254  | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || 419904  | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Dr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: click checkout button:    Next
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,202.64
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    1
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 1          | Hermes          | Next Day        | €15.00         | ASAP                    ||
    Zed: create new shipment inside the order:
    ...    || delivert address | salutation | first name | last name | email              | country | address 1     | address 2 | city   | zip code | shipment method | sku    ||
    ...    || New address      | Mr         | Evil       | Tester    | ${yves_user_email} | Austria | Hartmanngasse | 1         | Vienna | 1050     | DHL - Standard  | 419904 ||
    Zed: billing address for the order should be:    First Last, Billing Street 123, Additional street, 10247 Berlin, Germany 987654321
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    2
    Zed: shipping address inside xxx shipment should be:    1    Dr First, Last, First Street, 1, Additional street, Spryker, 10247, Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    2    Mr Evil, Tester, Hartmanngasse, 1, 1050, Vienna, Austria
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 2          | DHL             | Standard        | €0.00          | ASAP                    ||
    Zed: edit xxx shipment inside the order:
    ...    || shipmentN | delivert address | salutation | first name | last name | email              | country | address 1     | address 2 | city   | zip code | shipment method | requested delivery date | sku    ||
    ...    || 2         | New address      | Mr         | Edit       | Shipment  | ${yves_user_email} | Germany | Hartmanngasse | 9         | Vienna | 0987     | DHL - Express   | 2025-01-25              | 107254 ||
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 2          | DHL             | Standard        |  €0.00         | ASAP                    ||
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 3          | DHL             | Express         |  €0.00         | 2025-01-25              ||
    Zed: xxx shipment should/not contain the following products:    1    true    403125
    Zed: xxx shipment should/not contain the following products:    1    false    419904
    Zed: xxx shipment should/not contain the following products:    2    true    419904
    Zed: xxx shipment should/not contain the following products:    3    true    107254
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,202.64
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all user addresses

Zed_navigation_ordering_and_naming
    [Documentation]    Verifies each left navigation node can be opened
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: verify first navigation root menus
    Zed: verify root menu icons
    Zed: verify second navigation root menus

Minimum_Order_Value
    [Documentation]    checks that global minimum and maximun order thresholds can be applied
    [Setup]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    Free chair    Tu & Wed $5 off 5 or more    10% off $100+    Free marker    20% off storage    	Free office chair    Free standard delivery    	10% off Safescan    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: delete all user addresses
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: change global threshold settings:
    ...    || store & currency | minimum hard value | minimum hard en message  | minimum hard de message  | maximun hard value | maximun hard en message | maximun hard de message | soft threshold                | soft threshold value | soft threshold fixed fee | soft threshold en message | soft threshold de message ||
    ...    || DE - Euro [EUR]  | 5                  | EN minimum {{threshold}} | DE minimum {{threshold}} | 400                | EN max {{threshold}}    | DE max {{threshold}}    | Soft Threshold with fixed fee | 100000               | 9                        | EN fixed {{fee}} fee      | DE fixed {{fee}} fee      ||
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    minimumOV+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${multi_color_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    minimumOV+${random}
    Yves: soft threshold surcharge is added in the cart:    €9.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: soft threshold surcharge is added on summary page:    €9.00
    Yves: hard threshold is applied with the following message:    EN max €400.00
    Yves: go to the 'Home' page
    Yves: go to the shopping cart through the header with name:    minimumOV+${random}
    Yves: delete product from the shopping cart with sku:    403125
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
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €227.29
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    Free chair    Tu & Wed $5 off 5 or more    10% off $100+    Free marker    20% off storage    	Free office chair    Free standard delivery    	10% off Safescan    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Zed: change global threshold settings:
    ...    || store & currency | minimum hard value | minimum hard en message | minimum hard de message | maximun hard value | maximun hard en message                                                                                   | maximun hard de message                                                                                                              | soft threshold | soft threshold value | soft threshold en message | soft threshold de message ||
    ...    || DE - Euro [EUR]  | ${SPACE}           | ${SPACE}                | ${SPACE}                | 10000.00           | The cart value cannot be higher than {{threshold}}. Please remove some items to proceed with the order    | Der Warenkorbwert darf nicht höher als {{threshold}} sein. Bitte entfernen Sie einige Artikel, um mit der Bestellung fortzufahren    | None           | ${EMPTY}             | ${EMPTY}                  | ${EMPTY}                  ||

Order_Cancelation
    [Documentation]    Check that customer is able to cancel order
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: delete all user addresses
    Yves: create new 'Shopping Cart' with name:    cancelationCart+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    cancelationCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed    
    Yves: go to 'Order History' page
    Yves: get the last placed order ID by current customer
    Yves: cancel the order:    ${lastPlacedOrder}
    Trigger oms
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: wait for order item to be in state:    403125    cancelled
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    cancelationCart+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${multi_color_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    cancelationCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed    
    Yves: go to 'Order History' page
    Yves: get the last placed order ID by current customer
    ### change the order state of one product ###
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger matching state of order item inside xxx shipment:    403125    Pay
    Trigger oms
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page contains the cancel order button:    true
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger matching state of order item inside xxx shipment:    403125    Skip timeout 
    Trigger oms
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page contains the cancel order button:    false
    ### change state of state of all products ###
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger matching state of order item inside xxx shipment:    107254    Pay
    Trigger oms
    Zed: trigger matching state of order item inside xxx shipment:    107254    Skip timeout
    Trigger oms
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page contains the cancel order button:    false
    ### try to cancel order of another customer ###
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: delete all user addresses
    Yves: create new 'Shopping Cart' with name:    cancelationCart+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    cancelationCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed    
    Yves: go to 'Order History' page
    Yves: get the last placed order ID by current customer
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to 'Order History' page
    Yves: filter order history by business unit:    Company Orders
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page contains the cancel order button:    false
    [Teardown]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts

Multistore_Product
    [Documentation]    check product multistore functionality
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: start new abstract product creation:
    ...    || sku               | store | store 2 | name en               | name de                 | new from   | new to     ||
    ...    || multiSKU${random} | DE    | AT      | multiProduct${random} | DEmultiProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 ||
    ...    || farbe       | grey              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set        ||
    ...    || DE    | gross | default | €        | 100.00 | Standard Taxes ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set        ||
    ...    || AT    | gross | default | €        | 200.00 | Standard Taxes ||
    Zed: change concrete product data:
    ...    || productAbstract   | productConcrete              | active | searchable en | searchable de ||
    ...    || multiSKU${random} | multiSKU${random}-farbe-grey | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract   | productConcrete              | store | mode  | type    | currency | amount ||
    ...    || multiSKU${random} | multiSKU${random}-farbe-grey | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract   | productConcrete              | store | mode  | type    | currency | amount ||
    ...    || multiSKU${random} | multiSKU${random}-farbe-grey | AT    | gross | default | €        | 25.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract   | productConcrete              | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || multiSKU${random} | multiSKU${random}-farbe-grey | Warehouse2   | 100              | true                            ||
    Trigger multistore p&s 
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to URL:    en/search?q=multiSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: go to PDP of the product with sku:    multiSKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €15.00
    Yves: go to AT store 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    multiProductCart+${random}
    Yves: go to AT URL:    en/search?q=multiSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €200.00
    Yves: go to PDP of the product with sku:    multiSKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €25.00
    Save current URL
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    multiProductCart+${random}
    Yves: shopping cart contains product with unit price:    multiSKU${random}-farbe-grey    multiProduct${random}    25.00
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update abstract product data:
    ...    || productAbstract   | unselect store ||
    ...    || multiSKU${random} | AT             ||
    Trigger multistore p&s 
    Yves: go to URL and refresh until 404 occurs:    ${url}
    [Teardown]    Run Keywords    Yves: go to AT store 'Home' page
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts

Multistore_CMS
    [Documentation]    check CMS multistore functionality
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Content    Pages
    Zed: create a cms page and publish it:    Multistore Page${random}    multistore-page${random}    Multistore Page    Page text
    Trigger multistore p&s 
    Yves: go to newly created page by URL on AT store:    en/multistore-page${random}
    Save current URL
    Yves: page contains CMS element:    CMS Page Title    Multistore Page
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update cms page and publish it:
    ...    || cmsPage                  | unselect store ||
    ...    || Multistore Page${random} | AT             ||
    Trigger multistore p&s 
    Yves: go to URL and refresh until 404 occurs:    ${url}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Content    Pages
    ...    AND    Zed: click Action Button in a table for row that contains:    Multistore Page${random}    Deactivate

Product_Availability_Calculation
    [Tags]    skip-due-to-issue
    [Documentation]    Bug: CC-24108. check product availability + multistore. 
    [Setup]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: update warehouse:    
    ...    || warehouse  | store || 
    ...    || Warehouse1 | AT    ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: start new abstract product creation:
    ...    || sku                      | store | store 2 | name en                      | name de                        | new from   | new to     ||
    ...    || availabilitySKU${random} | DE    | AT      | availabilityProduct${random} | DEavailabilityProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 ||
    ...    || farbe       | grey              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set        ||
    ...    || DE    | gross | default | €        | 100.00 | Standard Taxes ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set        ||
    ...    || AT    | gross | default | €        | 200.00 | Standard Taxes ||
    Zed: change concrete product data:
    ...    || productAbstract          | productConcrete                     | active | searchable en | searchable de ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-farbe-grey | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract          | productConcrete                     | store | mode  | type    | currency | amount ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-farbe-grey | DE    | gross | default | €        | 50.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract          | productConcrete                     | store | mode  | type    | currency | amount ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-farbe-grey | AT    | gross | default | €        | 75.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract          | productConcrete                     | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-farbe-grey | Warehouse2   | 5                | false                            ||
    Trigger multistore p&s 
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    availabilityCart+${random}
    Yves: go to URL:    en/search?q=availabilitySKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-farbe-grey only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    availabilityCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed    
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Trigger oms
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-farbe-grey only has availability of 2.
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Cancel
    Trigger oms
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-farbe-grey only has availability of 5.
    Yves: go to AT store 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to AT URL:    en/search?q=availabilitySKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update warehouse:    
    ...    || warehouse  | unselect store || 
    ...    || Warehouse1 | AT             ||
    Trigger multistore p&s 
    Yves: go to AT store 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to AT URL:    en/search?q=availabilitySKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: update warehouse:    
    ...    || warehouse  | unselect store || 
    ...    || Warehouse1 | AT             ||

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

Update_Customer_Data
    [Documentation]    Checks customer data can be updated from Yves and Zed
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu item in header:    Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name                           | last name                           | email                            ||
    ...    || Mr.        | ${yves_company_user_buyer_firstname} | ${yves_company_user_buyer_lastname} | ${yves_company_user_buyer_email} ||
    Yves: update customer profile data:
    ...    || salutation | first name                                  | last name                                  ||
    ...    || Dr.        | updated${yves_company_user_buyer_firstname} | updated${yves_company_user_buyer_lastname} ||
    Yves: assert customer profile data:
    ...    || salutation | first name                                  | last name                                  ||
    ...    || Dr.        | updated${yves_company_user_buyer_firstname} | updated${yves_company_user_buyer_lastname} ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: assert customer profile data:
    ...    || email                            | salutation | first name                                  | last name                                  ||
    ...    || ${yves_company_user_buyer_email} | Dr         | updated${yves_company_user_buyer_firstname} | updated${yves_company_user_buyer_lastname} ||
    Zed: update customer profile data:
    ...    || email                            | salutation | first name                           | last name                           ||
    ...    || ${yves_company_user_buyer_email} | Mr         | ${yves_company_user_buyer_firstname} | ${yves_company_user_buyer_lastname} ||
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu item in header:    Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name                           | last name                           | email                            ||
    ...    || Mr.        | ${yves_company_user_buyer_firstname} | ${yves_company_user_buyer_lastname} | ${yves_company_user_buyer_email} ||
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: update customer profile data:
    ...    || email                            | salutation | first name                           | last name                           ||
    ...    || ${yves_company_user_buyer_email} | Mr         | ${yves_company_user_buyer_firstname} | ${yves_company_user_buyer_lastname} ||

CRUD_Product_Set
    [Documentation]    CRUD operations for product sets
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new product set:
    ...    || name en            | name de            | url en             | url de             | set key       | active | product                             | product 2                           | product 3                                      ||
    ...    || test set ${random} | test set ${random} | test-set-${random} | test-set-${random} | test${random} | true   | ${one_variant_product_abstract_sku} | ${multi_color_product_abstract_sku} | ${product_with_relations_related_products_sku} ||
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    crudSetsCart+${random}
    Yves: go to newly created page by URL:    en/test-set-${random}
    Yves: 'Product Set' page contains the following products:    QUIPO universal steel cabinet with swing doors - HxWxD 1950 x 950 x 420 mm - light gray, from 3 pieces
    Yves: 'Product Set' page contains the following products:    Safescan automatic banknote counter - with 6-fold Counterfeit recognition, EUR value counting, SAFESCAN 2665-S
    Yves: 'Product Set' page contains the following products:    EUROKRAFT hand truck - with open shovel - load capacity 400 kg
    Yves: add all products to the shopping cart from Product Set
    Yves: shopping cart contains the following products:    107254    419904    403125
    Yves: delete all shopping carts
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: delete product set:    test set ${random}
    Trigger p&s
    Yves: go to URL and refresh until 404 occurs:    ${yves_url}en/test-set-${random}

Comments_in_Cart
    [Documentation]    Add comments to cart and verify comments in Yves and Zed
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: create new 'Shopping Cart' with name:    commentCart+${random}
    Yves: go to PDP of the product with sku:    ${bundled_product_3_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    commentCart+${random}
    Yves: add comment on cart:    abc${random}
    Yves: check comments are visible or not in cart:    true    abc${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_shared_permission_owner_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: go to order details page to check comment:    abc${random}    ${lastPlacedOrder}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}    
    Zed: check comment appears at order detailed page in zed:    abc${random}    ${lastPlacedOrder}

Comment_Management_in_the_Cart
    [Documentation]    Editing and deleting comments in carts
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: create new 'Shopping Cart' with name:    commentManagement+${random}
    Yves: go to PDP of the product with sku:    ${bundled_product_3_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    commentManagement+${random}
    Yves: add comment on cart:    abc${random}
    Yves: check comments are visible or not in cart:    true    abc${random}    
    Yves: edit comment on cart:    xyz${random}
    Yves: check comments are visible or not in cart:    true    xyz${random}    
    Yves: delete comment on cart
    Yves: check comments are visible or not in cart:    false    xyz${random}
    [Teardown]    Run Keyword    Yves: delete 'Shopping Cart' with name:    commentManagement+${random}

Comment_Management_in_Order
    [Tags]    skip-due-to-issue
    [Documentation]    Bug:CC-23306. Add comments in Yves and check in Zed. 
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: create new 'Shopping Cart' with name:    comments+${random}
    Yves: go to PDP of the product with sku:    ${bundled_product_3_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    comments+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_shared_permission_owner_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: add comment on order in order detail page:    abc${random}
    Yves: check comments is visible or not in order:    true    abc${random}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}    
    Zed: check comment appears at order detailed page in zed:    abc${random}    ${lastPlacedOrder}

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
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: validate the page title:    ${original_EN_text}-Test-${random}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: undo the changes in glossary translation:    ${glossary_name}     ${original_DE_text}    ${original_EN_text}
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: validate the page title:    ${original_EN_text}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: undo the changes in glossary translation:    ${glossary_name}     ${original_DE_text}    ${original_EN_text}
    
Configurable_Product_PDP_Shopping_List
    [Documentation]    Configure product from PDP and Shopping List
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    configProduct+${random}
    ...    AND    Yves: create new 'Shopping List' with name:    configProduct+${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: check and go back that configuration page contains:
    ...    || store | locale | price_mode | currency | customer_id                          | sku                                  ||
    ...    || DE    | en_US  | GROSS_MODE | EUR      | ${yves_company_user_buyer_reference} | ${configurable_product_concrete_sku} ||
    Yves: change the product configuration to:
    ...    || date       | date_time ||
    ...    || 12.12.2030 | Evening   ||
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 12.12.2030 | Evening   ||
    Yves: change the product configuration to:
    ...    || date  | date_time ||
    ...    ||       | Afternoon ||
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    configProduct+${random}
    Yves: change the product configuration to:    
    ...    || date       | date_time ||
    ...    || 05.05.2035 | Afternoon ||
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 05.05.2035 | Afternoon ||
    Yves: change the product configuration to:
    ...    || date  | date_time ||
    ...    ||       | Afternoon ||
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: checkout is blocked with the following message:    This cart can't be processed. Please configure items inside the cart.
    Yves: delete product from the shopping cart with sku:    ${configurable_product_concrete_sku}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change the product configuration to:
    ...    || date       | date_time ||
    ...    || 01.01.2055 | Morning   ||
    Yves: add product to the shopping list:    configProduct+${random}
    Yves: go To 'Shopping Lists' Page
    Yves: view shopping list with name:    configProduct+${random}
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 01.01.2055 | Morning   ||
    Yves: change the product configuration to:
    ...    || date       | date_time ||
    ...    || 01.01.2055 | Afternoon ||
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 01.01.2055 | Afternoon ||
    Yves: add all available products from list to cart
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 01.01.2055 | Afternoon ||
    Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_sku}    ${configurable_product_name}    ${configurable_product_concrete_price}
    [Teardown]    Run Keywords    Yves: delete 'Shopping List' with name:    configProduct+${random}
    ...    AND    Yves: delete 'Shopping Cart' with name:    configProduct+${random}
      
Configurable_Product_RfQ_Order_Management
    [Documentation]    Conf Product in RfQ, OMS and reorder
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: create new Zed user with the following data:    agent_config+${random}@spryker.com    change123${random}    Config    Product    Root group    This user is an agent    en_US
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: create new 'Shopping Cart' with name:    confProductCart+${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change the product configuration to:
    ...    || date       | date_time ||
    ...    || 12.12.2030 | Evening   ||
    Yves: add product to the shopping cart
    Yves: change the product configuration to:
    ...    || date       | date_time ||
    ...    || 12.12.2030 | Evening   ||
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    confProductCart+${random}
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 12.12.2030 | Evening   ||
    Yves: submit new request for quote
    Yves: click 'Send to Agent' button on the 'Quote Request Details' page   
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent_config+${random}@spryker.com    change123${random}
    Yves: go to 'Quote Requests' page through the header
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Waiting
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: 'Quote Request Details' page is displayed
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: click 'Edit Items' button on the 'Quote Request Details' page
    Yves: change the product configuration to:
    ...    || date       | date_time ||
    ...    || 01.01.2050 | Morning   ||
    Yves: click 'Save and Back to Edit' button on the 'Quote Request Details' page
    Yves: click 'Send to Customer' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Quote Requests
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Ready
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: click 'Convert to Cart' button on the 'Quote Request Details' page
    Yves: 'Shopping Cart' page is displayed
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
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €2,636.11
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: product configuration should be equal:
    ...    || shipment | position | sku                                  | date       | date_time ||
    ...    || 1        | 1        | ${configurable_product_concrete_sku} | 12.12.2030 | Evening   ||
    Zed: product configuration should be equal:
    ...    || shipment | position | sku                                  | date       | date_time ||
    ...    || 1        | 2        | ${configurable_product_concrete_sku} | 01.01.2050 | Morning   ||
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Trigger oms
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Skip timeout
    Trigger oms
    Zed: trigger matching state of xxx order item inside xxx shipment:    Ship    2
    Trigger oms
    Zed: trigger matching state of xxx order item inside xxx shipment:    Stock update    2
    Trigger oms
    Zed: trigger matching state of xxx order item inside xxx shipment:    Refund    2
    Trigger oms
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,321.0
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx order item inside xxx shipment:    Ship    1
    Trigger oms
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Trigger oms
    Yves: create return for the following products:    ${configurable_product_concrete_sku}
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    ${configurable_product_concrete_sku}
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Execute return
    Trigger oms
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page contains the following order with a status:    ${lastPlacedOrder}    Returned
    Yves: 'View Order/Reorder/Return' on the order history page:     View Order
    Yves: 'Order Details' page is displayed
    ### Reorder ###
    Yves: reorder all items from 'Order Details' page
    Yves: go to the shopping cart through the header with name:    Cart from order ${lastPlacedOrder}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:     ${configurable_product_concrete_sku}
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 12.12.2030 | Evening   ||
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    agent_config+${random}@spryker.com