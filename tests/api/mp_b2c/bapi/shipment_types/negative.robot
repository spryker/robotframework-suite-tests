*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/shipment_type_steps.robot
Test Tags    bapi

*** Test Cases ***
*** Test Cases ***
Create_shipment_type_with_incorrect_type_in_body
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5845
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /shipment-types    {"data": {"type": "incorrect-type","attributes": {"name": "Some Shipment Type","key": "wrong-type${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response should return error code:    55020
    And Response should return error message:    Unknown error.

Create_shipment_type_with_empty_body
    [Documentation]    https://spryker.atlassian.net/browse/CC-29310
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /shipment-types    {}
    Then Response status code should be:    400
    And Response should return error code:    55020
    And Response should return error message:    Unknown error.

Create_shipment_type_with_empty_token
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    Authorization=
    When I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "empty_token${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.

Create_shipment_type_with_incorrect_token
    [Setup]    I set Headers:    Authorization=wrong_token
    When I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "incorrect_token${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden

Create_shipment_type_without_key_in_request
    [Documentation]    https://spryker.atlassian.net/browse/CC-32473 Attribute validation in Glue Requests
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response should return error code:    5501
    And Response should return error message:    A delivery type entity was not found.

Create_shipment_type_with_empty_key_in_request
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /shipment-types        {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type ${random}","key": "","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response should return error code:    5503
    And Response should return error message:    A delivery type key must have a length from 1 to 255 characters.

Create_shipment_type_with_already_used_key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "existing-shipment-type-key","isActive": "true","stores": ["DE", "AT"]}}}
    When I send a POST request:    /shipment-types    {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type","key": "existing-shipment-type-key","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response should return error code:    5502
    And Response should return error message:    A delivery type with the same key already exists.
    [Teardown]     Delete shipment type in DB:    existing-shipment-type-key

Update_shipment_type_without_token
    I set Headers:    Content-Type=${default_header_content_type}
    When I send a PATCH request:    /shipment-types/${shipment_type_uuid}
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}} 
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized request.

Update_shipment_type_with_incorrect_token
    [Setup]    I set Headers:    Authorization=wrong_token
    When I send a PATCH request:    /shipment-types/${shipment_type_uuid}
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}} 
     Then Response status code should be:    403
     And Response reason should be:    Forbidden

Update_shipment_type_without_key
    [Documentation]    https://spryker.atlassian.net/browse/CC-29310 Attribute validation in Glue Requests
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a PATCH request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}} 
    Then Response status code should be:    404
    And Response should return error code:    5501
    And Response should return error message:    A delivery type entity was not found.

Update_shipment_type_with_empty_key
    [Documentation]    https://spryker.atlassian.net/browse/CC-32473 Attribute validation in Glue Requests
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a PATCH request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "name${random}","key": "","isActive": "true","stores": ["DE"]}}}
    Then Response status code should be:    404
    And Response should return error code:    5501
    And Response should return error message:    A delivery type entity was not found.

Update_sipment_type_with_not_existing_key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a PATCH request:    /shipment-types/not-existing-key
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}} 
    Then Response status code should be:    404
    And Response should return error code:    5501
    And Response should return error message:    A delivery type entity was not found.

Retrieve_single_shipment_type_without_auth
    When I set Headers:    Content-Type=${default_header_content_type}
    And I send a GET request:    /shipment-types/${shipment_type_uuid}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized request.

Retrieve_single_shipment_type_with_incorrect_token
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    Authorization=wrong_token
    When I send a GET request:    /shipment-types/${shipment_type_uuid}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden

Retrieve_single_shipment_type_with_incorrect_id
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /shipment-types/incorrect_id
    Then Response status code should be:    404
    And Response should return error code:    5501
    And Response should return error message:    A delivery type entity was not found.

Retrieve_list_of_shipment_types_without_auth
    I set Headers:    Content-Type=${default_header_content_type}
    When I send a GET request:    /shipment-types/
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized request.

Retrieve_list_of_shipment_types_witt_incorrect_token
    [Setup]    I set Headers:    Authorization=wrong_token
    When I send a GET request:    /shipment-types/${shipment_type_uuid}
     Then Response status code should be:    403
     And Response reason should be:    Forbidden