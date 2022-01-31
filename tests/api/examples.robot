# *** Settings ***
# Suite Setup       SuiteSetup
# Resource    ../../resources/common/common_api.robot

# *** Test Cases ***
# Examples
#     ### Returns access token value as a test variable
#     When I get access token for the customer:    sonia@spryker.com
#     ### Check specific header parameter value. Multiple params are NOT supported. 
#     #TODO: update to support multiple params
#     Then Response header parameter should be:    Content-Type    ${default_header_content_type}
#     Then Response body parameter should be greater than:    [data][attributes][expiresIn]    0
#     Then Response body parameter should be less than:    [data][attributes][expiresIn]    500000
#     ### Might be: OK, Created, Not found, etc.
#     And Response reason should be:    Created
#     ### Multiple params are supported. Allows to set specific header params with values that will be applied to ALL requests in a test. 
#     ### If not used -> default headers will be used automatically
#     When I set Headers:    Content-Type=application/octet-stream    Accept=application/octet-stream    Authorization=${token}
#     And I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"name":"Test Cart${random}","priceMode":"GROSS_MODE","currency":"EUR","store":"DE"}}}
#     Then Response body parameter should be:    [data][attributes][priceMode]    GROSS_MODE
#     And Response body parameter should have datatype:    [data][attributes][priceMode]    str
#     ###
#     When I send a GET request:    /catalog-search?q=Canon&pricemin=99.99&pricemax=150
#     ### 2 types of json path are supported:
#     Then Response body parameter should be:    data[0].attributes.abstractProducts[2].abstractSku    185
#     Then Response body parameter should be:    [data][0][attributes][abstractProducts][2][abstractSku]    185
#     Then Response body parameter should not be EMPTY:    data[0].attributes.sort.sortParamNames[0]
#     Then Response reason should be:    OK
#     And Response status code should be:    200
#     And Response body should contain:    "localizedName": "Weight"
#     And Response body has correct self link
#     Then Response body parameter should be greater than:    data[0].attributes.abstractProducts[2].prices[0].grossAmount    18414
#     Then Response body parameter should be greater than:    [data][0][attributes][abstractProducts][2][prices][0][grossAmount]    18414
#     ### In case you need to remove smth from headers or add a new value -> Use the method below one more time, it will define new headers to all next requests in the test. 
#     ### With the next call 'Authorization=${token}' will be removed from headrs for all further requests in a test and 'X-Anonymous-Customer-Unique-Id=${random}' will be added
#     When I set Headers:    Content-Type=application/octet-streamtest    Accept=application/octet-stream    X-Anonymous-Customer-Unique-Id=${random}
#     And I send a POST request:    /guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"201_11217755","quantity":1}}}
#     Then Response body parameter should not be EMPTY:    data.attributes.name
#     When I send a GET request:    /merchants/MER000001/merchant-opening-hours
#     Then Response body parameter should NOT be:    data[0].id    000
#     Then Response body parameter should be greater than:    data[0].attributes.dateSchedule[0].date    2019-01-01
#     Then Response body parameter should be less than:    data[0].attributes.dateSchedule[0].date    ${today}
#     Then Response should contain the array of a certain size:    data[0].attributes.weekdaySchedule    8
#     ###
#     When I send a GET request:    /abstract-products/209?include=concrete-product-image-sets,concrete-products
#     Then Each array element of array in response should contain property:     [included]    type
#     Each array element of array in response should contain value:     [included]      name
#     When I send a GET request:    /navigations/footer_navigation
#     Then Each array element of array in response should contain property with value:     [data][attributes][nodes]    nodeType    cms_page
#     And Response should contain certain number of values:    [data][attributes][nodes]    cms_page    4
#     ###
#     When I set Headers:    Content-Type=application/octet-streamtest    Accept=application/octet-stream
#     And I send a POST request:    /guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"201_11217755","quantity":1}}}
#     Then Response should return error code:    109
#     And Response should return error message:    Anonymous customer unique id is empty.
