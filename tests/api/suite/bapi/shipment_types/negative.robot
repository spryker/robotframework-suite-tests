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
    And Response should return error code:    55020
    And Response should return error message:    "Unknown error."

Create_shipment_type_with_empty_body
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token} 
    When I send a POST request:    /shipment-types    {}
    Then Response status code should be:    400
    And Response should return error code:    55020
    And Response should return error message:    "Unknown error."

Create_shipment_type_with_empty_token
    [Setup]    I set Headers:    Authorization=
    When I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "empty_token${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Create_shipment_type_with_incorrect_token
    [Setup]    I set Headers:    Authorization=wrong_token
    When I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "incorrect_token${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Create_shipment_type_without_key_in_request
    [Documentation]    FRW-1597: Attribute validation in Glue Requests
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token} 
    When I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response should return error code:    5502
    And Response should return error message:    "A delivery type key required field".

Create_shipment_type_with_empty_key_in_request
    [Documentation]    FRW-1597: Attribute validation in Glue Requests
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token} 
    When I send a POST request:    /shipment-types        {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type ${random}","key": "","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response should return error code:    5502
    And Response should return error message:    "A delivery type key required field".

Create_shipment_type_with_already_used_key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token} 
    When I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "existing-shipment-type-key","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response should return error code:    5502
    And Response should return error message:    A delivery type with the same key already exists.

Update_sipment_type_without_token
    When I send a PATCH request:    /shipment-types/${shipment_type.uuid}
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}} 
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Update_sipment_type_with_incorrect_token
    [Setup]    I set Headers:    Authorization=wrong_token
    When I send a PATCH request:    /shipment-types/${shipment_type.uuid}
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}} 
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Update_sipment_type_without_key
    [Documentation]    FRW-1597: Attribute validation in Glue Requests
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}  
    When I send a PATCH request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}} 
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    A delivery type entity was not found.

Update_sipment_type_with_empty_key
    [Documentation]    FRW-1597: Attribute validation in Glue Requests
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}  
    When I send a PATCH request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "name${random}","key": "","isActive": "true","stores": ["DE"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    A delivery type entity was not found.

Update_sipment_type_with_not_existing_key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}  
    When I send a PATCH request:    /shipment-types/not-existing-key
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}} 
    Then Response status code should be:    404
    And Response should return error code:    5501
    And Response should return error message:    "Unknown error."

Retrive_single_shipment_type_without_auth
    When I send a GET request:    /shipment-types/${shipment_type.uuid}
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Retrive_single_shipment_type_with_incorrect_token
    [Setup]    I set Headers:    Authorization=wrong_token
    When I send a GET request:    /shipment-types/${shipment_type.uuid}
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized 
    And Response should return error message:    Invalid access token.   

Retrive_single_shipment_type_with_incorrect_id
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a GET request:    /shipment-types/incorrect_id
    Then Response status code should be:    404
    And Response should return error message:    "A delivery type entity was not found."

Retrive_list_of_shipment_types_without_auth
    When I send a GET request:    /shipment-types/
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Retrive_list_of_shipment_types_witt_incorrect_token
    [Setup]    I set Headers:    Authorization=wrong_token
    When I send a GET request:    /shipment-types/${shipment_type.uuid}
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.    