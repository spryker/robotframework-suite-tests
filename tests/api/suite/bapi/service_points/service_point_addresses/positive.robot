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


Create_Service_Point_Address
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][attributes][key]    service_point_key
    And Save value to a variable:    [data][id]    service_point_id
    When I send a POST request:    /service-points/${service_point_id}/service-point-addresses    {"data": {"type": "service-point-addresses", "attributes": {"regionUuid": "518409fa-a5c2-4b52-8ac9-a382ebdc6084", "countryIso2Code": "DE", "address": "Park Avenue", "address2": "Building №2", "zipCode": "30-221", "city": "Dreamtown"}}}
    Then Response status code should be:    201
    And Response body parameter should be:    [data][type]    service-point-addresses
    And Response body parameter should be:    [data][attributes][regionUuid]    ${region_uuid}
    And Response body parameter should be:    [data][attributes][countryIso2Code]    DE
    And Response body parameter should be:    [data][attributes][address]    Park Avenue
    And Response body parameter should be:    [data][attributes][address2]    Building №2
    And Response body parameter should be:    [data][attributes][zipCode]    30-221
    And Response body parameter should be:    [data][attributes][city]    Dreamtown
    # [Teardown]    Run Keywords    Get service point uuid by key:    ${service_point_key}
    # ...    AND    Delete service point in DB    ${servicePointUuid}
    # ...    AND    Delete service point address in DB    ${servicePointAddressUuid}

# Create_Service_Point_Address_with_address_3
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][attributes][key]    service_point_key
#     And Save value to a variable:    [data][id]    service_point_id
#     When I send a POST request:    /service-points/${service_point_id}/service-point-addresses    {"data": {"type": "service-point-addresses", "attributes": {"regionUuid": "${region_uuid}", "countryIso2Code": "DE", "address": "Park Avenue", "address2": "Building №2","address3": "7th floor", "zipCode": "30-221", "city": "Dreamtown"}}}
#     Then Response status code should be:    201
#     And Response body parameter should be:    [data][type]    service-point-addresses
#     And Response body parameter should be:    [data][attributes][regionUuid]    ${region_uuid}
#     And Response body parameter should be:    [data][attributes][countryIso2Code]    DE
#     And Response body parameter should be:    [data][attributes][address]    Park Avenue
#     And Response body parameter should be:    [data][attributes][address2]    Building №2
#     And Response body parameter should be:    [data][attributes][address2]    7th floor
#     And Response body parameter should be:    [data][attributes][zipCode]    30-221
#     And Response body parameter should be:    [data][attributes][city]    Dreamtown
#     [Teardown]    Run Keywords    Get service point uuid by key:    ${service_point_key}
#     ...    AND    Delete service point in DB    ${servicePointUuid}
#     # ...    AND    Delete service point address in DB    ${servicePointAddressUuid}