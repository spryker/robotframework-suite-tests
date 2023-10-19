*** Settings ***
Suite Setup       common_api.SuiteSetup
Test Setup        common_api.TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/service_point_steps.robot
Resource     ../../../../../resources/common/common.robot
Resource    ../../../../../resources/common/common_zed.robot
# Resource    ../../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../../resources/steps/zed_users_steps.robot

Default Tags    bapi


*** Test Cases ***
ENABLER
    common_api.TestSetup

Make_user_a_warehouse_user
    [Setup]    Run Keywords    common.SuiteSetup    AND    common.TestSetup
    Zed: login on Zed with provided credentials:    ${zed_admin.email}
    Zed: go to second navigation item level:    Users    Users
    Zed: set Zed user a warehouse user:
    ...    || password      | firstName | lastName ||
    ...    || Change123!321 |           |          ||



Assign_user_to_active_warehouse
    [Tags]    bapi
    And I get access token by user credentials:   ${zed_admin.email_de}
    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    # make warehouse active [warehouse = Spryker Mer 000001 Warehouse 1]
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id    

# Create_order_in_Glue
#     [Tags]    glue
#     # create a GLUE order
#     And I get access token for the customer:    ${yves_second_user.email}
#     Then I set Headers:    Authorization=${token}
#     Then Cleanup all customer carts
#     Then I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
#     Then Response status code should be:    201
#     Then Save value to a variable:    [data][id]    cart_id
#     And I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "091_25873091","quantity": 1}}}
#     And I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"093_24495843","quantity":1,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"09.09.2050"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":1,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","093_24495843"]}}}
#     Then Response status code should be:    200
#     When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","093_24495843"]}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
#     And Save value to a variable:    [included][0][attributes][items][1][uuid]    uuid1
#     And Update order status in Database:    waiting    ${uuid} 
#     And Update order status in Database:    waiting    ${uuid1} 
    # Trigger oms
    # And Update order status in Database:    picking list generation scheduled    ${uuid}
    # Trigger oms
    # And Update order status in Database:    picking list generation started    ${uuid}
    # Trigger oms  
    # And Update order status in Database:    ready for picking    ${uuid}
    # Trigger oms

# Change_OMS_States
#     [Setup]    Run Keywords    common.SuiteSetup    AND    common.TestSetup
#     Zed: login on Zed with provided credentials:    ${zed_admin.email}
#     Zed: go to order page:    ${lastPlacedOrder}
#     Zed: click Action Button in a table for row that contains:    $row_content    $zed_table_action_button_locator
#     Wait Until Element Is Visible    $locator
#     Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay


# Bapi_move_throe_picking_process
#     [Tags]    bapi
#     Then I get access token by user credentials:   ${zed_admin.email_de}
#     And I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
# #     # Check that picking lists created
#     And I send a GET request:    /picking-lists/?include=picking-list-items,concrete-products,sales-shipments,sales-orders
#     Then Save value to a variable:    [data][id]    cart_id

#     # Go to DB and choose last picking list, save uuid to variable picklist
#     Then I send a POST request:   /picking-lists/${picklist}/start-picking    {"data":[]}
#     Then I send a PATCH request:    /picking-lists/${picklist}/picking-list-items    {"data":[{"id":"${item1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":0}}]}
#     # check that status of picking list = started
#     Then I send a PATCH request:    /picking-lists/${picklist}/picking-list-items    {"data":[{"id":"${item1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":1}}]}
#     # check that status of picking list = finished
#     #  check status in BO and finish an order


# **********

# *** Settings ***
# Suite Setup       common_api.SuiteSetup
# Test Setup        common_api.TestSetup
# Resource    ../../../../../../resources/common/common_api.robot
# Resource    ../../../../../resources/steps/service_point_steps.robot
# Resource     ../../../../../resources/common/common.robot
# Resource    ../../../../../resources/common/common_zed.robot
# Resource    ../../../../../resources/steps/orders_management_steps.robot
# Default Tags    bapi


# *** Test Cases ***
# ENABLER
#     common_api.TestSetup

# Assign_user_to_active_warehouse
#     [Tags]    bapi
#     [Setup]    Run Keywords    common_api.SuiteSetup    AND    common_api.TestSetup    
#     And I get access token by user credentials:   ${zed_admin.email}
#     I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     # make warehouse active [warehouse = Spryker Mer 000001 Warehouse 1]
#     When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"true"}}}
#     Then Response status code should be:    201
#     Then Save value to a variable:    [data][id]   warehouse_assigment_id    

# Create_order_in_Glue
#     [Tags]    glue
#     # create a GLUE order
#     And I get access token for the customer:    ${yves_second_user.email}
#     Then I set Headers:    Authorization=${token}
#     Then Cleanup all customer carts
#     Then I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
#     Then Response status code should be:    201
#     Then Save value to a variable:    [data][id]    cart_id
#     And I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "091_25873091","quantity": 1}}}
#     And I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"093_24495843","quantity":1,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"09.09.2050"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":1,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","093_24495843"]}}}
#     Then Response status code should be:    200
#     When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","093_24495843"]}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
#     And Update order status in Database:    waiting    ${uuid} 
#     Trigger oms
#     And Update order status in Database:    picking list generation scheduled    ${uuid}
#     Trigger oms
#     And Update order status in Database:    picking list generation started    ${uuid}
#     Trigger oms  
#     And Update order status in Database:    ready for picking    ${uuid}
#     Trigger oms


# # Change_OMS_States
# #     [Setup]    Run Keywords    common.SuiteSetup    AND    common.TestSetup  
# #     Zed: login on Zed with provided credentials:    ${zed_admin.email}
# #     Zed: go to order page:    ${lastPlacedOrder}
# #     Zed: click Action Button in a table for row that contains:    $row_content    $zed_table_action_button_locator
# #     Wait Until Element Is Visible    $locator
# #     Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
# #     Trigger oms
# #     Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Skip timeout
# #     Trigger oms
# #     Zed: trigger matching state of xxx order item inside xxx shipment:    Ship    2
# #     Trigger oms
# #     Zed: trigger matching state of xxx order item inside xxx shipment:    Stock update    2


# Bapi_move_throe_picking_process
#     [Tags]    bapi
#     Then I get access token by user credentials:   ${zed_admin.email}
#     And I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
# #     # Check that picking lists created
#     And I send a GET request:    /picking-lists/
# #     Then Save value to a variable:    [data][id]    cart_id

# #     # Go to DB and choose last picking list, save uuid to variable picklist
# #     Then I send a POST request:   /picking-lists/${picklist}/start-picking    {"data":[]}
# #     Then I send a PATCH request:    /picking-lists/${picklist}/picking-list-items    {"data":[{"id":"${item1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":0}}]}
# #     # check that status of picking list = started
# #     Then I send a PATCH request:    /picking-lists/${picklist}/picking-list-items    {"data":[{"id":"${item1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":1}}]}
# #     # check that status of picking list = finished
# #     #  check status in BO and finish an order