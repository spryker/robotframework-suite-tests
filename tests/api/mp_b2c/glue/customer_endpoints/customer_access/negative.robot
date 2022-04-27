*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Access_restricted_resource_as_not_authorized_customer
    I send a GET request:    /wishlists
    Response status code should be:    403
    And Response reason should be:    Forbidden
