*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

# There is a bug https://spryker.atlassian.net/browse/CC-17140
Get_product_offer_availabilities
    When I send a GET request:    /product-offers/${second_offer_with_volume_price}/product-offer-availabilities
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    id    ${second_offer_with_volume_price}
    And Each array element of array in response should contain property with value:    [data]    type    product-offer-availabilities
    And Response should contain the array larger than a certain size:    [data][0][attributes][quantity]    0
    And Each array element of array in response should contain property with value in:    [data]    [attributes][isNeverOutOfStock]    True    False
    And Each array element of array in response should contain property with value in:    [data]    [attributes][availability]    True    False
    And Response body has correct self link