*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/service_point_steps.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup
*** Test Cases ***

# Create_Service_Point_Address
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][attributes][key]    service_point_key
#     And Save value to a variable:    [data][id]    service_point_id
#     When I send a POST request:    /service-points/${service_point_id}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"address1":"Park Avenue","address2":"Building №22","city":"Dreamtown","zipCode":"30-221","countryIso2Code":"DE"}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][id]    service_point_address_id
#     And Response body parameter should be:    [data][type]    service-point-addresses
#     And Response body parameter should be:    [data][attributes][countryIso2Code]    DE
#     And Response body parameter should be:    [data][attributes][address1]    Park Avenue
#     And Response body parameter should be:    [data][attributes][address2]    Building №22
#     And Response body parameter should be:    [data][attributes][zipCode]    30-221
#     And Response body parameter should be:    [data][attributes][city]    Dreamtown
#     And Response body has correct self link for created entity:    ${service_point_address_id}
#     # [Teardown]    Run Keywords    Get service point uuid by key:    ${service_point_key}
#     # ...    AND    Delete service point in DB    ${servicePointUuid}
#     # ...    AND    Delete service point address in DB    ${service_point_address_id}

# Create_Service_Point_Address_with_address_3
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][attributes][key]    service_point_key
#     And Save value to a variable:    [data][id]    service_point_id
#     When I send a POST request:    /service-points/${service_point_id}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"address1":"Park Avenue","address2":"Building №2","address3":"address3","city":"Dreamtown","zipCode":"30-221","countryIso2Code":"DE"}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][id]    service_point_address_id
#     And Response body parameter should be:    [data][attributes][address3]    address3
# #     [Teardown]    Run Keywords    Get service point uuid by key:    ${service_point_key}
# #     ...    AND    Delete service point in DB    ${servicePointUuid}
# #     ...    AND    Delete service point address in DB    ${service_point_address_id}

# Create_Service_Point_Address_with_region_uuid
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][attributes][key]    service_point_key
#     And Save value to a variable:    [data][id]    service_point_id
#     And Create reagion in DB:    60    DE    Germany    123456789
#     When I send a POST request:    /service-points/${service_point_id}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"regionUuid":"123456789","address1":"Park Avenue","address2":"Building №2","address3":"address3","city":"Dreamtown","zipCode":"30-221","countryIso2Code":"DE"}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][id]    service_point_address_id
#     And Response body parameter should be:    [data][attributes][regionUuid]    123456789
# #     [Teardown]    Run Keywords    Get service point uuid by key:    ${service_point_key}
# #     ...    AND    Delete service point in DB    ${servicePointUuid}
# #     ...    AND    Delete service point address in DB    ${service_point_address_id}