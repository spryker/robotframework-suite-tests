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

Create_Service_Point_Address_Without_Authentication
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=
    When I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"address1":"Park Avenue","address2":"Building №2","address3":"address3","city":"Dreamtown","zipCode":"30-221","countryIso2Code":"DE"}}}
    Then Response status code should be:    403
    And Response should return error message:    Invalid access token

# Create_Service_Point_Address_With_Incorrect_Token
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#      ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=IncorrectToken
#     When I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"address1":"Park Avenue","address2":"Building №2","address3":"address3","city":"Dreamtown","zipCode":"30-221","countryIso2Code":"DE"}}}
#     Then Response status code should be:    403
#     And Response should return error code:    5402
#     And Response should return error message:    Authorization failed.

# Create_Duplicate_Service_Point_Address
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][attributes][key]    service_point_key
#     And Save value to a variable:    [data][id]    service_point_id
#     When I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"address1":"Park Avenue","address2":"Building №2","address3":"address3","city":"Dreamtown","zipCode":"30-221","countryIso2Code":"DE"}}}
#     Then Response status code should be:    201
#     And I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"address1":"Park Avenue","address2":"Building №2","address3":"address3","city":"Dreamtown","zipCode":"30-221","countryIso2Code":"DE"}}}
#     Then Response status code should be:    400
#     And Response should return error code:    5417
#     And Response should return error message:    A service point address for the service point already exists.
#    [Teardown]    Run Keywords    Get service point uuid by key:    ${service_point_key}
#      ...    AND    Delete service point in DB    ${servicePointUuid}
#      ...    AND    Delete service point address in DB    ${service_point_address_id}

# Create_Service_Point_Address_With_Invalid_Address
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-addresses    {"data": {"type": "service-point-addresses", "attributes": {"regionUuid": "${region_uuid}", "countryIso2Code": "DE", "address": "Park Avenue", "address2": "Building №2", "zipCode": "30-221", "city": "Dreamtown"}}}
#     Then Response status code should be:    400
#     And Response should return error code:    5411
#     And Response should return error message:    A service point address address1 must have length from %min% to %max% characters.
#     [Teardown]    Run Keywords    Get service point uuid by key:    ${service_point_key}
#      ...    AND    Delete service point in DB    ${servicePointUuid}
#      ...    AND    Delete service point address in DB    ${service_point_address_id}

# Create_Service_Point_address_without_address
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points/${servicePoints_uuid}/service-point-addresses    {"data": {"type": "service-point-addresses", "attributes": {"regionUuid": "${region_uuid}", "countryIso2Code": "DE", "address2": "Building №2", "zipCode": "30-221", "city": "Dreamtown"}}}
#     Then Response status code should be:    400
    
# Create_Service_Point_address_with_empty_address
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-addresses    {"data": {"type": "service-point-addresses", "attributes": {"regionUuid": "${region_uuid}", "countryIso2Code": "DE", "address":"", "address2": "Building №2", "zipCode": "30-221", "city": "Dreamtown"}}}
#     Then Response status code should be:    400

# Create_Service_Point_address_with_not_existing_region
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][attributes][key]    service_point_key
#     And Save value to a variable:    [data][id]    service_point_id
#     When I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-addresses    {"data": {"type": "service-point-addresses", "attributes": {"regionUuid": "not-existing-rigion-uuid", "countryIso2Code": "DE", "address":"", "address2": "Building №2", "zipCode": "30-221", "city": "Dreamtown"}}}
#     Then Response status code should be:    400

# Create_Service_Point_address_with_not_existing_country
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-addresses    {"data": {"type": "service-point-addresses", "attributes": {"regionUuid": "${region_uuid}", "countryIso2Code": "NOTEXIST", "address":"", "address2": "Building №2", "zipCode": "30-221", "city": "Dreamtown"}}}
#     Then Response status code should be:    400

#  Create_Service_Point_address_with_zip_more_than_15
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-addresses    {"data": {"type": "service-point-addresses", "attributes": {"regionUuid": "${region_uuid}", "countryIso2Code": "DE", "address":"", "address2": "Building №2", "zipCode": "30-22111111111112", "city": "Dreamtown"}}}
#     Then Response status code should be:    400
