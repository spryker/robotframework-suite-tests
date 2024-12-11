*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    pabot_skip
Resource    ../../../../resources/common/common_zed.robot
Resource    ../../../../resources/steps/minimum_order_value_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/common/common_api.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/mp_products_steps.robot
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../resources/steps/mp_orders_steps.robot
Resource    ../../../../resources/steps/zed_discount_steps.robot

*** Test Cases ***
Minimum_Order_Value
    [Documentation]    checks that global minimum and maximun order thresholds can be applied
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Deactivate all discounts in the database
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: change global threshold settings:
    ...    || store & currency | minimum hard value | minimum hard en message  | minimum hard de message  | maximun hard value | maximun hard en message | maximun hard de message | soft threshold                | soft threshold value | soft threshold fixed fee | soft threshold en message | soft threshold de message ||
    ...    || DE - Euro [EUR]  | 5                  | EN minimum {{threshold}} | DE minimum {{threshold}} | 150                | EN max {{threshold}}    | DE max {{threshold}}    | Soft Threshold with fixed fee | 100000               | 9                        | EN fixed {{fee}} fee      | DE fixed {{fee}} fee      ||
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${available_never_out_of_stock_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: soft threshold surcharge is added in the cart:    €9.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
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
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €83.90
    [Teardown]    Run keywords    Delete dynamic customer via API
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: change global threshold settings:
    ...    || store & currency | minimum hard value | minimum hard en message | minimum hard de message | maximun hard value | maximun hard en message                                                                                   | maximun hard de message                                                                                                              | soft threshold | soft threshold value | soft threshold en message | soft threshold de message ||
    ...    || DE - Euro [EUR]  | ${SPACE}           | ${SPACE}                | ${SPACE}                | 10000.00           | The cart value cannot be higher than {{threshold}}. Please remove some items to proceed with the order    | Der Warenkorbwert darf nicht höher als {{threshold}} sein. Bitte entfernen Sie einige Artikel, um mit der Bestellung fortzufahren    | None           | ${EMPTY}             | ${EMPTY}                  | ${EMPTY}                  ||
    ...    AND    Delete dynamic admin user from DB
    ...    AND    Restore all discounts in the database

Configurable_Product_RfQ_OMS
    [Documentation]    Conf Product in RfQ, OMS, Merchant OMS and reorder. 
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: create dynamic merchant user:    merchant=Spryker    merchant_user_group=Root group
    ...    AND    Deactivate all discounts in the database
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: create new 'Shopping Cart' with name:    confProductCart+${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 607        | 275        ||
    Yves: save product configuration    
    Yves: add product to the shopping cart
    Yves: submit new request for quote
    Yves: click 'Send to Agent' button on the 'Quote Request Details' page   
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    ${dynamic_admin_user}
    Yves: go to 'Agent Quote Requests' page through the header
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Waiting
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: 'Quote Request Details' page is displayed
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: click 'Edit Items' button on the 'Quote Request Details' page
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 517        | 249        ||
    Yves: save product configuration    
    Yves: click 'Save and Back to Edit' button on the 'Quote Request Details' page
    Yves: click 'Send to Customer' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Quote Requests
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Ready
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: click 'Convert to Cart' button on the 'Quote Request Details' page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_spryker_merchant}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €771.90
    Zed: go to order page:    ${lastPlacedOrder} 
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: trigger all matching states inside this order:    skip picking
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of xxx order item inside xxx shipment:    Ship    1
    Zed: trigger matching state of xxx order item inside xxx shipment:    Deliver    1
    Zed: trigger matching state of xxx order item inside xxx shipment:    Refund    1
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Order History
    Yves: 'View Order/Reorder/Return' on the order history page:     View Order
    Yves: 'Order Details' page is displayed
    ### Reorder ###
    Yves: reorder all items from 'Order Details' page
    Yves: go to the shopping cart through the header with name:    ${lastPlacedOrder}
    Yves: 'Shopping Cart' page is displayed
    # ### bug: https://spryker.atlassian.net/browse/CC-33647
    # Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_sku}    ${configurable_product_name}    €766.00
    Yves: product configuration status should be equal:       Configuration is not complete.
    [Teardown]    Run Keywords    Restore all discounts in the database
    ...    AND    Delete dynamic customer via API
    ...    AND    Delete dynamic admin user from DB

Click_and_collect
    [Tags]    smoke    group_one
    [Documentation]    checks that product offer is successfully replaced with a target product offer
    [Setup]    Run keywords    Deactivate all discounts in the database
    ...    AND    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: create dynamic merchant user:    Spryker
    ...    AND    Zed: create dynamic merchant user:    Budget Cameras
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku              | product name                 | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || clickCollectSku${random} | clickCollectProduct${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    clickCollectProduct${random} 
    MP: click on a table row that contains:     clickCollectSku${random}
    MP: fill abstract product required fields:
    ...    || product name                 | store | tax set           ||
    ...    || clickCollectProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 50            ||
    MP: save abstract product
    MP: click on a table row that contains:    clickCollectSku${random}
    MP: open concrete drawer by SKU:    clickCollectSku${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     clickCollectSku${random}     Approve 
    Trigger p&s 
    MP: login on MP with provided credentials:    ${dynamic_budget_merchant}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    clickCollectSku${random}-2
    MP: click on a table row that contains:    clickCollectSku${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku                           | store | stock quantity | service point      | services | shipment types  ||
    ...    || true      | clickCollectFirstSku${random}${random} | DE    | 100            | Spryker Main Store | Pickup   | pickup - Pickup ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 100           ||
    MP: save offer
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    clickCollectSku${random}-2
    MP: click on a table row that contains:    clickCollectSku${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku                            | store | stock quantity | shipment types      ||
    ...    || true      | clickCollectSecondSku${random}${random} | DE    | 100            | delivery - Delivery ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 150           ||
    MP: save offer
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    clickCollectSku${random}-2
    MP: click on a table row that contains:    clickCollectSku${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku                  | store | stock quantity | service point        | services | shipment types  ||
    ...    || true      | clickCollectThirdSku${random} | DE    | 100            | Spryker Berlin Store | Pickup   | pickup - Pickup ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 200           ||
    MP: save offer
    Trigger p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Offers
    Zed: filter by merchant:    Budget Cameras
    Zed: table should contain:    clickCollectSku${random}-2
    Zed: click Action Button in a table for row that contains:     clickCollectSku${random}-2     View
    Zed: view offer page is displayed
    Zed: view offer product page contains:
    ...    || approval status | status | store | sku                        | merchant       | merchant sku                  | services                      | shipment types  ||
    ...    || Approved        | Active | DE    | clickCollectSku${random}-2 | Budget Cameras | clickCollectThirdSku${random} | Spryker Berlin Store - Pickup | pickup - Pickup ||
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     clickCollectSku${random}    wait_for_p&s=true
    Yves: select xxx merchant's offer with price:    Budget Cameras    €100.00    wait_for_p&s=true
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to PDP of the product with sku:     clickCollectSku${random}
    Yves: select xxx merchant's offer with price:    Budget Cameras    €150.00
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select multiple addresses from toggler
    Yves: select xxx shipment type for item number xxx:    shipment_type=Pickup    item_number=1
    Yves: select xxx shipment type for item number xxx:    shipment_type=Pickup    item_number=2
    Yves: check store availabiity for item number xxx:
    ...    || item_number | store              | availability ||
    ...    || 1           | Spryker Main Store | green        ||
    Yves: check store availabiity for item number xxx:
    ...    || item_number | store                | availability ||
    ...    || 1           | Spryker Berlin Store | green        ||
    Yves: check store availabiity for item number xxx:
    ...    || item_number | store              | availability ||
    ...    || 2           | Spryker Main Store | green        ||
    Yves: check store availabiity for item number xxx:
    ...    || item_number | store                | availability ||
    ...    || 2           | Spryker Berlin Store | green        ||
    Yves: select pickup service point store for item number xxx:
    ...    || item_number | store                ||
    ...    || 1           | Spryker Berlin Store ||
    Yves: select pickup service point store for item number xxx:
    ...    || item_number | store                ||
    ...    || 2           | Spryker Berlin Store ||
    Yves: 'billing same as shipping' checkbox should be displayed:    false
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Pickup    Free Pickup
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: checkout summary step contains product with unit price:    productName=clickCollectProduct${random}    productPrice=200.00
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €400.00
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    1
    Zed: billing address for the order should be:    First Last, Billing Street 123, 10247 Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    1    Spryker Berlin Store, Ms Dynamic, Customer, Julie-Wolfthorn-Straße, 1, 10115, Berlin, Germany
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 1          | Pickup          | Free Pickup     | €0.00          | ASAP                    ||
    [Teardown]    Run keywords    Restore all discounts in the database
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     clickCollectSku${random}     Deny
    ...    AND    Delete dynamic customer via API

Configurable_Product_Checkout
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Deactivate all discounts in the database
    ...    AND    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 517        | 167        ||
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 389.50     | 249        ||
    Yves: save product configuration
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_sku}    productName=${configurable_product_name}    productPrice=638.50 
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €644.40
    [Teardown]    Run keywords    Restore all discounts in the database
    ...    AND    Delete dynamic customer via API
    ...    AND    Delete dynamic admin user from DB

Fulfill_Order_from_Merchant_Portal
    [Tags]    smoke    group_two
    [Documentation]    Checks that merchant is able to process his order through OMS from merchant portal
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: create dynamic merchant user:    Video King
    ...    AND    Zed: create dynamic merchant user:    Budget Cameras
    ...    AND    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer30  | 10             | true                  ||
    ...    AND    MP: login on MP with provided credentials:    ${dynamic_budget_merchant}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer89 | 10             | true                  ||
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer410 | 10             | true                  ||
    ...    AND    Trigger p&s
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: change product stock:    ${one_variant_product_of_main_merchant_abstract_sku}    ${one_variant_product_of_main_merchant_concrete_sku}    true    10    10
    ...    AND    Deactivate all discounts in the database
    ...    AND    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_of_main_merchant_abstract_sku}
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to PDP of the product with sku:     ${product_with_multiple_offers_abstract_sku}
    Yves: merchant's offer/product price should be:    Budget Cameras    ${product_with_multiple_offers_budget_cameras_price}
    Yves: merchant's offer/product price should be:    Video King    ${product_with_multiple_offers_video_king_price}
    Yves: select xxx merchant's offer:    Budget Cameras
    Yves: product price on the PDP should be:    ${product_with_multiple_offers_budget_cameras_price}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:     ${second_product_with_multiple_offers_abstract_sku}
    Yves: select xxx merchant's offer:    Video King
    Yves: product price on the PDP should be:    ${second_product_with_multiple_offers_video_king_price}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:     ${product_with_budget_cameras_offer_abstract_sku}
    Yves: select xxx merchant's offer:    Budget Cameras
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: assert merchant of product in cart or list:    ${one_variant_product_of_main_merchant_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    Yves: assert merchant of product in cart or list:    ${product_with_budget_cameras_offer_concrete_sku}    Budget Cameras
    Yves: assert merchant of product in cart or list:    ${second_product_with_multiple_offers_concrete_sku}    Video King
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Standard
    Yves: select the following shipping method for the shipment:    2    Spryker Drone Shipment    Air Light
    Yves: select the following shipping method for the shipment:    3    Spryker Dummy Shipment    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice Marketplace
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: wait for order item to be in state:    ${product_with_multiple_offers_concrete_sku}    sent to merchant    2
    MP: login on MP with provided credentials:    ${dynamic_budget_merchant}
    MP: open navigation menu tab:    Orders    
    MP: wait for order to appear:    ${lastPlacedOrder}--${merchant_budget_cameras_reference}
    MP: click on a table row that contains:    ${lastPlacedOrder}--${merchant_budget_cameras_reference}
    MP: order grand total should be:    €171.42
    MP: update order state using header button:    Ship
    MP: order states on drawer should contain:    Shipped 
    MP: switch to the tab:    Items
    MP: change order item state on:    ${product_with_multiple_offers_concrete_sku}    Deliver
    MP: switch to the tab:    Items
    MP: order item state should be:    ${product_with_budget_cameras_offer_concrete_sku}    shipped
    MP: order item state should be:    ${product_with_multiple_offers_concrete_sku}    delivered
    MP: update order state using header button:    Deliver
    MP: order states on drawer should contain:    Delivered
    MP: switch to the tab:    Items
    MP: order item state should be:    ${product_with_budget_cameras_offer_concrete_sku}    delivered
    MP: order item state should be:    ${product_with_multiple_offers_concrete_sku}    delivered
    [Teardown]    Run Keywords    Restore all discounts in the database
    ...    AND    Delete dynamic customer via API
    ...    AND    Delete dynamic admin user from DB

Discounts
    [Tags]    smoke    group_tree
    [Documentation]    Discounts, Promo Products, and Coupon Codes (includes guest checkout)
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Deactivate all discounts in the database
    ...    AND    Zed: change product stock:    190    190_25111746    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Merchandising    Discount
    Zed: create a discount and activate it:    voucher    Percentage    5    sku = '*'    test${random}    discountName=Voucher Code 5% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    10    sku = '*'    discountName=Cart Rule 10% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    100    discountName=Promotional Product 100% ${random}    promotionalProductDiscount=True    promotionalProductAbstractSku=002    promotionalProductQuantity=2
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    190
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to b2c shopping cart
    Yves: apply discount voucher to cart:    test${random}
    Yves: discount is applied:    voucher    Voucher Code 5% ${random}    - €8.73
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €17.46
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €87.96
    Yves: promotional product offer is/not shown in cart:    true
    Yves: add promotional product to the cart
    Yves: shopping cart contains the following products:    190_25111746    002_25904004
    Yves: discount is applied:    cart rule    Promotional Product 100% ${random}    - €75.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Standard
    Yves: select the following shipping method for the shipment:    2    Spryker Dummy Shipment    Express
    Yves: select the following shipping method for the shipment:    3    Spryker Drone Shipment    Air Light
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €773.45
    [Teardown]    Run keywords    Restore all discounts in the database
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: deactivate following discounts from Overview page:    Voucher Code 5% ${random}    Cart Rule 10% ${random}    Promotional Product 100% ${random}
    ...    AND    Trigger p&s
    ...    AND    Delete dynamic admin user from DB
    ...    AND    Delete dynamic customer via API

Refunds
    [Tags]    smoke    group_tree
    [Documentation]    Checks that refund can be created for one item and the whole order
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Deactivate all discounts in the database
    ...    AND    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    008
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    010
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:   ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,041.90
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay   
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    skip picking
    Zed: trigger all matching states inside this order:    Ship
    Zed: trigger all matching states inside this order:    Stock update
    Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €696.90
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger matching state of order item inside xxx shipment:    007_30691822    Refund
    Zed: trigger matching state of order item inside xxx shipment:    010_30692994    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
    [Teardown]    Run keywords    Restore all discounts in the database
    ...    AND    Delete dynamic admin user from DB
    ...    AND    Delete dynamic customer via API

Manage_Shipments
    [Documentation]    Checks create/edit shipment functions from backoffice
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB    based_on=${yves_user_email}    create_default_address=False
    ...    AND    Deactivate all discounts in the database
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    012
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select delivery to multiple addresses
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 285 | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 175 | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 165 | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Standard
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €785.90
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    1
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method        | shipping method | shipping costs | requested delivery date ||
    ...    || 1          | Spryker Dummy Shipment | Standard        | €4.90          | ASAP                    ||
    Zed: create new shipment inside the order:
    ...    || delivert address | salutation | first name | last name | email              | country | address 1     | address 2 | city   | zip code | shipment method                  | sku          ||
    ...    || New address      | Mr         | Evil       | Tester    | ${yves_user_email} | Austria | Hartmanngasse | 1         | Vienna | 1050     | Spryker Dummy Shipment - Express | 012_25904598 ||
    Zed: billing address for the order should be:    First Last, Billing Street 123, 10247 Berlin, Germany
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    2
    Zed: shipping address inside xxx shipment should be:    1    Dr First, Last, First Street, 1, Additional street, Spryker, 10247, Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    2    Mr Evil, Tester, Hartmanngasse, 1, 1050, Vienna, Austria
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method        | shipping method | shipping costs | requested delivery date ||
    ...    || 2          | Spryker Dummy Shipment | Express         | €0.00          | ASAP                    ||
    Zed: edit xxx shipment inside the order:
    ...    || shipmentN | delivert address | salutation | first name | last name | email              | country | address 1     | address 2 | city   | zip code | shipment method                    | requested delivery date | sku          ||
    ...    || 2         | New address      | Mr         | Edit       | Shipment  | ${yves_user_email} | Germany | Hartmanngasse | 9         | Vienna | 0987     | Spryker Drone Shipment - Air Light | 2025-01-25              | 005_30663301 ||
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method        | shipping method | shipping costs | requested delivery date ||
    ...    || 2          | Spryker Dummy Shipment | Express         |  €0.00         | ASAP                    ||
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method        | shipping method | shipping costs | requested delivery date ||
    ...    || 3          | Spryker Drone Shipment | Air Light       |  €0.00         | 2025-01-25              ||
    Zed: xxx shipment should/not contain the following products:    1    true    007_30691822
    Zed: xxx shipment should/not contain the following products:    1    false    012_25904598
    Zed: xxx shipment should/not contain the following products:    2    true    012_25904598
    Zed: xxx shipment should/not contain the following products:    3    true    005_30663301
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €785.90
    [Teardown]    Run Keywords    Restore all discounts in the database
    ...    AND    Delete dynamic admin user from DB
    ...    AND    Delete dynamic customer via API