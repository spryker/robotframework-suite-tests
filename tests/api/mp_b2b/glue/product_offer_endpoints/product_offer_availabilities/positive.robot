*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

# There is a bug MP-6749
Get_product_offer_availabilities
    When I send a GET request:    /product-offers/${second_offer_with_vp}/product-offer-availabilities?include=product-offer-prices,product-offers,merchants
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${second_offer_with_vp}
    And Response body parameter should be:    [data][0][type]    product-offer-availabilities
    And Response body parameter should be in:    [data][0][attributes][isNeverOutOfStock]    True    False
    And Response body parameter should be greater than:    [data][0][attributes][quantity]    0
    And Response body parameter should be in:    [data][0][attributes][availability]    True    False
    And Response body parameter should not be EMPTY:    [data][0][links][self]