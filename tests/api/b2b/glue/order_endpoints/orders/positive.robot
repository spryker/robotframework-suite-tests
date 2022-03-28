*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
#GET requests
Get_order_by_order_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][priceMode]    ${GROSS_MODE}
    #totals
    And Response body parameter should be greater than:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [data][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [data][attributes][totals][remunerationTotal]    0
    #billingAddress
    And Response body parameter should be:    [data][attributes][billingAddress][salutation]    ${yves_user_salutation}
    And Response body parameter should be:    [data][attributes][billingAddress][firstName]    ${yves_user_first_name}
    And Response body parameter should be:    [data][attributes][billingAddress][middleName]    None
    And Response body parameter should be:    [data][attributes][billingAddress][lastName]    ${yves_user_last_name}
    And Response body parameter should be:    [data][attributes][billingAddress][address1]    ${default_address1}
    And Response body parameter should be:    [data][attributes][billingAddress][address2]    ${default_address2}
    And Response body parameter should be:    [data][attributes][billingAddress][address3]    ${default_address3}
    And Response body parameter should be:    [data][attributes][billingAddress][company]    ${default_company}
    And Response body parameter should be:    [data][attributes][billingAddress][city]    ${default_city}
    And Response body parameter should be:    [data][attributes][billingAddress][zipCode]    ${default_zipCode}
    And Response body parameter should be:    [data][attributes][billingAddress][poBox]    None
    And Response body parameter should be:    [data][attributes][billingAddress][phone]    ${default_phone}
    And Response body parameter should be:    [data][attributes][billingAddress][cellPhone]    None
    And Response body parameter should be:    [data][attributes][billingAddress][description]    None
    And Response body parameter should be:    [data][attributes][billingAddress][comment]    None
    And Response body parameter should be:    [data][attributes][billingAddress][email]    None
    And Response body parameter should be:    [data][attributes][billingAddress][country]    ${default_country}
    And Response body parameter should be:    [data][attributes][billingAddress][iso2Code]    ${default_iso2Code}
    #shippingAddress
    And Response body parameter should be:    [data][attributes][shippingAddress][salutation]    ${yves_user_salutation}
    And Response body parameter should be:    [data][attributes][shippingAddress][firstName]    ${yves_user_first_name}
    And Response body parameter should be:    [data][attributes][shippingAddress][middleName]    None
    And Response body parameter should be:    [data][attributes][shippingAddress][lastName]    ${yves_user_last_name}
    And Response body parameter should be:    [data][attributes][shippingAddress][address1]    ${default_address1}
    And Response body parameter should be:    [data][attributes][shippingAddress][address2]    ${default_address2}
    And Response body parameter should be:    [data][attributes][shippingAddress][address3]    ${default_address3}
    And Response body parameter should be:    [data][attributes][shippingAddress][company]    ${default_company}
    And Response body parameter should be:    [data][attributes][shippingAddress][city]    ${default_city}
    And Response body parameter should be:    [data][attributes][shippingAddress][zipCode]    ${default_zipCode}
    And Response body parameter should be:    [data][attributes][shippingAddress][poBox]    None
    And Response body parameter should be:    [data][attributes][shippingAddress][phone]    ${default_phone}
    And Response body parameter should be:    [data][attributes][shippingAddress][cellPhone]    None
    And Response body parameter should be:    [data][attributes][shippingAddress][description]    None
    And Response body parameter should be:    [data][attributes][shippingAddress][comment]    None
    And Response body parameter should be:    [data][attributes][shippingAddress][email]    None
    And Response body parameter should be:    [data][attributes][shippingAddress][country]    ${default_country}
    And Response body parameter should be:    [data][attributes][shippingAddress][iso2Code]    ${default_iso2Code}
    #items
    And Response body parameter should be:    [data][attributes][items][0][name]    ${concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be greater than:    [data][attributes][items][0][sumPrice]    0
    And Response body parameter should be:    [data][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [data][attributes][items][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][sumGrossPrice]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][taxRate]    0
    And Response body parameter should be:    [data][attributes][items][0][unitNetPrice]    0
    And Response body parameter should be:    [data][attributes][items][0][sumNetPrice]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][unitPrice]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][unitTaxAmountFullAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][sumTaxAmountFullAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][refundableAmount]    0
    And Response body parameter should be:    [data][attributes][items][0][canceledAmount]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][sumSubtotalAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][unitSubtotalAggregation]    0
    And Response body parameter should be:    [data][attributes][items][0][unitProductOptionPriceAggregation]    0
    And Response body parameter should be:    [data][attributes][items][0][sumProductOptionPriceAggregation]    0
    And Response body parameter should be:    [data][attributes][items][0][unitExpensePriceAggregation]    0
    And Response body parameter should be:    [data][attributes][items][0][sumExpensePriceAggregation]    None
    And Response body parameter should be greater than:    [data][attributes][items][0][unitDiscountAmountAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][sumDiscountAmountAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][unitDiscountAmountFullAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][sumDiscountAmountFullAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][unitPriceToPayAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][sumPriceToPayAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][taxRateAverageAggregation]    0
    And Response body parameter should be:    [data][attributes][items][0][taxAmountAfterCancellation]    None
    And Response body parameter should be:    [data][attributes][items][0][orderReference]    None
    And Response body parameter should not be EMPTY:    [data][attributes][items][0][uuid]
    And Response body parameter should be:    [data][attributes][items][0][isReturnable]    False
    And Response body parameter should be greater than:    [data][attributes][items][0][idShipment]    0
    And Response body parameter should be:    [data][attributes][items][0][bundleItemIdentifier]    None
    And Response body parameter should be:    [data][attributes][items][0][relatedBundleItemIdentifier]    None
    And Response should contain the array of a certain size:    [data][attributes][items][0][metadata][superAttributes]    0
    And Response body parameter should not be EMPTY:    [data][attributes][items][0][metadata][image]
    And Response body parameter should be:    [data][attributes][items][0][salesUnit]    None
    And Response body parameter should be greater than:    [data][attributes][items][0][calculatedDiscounts][0][unitAmount]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][calculatedDiscounts][0][sumAmount]    0
    And Response body parameter should not be EMPTY:    [data][attributes][items][0][calculatedDiscounts][0][displayName]
    And Response body parameter should not be EMPTY:    [data][attributes][items][0][calculatedDiscounts][0][description]
    And Response body parameter should be:    [data][attributes][items][0][calculatedDiscounts][0][voucherCode]    None
    And Response body parameter should be:    [data][attributes][items][0][calculatedDiscounts][0][quantity]    1
    And Response should contain the array of a certain size:    [data][attributes][items][0][productOptions]    0
    And Response body parameter should be:    [data][attributes][items][0][amount]    None
    #expenses
    And Response body parameter should be:    [data][attributes][expenses][0][type]    SHIPMENT_EXPENSE_TYPE
    And Response body parameter should be:    [data][attributes][expenses][0][name]    ${shipment_method_name}
    And Response body parameter should be greater than:    [data][attributes][expenses][0][sumPrice]    0
    And Response body parameter should be greater than:    [data][attributes][expenses][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [data][attributes][expenses][0][sumGrossPrice]    0
    And Response body parameter should be greater than:    [data][attributes][expenses][0][taxRate]    0
    And Response body parameter should be:    [data][attributes][expenses][0][unitNetPrice]    0
    And Response body parameter should be:    [data][attributes][expenses][0][sumNetPrice]    0
    And Response body parameter should be:    [data][attributes][expenses][0][canceledAmount]    None
    And Response body parameter should be:    [data][attributes][expenses][0][unitDiscountAmountAggregation]    None
    And Response body parameter should be:    [data][attributes][expenses][0][sumDiscountAmountAggregation]    None
    And Response body parameter should be greater than:    [data][attributes][expenses][0][unitTaxAmount]    0
    And Response body parameter should be greater than:    [data][attributes][expenses][0][sumTaxAmount]    0
    And Response body parameter should be greater than:    [data][attributes][expenses][0][unitPriceToPayAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][expenses][0][sumPriceToPayAggregation]    0
    And Response body parameter should be:    [data][attributes][expenses][0][taxAmountAfterCancellation]    None
    And Response body parameter should be greater than:    [data][attributes][expenses][0][idShipment]    0
    And Response body parameter should be greater than:    [data][attributes][expenses][0][idSalesExpense]    0
    #payments
    And Response body parameter should be greater than:    [data][attributes][payments][0][amount]    0
    And Response body parameter should be:    [data][attributes][payments][0][paymentProvider]    ${payment_provider_name}
    And Response body parameter should be:    [data][attributes][payments][0][paymentMethod]    ${payment_method_name}
    #shipments
    And Response body parameter should be:    [data][attributes][shipments][0][shipmentMethodName]    ${shipment_method_name}
    And Response body parameter should be:    [data][attributes][shipments][0][carrierName]    ${carrier_name}
    And Response body parameter should be:    [data][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [data][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [data][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [data][attributes][shipments][0][currencyIsoCode]    ${currency_code_eur}
    #calculatedDiscounts
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    unitAmount
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    sumAmount
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    displayName
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    description
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    voucherCode
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    quantity
    And Response body has correct self link internal

Get_order_by_order_id_with_bundle_product
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${bundle_product_concrete_sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${bundle_product_concrete_sku}"]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][priceMode]    ${GROSS_MODE}
    #items
    And Response should contain the array of a certain size:    [data][attributes][items]    3
    And Each array element of array in response should contain property with value:    [data][attributes][items]    bundleItemIdentifier    None
    And Each array element of array in response should contain property:    [data][attributes][items]    relatedBundleItemIdentifier
    And Response body parameter should be:    [data][attributes][items][0][name]    ${bundled_product_1_concrete_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${bundled_product_1_concrete_sku}
    And Response body parameter should be:    [data][attributes][items][1][name]    ${bundled_product_2_concrete_name}
    And Response body parameter should be:    [data][attributes][items][1][sku]    ${bundled_product_2_concrete_sku}
    And Response body parameter should be:    [data][attributes][items][2][name]    ${bundled_product_3_concrete_name}
    And Response body parameter should be:    [data][attributes][items][2][sku]    ${bundled_product_3_concrete_sku}
    #bundleItems
    And Response body parameter should be:    [data][attributes][bundleItems][0][name]    ${bundle_product_product_name}
    And Response body parameter should be:    [data][attributes][bundleItems][0][sku]    ${bundle_product_concrete_sku}
    And Response body parameter should be greater than:    [data][attributes][bundleItems][0][sumPrice]    0
    And Response body parameter should be:    [data][attributes][bundleItems][0][quantity]    1
    And Response body parameter should be greater than:    [data][attributes][bundleItems][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [data][attributes][bundleItems][0][sumGrossPrice]    0
    And Response body parameter should be:    [data][attributes][bundleItems][0][taxRate]    None
    And Response body parameter should be:    [data][attributes][bundleItems][0][unitNetPrice]    0
    And Response body parameter should be:    [data][attributes][bundleItems][0][sumNetPrice]    0
    And Response body parameter should be greater than:    [data][attributes][bundleItems][0][unitPrice]    0
    And Response body parameter should be:    [data][attributes][bundleItems][0][unitTaxAmountFullAggregation]    None
    And Response body parameter should be:    [data][attributes][bundleItems][0][sumTaxAmountFullAggregation]    None
    And Response body parameter should be:    [data][attributes][bundleItems][0][refundableAmount]    None
    And Response body parameter should be:    [data][attributes][bundleItems][0][canceledAmount]    None
    And Response body parameter should be greater than:    [data][attributes][bundleItems][0][sumSubtotalAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][bundleItems][0][unitSubtotalAggregation]    0
    And Response body parameter should be:    [data][attributes][bundleItems][0][unitProductOptionPriceAggregation]    None
    And Response body parameter should be:    [data][attributes][bundleItems][0][sumProductOptionPriceAggregation]    None
    And Response body parameter should be:    [data][attributes][bundleItems][0][unitExpensePriceAggregation]    None
    And Response body parameter should be:    [data][attributes][bundleItems][0][sumExpensePriceAggregation]    None
    And Response body parameter should be greater than:    [data][attributes][bundleItems][0][unitDiscountAmountAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][bundleItems][0][sumDiscountAmountAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][bundleItems][0][unitDiscountAmountFullAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][bundleItems][0][sumDiscountAmountFullAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][bundleItems][0][unitPriceToPayAggregation]    0
    And Response body parameter should be greater than:    [data][attributes][bundleItems][0][sumPriceToPayAggregation]    0
    And Response body parameter should be:    [data][attributes][bundleItems][0][taxRateAverageAggregation]    None
    And Response body parameter should be:    [data][attributes][bundleItems][0][taxAmountAfterCancellation]    None
    And Response body parameter should be:    [data][attributes][bundleItems][0][orderReference]    None
    And Response body parameter should be:    [data][attributes][bundleItems][0][uuid]    None
    And Response body parameter should be:    [data][attributes][bundleItems][0][isReturnable]    None
    And Response body parameter should be:    [data][attributes][bundleItems][0][idShipment]    None
    And Response body parameter should be greater than:    [data][attributes][bundleItems][0][bundleItemIdentifier]    0
    And Response body parameter should be:    [data][attributes][bundleItems][0][relatedBundleItemIdentifier]    None
    And Response should contain the array of a certain size:    [data][attributes][bundleItems][0][metadata][superAttributes]    0
    And Response body parameter should not be EMPTY:    [data][attributes][bundleItems][0][metadata][image]
    And Response body parameter should be:    [data][attributes][bundleItems][0][salesUnit]    None
    And Response should contain the array of a certain size:    [data][attributes][bundleItems][0][calculatedDiscounts]    0
    And Response should contain the array of a certain size:    [data][attributes][bundleItems][0][productOptions]    0
    And Response body parameter should be:    [data][attributes][bundleItems][0][amount]    None
    And Response body has correct self link internal

Get_order_by_order_id_with_sales_unit
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a GET request:    /concrete-products/${concrete_product_random_weight_sku}?include=sales-units
    ...  AND    Save value to a variable:    [included][0][id]    sales_unit_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_random_weight_sku}","quantity": 1,"salesUnit": {"id": "${sales_unit_id}","amount": 5}}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_product_random_weight_sku}"]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][priceMode]    ${GROSS_MODE}
    #items
    And Response body parameter should be:    [data][attributes][items][0][name]    ${concrete_product_random_weight_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${concrete_product_random_weight_sku}
    And Response body parameter should be:    [data][attributes][items][0][quantity]    1
    And Response should contain the array of a certain size:    [data][attributes][items]    1
    And Response body parameter should be:    [data][attributes][items][0][salesUnit][conversion]    ${concrete_product_random_weight_conversion}
    And Response body parameter should be:    [data][attributes][items][0][salesUnit][precision]    ${concrete_product_random_weight_precision}
    And Response body parameter should be:    [data][attributes][items][0][salesUnit][productMeasurementUnit][name]    ${packaging_unit_m_name}
    And Response body parameter should be:    [data][attributes][items][0][salesUnit][productMeasurementUnit][code]    ${packaging_unit_m}
    And Response body parameter should be:    [data][attributes][items][0][amount]    ${concrete_product_random_weight_amount}

Get_order_by_order_id_with_different_items_and_quantity
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_options}","quantity": 2}}}
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user_salutation}","email": "${yves_user_email}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentMethodName": "${payment_method_name}","paymentProviderName": "${payment_provider_name}"}],"shipments": [{"items": ["${concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": None},{"items": ["${concrete_product_with_options}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": None}]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][priceMode]    ${GROSS_MODE}
    #items
    And Response should contain the array of a certain size:    [data][attributes][items]    3
    And Response body parameter should be:    [data][attributes][items][0][name]    ${concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [data][attributes][items][0][quantity]    1
    And Response body parameter should be:    [data][attributes][items][1][name]    ${concrete_product_with_options_name}
    And Response body parameter should be:    [data][attributes][items][1][sku]    ${concrete_product_with_options}
    And Response body parameter should be:    [data][attributes][items][1][quantity]    1
    And Response body parameter should be:    [data][attributes][items][2][name]    ${concrete_product_with_options_name}
    And Response body parameter should be:    [data][attributes][items][2][sku]    ${concrete_product_with_options}
    And Response body parameter should be:    [data][attributes][items][2][quantity]    1

Get_order_by_order_id_with_nonsplit_item
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 10}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][priceMode]    ${GROSS_MODE}
    #items
    And Response should contain the array of a certain size:    [data][attributes][items]    1
    And Response body parameter should be:    [data][attributes][items][0][name]    ${concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [data][attributes][items][0][quantity]    10

Get_order_by_order_id_with_net_mode_&_chf_currency_&_express_shipment_method
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${net_mode}","currency": "${currency_code_chf}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 20}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 2},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency_code_chf}
    And Response body parameter should be:    [data][attributes][priceMode]    ${net_mode}
    And Response body parameter should be:    [data][attributes][items][0][name]    ${concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [data][attributes][items][0][quantity]    20
    #shipments
    And Response body parameter should be:    [data][attributes][shipments][0][shipmentMethodName]    ${shipment_method_name_2}
    And Response body parameter should be:    [data][attributes][shipments][0][carrierName]    ${carrier_name}
    And Response body parameter should be:    [data][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [data][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [data][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [data][attributes][shipments][0][currencyIsoCode]    ${currency_code_chf}

Get_order_by_order_id_with_split_shipment
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_options}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user_salutation}","email": "${yves_user_email}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentMethodName": "${payment_method_name}","paymentProviderName": "${payment_provider_name}"}],"shipments": [{"items": ["${concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": "${delivery_date}"},{"items": ["${concrete_product_with_options}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${changed_address1}","address2": "${changed_address2}","address3": "${changed_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${changed_phone}","isDefaultBilling": False,"isDefaultShipping": False},"idShipmentMethod": 4,"requestedDeliveryDate": None}]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][priceMode]    ${GROSS_MODE}
    And Response body parameter should be:    [data][attributes][shippingAddress]    None
    And Response body parameter should be:    [data][attributes][items][0][name]    ${concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [data][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [data][attributes][items][0][idShipment]    0
    And Response body parameter should be:    [data][attributes][items][1][name]    ${concrete_product_with_options_name}
    And Response body parameter should be:    [data][attributes][items][1][sku]    ${concrete_product_with_options}
    And Response body parameter should be:    [data][attributes][items][1][quantity]    1
    And Response body parameter should be greater than:    [data][attributes][items][1][idShipment]    0
    And Response should contain the array of a certain size:    [data][attributes][shipments]    0
    And Response should contain certain number of values:    [data][attributes][expenses]    idShipment    2
    And Response body has correct self link internal

Get_order_by_order_id_with_split_shipment_&_include
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_options}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user_salutation}","email": "${yves_user_email}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentMethodName": "${payment_method_name}","paymentProviderName": "${payment_provider_name}"}],"shipments": [{"items": ["${concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": "${delivery_date}"},{"items": ["${concrete_product_with_options}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${changed_address1}","address2": "${changed_address2}","address3": "${changed_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${changed_phone}","isDefaultBilling": False,"isDefaultShipping": False},"idShipmentMethod": 1,"requestedDeliveryDate": None}]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}?include=order-shipments
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][priceMode]    ${GROSS_MODE}
    And Response body parameter should be:    [data][attributes][shippingAddress]    None
    And Response body parameter should be:    [data][attributes][items][0][name]    ${concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [data][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [data][attributes][items][0][idShipment]    0
    And Response body parameter should be:    [data][attributes][items][1][name]    ${concrete_product_with_options_name}
    And Response body parameter should be:    [data][attributes][items][1][sku]    ${concrete_product_with_options}
    And Response body parameter should be:    [data][attributes][items][1][quantity]    1
    And Response body parameter should be greater than:    [data][attributes][items][1][idShipment]    0
    And Response should contain the array of a certain size:    [data][attributes][shipments]    0
    And Response should contain certain number of values:    [data][attributes][expenses]    idShipment    2
    And Response body has correct self link internal
    And Each array element of array in response should contain property with value:    [data][relationships][order-shipments][data]    type    order-shipments
    And Each array element of array in response should contain property:    [data][relationships][order-shipments][data]    id
    And Response should contain the array of a certain size:    [included]    2
    #included 1
    And Response body parameter should be:    [included][0][type]    order-shipments
    And Response body parameter should be greater than:    [included][0][id]    0
    And Response body parameter should not be EMPTY:    [included][0][attributes][itemUuids][0]
    And Response body parameter should be:    [included][0][attributes][methodName]    ${shipment_method_name}
    And Response body parameter should be:    [included][0][attributes][carrierName]    ${carrier_name}
    And Response body parameter should be:    [included][0][attributes][requestedDeliveryDate]    ${delivery_date}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][salutation]    ${yves_user_salutation}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][firstName]    ${yves_user_first_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][lastName]    ${yves_user_last_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address1]    ${default_address1}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address2]    ${default_address2}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address3]    ${default_address3}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][company]    ${default_company}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][city]    ${default_city}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][zipCode]    ${default_zipCode}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][phone]    ${default_phone}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][country]    ${default_country}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][iso2Code]    ${default_iso2Code}
    And Response body parameter should not be EMPTY:    [included][0][links]
    #included 2
    And Response body parameter should be:    [included][1][type]    order-shipments
    And Response body parameter should be greater than:    [included][1][id]    0
    And Response body parameter should not be EMPTY:    [included][1][attributes][itemUuids][0]
    And Response body parameter should be:    [included][1][attributes][methodName]    ${shipment_method_name}
    And Response body parameter should be:    [included][1][attributes][carrierName]    ${carrier_name}
    And Response body parameter should be:    [included][1][attributes][requestedDeliveryDate]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][salutation]    ${yves_user_salutation}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][firstName]    ${yves_user_first_name}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][middleName]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][lastName]    ${yves_user_last_name}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][address1]    ${changed_address1}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][address2]    ${changed_address2}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][address3]    ${changed_address3}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][company]    ${default_company}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][city]    ${default_city}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][zipCode]    ${default_zipCode}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][poBox]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][phone]    ${changed_phone}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][cellPhone]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][description]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][comment]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][email]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][country]    ${default_country}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][iso2Code]    ${default_iso2Code}
    And Response body parameter should not be EMPTY:    [included][1][links]

