*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Update_customer_password_with_all_required_fields_and_valid_data
    [Setup]    Run Keywords    I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_user_email}","password":"${yves_user_password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    token
    When I set Headers:    Authorization=Bearer ${token}
    AND I send a PATCH request:    /customer-password/${yves_user_reference}   {"data":{"type":"customer-password","attributes":{"password":"${yves_user_password}","newPassword":"${yves_user_password_new}","confirmPassword":"${yves_user_password_new}"}}}
    Response status code should be:    204
    And Response reason should be:    No Content
    And I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_user_email}","password":"${yves_user_password}"}}}
    Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    003
    And Response should return error message:    Failed to authenticate user.
    And I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_user_email}","password":"${yves_user_password_new}"}}}
    And Response status code should be:    201
    [Teardown]    Run Keywords    Save value to a variable:    [data][attributes][accessToken]    token
    ...    AND    I set Headers:    Authorization=Bearer ${token}
    ...    AND    I send a PATCH request:    /customer-password/${yves_user_reference}   {"data":{"type":"customer-password","attributes":{"password":"${yves_user_password_new}","newPassword":"${yves_user_password}","confirmPassword":"${yves_user_password}"}}}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content