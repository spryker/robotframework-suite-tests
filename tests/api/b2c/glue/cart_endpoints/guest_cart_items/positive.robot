*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Add_items_to_guest_cart_with_items_include
     [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
            ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a POST request:    /guest-cart-items?include=items    {"data": {"type": "guest-cart-items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative.sku}","quantity": 3}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][priceMode]    ${currency.mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    And Response body parameter should be:    [included][0][type]    guest-cart-items
    And Response body parameter should be:    [included][0][id]    ${concrete_product_with_concrete_product_alternative.sku}
    And Response body parameter should be:    [included][0][attributes][sku]    ${concrete_product_with_concrete_product_alternative.sku}
    And Response body parameter should be:    [included][0][attributes][quantity]    4
    And Response body parameter should be:    [included][0][attributes][groupKey]    ${concrete_product_with_concrete_product_alternative.sku}
    And Response body parameter should be:    [included][0][attributes][abstractSku]    ${abstract_product_with_alternative.sku}
    And Response body parameter should be:    [included][0][attributes][amount]    None
    And Response body parameter should be:    [included][0][attributes][configuredBundle]    None
    And Response body parameter should be:    [included][0][attributes][configuredBundleItem]    None
    And Response should contain the array of a certain size:    [included][0][attributes][selectedProductOptions]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][unitPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][sumPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][taxRate]    0
    And Response body parameter should be:    [included][0][attributes][calculations][unitNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][calculations][sumNetPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][unitGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][sumGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][unitTaxAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][sumTaxAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][sumSubtotalAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][unitSubtotalAggregation]    0
    And Response body parameter should be:    [included][0][attributes][calculations][unitProductOptionPriceAggregation]    0
    And Response body parameter should be:    [included][0][attributes][calculations][sumProductOptionPriceAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][unitDiscountAmountAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][sumDiscountAmountAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][unitDiscountAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][sumDiscountAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][unitPriceToPayAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][sumPriceToPayAggregation]    0

Change_item_qty_in_guest_cart
     [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
            ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a PATCH request:    /guest-carts/${guest_cart_id}/guest-cart-items/${concrete_product_with_concrete_product_alternative.sku}?include=items    {"data": {"type": "guest-cart-items","attributes": {"quantity": "10"}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][priceMode]    ${currency.mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    And Response body parameter should be:    [included][0][type]    guest-cart-items
    And Response body parameter should be:    [included][0][attributes][sku]    ${concrete_product_with_concrete_product_alternative.sku}
    And Response body parameter should be:    [included][0][attributes][quantity]    10

Remove_item_from_guest_cart
     [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
            ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/guest-cart-items/${concrete_product_with_concrete_product_alternative.sku}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    And I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    And I send a GET request:    /guest-carts/${guest_cart_id}?include=items
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [data][attributes][totals][priceToPay]    0

Add_items_to_guest_cart_with_included_items_concrete_products_and_abstract_products
     [Setup]    I set Headers:    X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-cart-items?include=items,concrete-products,abstract-products    {"data": {"type": "guest-cart-items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative.sku}","quantity": 1}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][priceMode]    ${currency.mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    #totals
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    #included
    And Response should contain the array of a certain size:    [included]    4
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    abstract-products
    And Response include should contain certain entity type:    guest-cart-items
    And Response include element has self link:   concrete-products
    And Response include element has self link:   abstract-products
    And Response include element has self link:   guest-cart-items
    And Each array element of array in response should a nested array of a certain size:    [included]    [relationships]    1
    And Response should contain the array of a certain size:    [included][0][relationships][abstract-products][data]    1
    And Response should contain the array of a certain size:    [included][1][relationships][abstract-products][data]    1
    And Response should contain the array of a certain size:    [included][2][relationships][concrete-products][data]    2
    And Response should contain the array of a certain size:    [included][3][relationships][concrete-products][data]    1

Add_items_to_guest_cart_with_included_cart_rules
     [Setup]    I set Headers:    X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-cart-items?include=cart-rules    {"data": {"type": "guest-cart-items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative.sku}","quantity": 10}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][priceMode]    ${currency.mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    And Response body parameter should be:    [included][0][type]    cart-rules
    And Response body parameter should not be EMPTY:    [included][0][id]
    And Response body parameter should be greater than:    [included][0][attributes][amount]    0
    And Response body parameter should be:    [included][0][attributes][code]    None
    And Response body parameter should not be EMPTY:    [included][0][attributes][discountType]
    And Response body parameter should not be EMPTY:    [included][0][attributes][displayName]
    And Response body parameter should be:    [included][0][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [included][0][attributes][expirationDateTime]
    And Response body parameter should be:    [included][0][attributes][discountPromotionAbstractSku]    None
    And Response body parameter should be:    [included][0][attributes][discountPromotionQuantity]    None

Add_items_to_guest_cart_with_included_promotional_products
     [Setup]    I set Headers:    X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-cart-items?include=promotional-items    {"data": {"type": "guest-cart-items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative.sku}","quantity": 100}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][priceMode]    ${currency.mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    And Response body parameter should be:    [included][0][type]    promotional-items
    And Response body parameter should not be EMPTY:    [included][0][id]
    And Response body parameter should be:    [included][0][attributes][sku]    ${concrete_product_with_concrete_product_alternative.promotional_items_sku}
    And Response body parameter should be:    [included][0][attributes][quantity]    1
    And Response body parameter should be:    [included][0][attributes][skus]    ${concrete_product_with_concrete_product_alternative.promotional_items_sku}

Add_items_to_guest_cart_with_included_bundle_items
     [Setup]    I set Headers:    X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-cart-items?include=bundle-items,bundled-items    {"data": {"type": "guest-cart-items","attributes": {"sku": "${bundle_product.concrete_sku}","quantity": 1}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][priceMode]    ${currency.mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    And Response should contain the array of a certain size:    [data][relationships][bundle-items][data]    1
    And Response should contain the array of a certain size:    [included]    5
    And Response include should contain certain entity type:    bundle-items
    And Response include should contain certain entity type:    bundled-items
    And Response include element has self link:   bundle-items
    And Response include element has self link:   bundled-items
    And Response body parameter should be:    [included][0][type]    bundled-items
    And Response body parameter should be:    [included][0][attributes][sku]    ${bundled.product_1.concrete_sku}
    And Response body parameter should be:    [included][1][type]    bundled-items
    And Response body parameter should be:    [included][1][attributes][sku]    ${bundled.product_2.concrete_sku}
    And Response body parameter should be:    [included][2][type]    bundled-items
    And Response body parameter should be:    [included][2][attributes][sku]    ${bundled.product_3.concrete_sku}
    And Response body parameter should be:    [included][3][type]    bundle-items
    And Response body parameter should be:    [included][3][attributes][sku]    ${bundle_product.concrete_sku}
    And Response body parameter should be:    [included][3][attributes][quantity]    1
    And Response body parameter should be:    [included][3][attributes][groupKey]    ${bundle_product.concrete_sku}
    And Response body parameter should be:    [included][3][attributes][abstractSku]    ${bundle_product.abstract_sku}