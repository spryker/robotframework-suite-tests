*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Retrieves_list_of_merchants
    When I send a GET request:  /merchants
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    merchants
    And Each array element of array in response should contain nested property:    [data]    [attributes]    merchantName
    And Each array element of array in response should contain nested property:    [data]    [attributes]    merchantUrl
    And Each array element of array in response should contain nested property:    [data]    [attributes]    contactPersonRole
    And Each array element of array in response should contain nested property:    [data]    [attributes]    contactPersonTitle
    And Each array element of array in response should contain nested property:    [data]    [attributes]    contactPersonFirstName
    And Each array element of array in response should contain nested property:    [data]    [attributes]    contactPersonLastName
    And Each array element of array in response should contain nested property:    [data]    [attributes]    contactPersonPhone
    And Each array element of array in response should contain nested property:    [data]    [attributes]    logoUrl
    And Each array element of array in response should contain nested property:    [data]    [attributes]    publicEmail
    And Each array element of array in response should contain nested property:    [data]    [attributes]    publicPhone
    And Each array element of array in response should contain nested property:    [data]    [attributes]    description
    And Each array element of array in response should contain nested property:    [data]    [attributes]    bannerUrl
    And Each array element of array in response should contain nested property:    [data]    [attributes]    deliveryTime
    And Each array element of array in response should contain nested property:    [data]    [attributes]    faxNumber
    And Each array element of array in response should contain nested property:    [data]    [attributes][legalInformation]    terms
    And Each array element of array in response should contain nested property:    [data]    [attributes][legalInformation]    cancellationPolicy
    And Each array element of array in response should contain nested property:    [data]    [attributes][legalInformation]    imprint
    And Each array element of array in response should contain nested property:    [data]    [attributes][legalInformation]    dataPrivacy
    And Each array element of array in response should contain nested property:    [data]    [attributes]    categories
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link



Retrieves_a_merchant_by_id
    When I send a GET request:  /merchants/${merchants.sony_experts.merchant_reference}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should not be EMPTY:    [data][type]
    And Response body parameter should not be EMPTY:    [data][id]    
    And Response body parameter should be:    [data][id]    ${merchants.sony_experts.merchant_reference}
    And Response body parameter should be:    [data][type]    merchants
    And Response body parameter should be:    [data][attributes][merchantName]    ${merchants.sony_experts.merchant_name}
    And Response body parameter should be:    [data][attributes][merchantUrl]    ${merchants.sony_experts.merchant_url}
    And Response body parameter should be:    [data][attributes][contactPersonRole]    ${merchants.sony_experts.contact_person_role}
    And Response body parameter should be:    [data][attributes][contactPersonTitle]    ${merchants.sony_experts.contact_person_title}
    And Response body parameter should be:    [data][attributes][contactPersonFirstName]    ${merchants.sony_experts.contact_person_first_name}
    And Response body parameter should be:    [data][attributes][contactPersonLastName]    ${merchants.sony_experts.contact_person_last_name}
    And Response body parameter should be:    [data][attributes][contactPersonPhone]    ${merchants.sony_experts.contact_person_phone}
    And Response body parameter should be:    [data][attributes][publicEmail]    ${merchants.sony_experts.public_email}
    And Response body parameter should be:    [data][attributes][publicPhone]    ${merchants.sony_experts.public_phone}
    And Response body parameter should be:    [data][attributes][description]    ${merchants.sony_experts.description}
    And Response body parameter should not be EMPTY:    [data][attributes]
    And Response body parameter should not be EMPTY:    [data][attributes][logoUrl]
    And Response body parameter should not be EMPTY:    [data][attributes][bannerUrl]
    And Response body parameter should not be EMPTY:    [data][attributes][deliveryTime]
    And Response body parameter should not be EMPTY:    [data][attributes][faxNumber]
    And Response body parameter should not be EMPTY:    [data][attributes][legalInformation][terms]
    And Response body parameter should not be EMPTY:    [data][attributes][legalInformation][cancellationPolicy]
    And Response body parameter should not be EMPTY:    [data][attributes][legalInformation][imprint]
    And Response body parameter should not be EMPTY:    [data][attributes][legalInformation][dataPrivacy]
    And Response body parameter should have datatype:    [data][attributes][categories]    list
    And Response body has correct self link internal
