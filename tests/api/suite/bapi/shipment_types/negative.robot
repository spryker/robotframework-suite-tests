*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

*** Test Cases ***
Create_shipment_type_with_incorrect_type_in_body
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token} 
    When I send a POST request:    /shipment-types    {"data": {"type": "incorrect-type","attributes": {"name": "Some Shipment Type","key": "wrong-type${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body should contain:    5501

Create_shipment_type_with_empty_body
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token} 
    When I send a POST request:    /shipment-types    {}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body should contain:    5500

Create_shipment_type_with_empty_token
    [Setup]    I set Headers:    Authorization=
    When I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "empty_token${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized

Create_shipment_type_with_incorrect_token
    [Setup]    I set Headers:    Authorization=wrong_token
    When I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "incorrect_token${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized

Create_shipment_type_without_key_in_request
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token} 
    When I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body should contain:    5502

Create_shipment_type_with_already_used_key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token} 
    When I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "existing-shipment-type-key","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body should contain:    5503
