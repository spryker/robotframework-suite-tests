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
Retrieve_push_notification_provider
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a GET request:    /push-notification-providers
    Then Response status code should be:    200
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Save value to a variable:    [data][0][id]    push_notification_provider_id
    And Response body parameter should be:    [data][0][type]    push-notification-providers
    And Response body parameter should not be EMPTY:    [data][0][attributes][name]   
    # And Response body has correct self link:    https://glue-backend.de.spryker.local/push-notification-providers
    And Response body has correct self link for created entity:    ${push_notification_provider_id}
    [Teardown]    # No teardown needed as we are not creating a new entity

Create_push_notification_provider
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    Then Response status code should be:    201
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    push_notification_provider_id
    And Response body parameter should be:    [data][type]    push-notification-providers
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    # And Response body has correct self link for created entity:    ${push_notification_provider_id}
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

Update_push_notification_provider
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a PATCH request:    /push-notification-providers/${push_notification_provider_id}    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider Updated ${random}"}}}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][type]    push-notification-providers
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body has correct self link for created entity:    ${push_notification_provider_id}
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

Retrieve_push_notification_provider_by_id
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a GET request:    /push-notification-providers/${push_notification_provider_id}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][type]    push-notification-providers
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body has correct self link for created entity:    ${push_notification_provider_id}
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}
