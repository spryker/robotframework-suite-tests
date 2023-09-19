*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/push_notifications_steps.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
   TestSetup

*** Test Cases ***
Create_push_notification_provider
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    Then Response status code should be:    201
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    push_notification_provider_id
    And Response body parameter should be:    [data][type]    push-notification-providers
    And Response body parameter should not be EMPTY:    [data][attributes][uuid]
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should be:    [data][attributes][name]    My Push Notification Provider ${random}
    And Response body has correct self link for created entity:    ${push_notification_provider_id}
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

Update_push_notification_provider
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a PATCH request:    /push-notification-providers/${push_notification_provider_id}    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider Updated ${random}"}}}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][type]    push-notification-providers
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should not be EMPTY:    [data][attributes][uuid]
    And Response body parameter should be:    [data][attributes][name]    My Push Notification Provider Updated ${random}
    And Response body has correct self link internal
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

Retrieve_push_notification_provider
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider1 ${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider2 ${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id_2
    When I send a GET request:    /push-notification-providers
    Then Response status code should be:    200
    And Response should contain the array larger than a certain size:    [data]    1
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should not be EMPTY:    [data][1][id]
    And Response body parameter should be:    [data][0][type]    push-notification-providers
    And Response body parameter should be:    [data][1][type]    push-notification-providers
    And Each array in response should contain property with NOT EMPTY value:    [data]    [attributes][name]
    And Each array in response should contain property with NOT EMPTY value:    [data]    [attributes][uuid]
    [Teardown]     Run Keywords    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}
    ...    AND    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id_2}
    
Retrieve_push_notification_provider_with_pagination
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider1 ${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider2 ${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id_2
    When I send a GET request:    /push-notification-providers?page[offset]=0&page[limit]=1
    Then Response status code should be:    200
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should be:    [data][0][type]    push-notification-providers
    And Response body parameter should not be EMPTY:    [data][0][attributes][uuid]
    And Response body parameter should not be EMPTY:    [data][0][attributes][name]
    And Response body parameter should be:    [data][0][attributes][name]    My Push Notification Provider1 ${random}
    [Teardown]     Run Keywords    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}
    ...    AND    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id_2}

Retrieve_push_notification_provider_by_id
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a GET request:    /push-notification-providers/${push_notification_provider_id}
    Then Response status code should be:    200
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    push_notification_provider_id
    And Response body parameter should be:    [data][type]    push-notification-providers
    And Response body parameter should not be EMPTY:    [data][attributes][uuid]
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should be:    [data][attributes][name]    My Push Notification Provider ${random}
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}