Get_customer_orders_list_without_order_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    When I send a GET request:    /orders
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:    [data]    type    orders
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain nested property:    [data]    [attributes]    createdAt
    And Each array element of array in response should contain nested property:    [data]    [attributes]    currencyIsoCode
    And Each array element of array in response should contain nested property:    [data]    [attributes]    priceMode
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    expenseTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    discountTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    taxTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    subtotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    grandTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    canceledTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    remunerationTotal
    And Each array element of array in response should contain property:    [data]    links
    And Response body has correct self link

Get_customer_orders_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    When I send a GET request:    /customers/${yves_user_reference}/orders
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:    [data]    type    orders
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain nested property:    [data]    [attributes]    createdAt
    And Each array element of array in response should contain nested property:    [data]    [attributes]    currencyIsoCode
    And Each array element of array in response should contain nested property:    [data]    [attributes]    priceMode
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    expenseTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    discountTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    taxTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    subtotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    grandTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    canceledTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    remunerationTotal
    And Each array element of array in response should contain property:    [data]    links
    And Response body has correct self link

Get_customer_orders_list_without_order_id_with_pagination
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    ...  AND    I send a GET request:    /orders
    ...  AND    Save value to a variable:    [data][2][id]    order_id
    When I send a GET request:    /customers/${yves_user_reference}/orders?page[offset]=2&page[limit]=1
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    1
    And Response body parameter should be:    [data][0][type]    orders
    And Response body parameter should be:    [data][0][id]    ${order_id}
    And Each array element of array in response should contain nested property:    [data]    [attributes]    createdAt
    And Each array element of array in response should contain nested property:    [data]    [attributes]    currencyIsoCode
    And Each array element of array in response should contain nested property:    [data]    [attributes]    priceMode
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    expenseTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    discountTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    taxTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    subtotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    grandTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    canceledTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    remunerationTotal
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body parameter should not be EMPTY:    [links][self]
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][prev]
    And Response body parameter should not be EMPTY:    [links][next]