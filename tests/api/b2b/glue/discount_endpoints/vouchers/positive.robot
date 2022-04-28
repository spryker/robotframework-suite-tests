*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

#####POST#####
Adding_voucher_code_to_cart_of_logged_in_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${GROSS_MODE}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_brand_safescan}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "${discount_id_4_voucher_code}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Save value to a variable:    [data][attributes][totals][discountTotal]    discount_total_sum
    And Save value to a variable:    [data][attributes][totals][subtotal]    sub_total_sum
    And Save value to a variable:    [data][attributes][totals][expenseTotal]    expense_total_sum
    #discountTotal
    And Perform arithmetical calculation with two arguments:    discount_total_sum    ${voucher_concrete_product_1_with_brand_safescan}    +    0
    And Response body parameter with rounding should be:    [data][attributes][totals][discountTotal]    ${discount_total_sum}
    # #grandTotal
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${sub_total_sum}    -    ${discount_total_sum}
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${grand_total_sum}    +    ${expense_total_sum}
    And Response body parameter with rounding should be:    [data][attributes][totals][grandTotal]    ${grand_total_sum}
    # #calculatedDiscounts - "10% off Safescan" discount
    And Response body parameter should contain:    [data][attributes][discounts][0][displayName]    ${discount_id_4_name}
    And Response body parameter should contain:    [data][attributes][discounts][0][amount]    ${discount_total_sum}
    And Response body parameter should contain:    [data][attributes][discounts][0][code]    ${discount_id_4_voucher_code}
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204


Checking_voucher_is_applied_after_order_is_placed
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${GROSS_MODE}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_brand_safescan}","quantity": 3}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "${discount_id_4_voucher_code}"}}}
    ...    AND    Response status code should be:    201
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user_salutation}","email": "${yves_user_email}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentMethodName": "${payment_method_name}","paymentProviderName": "${payment_provider_name}"}],"shipments": [{"items": ["${concrete_of_product_with_relations_upselling_sku}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": "${delivery_date}"},{"items": ["${concrete_product_with_options}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${changed_address1}","address2": "${changed_address2}","address3": "${changed_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${changed_phone}","isDefaultBilling": False,"isDefaultShipping": False},"idShipmentMethod": 4,"requestedDeliveryDate": None}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Save value to a variable:    [data][attributes][totals][discountTotal]    discount_total_sum
    And Save value to a variable:    [data][attributes][totals][subtotal]    sub_total_sum
    And Save value to a variable:    [data][attributes][totals][expenseTotal]    expense_total_sum
    #discountTotal
    And Perform arithmetical calculation with two arguments:    discount_total_sum    ${voucher_concrete_product_1_with_brand_safescan}    +    0
    # And Response body parameter with rounding should be:    [data][attributes][totals][discountTotal]    ${discount_total_sum}
    # #grandTotal
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${sub_total_sum}    -    ${discount_total_sum}
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${grand_total_sum}    +    ${expense_total_sum}
    # And Response body parameter with rounding should be:    [data][attributes][totals][grandTotal]    ${grand_total_sum}
    # #calculatedDiscounts - "10% off Safescan" discount
    # And Response body parameter should contain:    [data][attributes][discounts][0][displayName]    ${discount_id_4_name}
    # And Response body parameter should contain:    [data][attributes][discounts][0][amount]    ${discount_total_sum}
    # And Response body parameter should contain:    [data][attributes][discounts][0][code]    ${discount_id_4_voucher_code}
    # [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    # ...  AND    Response status code should be:    204


# Adding_two_vouchers_with_different_priority_to_the_same_cart
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${GROSS_MODE}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
#     ...    AND    Save value to a variable:    [data][id]    cart_id
#     ...    AND    Response status code should be:    201
#     ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "419901","quantity": 1}}}
#     ...    AND    Response status code should be:    201
#     When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "${discount_id_3_voucher_code}"}}}
#     Then Response status code should be:    201
#     And Response reason should be:    Created
#     And I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "safescanxu6ce5ta8c"}}}
#     Then Response status code should be:    201
#     And Response reason should be:    Created
#     And Response body parameter should not be EMPTY:    [data][attributes][discounts][2]
#     And Response should contain the array of a certain size:    [data][attributes][discounts]    3
#     And Response body parameter should be:    [data][attributes][totals][discountTotal]    2635
#     And Response body parameter should be:    [data][attributes][totals][taxTotal]    1405
#     And Response body parameter should be:    [data][attributes][totals][subtotal]    11434
#     And Response body parameter should be:    [data][attributes][totals][grandTotal]    8799
#     [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
#     ...  AND    Response status code should be:    204


# ####### DELETE #######
# Deleting_voucher_from_cart_of_logged_in_customer
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${GROSS_MODE}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
#     ...    AND    Save value to a variable:    [data][id]    cart_id
#     ...    AND    Response status code should be:    201
#     ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "419901","quantity": 1}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "${discount_id_3_voucher_code}"}}}
#     ...    AND    Response status code should be:    201
#     When I send a DELETE request:    /carts/${cartId}/vouchers/${discount_id_3_voucher_code}
#     Then Response status code should be:    204
#     And Response reason should be:    No Content
#     [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
#     ...  AND    Response status code should be:    204




