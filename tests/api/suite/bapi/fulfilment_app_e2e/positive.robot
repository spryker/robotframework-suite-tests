# *** Settings ***
# Suite Setup       UI_suite_setup
# Test Setup        UI_test_setup
# Test Teardown     common.TestTeardown
# Suite Teardown    common.SuiteTeardown
# Resource    ../../../../../resources/common/common.robot
# Resource    ../../../../../resources/common/common_zed.robot
# Resource    ../../../../../resources/common/common_yves.robot
# Resource    ../../../../../resources/steps/zed_users_steps.robot
# Resource    ../../../../../resources/steps/orders_management_steps.robot
# Resource    ../../../../../../resources/common/common_api.robot
# Resource    ../../../../../resources/steps/service_point_steps.robot
# Resource    ../../../../../resources/steps/service_point_steps.robot
# Resource    ../../../../../resources/steps/warehouse_user_assigment_steps.robot
# Resource    ../../../../../resources/steps/picking_list_steps.robot
# Default Tags    bapi
# Test Tags     robot:recursive-stop-on-failure
# *** Test Cases ***
# Fulfilment_app_e2e
#     # #LOGGED IN TO BO and SET CHECKBOX is a warehouse user = true FOR admin_de USER. UI TEST
#     Zed: login on Zed with provided credentials:    ${zed_admin.email}
#     Zed: update Zed user:
#     ...    || oldEmail                       | password      | user_is_warehouse_user ||
#     ...    || admin_de@spryker.com           | Change123!321 | true                   ||
#     API_test_setup
#     # #ASSIGN admin_de user TO WAREHOUSE [Spryker Mer 000001 Warehouse 1] MAKE WAREHOUSE ACTIVE BY BAPI
#     And I get access token by user credentials:   ${zed_admin.email}
#     I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].de_admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"true"}}}
#     Then Response status code should be:    201
#     Then Save value to a variable:    [data][id]   warehouse_assigment_id  
#     # #CREATE AN ORDER BY GLUE
#     I set Headers:    Content-Type=${default_header_content_type}
#     Set Tags    glue
#     API_test_setup
#     And I get access token for the customer:    ${yves_user.email}
#     I set Headers:    Authorization=${token}
#     Then Cleanup all customer carts
#     I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
#     Then Response status code should be:    201
#     Then Save value to a variable:    [data][id]    cart_id
#     I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "091_25873091","quantity": 1}}}
#     I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"093_24495843","quantity":1,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"09.09.2050"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":1,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","093_24495843"]}}}
#     Then Response status code should be:    200
#     I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","093_24495843"]}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
#     And Save value to a variable:    [included][0][attributes][items][1][uuid]    uuid1
#     #MOVE ORDER ITEMS INTO WAITING STATE
#     And Update order status in Database:    waiting    ${uuid} 
#     And Update order status in Database:    waiting    ${uuid1}     
#     # #MOVE ORDER ITEMS TO PROPER STATE USING BO, PICKING LIST GENERATED AUTOMATICALLY. UI TEST
#     UI_test_setup
#     Yves: login on Yves with provided credentials:    ${yves_user.email}
#     Yves: get the last placed order ID by current customer
#     Zed: login on Zed with provided credentials:    ${zed_admin.email}
#     Zed: go to order page:    ${lastPlacedOrder}
#     Zed: trigger all matching states inside this order:    picking list generation schedule
#     Trigger oms
#     # #ORDER READY FOR PICKING
#     Zed: wait for order item to be in state:    091_25873091    ready for picking
#     Zed: wait for order item to be in state:    093_24495843    ready for picking
#     # #START PICKING PROCESS AND PICKING ITEMS BY BAPI
#     Remove Tags    glue
#     Set Tags   bapi
#     API_test_setup
#     I set Headers:    Content-Type=${default_header_content_type}
#     Then I get access token by user credentials:   ${zed_admin.email_de}    Change123!321
#     I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     I send a GET request:    /picking-lists/?include=picking-list-items,concrete-products,sales-shipments,sales-orders,warehouses
#     Then Response status code should be:    200
#     Then Save value to a variable:    [data][0][id]    picklist_id
#     And Response body parameter should be:    [data][0][type]    picking-lists
#     Then Save value to a variable:    [data][0][relationships][picking-list-items][data][0][id]    item_id_1
#     Then Save value to a variable:    [data][0][relationships][picking-list-items][data][1][id]    item_id_2
#     And Response body parameter should be:    [data][0][attributes][status]    ready-for-picking
#     And Response body parameter should be in:    [included][0][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
#     And Response body parameter should be in:    [included][1][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
#     And Response body parameter should be in:    [included][2][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
#     And Response body parameter should be in:    [included][3][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
#     And Response body parameter should be in:    [included][4][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
#     And Response body parameter should be in:    [included][5][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
#     And Response body parameter should be in:    [included][6][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
#     And Each array in response should contain property with NOT EMPTY value:    [included]    id
#     # #START PICKING
#     I send a POST request:   /picking-lists/${picklist_id}/start-picking    {"data": [{"type": "picking-lists","attributes": {"action": "startPicking"}}]}
#     Then Response status code should be:    201
#     And Response body parameter should be:    [data][attributes][status]    picking-started
#     And Response body parameter should be:    [data][type]    picking-lists
#     And Response body parameter should not be EMPTY:    [data][id]
#     # #PICKING ONE ITEM, ANOTHER ITEM STILL NOT PICKED
#     Then I send a PATCH request:    /picking-lists/${picklist_id}/picking-list-items    {"data":[{"id":"${item_id_1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item_id_2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":0}}]}
#     Then Response status code should be:    200
#     And Response body parameter should be:    [data][0][attributes][status]    picking-started
#     And Response body parameter should be in:    [data][0][relationships][picking-list-items][data][0][id]    ${item_id_1}    ${item_id_2}
#     And Response body parameter should be in:    [data][0][relationships][picking-list-items][data][1][id]    ${item_id_1}    ${item_id_2}
#     # #PICKING SECOND ITEM, PICKING FINISHED
#     Then I send a PATCH request:    /picking-lists/${picklist_id}/picking-list-items    {"data":[{"id":"${item_id_1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item_id_2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":1}}]}
#     Then Response status code should be:    200
#     And Response body parameter should be:    [data][0][attributes][status]    picking-finished
#     #CLEAN SYSTEM, REMOVE CREATED RELATIONS IN DB
#     [Teardown]     Run Keywords    Remove picking list item by uuid in DB:    ${item_id_1}
#     ...  AND    Remove picking list item by uuid in DB:    ${item_id_2} 
#     ...  AND    Remove picking list by uuid in DB:    ${picklist_id}
#     ...  AND    Make user not a warehouse user:   ${warehous_user[0].de_admin_user_uuid}    0
#     ...  AND    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}