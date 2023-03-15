*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Get_product_tax sets
    When I send a GET request:    /abstract-products/${abstract.with_review.sku}/product-tax-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    1
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should be:    [data][0][type]    product-tax-sets
    And Response body parameter should not be EMPTY:    [data][0][attributes][name]
    And Response should contain the array larger than a certain size:    [data][0][attributes][restTaxRates]    1
    And Response body parameter should not be EMPTY:    [data][0][links][self]
    Each array element of array in response should contain property:    [data][0][attributes][restTaxRates]    name
    Each array element of array in response should contain property:    [data][0][attributes][restTaxRates]    rate
    Each array element of array in response should contain property:    [data][0][attributes][restTaxRates]    country
    And Response body has correct self link
