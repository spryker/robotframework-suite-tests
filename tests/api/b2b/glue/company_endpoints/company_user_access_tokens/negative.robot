*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup    TestSetup

*** Test Cases ***
Request_access_token_by_invalid_company_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    When I send a POST request:    /company-user-access-tokens    {"data":{"type":"company-user-access-tokens","attributes":{"idCompanyUser":"35235"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Entity
    And Response should return error code:    901
    And Response should return error message:    idCompanyUser => This is not a valid UUID.

Request_access_token_by_empty_company_id
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    When I send a POST request:    /company-user-access-tokens    {"data":{"type":"company-user-access-tokens","attributes":{"idCompanyUser":""}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Entity
    And Response should return error code:    901
    And Response should return error message:    idCompanyUser => This value should not be blank.

Request_access_token_with_invalid_type
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    When I send a POST request:    /company-user-access-tokens    {"data":{"type":"company-access-tokens","attributes":{"idCompanyUser":""}}}
   Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Request_access_token_with_empty_type
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    When I send a POST request:    /company-user-access-tokens    {"data":{"type":"","attributes":{"idCompanyUser":""}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.