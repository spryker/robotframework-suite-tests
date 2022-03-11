*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Request_business_units_address_by_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    Log    ${token}
    When I send a GET request:    /company-business-unit-addresses/${busines_unit_address_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    company-business-unit-addresses
    And Response body parameter should be:    [data][id]    ${busines_unit_address_id}
    And Response should contain the array of a certain size:    [data][attributes]  8  
    And Response body parameter should be:    [data][attributes][address1]    Oderberger Str.
    And Response body parameter should be:    [data][attributes][address2]    57
    And Response body parameter should be:    [data][attributes][zipCode]    10115
    And Response body parameter should be:    [data][attributes][city]    Berlin
    And Response body parameter should be:    [data][attributes][iso2Code]    DE
    And Response body parameter should be:    [data][attributes][comment]    HQ
    And Response body parameter should contain:   [data][attributes]    address3




