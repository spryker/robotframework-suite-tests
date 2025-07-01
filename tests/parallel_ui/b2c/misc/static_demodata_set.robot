*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    static-set
Resource    ../../../../resources/common/common_ui.robot
Resource    ../../../../resources/common/common_zed.robot
Resource    ../../../../resources/steps/zed_discount_steps.robot
Resource    ../../../../resources/steps/minimum_order_value_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot
Resource    ../../../../resources/steps/picking_list_steps.robot
Resource    ../../../../resources/steps/warehouse_user_assignment_steps.robot
Resource    ../../../../resources/steps/zed_users_steps.robot
Resource    ../../../../resources/steps/zed_availability_steps.robot

*** Test Cases ***
Minimum_Order_Value
    [Documentation]    checks that global minimum and maximum order thresholds can be applied
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Deactivate all discounts in the database
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: change global threshold settings:
    ...    || store & currency | minimum hard value | minimum hard en message  | minimum hard de message  | maximum hard value | maximum hard en message | maximum hard de message | soft threshold                | soft threshold value | soft threshold fixed fee | soft threshold en message | soft threshold de message ||
    ...    || DE - Euro [EUR]  | 5                  | EN minimum {{threshold}} | DE minimum {{threshold}} | 150                | EN max {{threshold}}    | DE max {{threshold}}    | Soft Threshold with fixed fee | 100000               | 9                        | EN fixed {{fee}} fee      | DE fixed {{fee}} fee      ||
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: soft threshold surcharge is added in the cart:    €9.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: soft threshold surcharge is added on summary page:    €9.00
    Yves: hard threshold is applied with the following message:    €150.00
    Yves: go to the 'Home' page
    Yves: go to shopping cart page
    Yves: delete product from the shopping cart with name:    Canon IXUS 175
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
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €153.38
    [Teardown]    Run keywords    Restore all discounts in the database
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: change global threshold settings:
    ...    || store & currency | minimum hard value | minimum hard en message | minimum hard de message | maximum hard value | maximum hard en message                                                                                   | maximum hard de message                                                                                                              | soft threshold | soft threshold value | soft threshold en message | soft threshold de message ||
    ...    || DE - Euro [EUR]  | ${SPACE}           | ${SPACE}                | ${SPACE}                | 10000.00           | The cart value cannot be higher than {{threshold}}. Please remove some items to proceed with the order    | Der Warenkorbwert darf nicht höher als {{threshold}} sein. Bitte entfernen Sie einige Artikel, um mit der Bestellung fortzufahren    | None           | ${EMPTY}             | ${EMPTY}                  | ${EMPTY}                  ||
    ...    AND    Delete dynamic admin user from DB

Volume_Prices
    [Documentation]    Checks volume prices are applied
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Deactivate all discounts in the database
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    193
    Yves: change quantity using '+' or '-' button № times:    +    4
    Yves: product price on the PDP should be:    €165.00
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    193    Sony FDR-AX40    825.00
    Yves: delete from b2c cart products with name:    Sony FDR-AX40
    [Teardown]    Run keywords    Restore all discounts in the database
    ...    AND    Delete dynamic admin user from DB

