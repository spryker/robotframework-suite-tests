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
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized

Create_shipment_type_with_incorrect_token
    [Setup]    I set Headers:    Authorization=wrong_token
    When I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "incorrect_token${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    403
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


Update_sipment_type_without_token
    When I send a PATCH request:    /shipment-types/${shipment_type.uuid}
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}} 
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized

Update_sipment_type_with_incorrect_token
    [Setup]    I set Headers:    Authorization=wrong_token
    When I send a PATCH request:    /shipment-types/${shipment_type.uuid}
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}} 
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized

Update_sipment_type_without_key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}  
    When I send a PATCH request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}} 
    Then Response status code should be:    400
    And Response reason should be:    Bad Request

Update_sipment_type_with_not_existing_key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}  
    When I send a PATCH request:    /shipment-types/not-existing-key
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}} 
    Then Response status code should be:    400
    And Response reason should be:    Bad Request

Retrive_single_shipment_type_without_auth
    When I send a GET request:    /shipment-types/${shipment_type.uuid}
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized

Retrive_single_shipment_type_with_incorrect_token
    [Setup]    I set Headers:    Authorization=wrong_token
    When I send a GET request:    /shipment-types/${shipment_type.uuid}
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized    

Retrive_single_shipment_type_with_incorrect_id
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a GET request:    /shipment-types/incorrect_id
    Then Response status code should be:    400
    And Response reason should be:    Bad Request

Retrive_list_of_shipment_types_without_auth
    When I send a GET request:    /shipment-types/
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized

Retrive_list_of_shipment_types_witt_incorrect_token
    [Setup]    I set Headers:    Authorization=wrong_token
    When I send a GET request:    /shipment-types/${shipment_type.uuid}
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized    