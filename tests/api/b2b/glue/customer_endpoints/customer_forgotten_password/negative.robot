*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Forgot_password_wrong_email_format
    I send a POST request:
    ...    /customer-forgotten-password
    ...    {"data":{"type":"customer-forgotten-password","attributes":{"email":"123"}}}
    Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    email => This value is not a valid email address.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Forgot_password_empty_email
    I send a POST request:
    ...    /customer-forgotten-password
    ...    {"data":{"type":"customer-forgotten-password","attributes":{"email":""}}}
    Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    email => This value should not be blank.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Forgot_password_incorrect_type
    I send a POST request:
    ...    /customer-forgotten-password
    ...    {"data":{"type":"customer","attributes":{"email":"${yves_user.email}"}}}
    Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