Configurable_Product_Checkout
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Deactivate all discounts in the database
    ...    AND    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    ...    AND    Yves: create new 'Wishlist' with name:    configProduct${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change variant of the product on PDP on:    ${configurable_product_concrete_one_attribute}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: change the product options in configurator to:
    ...    || option one | option two | option three |option four | option five | option six | option seven | option eight | option nine | option ten       ||
    ...    || 517        | 473        | 100          | 0.00       |  51         | 19         | 367          | 46           | 72          | English Keyboard ||
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_one_sku}    productName=${configurable_product_name}    productPrice=1,599.00
    Yves: change the product options in configurator to:
    ...    || option one | option two | option three |option four | option five | option six | option seven | option eight | option nine | option ten      ||
    ...    || 905        | 249        | 100          | 36         |  15         | 0.00       | 48           | 57           | 36          | German Keyboard ||
    Yves: save product configuration
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_one_sku}    productName=${configurable_product_name}    productPrice=1,346.00 
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:   ${default_address.full_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,361.00
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    skip picking
    Zed: trigger all matching states inside this order:    Ship
    Zed: trigger all matching states inside this order:    Stock update
    Zed: trigger all matching states inside this order:    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
    [Teardown]    Run keywords    Restore all discounts in the database
    ...    AND    Delete dynamic admin user from DB

Fulfillment_app_e2e
    # # LOGGED IN TO BO and SET CHECKBOX is a warehouse user = true FOR admin_de USER. UI TEST
    Remove all warehouse user assignments by user uuid:    ${warehouse_user[0].de_admin_user_uuid}
    Make user a warehouse user/ not a warehouse user:    ${warehouse_user[0].de_admin_user_uuid}    0
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update Zed user:
    ...    || oldEmail              | user_is_warehouse_user ||
    ...    || admin_de@spryker.com  | true                   ||
    Remove Tags    *
    Set Tags   bapi
    API_test_setup
    # # ASSIGN admin_de user TO WAREHOUSE [Warehouse 1] MAKE WAREHOUSE ACTIVE BY BAPI
    And I get access token by user credentials:   ${zed_admin_email}
    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehouse_user[0].de_admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid_warehouse1}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assignment_id  
    # CREATE AN ORDER BY GLUE
    I set Headers:    Content-Type=${default_header_content_type}
    Remove Tags    *
    Set Tags    glue
    API_test_setup
    When I get access token for the customer:    ${yves_user_email}    
    Then I set Headers:    Authorization=${token}
    When Find or create customer cart
    Then Cleanup all items in the cart:    ${cart_id}
    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "091_25873091","quantity": 1}}}
    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "093_24495843","quantity": 1}}}
    I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment_provider_name_1}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","093_24495843"]}}}
    Then Response status code should be:    200
    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment_provider_name_1}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","093_24495843"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    And Save value to a variable:    [included][0][attributes][items][1][uuid]    uuid1
    # # MOVE ORDER ITEMS INTO WAITING STATE
    And Update order status in Database:    waiting    ${uuid} 
    And Update order status in Database:    waiting    ${uuid1}     
    # # MOVE ORDER ITEMS TO PROPER STATE USING BO, PICKING LIST GENERATED AUTOMATICALLY. UI TEST
    UI_test_setup
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: get the last placed order ID by current customer
    Trigger oms
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    picking list generation schedule
    # # ORDER READY FOR PICKING
    Zed: wait for order item to be in state:    091_25873091    ready for picking
    Zed: wait for order item to be in state:    093_24495843    ready for picking
    # # START PICKING PROCESS AND PICKING ITEMS BY BAPI
    Remove Tags    glue
    Set Tags   bapi
    API_test_setup
    I set Headers:    Content-Type=${default_header_content_type}
    Then I get access token by user credentials:   ${zed_admin_email_de}
    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    I send a GET request:    /picking-lists/?include=picking-list-items,concrete-products,sales-shipments,sales-orders,include=warehouses
    Then Response status code should be:    200
    Then Save value to a variable:    [data][0][id]    picklist_id
    Then Save value to a variable:    [data][0][relationships][picking-list-items][data][0][id]    item_id_1
    Then Save value to a variable:    [data][0][relationships][picking-list-items][data][1][id]    item_id_2
    And Response body parameter should be:    [data][0][attributes][status]    ready-for-picking
    # # START PICKING
    I send a POST request:   /picking-lists/${picklist_id}/start-picking    {"data": [{"type": "picking-lists","attributes": {"action": "startPicking"}}]}
    Then Response status code should be:    201
    And Response body parameter should be:    [data][attributes][status]    picking-started
    # # PICKING ONE ITEM, ANOTHER ITEM STILL NOT PICKED
    Then I send a PATCH request:    /picking-lists/${picklist_id}/picking-list-items    {"data":[{"id":"${item_id_1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item_id_2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":0}}]}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][attributes][status]    picking-started
    And Response body parameter should be in:    [data][0][relationships][picking-list-items][data][0][id]    ${item_id_1}    ${item_id_2}
    And Response body parameter should be in:    [data][0][relationships][picking-list-items][data][1][id]    ${item_id_1}    ${item_id_2}
    # # PICKING SECOND ITEM, PICKING FINISHED
    Then I send a PATCH request:    /picking-lists/${picklist_id}/picking-list-items    {"data":[{"id":"${item_id_1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item_id_2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":1}}]}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][attributes][status]    picking-finished
    # CLEAN SYSTEM, REMOVE CREATED RELATIONS IN DB
    [Teardown]     Run Keywords    Remove picking list item by uuid in DB:    ${item_id_1}
    ...  AND    Remove picking list item by uuid in DB:    ${item_id_2} 
    ...  AND    Remove picking list by uuid in DB:    ${picklist_id}
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].de_admin_user_uuid}    0
    ...  AND    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assignment_id}    

