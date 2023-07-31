*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

*** Test Cases ***
Negative Test - Wrong Type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:    ${base_url}${endpoint}    {"data": {"type": "incorrect-type","attributes": {"name": "Some Shipment Type","key": "some-shipment-type","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body should contain:    5501

Negative Test - Empty Body
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:    ${base_url}${endpoint}    {}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body should contain:    5500

Negative Test - Empty Token
    [Setup]    I set Headers:    Authorization=
    When I send a POST request:    ${base_url}${endpoint}    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "some-shipment-type","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized

Negative Test - Wrong Token
    [Setup]    I set Headers:    Authorization=wrong_token
    When I send a POST request:    ${base_url}${endpoint}    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "some-shipment-type","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized

Negative Test - Missing Part Of Data In Request
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:    ${base_url}${endpoint}    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body should contain:    5502

Negative Test - Use Already Used/Existing Key In The System
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:    ${base_url}${endpoint}    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "existing-shipment-type-key","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body should contain:    5503
