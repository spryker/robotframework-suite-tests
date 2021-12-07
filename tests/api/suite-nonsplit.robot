*** Settings ***
Suite Setup       SuiteSetup

Resource    ../../resources/common/common_api.robot

*** Test Cases ***
Examples
    ###
    When I get access token for the customer:    sonia@spryker.com
    Then Response header parameter should be:    Content-Type    application/vnd.api+json
    And Response reason should be:    Created
    And Response body has correct self link
    ###
    When I set Headers:    Content-Type=application/octet-streamtest    Accept=application/octet-streamfuck    Authorization=${token}
    And I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"name":"Test Cart","priceMode":"GROSS_MODE","currency":"EUR","store":"DE"}}}
    Then Response body parameter should be:    [data][attributes][priceMode]    GROSS_MODE
    And Response body parameter should have datatype:    [data][attributes][priceMode]    str
    ###
    When I send a GET request:    /catalog-search?q=HSM&pricemin=99.99&pricemax=150
    Then Response reason should be:    OK
    And Response status code should be:    200
    And Response body should contain:    "localizedName": "Weight"
    And Response body has correct self link
    

#TODO: implement the foloowing methods:
# Response parameter value should contain:    [data][attr]    value
# Response parameter value should be larger than:    [ata][attr]    number|date
# Response parameter value should be smaller than:    [ata][attr]    number|date
# Response should contain the array of certain size:   [data][array]     number
# Include in response should contain certain number of values:   [data][array]     value       number
# Each array element of array in response should contain property:     [data][array]      property
# Each array element of array in response should contain value:     [data][array]      value
# Each array element of array in response should contain property with value:     [data][array]      value     property
# Response should return error message:      text

