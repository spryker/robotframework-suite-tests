*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Default Tags    glue

*** Test Cases ***
ENABLER
    API_test_setup

Access_restricted_resource_as_not_authorized_customer
    I send a GET request:    /wishlists
    Response status code should be:    403
    And Response reason should be:    Forbidden
