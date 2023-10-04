
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
# !!!!
Retrieve_push_notification_providers_with_incorrect_token
   [Documentation]    expected 401, but receive 400
#    [Tags]    skip-due-to-issue
    When I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer incorrect_token
    When I send a GET request:    /push-notification-providers
    Then Response status code should be:    400
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
# !!!!
Retrieve_non-existent_push_notification_provider
   [Documentation]    expected 404, but receive 400 error for not found
#    [Tags]    skip-due-to-issue
   [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a GET request:    /push-notification-providers/non-existent-id
    Then Response status code should be:    404
    And Response should return error code:    5001
    And Response should return error message:    Push notification provider is not found.

Create_push_notification_provider_without_name
   [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
   ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
   When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {}}}
   Then Response status code should be:    400
   And Response should return error code:    5400
   And Response should return error message:    Wrong request body.

Create_push_notification_provider_without_authorization
  [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
  [Tags]    skip-due-to-issue
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "Unauthorized Push Notification Provider"}}}
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Create_push_notification_provider_with_invalid_type
    [Documentation]    https://spryker.atlassian.net/browse/FRW-6312
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "invalid-type","attributes": {"name": "Invalid Type Push Notification Provider"}}}
    Then Response status code should be:    400
    And Response should return error message:    Validation issues during the creation

Create_two_push_notification_providers_with_same_name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id
    Then Response status code should be:    201
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id_2
    Then Response status code should be:    400
    And Response should return error code:    5008
    And Response should return error message:    A push notification provider with the same name already exists.
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}
    
Create_push_notification_provider_with_256_characters_in_the_name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "testProviderNamesadkjhsjkdhsjkdsjdsjdjsdfsdbshajdbshdhsdsadbfsadhjfsajdfhbwehfdnmsabdfmsbdafnmbsadfnmasbdfnabfnasbdfnasdbfsndafbsnadfbsnfbsnfbsndfbsnafbsanfbsanfmbasnfabsfnabsfnas fnceaschgewahcaehewdhdbsadbcashdcdsacsedfseffsfdfedrfreferfferferferferfrfer"}}}
    Then Response status code should be:    400
    And Response should return error code:    5007
    And Response should return error message:    A push notification provider name must have length from 1 to 255 characters.
    
Update_push_notification_provider_without_name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a PATCH request:    /push-notification-providers/${push_notification_provider_id}    {"data": {"type": "push-notification-providers","attributes": {}}}
    Then Response status code should be:    400
    And Response should return error code:    5400
    And Response should return error message:    Wrong request body.
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

Update_push_notification_provider_with_incorrect_auth
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I set Headers:    Content-Type=application/vnd.api+json   Authorization=invalid
    ...    AND    I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "Unauthorized Push Notification Provider"}}}
    ...    AND    Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a PATCH request:    /push-notification-providers/${push_notification_provider_id}    {"data": {"type": "push-notification-providers","attributes": {"name": "Unauthorized Push Notification Provider Updated"}}}
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

# !!!!!!!
Update_non-existent_push_notification_provider
    [Documentation]    expected 404, but receive 400 error for not found
    # [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a PATCH request:    /push-notification-providers/non-existent-uuid    {"data": {"type": "push-notification-providers","attributes": {"name": "Non-Existent Push Notification Provider Updated"}}}
    Then Response status code should be:    404
    And Response should return error code:    5001
    And Response should return error message:    Push notification provider is not found.

 Update_push_notification_provider_with_existing_name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "Provider1 ${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id
    Then Response status code should be:    201
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "Provider2 ${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id_2
    When I send a PATCH request:    /push-notification-providers/${push_notification_provider_id_2}  {"data": {"type": "push-notification-providers","attributes": {"name": "Provider1 ${random}"}}}
    Then Response status code should be:    400
    And Response should return error code:    5008
    And Response should return error message:    A push notification provider with the same name already exists.
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}   

Delete_push_notification_provider_with_not_exist_id
    Then I send a DELETE request:    /push-notification-providers/invalid
    Then Response status code should be:    404
