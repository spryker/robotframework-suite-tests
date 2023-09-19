
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
Retrieve_push_notification_providers_without_authorization
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    When I send a GET request:    /push-notification-providers
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Retrieve_non-existent_push_notification_provider
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a GET request:    /push-notification-providers/non-existent-id
    Then Response status code should be:    404
    And Response should return error code:    5001
    And Response should return error message:    Push notification provider is not found.

# Create_push_notification_provider_without_name
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
#     ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
#     When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {}}}
#     Then Response status code should be:    400
#     And Response should return error message:    Validation issues during the creation

# Create_push_notification_provider_without_authorization
#     [Setup]    I set Headers:    Content-Type=application/vnd.api+json   Authorization=
#     When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "Unauthorized Push Notification Provider"}}}
#     Then Response status code should be:    403
#     And Response should return error message:    Forbidden

# Create_push_notification_provider_with_invalid_type
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
#     ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
#     When I send a POST request:    /push-notification-providers    {"data": {"type": "invalid-type","attributes": {"name": "Invalid Type Push Notification Provider"}}}
#     Then Response status code should be:    400
#     And Response should return error message:    Validation issues during the creation

# Update_push_notification_provider_without_name
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
#     ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
#     ...    AND    I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
#     ...    AND    Save value to a variable:    [data][id]    push_notification_provider_id
#     When I send a PATCH request:    /push-notification-providers/${push_notification_provider_id}    {"data": {"type": "push-notification-providers","attributes": {}}}
#     Then Response status code should be:    400
#     And Response should return error message:    Validation issues during the update
#     [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

# Update_push_notification_provider_without_authorization
#     [Setup]    Run Keywords    I set Headers:    Content-Type=application/vnd.api+json   Authorization=
#     ...    AND    I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "Unauthorized Push Notification Provider"}}}
#     ...    AND    Save value to a variable:    [data][id]    push_notification_provider_id
#     When I send a PATCH request:    /push-notification-providers/${push_notification_provider_id}    {"data": {"type": "push-notification-providers","attributes": {"name": "Unauthorized Push Notification Provider Updated"}}}
#     Then Response status code should be:    403
#     And Response should return error message:    Forbidden
#     [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

# Update_non-existent_push_notification_provider
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
#     ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
#     When I send a PATCH request:    /push-notification-providers/non-existent-uuid    {"data": {"type": "push-notification-providers","attributes": {"name": "Non-Existent Push Notification Provider Updated"}}}
#     Then Response status code should be:    404
#     And Response should return error message:    Not found

