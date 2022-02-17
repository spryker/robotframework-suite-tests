*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Request_company_role_by_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /company-roles/${company_role_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    company-roles
    And Response body parameter should be:    [data][id]    ${company_role_id}
    And Response body parameter should be:    [data][attributes][name]    Admin
    And Response should contain the array of a certain size:    [data][attributes]  2  

