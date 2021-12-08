*** Settings ***
Suite Setup       SuiteSetup

Resource    ../../resources/common/common_api.robot

*** Test Cases ***
Examples
    ###
    When I get access token for the customer:    sonia@spryker.com
    Then Response header parameter should be:    Content-Type    application/vnd.api+json
    Then Response body parameter should be greater than:    [data][attributes][expiresIn]    0
    Then Response body parameter should be less than:    [data][attributes][expiresIn]    500000
    And Response reason should be:    Created
    And Response body has correct self link
    ###
    When I set Headers:    Content-Type=application/octet-stream    Accept=application/octet-stream    Authorization=${token}
    And I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"name":"Test Cart${random}","priceMode":"GROSS_MODE","currency":"EUR","store":"DE"}}}
    Then Response body parameter should be:    [data][attributes][priceMode]    GROSS_MODE
    And Response body parameter should have datatype:    [data][attributes][priceMode]    str
    ###
    When I send a GET request:    /catalog-search?q=Canon&pricemin=99.99&pricemax=150
    Then Response body parameter should be:    data[0].attributes.abstractProducts[2].abstractSku    185
    Then Response body parameter should be:    [data][0][attributes][abstractProducts][2][abstractSku]    185
    Then Response body parameter should not be EMPTY:    data[0].attributes.sort.sortParamNames[0]
    Then Response reason should be:    OK
    And Response status code should be:    200
    And Response body should contain:    "localizedName": "Weight"
    And Response body has correct self link
    Then Response body parameter should be greater than:    data[0].attributes.abstractProducts[2].prices[0].grossAmount    18414
    Then Response body parameter should be greater than:    [data][0][attributes][abstractProducts][2][prices][0][grossAmount]    18414
    ### 
    When I set Headers:    Content-Type=application/octet-streamtest    Accept=application/octet-stream    X-Anonymous-Customer-Unique-Id=${random}
    And I send a POST request:    /guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"201_11217755","quantity":1}}}
    Then Response body parameter should not be EMPTY:    data.attributes.name
    When I send a GET request:    /merchants/MER000001/merchant-opening-hours
    Then Response body parameter should NOT be:    data[0].id    000


    

#TODO: implement the foloowing methods:
# Response parameter value should be larger than:    [ata][attr]    |date
# Response parameter value should be smaller than:    [ata][attr]   |date
# Response should contain the array of certain size:   [data][array]     number
# Include in response should contain certain number of values:   [data][array]     value       number
# Each array element of array in response should contain property:     [data][array]      property
# Each array element of array in response should contain value:     [data][array]      value
# Each array element of array in response should contain property with value:     [data][array]      value     property
# Response should return error message:      text

