*** Settings ***
Suite Setup    SuiteSetup
Test Setup     TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

#POST requests
Add_voucher_code_to_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${discount_concrete_product.sku_with_voucher_code}","quantity": 1}}}
    ...    AND    Get voucher code by discountId from Database:    ${discount_voucher_type_id}
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    #totals
    And Save value to a variable:    [data][attributes][totals][discountTotal]    discount_total
    And Save value to a variable:    [data][attributes][totals][subtotal]    subtotal
    And Perform arithmetical calculation with two arguments:    grand_total    ${subtotal}    -    ${discount_total}
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
    And Response body parameter with rounding should be:    [data][attributes][totals][grandTotal]    ${grand_total}
    And Response body parameter with rounding should be:    [data][attributes][totals][priceToPay]    ${grand_total}
    #discounts
    And Response body parameter should be:    [data][attributes][discounts][0][displayName]    ${discount_4.name}
    And Response body parameter should be greater than:    [data][attributes][discounts][0][amount]    0
    And Response body parameter should be:    [data][attributes][discounts][0][code]    ${discount_voucher_code}
    And Response should contain the array of a certain size:    [data][attributes][thresholds]    0
    And Response body parameter should not be EMPTY:    [data][links][self]


Add_voucher_code_to_guest_user_cart
    [Setup]    Run Keywords   Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount_concrete_product.sku_with_voucher_code}    1
    ...    AND    Get voucher code by discountId from Database:    ${discount_voucher_type_id}
    When I send a POST request:    /guest-carts/${guest_cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should be:    [data][id]    ${guest_cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    #totals
    And Save value to a variable:    [data][attributes][totals][discountTotal]    discount_total
    And Save value to a variable:    [data][attributes][totals][subtotal]    subtotal
    And Perform arithmetical calculation with two arguments:    grand_total    ${subtotal}    -    ${discount_total}
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
    And Response body parameter with rounding should be:    [data][attributes][totals][grandTotal]    ${grand_total}
    And Response body parameter with rounding should be:    [data][attributes][totals][priceToPay]    ${grand_total}
    #discounts
    And Response body parameter should be:    [data][attributes][discounts][0][displayName]    ${discount_4.name}
    And Response body parameter should be greater than:    [data][attributes][discounts][0][amount]    0
    And Response body parameter should be:    [data][attributes][discounts][0][code]    ${discount_voucher_code}
    And Response should contain the array of a certain size:    [data][attributes][thresholds]    0
    And Response body parameter should not be EMPTY:    [data][links][self]
    [Teardown]    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_voucher_code_to_cart_including_vouchers
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${discount_concrete_product.sku_with_voucher_code}","quantity": 1}}}
    ...    AND    Get voucher code by discountId from Database:    ${discount_voucher_type_id}
    When I send a POST request:    /carts/${cart_id}/vouchers?include=vouchers    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    #relationships
    And Response body parameter should be:    [data][relationships][vouchers][data][0][type]    vouchers
    And Response body parameter should be:    [data][relationships][vouchers][data][0][id]    ${discount_voucher_code}
    And Response should contain the array of a certain size:    [data][relationships][vouchers][data]    1

    #included
    And Response include should contain certain entity type:    vouchers
    And Response body parameter should be:    [included][0][id]    ${discount_voucher_code}
    And Response body parameter should be greater than:    [included][0][attributes][amount]    0
    And Response body parameter should be:    [included][0][attributes][code]    ${discount_voucher_code}
    And Response body parameter should be:    [included][0][attributes][discountType]    voucher
    And Response body parameter should be:    [included][0][attributes][displayName]    ${discount_4.name}
    And Response body parameter should be:    [included][0][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [included][0][attributes][expirationDateTime]
    And Response body parameter should be:    [included][0][attributes][discountPromotionAbstractSku]    None
    And Response body parameter should be:    [included][0][attributes][discountPromotionQuantity]    None
    And Response include element has self link:    vouchers


Add_voucher_code_to_guest_user_cart_including_vouchers
    [Setup]    Run Keywords     Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount_concrete_product.sku_with_voucher_code}    1
    ...    AND    Get voucher code by discountId from Database:    ${discount_voucher_type_id}
    When I send a POST request:    /guest-carts/${guest_cart_id}/vouchers?include=vouchers      {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should be:    [data][id]    ${guest_cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    #relationships
    And Response body parameter should be:    [data][relationships][vouchers][data][0][type]    vouchers
    And Response body parameter should be:    [data][relationships][vouchers][data][0][id]    ${discount_voucher_code}
    And Response should contain the array of a certain size:    [data][relationships][vouchers][data]    1
    #included
    And Response include should contain certain entity type:    vouchers
    And Response body parameter should be:    [included][0][id]    ${discount_voucher_code}
    And Response body parameter should be greater than:    [included][0][attributes][amount]    0
    And Response body parameter should be:    [included][0][attributes][code]    ${discount_voucher_code}
    And Response body parameter should be:    [included][0][attributes][discountType]    voucher
    And Response body parameter should be:    [included][0][attributes][displayName]    ${discount_4.name}
    And Response body parameter should be:    [included][0][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [included][0][attributes][expirationDateTime]
    And Response body parameter should be:    [included][0][attributes][discountPromotionAbstractSku]    None
    And Response body parameter should be:    [included][0][attributes][discountPromotionQuantity]    None
    And Response include element has self link:    vouchers
    [Teardown]    Cleanup all items in the guest cart:    ${guest_cart_id}

#DELETE requests
Delete_voucher_code_from_cart
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    Get voucher code by discountId from Database:    ${discount_voucher_type_id}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${discount_concrete_product.sku_with_voucher_code}","quantity": 1}}}
    ...    AND    I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    When I send a DELETE request:    /carts/${cart_id}/vouchers/${discount_voucher_code}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    And I send a GET request:    /carts/${cart_id}
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    1970

Delete_voucher_code_from_guest_user_cart
    [Setup]    Run Keywords    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount_concrete_product.sku_with_voucher_code}     1
    ...   AND    Get voucher code by discountId from Database:    ${discount_voucher_type_id}
    ...   AND    I send a POST request:    /guest-carts/${guest_cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/vouchers/${discount_voucher_code}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    And I send a GET request:    /guest-carts
    And Response body parameter should be:    [data][0][attributes][totals][discountTotal]    1970
    [Teardown]    Cleanup all items in the guest cart:    ${guest_cart_id} 