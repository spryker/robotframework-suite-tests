*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Request_company_by_ID
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /companies/${company_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    companies
    And Response body parameter should be:    [data][id]    ${company_id}
    And Response body parameter should be:    [data][attributes][name]    ${company_name}
    And Response body parameter should be:    [data][attributes][status]    approved
    And Response should contain the array of a certain size:    [data][attributes]    3


Request_company_by_mine
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /companies/mine
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    companies
    And Response body parameter should be:    [data][0][id]    ${company_id}
    And Response body parameter should be:    [data][0][attributes][name]    ${company_name}
    And Response body parameter should be:    [data][0][attributes][status]    approved
    And Response should contain the array of a certain size:    [data][0][attributes]    3
    And Response body has correct self link

