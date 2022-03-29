*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***

Get_all_availiable_stores
    When I send a GET request:    /stores
    Then Response status code should be:    200
    And Response reason should be:    OK
    Each array element of array in response should contain property:    [data]    type
    Each array element of array in response should contain property:    [data]    id
    Each array element of array in response should contain nested property:    [data]    [attributes]    timeZone
    Each array element of array in response should contain nested property:    [data]    [attributes]    defaultCurrency
    Each array element of array in response should contain nested property:    [data]    [attributes]    currencies
    Each array element of array in response should contain nested property:    [data]    [attributes]    locales
    Each array element of array in response should contain nested property:    [data]    [attributes]    countries
    Each array element of array in response should contain nested property:    [data]    [attributes]    defaultCurrency

    Each array element of array in response should contain nested property:    [data]    [attributes][currencies]    code
    Each array element of array in response should contain nested property:    [data]    [attributes][currencies]    name

    Each array element of array in response should contain nested property:    [data]    [attributes][locales]    code
    Each array element of array in response should contain nested property:    [data]    [attributes][locales]    name

    Each array element of array in response should contain nested property:    [data]    [attributes][countries]    iso2Code
    Each array element of array in response should contain nested property:    [data]    [attributes][countries]    iso3Code
    Each array element of array in response should contain nested property:    [data]    [attributes][countries]    name
    Each array element of array in response should contain nested property:    [data]    [attributes][countries]    postalCodeMandatory
    Each array element of array in response should contain nested property:    [data]    [attributes][countries]    postalCodeRegex
    Each array element of array in response should contain nested property:    [data]    [attributes][countries]    regions
    
    Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link


Get_store_by_id
    When I send a GET request:    /stores/${store_de}
    Then Response status code should be:    200
    And Response reason should be:    OK
    Response body parameter should be:    [data][type]    stores
    Response body parameter should be:    [data][id]    ${store_de}
    Response body parameter should not be EMPTY:    [data][attributes]
    Response body parameter should not be EMPTY:    [data][attributes][timeZone]
    Response body parameter should not be EMPTY:    [data][attributes][timeZone]

    Response body parameter should have datatype:    [data][attributes][timeZone]   str
    Response body parameter should have datatype:    [data][attributes][currencies]   list
    Response body parameter should have datatype:    [data][attributes][locales]   list
    Response body parameter should have datatype:    [data][attributes][countries]   list

    Each array element of array in response should contain property:    [data][attributes][currencies]    name
    Each array element of array in response should contain property:    [data][attributes][currencies]    code

    Each array element of array in response should contain property:    [data][attributes][locales]    name
    Each array element of array in response should contain property:    [data][attributes][locales]    code

    Each array element of array in response should contain property:    [data][attributes][countries]    iso2Code
    Each array element of array in response should contain property:    [data][attributes][countries]    iso3Code
    Each array element of array in response should contain property:    [data][attributes][countries]    name
    Each array element of array in response should contain property:    [data][attributes][countries]    postalCodeMandatory
    Each array element of array in response should contain property:    [data][attributes][countries]    postalCodeRegex
    Each array element of array in response should contain property:    [data][attributes][countries]    regions

    Response body has correct self link internal
