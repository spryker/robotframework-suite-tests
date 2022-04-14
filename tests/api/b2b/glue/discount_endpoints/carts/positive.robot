*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Test_check_discount_is_applied_to_cart_of_logged_in_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${GROSS_MODE}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    When I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "419901","quantity": 1}}}
    And Response status code should be:    201
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0]
    And Response should contain the array of a certain size:    [data][attributes][discounts]    1
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    1143
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    1643
    And Response body parameter should be:    [data][attributes][totals][subtotal]    11434
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    10291
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204


Test_check_two_discounts_are_applied_to_cart_of_logged_in_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${GROSS_MODE}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    When I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "419901","quantity": 1}}}
    And Response status code should be:    201
    And I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "574987","quantity": 1}}}
    And Response status code should be:    201
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0]
    And Response should contain the array of a certain size:    [data][attributes][discounts]    2
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    13183
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    6586
    And Response body parameter should be:    [data][attributes][totals][subtotal]    54432
    And Response body parameter should be:    [data][attributes][totals][grandTotal]   41249 
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204



