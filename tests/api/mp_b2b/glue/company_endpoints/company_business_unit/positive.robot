*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue

*** Test Cases ***
Request_business_unit_by_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /company-business-units/mine
    ...    AND    Save value to a variable:    [data][0][id]    business_unit_id   
    When I send a GET request:    /company-business-units/${business_unit_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    company-business-units
    And Response body parameter should not be EMPTY:    [data][id]
    And Response should contain the array of a certain size:    [data][attributes]  7
    And Response body parameter should be:    [data][attributes][defaultBillingAddress]    None
    And Response body parameter should be:    [data][attributes][name]    ${business_unit.name}
    And Response body parameter should not be EMPTY:    [data][attributes][email]
    And Response body parameter should not be EMPTY:    [data][attributes][phone]
    And Response body parameter should contain:   [data][attributes]    externalUrl
    And Response body parameter should contain:   [data][attributes]    bic
    And Response body parameter should contain:   [data][attributes]    iban
    And Response body has correct self link internal

Request_business_unit_by_mine
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /company-business-units/mine
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    company-business-units
    And Response body parameter should not be EMPTY:    [data][0][id]  
    And Response should contain the array of a certain size:    [data][0][attributes]  7
    And Response body parameter should be:    [data][0][attributes][defaultBillingAddress]    None
    And Response body parameter should be:    [data][0][attributes][name]    ${business_unit.name}
    And Response body parameter should not be EMPTY:    [data][0][attributes][email]
    And Response body parameter should not be EMPTY:    [data][0][attributes][phone]
    And Response body parameter should contain:   [data][0][attributes]    externalUrl
    And Response body parameter should contain:   [data][0][attributes]    bic
    And Response body parameter should contain:   [data][0][attributes]    iban
    And Response body has correct self link

Request_business_unit_by_id_with_include_address_and_company
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /company-business-units/mine
    ...    AND    Save value to a variable:    [data][0][id]    business_unit_id  
    When I send a GET request:    /company-business-units/${business_unit_id}?include=company-business-unit-addresses,companies
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    company-business-units
    And Response body parameter should be:    [data][id]    ${business_unit_id}
    And Response should contain the array of a certain size:    [data][attributes]  7
    And Response body parameter should be:    [data][attributes][defaultBillingAddress]    None
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should not be EMPTY:    [data][attributes][email]
    And Response body parameter should not be EMPTY:    [data][attributes][phone]
    And Response body parameter should contain:   [data][attributes]    externalUrl
    And Response body parameter should contain:   [data][attributes]    bic
    And Response body parameter should contain:   [data][attributes]    iban
    And Response should contain the array of a certain size:    [data][relationships]  2
    And Response body parameter should contain:    [data]    relationships
    And Response body parameter should contain:    [data][relationships][companies][data][0][type]   companies
    And Response body parameter should not be EMPTY:    [data][relationships][companies][data][0][id]
    And Response should contain the array of a certain size:    [data][relationships][company-business-unit-addresses]    1
    And Response body parameter should contain:    [data][relationships]    company-business-unit-addresses
    And Response body parameter should contain:    [data][relationships][company-business-unit-addresses][data][0][type]    company-business-unit-addresses
    And Response body parameter should not be EMPTY:    [data][relationships][company-business-unit-addresses][data][0][id]
    And Response should contain the array of a certain size:    [included]  2
    And Response include should contain certain entity type:    companies
    And Response include should contain certain entity type:    company-business-unit-addresses
    And Response body parameter should not be EMPTY:    [included][0][id]
    And Response body parameter should not be EMPTY:    [included][1][id]
    And Each array element of array in response should contain property:    [included]    attributes
    And Response body parameter should not be EMPTY:    [included][0][attributes][isActive]
    And Response body parameter should not be EMPTY:    [included][0][attributes][name]
    And Response body parameter should not be EMPTY:    [included][0][attributes][status]
    And Response body parameter should not be EMPTY:    [included][1][attributes][address1]
    And Response body parameter should not be EMPTY:    [included][1][attributes][address2]
    And Response body parameter should contain:     [included][1][attributes]    address3
    And Response body parameter should not be EMPTY:    [included][1][attributes][zipCode]
    And Response body parameter should not be EMPTY:    [included][1][attributes][city]
    And Response body parameter should not be EMPTY:    [included][1][attributes][phone]
    And Response body parameter should not be EMPTY:    [included][1][attributes][iso2Code]
    And Response body parameter should contain:     [included][1][attributes]    comment
    And Response body has correct self link internal

Request_business_unit_by_mine_include_address_and_company
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}   
    When I send a GET request:    /company-business-units/mine?include=company-business-unit-addresses,companies
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    company-business-units
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response should contain the array of a certain size:    [data][0][attributes]  7
    And Response body parameter should be:    [data][0][attributes][defaultBillingAddress]    None
    And Response body parameter should not be EMPTY:    [data][0][attributes][name]
    And Response body parameter should not be EMPTY:    [data][0][attributes][email]
    And Response body parameter should not be EMPTY:    [data][0][attributes][phone]
    And Response body parameter should contain:   [data][0][attributes]    externalUrl
    And Response body parameter should contain:   [data][0][attributes]    bic
    And Response body parameter should contain:   [data][0][attributes]    iban
    And Response should contain the array of a certain size:    [data][0][relationships]  2
    And Response body parameter should contain:    [data]    relationships
    And Response body parameter should contain:    [data][0][relationships][companies][data][0][type]   companies
    And Response body parameter should not be EMPTY:    [data][0][relationships][companies][data][0][id]
    And Response should contain the array of a certain size:    [included]  2
    And Response include should contain certain entity type:    companies
    And Response include should contain certain entity type:    company-business-unit-addresses
    And Response body parameter should not be EMPTY:    [included][0][id]
    And Response body parameter should not be EMPTY:    [included][1][id]
    And Each array element of array in response should contain property:    [included]    attributes
    And Response body parameter should not be EMPTY:    [included][0][attributes][isActive]
    And Response body parameter should not be EMPTY:    [included][0][attributes][name]
    And Response body parameter should not be EMPTY:    [included][0][attributes][status]
    And Response body parameter should not be EMPTY:    [included][1][attributes][address1]
    And Response body parameter should not be EMPTY:    [included][1][attributes][address2]
    And Response body parameter should contain:     [included][1][attributes]    address3
    And Response body parameter should not be EMPTY:    [included][1][attributes][zipCode]
    And Response body parameter should not be EMPTY:    [included][1][attributes][city]
    And Response body parameter should not be EMPTY:    [included][1][attributes][phone]
    And Response body parameter should not be EMPTY:    [included][1][attributes][iso2Code]
    And Response body parameter should contain:     [included][1][attributes]    comment
    And Response body has correct self link