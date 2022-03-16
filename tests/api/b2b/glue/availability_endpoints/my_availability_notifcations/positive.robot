*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***



#GET requests
Get_my_availability_notifications
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    When I set Headers:     Authorization=${token}
    Then I send a GET request:    /my-availability-notifications
    Then Response status code should be:    200
    And Response reason should be:    OK
    Log:    ${token}