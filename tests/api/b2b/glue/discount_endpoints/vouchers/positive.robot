*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

#####POST#####

Adding_voucher_code_to_cart_of_logged_in_customer
    [Documentation]    Fails because of CC-16735 ( CC-16719 is closed as duplicate)
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.with_brand_safescan.product_1.sku}","quantity": 2}}}
    ...    AND    Response status code should be:    201
    ...    AND    Get voucher code by discountId from Database:    4
    When I send a POST request:
    ...    /carts/${cart_id}/vouchers
    ...    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Save value to a variable:    [data][attributes][totals][discountTotal]    discount_total_sum
    And Save value to a variable:    [data][attributes][totals][subtotal]    sub_total_sum
    And Save value to a variable:    [data][attributes][totals][expenseTotal]    expense_total_sum
    #discountTotal
    And Save value to a variable:    discount_total_sum    ${voucher.brand_safescan_2_items}
    And Response body parameter with rounding should be:
    ...    [data][attributes][totals][discountTotal]
    ...    ${discount_total_sum}
    #grandTotal
    And Perform arithmetical calculation with two arguments:
    ...    grand_total_sum
    ...    ${sub_total_sum}
    ...    -
    ...    ${discount_total_sum}
    And Perform arithmetical calculation with two arguments:
    ...    grand_total_sum
    ...    ${grand_total_sum}
    ...    +
    ...    ${expense_total_sum}
    And Response body parameter with rounding should be:
    ...    [data][attributes][totals][grandTotal]
    ...    ${grand_total_sum}
    #checking cart rule and vouchers in cart
    And Response body parameter should contain:
    ...    [data][attributes][discounts][0][displayName]
    ...    ${discounts.id_4.name}
    And Response body parameter should contain:    [data][attributes][discounts][0][code]    ${discount_voucher_code}
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Checking_voucher_is_applied_after_order_is_placed
    [Documentation]    Fails because of CC-16735 ( CC-16719 is closed as duplicate)
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.with_brand_safescan.product_1.sku}","quantity": 2}}}
    ...    AND    Response status code should be:    201
    ...    AND    Get voucher code by discountId from Database:    4
    ...    AND    I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    ...    AND    Response status code should be:    201
    When I send a POST request:
    ...    /checkout?include=orders
    ...    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user.salutation}","email": "${yves_user.email}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentMethodName": "${payment_method_name}","paymentProviderName": "${payment_provider_name}"}],"shipments": [{"items": ["${concrete.with_relations_upselling_sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": "${shipment.delivery_date}"},{"items": ["${concrete.with_options.sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${changed.phone}","isDefaultBilling": False,"isDefaultShipping": False},"idShipmentMethod": 4,"requestedDeliveryDate": None}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Save value to a variable:    [included][0][attributes][totals][discountTotal]    discount_total_sum
    And Save value to a variable:    [included][0][attributes][totals][subtotal]    sub_total_sum
    And Save value to a variable:    [included][0][attributes][totals][expenseTotal]    expense_total_sum
    #discountTotal
    And Save value to a variable:    discount_total_sum    ${voucher.brand_safescan_2_items}
    And Response body parameter with rounding should be:
    ...    [included][0][attributes][totals][discountTotal]
    ...    ${discount_total_sum}
    #grandTotal
    And Perform arithmetical calculation with two arguments:
    ...    grand_total_sum
    ...    ${sub_total_sum}
    ...    -
    ...    ${discount_total_sum}
    And Perform arithmetical calculation with two arguments:
    ...    grand_total_sum
    ...    ${grand_total_sum}
    ...    +
    ...    ${expense_total_sum}
    And Response body parameter with rounding should be:
    ...    [included][0][attributes][totals][grandTotal]
    ...    ${grand_total_sum}
    #calculatedDiscounts - "10% off Safescan" discount
    And Response body parameter should not be EMPTY:
    ...    [included][0][attributes][calculatedDiscounts]["${discounts.id_4.name}"]
    And Response body parameter should contain:
    ...    [included][0][attributes][calculatedDiscounts]["${discounts.id_4.name}"][displayName]
    ...    ${discounts.id_4.name}
    And Response body parameter should contain:
    ...    [included][0][attributes][calculatedDiscounts]["${discounts.id_4.name}"][sumAmount]
    ...    ${discount_total_sum}
    And Response body parameter should contain:
    ...    [included][0][attributes][calculatedDiscounts]["${discounts.id_4.name}"][voucherCode]
    ...    ${discount_voucher_code}

Adding_two_vouchers_with_different_priority_to_the_same_cart
    [Documentation]    Fails because of CC-16735 ( CC-16719 is closed as duplicate)
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.with_brand_safescan.product_2_and_white_color.sku}","quantity": 2}}}
    ...    AND    Response status code should be:    201
    ...    AND    Get voucher code by discountId from Database:    3
    When I send a POST request:
    ...    /carts/${cart_id}/vouchers
    ...    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    And Save value to a variable:    [data][attributes][discounts][0][code]    voucher_1
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Get voucher code by discountId from Database:    4
    And I send a POST request:
    ...    /carts/${cart_id}/vouchers
    ...    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    And Save value to a variable:    [data][attributes][discounts][0][code]    voucher_2
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][2]
    And Response should contain the array of a certain size:    [data][attributes][discounts]    3
    And Save value to a variable:    [data][attributes][totals][discountTotal]    discount_total_sum
    And Save value to a variable:    [data][attributes][totals][subtotal]    sub_total_sum
    And Save value to a variable:    [data][attributes][totals][expenseTotal]    expense_total_sum
    #discountTotal
    And Save value to a variable:    discount_total_sum    ${voucher.brand_safescan_2_items}
    And Response body parameter with rounding should be:
    ...    [data][attributes][totals][discountTotal]
    ...    ${discount_total_sum}
    #grandTotal
    And Perform arithmetical calculation with two arguments:
    ...    grand_total_sum
    ...    ${sub_total_sum}
    ...    -
    ...    ${discount_total_sum}
    And Perform arithmetical calculation with two arguments:
    ...    grand_total_sum
    ...    ${grand_total_sum}
    ...    +
    ...    ${expense_total_sum}
    And Response body parameter with rounding should be:
    ...    [data][attributes][totals][grandTotal]
    ...    ${grand_total_sum}
    #calculatedDiscounts - "10% off Safescan" discount
    And Response body parameter should contain:
    ...    [data][attributes][discounts][0][displayName]
    ...    ${discounts.id_4.name}
    And Response body parameter should contain:    [data][attributes][discounts][0][code]    ${voucher_2}
    #calculatedDiscounts - "5% off White" discount
    And Response body parameter should contain:
    ...    [data][attributes][discounts][1][displayName]
    ...    ${discounts.id_3.name}
    And Response body parameter should contain:    [data][attributes][discounts][1][code]    ${voucher_1}
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Adding_voucher_with_cart_rule_with_to_the_same_cart
    [Documentation]    Fails because of CC-16735 ( CC-16719 is closed as duplicate)
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.with_brand_safescan.product_1.sku}","quantity": 10}}}
    ...    AND    Response status code should be:    201
    ...    AND    Get voucher code by discountId from Database:    4
    When I send a POST request:
    ...    /carts/${cart_id}/vouchers
    ...    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Save value to a variable:    [data][attributes][totals][discountTotal]    discount_total_sum
    And Save value to a variable:    [data][attributes][totals][subtotal]    sub_total_sum
    And Save value to a variable:    [data][attributes][totals][expenseTotal]    expense_total_sum
    #discountTotal
    And Save value to a variable:    discount_total_sum    ${voucher.brand_safescan_2_items}
    And Response body parameter with rounding should be:
    ...    [data][attributes][totals][discountTotal]
    ...    ${discount_total_sum}
    #grandTotal
    And Perform arithmetical calculation with two arguments:
    ...    grand_total_sum
    ...    ${sub_total_sum}
    ...    -
    ...    ${discount_total_sum}
    And Perform arithmetical calculation with two arguments:
    ...    grand_total_sum
    ...    ${grand_total_sum}
    ...    +
    ...    ${expense_total_sum}
    And Response body parameter with rounding should be:
    ...    [data][attributes][totals][grandTotal]
    ...    ${grand_total_sum}
    #checking cart rule and vouchers in cart
    And Response body parameter should contain:
    ...    [data][attributes][discounts][0][displayName]
    ...    ${discounts.id_4.name}
    And Response body parameter should contain:    [data][attributes][discounts][0][code]    ${discount_voucher_code}
    And Response body parameter should contain:
    ...    [data][attributes][discounts][1][displayName]
    ...    ${cart_rule_name_10_off_minimum_order}
    And Response body parameter should contain:    [data][attributes][discounts][1][code]    None
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

####### DELETE #######

Deleting_voucher_from_cart_of_logged_in_customer
    [Documentation]    Fails because of CC-16735 ( CC-16719 is closed as duplicate)
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.with_brand_safescan.product_2_and_white_color.sku}","quantity": 5}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][totals][grandTotal]    grand_total
    ...    AND    Save value to a variable:    [data][attributes][totals][discountTotal]    discount_total
    ...    AND    Get voucher code by discountId from Database:    4
    ...    AND    I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    ...    AND    Response status code should be:    201
    When I send a DELETE request:    /carts/${cartId}/vouchers/${discount_voucher_code}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    When I send a GET request:    /carts/${cartId}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter with rounding should be:    [data][attributes][totals][grandTotal]    ${grand_total}
    And Response body parameter with rounding should be:
    ...    [data][attributes][totals][discountTotal]
    ...    ${discount_total}
    And Response body parameter should NOT be:
    ...    [data][attributes][discounts][0][displayName]
    ...    ${discounts.id_4.name}
    And Response body parameter should NOT be:    [data][attributes][discounts][0][code]    ${discount_voucher_code}
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204
