*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Default Tags    glue
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
ENABLER
    TestSetup

Retrieve_list_of_company_users
    When I get access token for the customer:    ${yves_user_email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    12
    And Response should contain the array of a certain size:    [data][0]    4
    And Each array element of array in response should contain value:    [data]    type
    And Each array element of array in response should contain property with value:    [data]    type    company-users
    And Each array element of array in response should contain value:    [data]    id
    And Each array element of array in response should contain property with value NOT in:    [data]    [id]    None
    And Response should contain the array of a certain size:    [data][0][attributes]    2
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isActive
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isDefault
    And Each array element of array in response should contain nested property with value:    [data]    attributes.isActive    True
    And Each array element of array in response should contain nested property with value:    [data]    attributes.isDefault    False
    And Response body has correct self link

Retrieve_company_user_by_id 
    When I get access token for the customer:    ${yves_user_email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users/2816dcbd-855e-567e-b26f-4d57f3310bb8
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    4
    And Response body parameter should contain:    [data][type]    company-users
    And Response body parameter should contain:    [data][id]    2816dcbd-855e-567e-b26f-4d57f3310bb8
    And Response should contain the array of a certain size:    [data][attributes]    2
    And Response body parameter should be in:    [data][attributes][isActive]    True    False
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response body has correct self link internal

Retrieve_company_user_including_customers
    When I get access token for the customer:    ${yves_user_email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users?include=customers
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    type    company-users
    And Each array element of array in response should contain value:    [data]    id
    And Each array element of array in response should contain property with value NOT in:    [data]    [id]    None
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isActive
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isDefault
    And Each array element of array in response should contain property with value:    [data][0][relationships][customers][data]    type    customers
    And Each array element of array in response should contain property with value NOT in:     [data][0][relationships][customers][data]    id    None
    And Each array element of array in response should contain property with value:    [included]    type    customers
    And Response body parameter should start with:    [included][0][id]    DE--
    And Each array element of array in response should contain property with value NOT in:    [included]    id    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.name    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.email    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.firstName    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.lastName    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.email    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.gender    None
    And Each array element of array in response should contain nested property:    [included]    [attributes]    dateOfBirth
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.salutation    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.createdAt    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.updatedAt    None
    And Response body has correct self link

Retrieve_company_user_including_company_business_units
    When I get access token for the customer:    ${yves_user_email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users?include=company-business-units
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    type    company-users
    And Each array element of array in response should contain value:    [data]    id
    And Each array element of array in response should contain property with value NOT in:    [data]    [id]    None
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isActive
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isDefault
    And Each array element of array in response should contain property with value:    [data][0][relationships][company-business-units][data]    type    company-business-units
    And Each array element of array in response should contain property with value NOT in:     [data][0][relationships][company-business-units][data]    id    None
    And Each array element of array in response should contain property with value:    [included]    type    company-business-units
    And Each array element of array in response should contain property with value NOT in:    [included]    id    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.name    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.email    None
    And Each array element of array in response should contain nested property:    [included]    [attributes]    defaultBillingAddress
    And Each array element of array in response should contain nested property:    [included]    [attributes]    phone
    And Each array element of array in response should contain nested property:    [included]    [attributes]    externalUrl
    And Each array element of array in response should contain nested property:    [included]    [attributes]    bic
    And Each array element of array in response should contain nested property:    [included]    [attributes]    iban
    And Response body has correct self link

Retrieve_company_user_including_company_roles
    When I get access token for the customer:    ${yves_user_email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users?include=company-roles
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    type    company-users
    And Each array element of array in response should contain value:    [data]    id
    And Each array element of array in response should contain property with value NOT in:    [data]    [id]    None
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isActive
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isDefault
    And Each array element of array in response should contain property with value:    [data][0][relationships][company-roles][data]    type    company-roles
    And Each array element of array in response should contain property with value NOT in:     [data][0][relationships][company-roles][data]    id    None
    And Each array element of array in response should contain property with value:    [included]    type    company-roles
    And Each array element of array in response should contain property with value NOT in:    [included]    id    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.name    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.isDefault    None
    And Response body has correct self link

Retrieve_company_user_including_companies
    When I get access token for the customer:    ${yves_user_email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users?include=companies
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    type    company-users
    And Each array element of array in response should contain value:    [data]    id
    And Each array element of array in response should contain property with value NOT in:    [data]    [id]    None
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isActive
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isDefault
    And Each array element of array in response should contain property with value:    [data][0][relationships][companies][data]    type    companies
    And Each array element of array in response should contain property with value NOT in:     [data][0][relationships][companies][data]    id    None
    And Each array element of array in response should contain property with value:    [included]    type    companies
    And Each array element of array in response should contain property with value NOT in:    [included]    id    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.isActive    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.name    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes.status    None
    And Response body has correct self link