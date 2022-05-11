*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    SuiteSetup
Test Setup    TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Retrieves_my_availability_notifications_without_auth_token
    When I send a GET request:    /my-availability-notifications
    Then Response status code should be:     403
    And Response reason should be:     Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Retrieves_my_availability_notifications_with_invalid_auth_token
    [Setup]    I set Headers:    Authorization=fake_token
    When I send a GET request:    /my-availability-notifications
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001 