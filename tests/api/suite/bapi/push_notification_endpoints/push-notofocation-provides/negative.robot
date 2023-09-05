
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
Retrieve Push Notification Providers Without Authorization
    [Setup]    I set Headers:    Content-Type=application/vnd.api+json   Authorization=
    When I send a GET request:    /push-notification-providers
    Then Response status code should be:    403
    And Response should return error message:    Forbidden

*** Test Cases ***
Retrieve Non-Existent Push Notification Provider
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a GET request:    /push-notification-providers/non-existent-id
    Then Response status code should be:    404
    And Response should return error message:    Not found

Create Push Notification Provider Without Name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {}}}
    Then Response status code should be:    400
    And Response should return error message:    Validation issues during the creation

Create Push Notification Provider Without Authorization
    [Setup]    I set Headers:    Content-Type=application/vnd.api+json   Authorization=
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "Unauthorized Push Notification Provider"}}}
    Then Response status code should be:    403
    And Response should return error message:    Forbidden

Create Push Notification Provider with Invalid Type
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "invalid-type","attributes": {"name": "Invalid Type Push Notification Provider"}}}
    Then Response status code should be:    400
    And Response should return error message:    Validation issues during the creation

Update Push Notification Provider Without Name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a PATCH request:    /push-notification-providers/${push_notification_provider_id}    {"data": {"type": "push-notification-providers","attributes": {}}}
    Then Response status code should be:    400
    And Response should return error message:    Validation issues during the update
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

Update Push Notification Provider Without Authorization
    [Setup]    Run Keywords    I set Headers:    Content-Type=application/vnd.api+json   Authorization=
    ...    AND    I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "Unauthorized Push Notification Provider"}}}
    ...    AND    Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a PATCH request:    /push-notification-providers/${push_notification_provider_id}    {"data": {"type": "push-notification-providers","attributes": {"name": "Unauthorized Push Notification Provider Updated"}}}
    Then Response status code should be:    403
    And Response should return error message:    Forbidden
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

Update Non-Existent Push Notification Provider
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a PATCH request:    /push-notification-providers/non-existent-uuid    {"data": {"type": "push-notification-providers","attributes": {"name": "Non-Existent Push Notification Provider Updated"}}}
    Then Response status code should be:    404
    And Response should return error message:    Not found

Retrieve Push Notification Provider Without Authorization
    [Setup]    Run Keywords    I set Headers:    Content-Type=application/vnd.api+json   Authorization=
    ...    AND    I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "Unauthorized Push Notification Provider"}}}
    ...    AND    Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a GET request:    /push-notification-providers/${push_notification_provider_id}
    Then Response status code should be:    403
    And Response should return error message:    Forbidden
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

Retrieve Non-Existent Push Notification Provider
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a GET request:    /push-notification-providers/non-existent-uuid
    Then Response status code should be:    404
    And Response should return error message:    Not found
