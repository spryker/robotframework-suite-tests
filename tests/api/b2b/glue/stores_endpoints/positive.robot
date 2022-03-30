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
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain nested property:    [data]    [attributes]    timeZone
    And Each array element of array in response should contain nested property:    [data]    [attributes]    defaultCurrency
    And Each array element of array in response should contain nested property:    [data]    [attributes]    currencies
    And Each array element of array in response should contain nested property:    [data]    [attributes]    locales
    And Each array element of array in response should contain nested property:    [data]    [attributes]    countries
    And Each array element of array in response should contain nested property:    [data]    [attributes]    defaultCurrency

    And Each array element of nested array should contain property with value in:    [data]    [attributes][currencies]    code    ${currency_code_eur}    ${currency_code_dollar}    ${currency_code_chf}
    And Each array element of nested array should contain property with value in:    [data]    [attributes][currencies]    name    ${currency_name_eur}    ${currency_name_dollar}    ${currency_name_chf}
    And Each array element of array in response should contain nested property:    [data]    [attributes][currencies]    code
    And Each array element of array in response should contain nested property:    [data]    [attributes][currencies]    name

    And Each array element of nested array should contain property with value in:    [data]    [attributes][locales]    code    ${locale_code_DE}    ${locale_code_EN}
    And Each array element of nested array should contain property with value in:    [data]    [attributes][locales]    name    ${locale_name_DE}    ${locale_name_EN}
    And Each array element of array in response should contain nested property:    [data]    [attributes][locales]    code
    And Each array element of array in response should contain nested property:    [data]    [attributes][locales]    name

    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    iso2Code
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    iso3Code
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    postalCodeMandatory
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    postalCodeRegex
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    regions
    
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link


Get_store_by_id
    When I send a GET request:    /stores/${store_de}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    stores
    And Response body parameter should be:    [data][id]    ${store_de}
    And Response body parameter should not be EMPTY:    [data][attributes]
    And Response body parameter should not be EMPTY:    [data][attributes][timeZone]
    And Response body parameter should not be EMPTY:    [data][attributes][timeZone]

    And Response body parameter should have datatype:    [data][attributes][timeZone]   str
    And Response body parameter should have datatype:    [data][attributes][currencies]   list
    And Response body parameter should have datatype:    [data][attributes][locales]   list
    And Response body parameter should have datatype:    [data][attributes][countries]   list

    And Each array element of array in response should contain property with value in:    [data][attributes][currencies]    name    ${currency_name_eur}    ${currency_name_dollar}    ${currency_name_chf}
    And Each array element of array in response should contain property with value in:    [data][attributes][currencies]    code    ${currency_code_eur}    ${currency_code_dollar}    ${currency_code_chf}
    And Each array element of array in response should contain property:    [data][attributes][currencies]    name
    And Each array element of array in response should contain property:    [data][attributes][currencies]    code

    And Each array element of array in response should contain property with value in:    [data][attributes][locales]    code    ${locale_code_DE}    ${locale_code_EN}
    And Each array element of array in response should contain property with value in:    [data][attributes][locales]    name    ${locale_name_DE}    ${locale_name_EN}
    And Each array element of array in response should contain property:    [data][attributes][locales]    name
    And Each array element of array in response should contain property:    [data][attributes][locales]    code

    And Each array element of array in response should contain property:    [data][attributes][countries]    iso2Code
    And Each array element of array in response should contain property:    [data][attributes][countries]    iso3Code
    And Each array element of array in response should contain property:    [data][attributes][countries]    name
    And Each array element of array in response should contain property:    [data][attributes][countries]    postalCodeMandatory
    And Each array element of array in response should contain property:    [data][attributes][countries]    postalCodeRegex
    And Each array element of array in response should contain property:    [data][attributes][countries]    regions

    And Response body has correct self link internal
