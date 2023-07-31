*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

*** Test Cases ***
Positive Test - Create Shipment Type
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /shipment-types   {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type ${random}","key": "some-shipment-type-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    shipment-types
    And Save value to a variable:    [data][id]    shipment_type_id
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][name]    Some Shipment Type ${random}
    And Response body parameter should be:    [data][attributes][key]    some-shipment-type-${random}
    And Response body parameter should be:    [data][attributes][isActive]    True
    And Response body parameter should be in:    [data][attributes][stores]    DE    AT
    And Response body parameter should be in:    [data][attributes][stores]    AT    DE
    And Response body has correct self link for created entity:    ${shipment_type_id}
    # [Teardown]

Create New Delivery Type With Existing Not-Unique Name and IsActive and Unique Key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /shipment-types   {"data": {"type": "shipment-types","attributes": {"name": "not_unnique_name","key": "new-shipment-type-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    # Create new shipment type with existing name
    When I send a POST request:    /shipment-types   {"data": {"type": "shipment-types","attributes": {"name": "not_unnique_name","key": "second-shipment-type-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created 
    And Response body parameter should be:    [data][type]    shipment-types
    And Save value to a variable:    [data][id]    shipment_type_id
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][name]    not_unnique_name
    And Response body parameter should be:    [data][attributes][key]    second-shipment-type-${random}
    And Response body parameter should be:    [data][attributes][isActive]    True
    And Response body parameter should be in:    [data][attributes][stores]    DE    AT
    And Response body parameter should be in:    [data][attributes][stores]    AT    DE
    And Response body has correct self link for created entity:    ${shipment_type_id}
    # [Teardown]
    
Update Delivery Type via PATCH - Change Name and Store Relation, deactivate
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}  
    When I send a POST request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "name${random}","key": "key${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    shipment_type_uuid
    # Update the Delivery Type with new attributes via PATCH request
    When I send a PATCH request:    /shipment-types/${shipment_type_uuid}
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}} 
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][attributes][name]    updated_name${random}
    And Response body parameter should be:    [data][attributes][isActive]    False
    And Response body parameter should be:    [data][attributes][stores]    AT
    And Response body has correct self link internal
    # [Teardown]

GET single Delivery Type with valid token
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type${random}","key": "shipment-key${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    delivery_type_uuid
    When I send a GET request:    /shipment-types/${delivery_type_uuid}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    shipment-types
    And Response body parameter should be:    [data][attributes][name]    shipment-type${random}
    And Response body parameter should be:    [data][attributes][key]    shipment-key${random}
    And Response body parameter should be:    [data][attributes][isActive]    True
    And Response body parameter should be in:    [data][attributes][stores]    DE    AT
    And Response body parameter should be in:    [data][attributes][stores]    AT    DE
    And Response body has correct self link internal

GET list of Delivery Types with valid token
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token} 
    # #prepare test data
    # When I send a POST request:    /shipment-types
    # ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type1${random}","key": "shipment-key1${random}","isActive": "true","stores": ["DE", "AT"]}}}
    # When I send a POST request:    /shipment-types
    # ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type2${random}","key": "shipment-key2${random}","isActive": "true","stores": ["AT"]}}}
    # When I send a POST request:    /shipment-types
    # ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type3${random}","key": "shipment-key3${random}","isActive": "true","stores": ["DE"]}}}
    #run get request
    When I send a GET request:    /shipment-types
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should be:    [data][0][type]    shipment-types
    And Response body parameter should not be EMPTY:    [data][0][attributes][name]
    And Response body parameter should not be EMPTY:    [data][0][attributes][key]
    And Response body parameter should not be EMPTY:    [data][0][attributes][isActive]
    And Response should contain the array larger than a certain size:    [data][0][attributes][stores]    0
    And Response body has correct self link
