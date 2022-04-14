*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Test_adding_voucher_code_to_cart_of_logged_in_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${GROSS_MODE}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "419901","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "sprykerje7p"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0]
    And Response should contain the array of a certain size:    [data][attributes][discounts]    2
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    1658
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    1561
    And Response body parameter should be:    [data][attributes][totals][subtotal]    11434
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    9776
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Test_delete_voucher_code_from_cart_of_logged_in_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${GROSS_MODE}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "419901","quantity": 1}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "sprykerje7p"}}}
    ...    AND    Response status code should be:    201
    When I send a DELETE request:    /carts/${cart_id}/vouchers/sprykerje7p
    Then Response status code should be:    204
    And Response reason should be:    No Content

Test_adding_two_vouchers_with_different_priority_to_the_same_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${GROSS_MODE}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "419901","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "sprykerje7p"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "safescanxu6ce5ta8c"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][2]
    And Response should contain the array of a certain size:    [data][attributes][discounts]    3
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    2635
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    1405
    And Response body parameter should be:    [data][attributes][totals][subtotal]    11434
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    8799
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204



*** comment ***
Test_adding_voucher_code_to_guest_cart
    [Setup]    Run Keywords    I set Headers:    X-Anonymous-Customer-Unique-Id=22
    ...    AND    I send a POST request:    /guest-cart-items    {"data": {"type": "guest-cart-items","attributes": {"sku": "419901","quantity": 1}}}
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Log    ${guestCartId}
    ...    AND    Response status code should be:    201
    When I send a POST request:    /guest-carts/${guestCartId}/vouchers    {{"data": {"type": "vouchers","attributes": {"code": "sprykerru9t"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0]
    And Response should contain the array of a certain size:    [data][attributes][discounts]    2
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    1658
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    1561
    And Response body parameter should be:    [data][attributes][totals][subtotal]    11434
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    9776
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${guestCartId}
    ...  AND    Response status code should be:    204


Test_delete_voucher_code_from_guest_cart
    [Setup]    Run Keywords    I set Headers:    X-Anonymous-Customer-Unique-Id=2
    ...    AND    I send a POST request with data:    /guest-cart-items    {"data": {"type": "guest-cart-items","attributes": {"sku": "419901","quantity": 1}}}
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Response status code should be:    201
    ...    AND I send a POST request with data:    /guest-carts/${guestCartId}/vouchers    {{"data": {"type": "vouchers","attributes": {"code": "sprykerru9t"}}}
    ...    AND    Response status code should be:    201
    When I send a DELETE request:    /guest-carts/${guestCartId}/vouchers/sprykerru9t
    Then Response status code should be:    204
    And Response body has correct self link
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0]
    And Response should contain the array of a certain size:    [data][attributes][discounts]    1
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    1143
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    1643
    And Response body parameter should be:    [data][attributes][totals][subtotal]    11434
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    10291


