*** Settings ***
Library    BuiltIn
Suite Setup       common.SuiteSetup
Test Setup        common.TestSetup
Test Teardown     common.TestTeardown
Suite Teardown    common.SuiteTeardown

Resource    ../../../../../resources/common/common.robot
Resource    ../../../../../resources/common/common_zed.robot
Resource    ../../../../../resources/common/common_yves.robot
Resource    ../../../../../resources/steps/zed_users_steps.robot
Resource    ../../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/service_point_steps.robot
Resource    ../../../../../resources/steps/service_point_steps.robot
Resource    ../../../../../resources/steps/warehouse_user_assigment_steps.robot
Resource    ../../../../../resources/steps/picking_list_steps.robot
Default Tags    bapi
Test Tags     robot:recursive-stop-on-failure

*** Test Cases ***

Fulfilment_app_e2e
    # Logged in to BO and set checkbox is a warehouse user = true for admin_de user. UI test
    Zed: login on Zed with provided credentials:    ${zed_admin.email}
    Zed: update Zed user:
    ...    || oldEmail                       | password      | user_is_warehouse_user ||
    ...    || admin_de@spryker.com           | Change123!321 | true                   ||
    common_api.TestSetup
    # Assign admin_de user to warehouse [Spryker Mer 000001 Warehouse 1] make warehouse active by BAPI
    And I get access token by user credentials:   ${zed_admin.email}
    common_api.I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    common_api.I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].de_admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id  
    # Create an order by GLUE
    common_api.I set Headers:    Content-Type=${default_header_content_type}
    Set Tags    glue
    common_api.TestSetup
    And I get access token for the customer:    ${yves_user.email}
    common_api.I set Headers:    Authorization=${token}
    Then Cleanup all customer carts
    common_api.I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]    cart_id
    common_api.I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "091_25873091","quantity": 1}}}
    common_api.I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"093_24495843","quantity":1,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"09.09.2050"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":1,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    common_api.I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","093_24495843"]}}}
    Then Response status code should be:    200
    common_api.I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","093_24495843"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    And Save value to a variable:    [included][0][attributes][items][1][uuid]    uuid1
    # move order items into waiting state by DB
    And Update order status in Database:    waiting    ${uuid} 
    And Update order status in Database:    waiting    ${uuid1}     
    # move order items to proper states using BO, picking list generated automatically. UI test
    common.SuiteSetup
    common.TestSetup
    common.TestTeardown
    common.SuiteTeardown
    Yves: login on Yves with provided credentials:    ${yves_user.email}
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin.email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    picking list generation schedule
    # Trigger oms
    # order ready for pickking process 
    Zed: wait for order item to be in state:    091_25873091    ready for picking
    Zed: wait for order item to be in state:    093_24495843    ready for picking
    # Start picking process and picking itemes bu BAPI
    common_api.I set Headers:    Content-Type=${default_header_content_type}
    Set Tags    bapi
    common_api.TestSetup
    Then I get access token by user credentials:   ${zed_admin.email_de}    Change123!321
    common_api.I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    common_api.I send a GET request:    /picking-lists/?include=picking-list-items,concrete-products,sales-shipments,sales-orders,include=warehouses
    Then Response status code should be:    200
    Then Save value to a variable:    [data][0][id]    picklist_id
    Then Save value to a variable:    [data][0][relationships][picking-list-items][data][0][id]    item_id_1
    Then Save value to a variable:    [data][0][relationships][picking-list-items][data][1][id]    item_id_2
    And Response body parameter should be:    [data][0][attributes][status]    ready-for-picking
    # start picking
    common_api.I send a POST request:   /picking-lists/${picklist_id}/start-picking    {"data": [{"type": "picking-lists","attributes": {"action": "startPicking"}}]}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][attributes][status]    picking-started
    # picking one item, another item still not picked
    Then I send a PATCH request:    /picking-lists/${picklist_id}/picking-list-items    {"data":[{"id":"${item_id_1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item_id_2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":0}}]}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][attributes][status]    picking-started
    And Response body parameter should be in:    [data][0][relationships][picking-list-items][data][0][id]    ${item_id_1}    ${item_id_2}
    And Response body parameter should be in:    [data][0][relationships][picking-list-items][data][1][id]    ${item_id_1}    ${item_id_2}
    # picking second item, picking finished
    Then I send a PATCH request:    /picking-lists/${picklist_id}/picking-list-items    {"data":[{"id":"${item_id_1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item_id_2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":1}}]}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][attributes][status]    picking-finished
    # clean the system, remove created relations
    [Teardown]     Run Keywords    Remove picking list item by uuid in DB:    ${item_id_1}
    ...  AND    Remove picking list item by uuid in DB:    ${item_id_2} 
    ...  AND    Remove picking list item by uuid in DB:    ${pick_list_uuid}
    ...  AND    Make user not a warehouse user:   ${warehous_user[0].user_uuid}    0
    ...  AND    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}
