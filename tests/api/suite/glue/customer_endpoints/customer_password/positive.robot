*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue

*** Test Cases ***

ENABLER
    API_test_setup

Update_customer_password_with_all_required_fields_and_valid_data
    [Setup]    Run Keywords    I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_eighth_user.email}","password":"${yves_eighth_user.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    token
    When I set Headers:    Authorization=Bearer ${token}
    AND I send a PATCH request:    /customer-password/${yves_eighth_user.reference}   {"data":{"type":"customer-password","attributes":{"password":"${yves_eighth_user.password}","newPassword":"${yves_eighth_user.password_new}","confirmPassword":"${yves_eighth_user.password_new}"}}}
    Response status code should be:    204
    And Response reason should be:    No Content
    And I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_eighth_user.email}","password":"${yves_eighth_user.password}"}}}
    Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    003
    And Response should return error message:    Failed to authenticate user.
    And I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_eighth_user.email}","password":"${yves_eighth_user.password_new}"}}}
    And Response status code should be:    201
    [Teardown]    Run Keywords    Save value to a variable:    [data][attributes][accessToken]    token
    ...    AND    I set Headers:    Authorization=Bearer ${token}
    ...    AND    I send a PATCH request:    /customer-password/${yves_eighth_user.reference}   {"data":{"type":"customer-password","attributes":{"password":"${yves_eighth_user.password_new}","newPassword":"${yves_eighth_user.password_new_additional}","confirmPassword":"${yves_eighth_user.password_new_additional}"}}}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
