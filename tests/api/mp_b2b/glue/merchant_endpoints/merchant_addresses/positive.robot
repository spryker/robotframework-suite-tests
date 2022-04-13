*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Retrieves_merchant_addresses
    When I send a GET request:  /merchants/${merchant_id}/merchant-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${merchant_id}
    And Response body parameter should be:    [data][0][type]    merchant-addresses
    And Response body parameter should be:    [data][0][attributes][addresses][0][countryName]    ${default_country}
    And Response body parameter should be:    [data][0][attributes][addresses][0][city]    München
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    merchant-addresses
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    countryName
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address2
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address3
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    city
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    zipCode
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    latitude
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    longitude
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link


Retrieves_merchant_with_include_merchant_addresses
    When I send a GET request:  /merchants/${merchant_id}?include=merchant-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK    
    And Response body parameter should be:    [data][type]    merchants
    And Response body parameter should be:    [data][id]    ${merchant_id}
    And Response Should Contain The Array Larger Than a Certain Size:    [included]    0
    And Response Should Contain The Array Larger Than a Certain Size:    [data][relationships]    0
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][merchant-addresses]
    And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][merchant-addresses][data]    type
    And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][merchant-addresses][data]    id
    And Response body parameter should not be EMPTY:    [included]
    And Each Array Element Of Array In Response Should Contain Property:    [included]    type
    And Each Array Element Of Array In Response Should Contain Property:    [included]    id
    And Each Array Element Of Array In Response Should Contain Property:    [included]    attributes
    And Each Array Element Of Array In Response Should Contain Property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain property with value:    [included]    type    merchant-addresses
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    countryName
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address3
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    city
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    zipCode
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    latitude
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    longitude