Discounts
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
    Zed: create a discount and activate it:    voucher    Percentage    5    sku = '*'    test${random}    discountName=Voucher Code 5% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    10    sku = '*'    discountName=Cart Rule 10% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    100    discountName=Promotional Product 100% ${random}    promotionalProductDiscount=True    promotionalProductAbstractSku=002    promotionalProductQuantity=2
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    190
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: apply discount voucher to cart:    test${random}
    Yves: discount is applied:    voucher    Voucher Code 5% ${random}    - €8.73
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €17.46
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €87.96
    Yves: promotional product offer is/not shown in cart:    true
    Yves: change quantity of promotional product and add to cart:    +    1
    Yves: shopping cart contains the following products:    Kodak EasyShare M532    Canon IXUS 160
    Yves: discount is applied:    cart rule    Promotional Product 100% ${random}    - €75.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €753.55
    [Teardown]    Run keywords    Restore all discounts in the database
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: deactivate following discounts from Overview page:    Voucher Code 5% ${random}    Cart Rule 10% ${random}    Promotional Product 100% ${random}
    ...    AND    Delete dynamic admin user from DB

Refunds
    [Documentation]    Checks that refund can be created for one item and the whole order. DMS-ON: https://spryker.atlassian.net/browse/FRW-7463
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Deactivate all discounts in the database
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    008
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    010
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €394.41
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    skip picking
    Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Ship
    Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Stock
    Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €265.03
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Ship
    Zed: trigger all matching states inside this order:    Stock update
    Zed: trigger all matching states inside this order:    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
    [Teardown]    Run keywords    Restore all discounts in the database
    ...    AND    Delete dynamic admin user from DB

Manage_Shipments
    [Documentation]    Checks create/edit shipment functions from backoffice
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Deactivate all discounts in the database
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    012
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
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
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €307.88
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    1
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 1          | Hermes          | Next Day        | €15.00         | ASAP                    ||
    Zed: create new shipment inside the order:
    ...    || delivery address | salutation | first name | last name | email               | country | address 1     | address 2 | city   | zip code | shipment method | sku          ||
    ...    || New address      | Mr         | Evil       | Tester    | ${dynamic_customer} | Austria | Hartmanngasse | 1         | Vienna | 1050     | DHL - Standard  | 012_25904598 ||
    Zed: billing address for the order should be:    First Last, Billing Street 123, 10247 Berlin, Germany
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    2
    Zed: shipping address inside xxx shipment should be:    1    Dr First, Last, First Street, 1, Additional street, Spryker, 10247, Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    2    Mr Evil, Tester, Hartmanngasse, 1, 1050, Vienna, Austria
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 2          | DHL             | Standard        | €0.00          | ASAP                    ||
    Zed: edit xxx shipment inside the order:
    ...    || shipmentN | delivery address | salutation | first name | last name | email               | country | address 1     | address 2 | city   | zip code | shipment method | requested delivery date | sku          ||
    ...    || 2         | New address      | Mr         | Edit       | Shipment  | ${dynamic_customer} | Germany | Hartmanngasse | 9         | Vienna | 0987     | DHL - Express   | 2025-01-25              | 005_30663301 ||
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 2          | DHL             | Standard        |  €0.00         | ASAP                    ||
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 3          | DHL             | Express         |  €0.00         | 2025-01-25              ||
    Zed: xxx shipment should/not contain the following products:    1    true    007_30691822
    Zed: xxx shipment should/not contain the following products:    1    false    012_25904598
    Zed: xxx shipment should/not contain the following products:    2    true    012_25904598
    Zed: xxx shipment should/not contain the following products:    3    true    005_30663301
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €307.88
    [Teardown]    Run Keywords    Restore all discounts in the database
    ...    AND    Delete dynamic admin user from DB

Configurable_Product_OMS
    [Documentation]    Conf Product OMS check and reorder.
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Deactivate all discounts in the database
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change variant of the product on PDP on:    ${configurable_product_concrete_one_attribute}
    Yves: change the product options in configurator to:
    ...    || option one | option two | option three |option four | option five | option six | option seven | option eight | option nine | option ten       ||
    ...    || 517        | 473        | 100          | 0.00       |  51         | 19         | 367          | 46           | 72          | English Keyboard ||
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_one_attribute}   productName=${configurable_product_name}    productPrice=1,599.00
    Yves: change the product options in configurator to:
    ...    || option one | option two | option three |option four | option five | option six | option seven | option eight | option nine | option ten      ||
    ...    || 905        | 249        | 100          | 36         |  15         | 0.00       | 48           | 57           | 36          | German Keyboard ||
    Yves: save product configuration
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_one_attribute}    productName=${configurable_product_name}    productPrice=1,346.00 
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Trigger oms
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,361.00
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    skip picking
    Zed: trigger matching state of xxx order item inside xxx shipment:    Ship    1
    Zed: trigger matching state of xxx order item inside xxx shipment:    Stock-update    1
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    ${configurable_product_concrete_one_sku}
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    ${configurable_product_concrete_one_sku}
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Execute return
    [Teardown]    Run Keywords    Restore all discounts in the database
    ...    AND    Delete dynamic admin user from DB