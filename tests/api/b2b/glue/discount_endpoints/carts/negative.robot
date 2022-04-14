*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Test_check_discount_is_not_applied_to_cart_that_does_not_fulfill_cart_rule_GROSS_MODE
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${GROSS_MODE}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    When I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "424265","quantity": 1}}}
    And Response status code should be:    201
    And Response should contain the array of a certain size:    [data][attributes][discounts]   0 
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    141
    And Response body parameter should be:    [data][attributes][totals][subtotal]    880
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    880
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204


Test_check_discount_is_not_applied_to_cart_that_does_not_fulfill_cart_rule_NET_MODE
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${NET_MODE}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    When I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "424265","quantity": 1}}}
    And Response status code should be:    201
    And Response should contain the array of a certain size:    [data][attributes][discounts]   0 
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    140
    And Response body parameter should be:    [data][attributes][totals][subtotal]    739
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    879
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204