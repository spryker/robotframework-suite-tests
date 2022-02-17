*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Request_business_unit_by_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /company-business-units/${busines_unit_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    company-business-units
    And Response body parameter should be:    [data][id]    ${busines_unit_id}
    And Response body parameter should be:    [data][attributes][name]    ${busines_unit_name}
    And Response should contain the array of a certain size:    [data][attributes]  7  

