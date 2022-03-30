*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***

Get_token_for_customer_using_invalid_grant_type
    When I set Headers:    Content-Type=${urlencoded_header_content_type}
    Then I send a POST request with data:    /token    {"grant_type": "invalid_grant_type","username": "${yves_user_email}","password": "${yves_user_password}"}
    And Response status code should be:    400
    And Response body parameter should be:    [error]    invalid_grant
    And Response body parameter should be:    [error_description]    The provided authorization grant (e.g., authorization code, resource owner credentials) or refresh token is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client.



Get_token_for_customer_usin_wrong_password
    When I set Headers:    Content-Type=${urlencoded_header_content_type}
    Then I send a POST request with data:    /token    {"grant_type": "${grant_type_password}","username": "${yves_user_email}","password": "wrong_password"}
    And Response status code should be:    400
    And Response body parameter should be:    [error]    invalid_grant
    And Response body parameter should be:    [error_description]    The user credentials were incorrect.
