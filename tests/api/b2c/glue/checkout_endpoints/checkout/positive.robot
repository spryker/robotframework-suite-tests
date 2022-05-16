*** Settings ***
Suite Setup    SuiteSetup
Test Setup     TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

#POST requests
Create_order
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store_de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal

Create_order_for_guest_user
    [Setup]    Run Keywords    I set Headers:    X-Anonymous-Customer-Unique-Id=${x_anonymous_prefix}${random}
    ...  AND    I send a POST request:    /guest-cart-items    {"data": { "type": "guest-cart-items", "attributes": {"sku":"${concrete_available_with_stock_and_never_out_of_stock}", "quantity": "1"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store_de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal

Create_order_include_orders
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store_de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal
    #totals
    And Response body parameter should be:    [data][relationships][orders][data][0][type]    orders
    And Response body parameter should contain:    [data][relationships][orders][data][0][id]    ${store_de}--
    And Response body parameter should be:    [included][0][type]    orders
    And Response body parameter should contain:    [included][0][id]    ${store_de}--
    And Response body parameter should not be EMPTY:    [included][0][attributes][createdAt]
    And Response body parameter should be:    [included][0][attributes][currencyIsoCode]    ${currency_code_eur}
    And Response body parameter should be:    [included][0][attributes][priceMode]    ${gross_mode}
    And Response body parameter should be greater than:    [included][0][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][remunerationTotal]    0
    #billingAddress
    And Response body parameter should be:    [included][0][attributes][billingAddress][salutation]    ${yves_user_salutation}
    And Response body parameter should be:    [included][0][attributes][billingAddress][firstName]    ${yves_user_first_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][lastName]    ${yves_user_last_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address1]    ${default_address1}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address2]    ${default_address2}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address3]    ${default_address3}
    And Response body parameter should be:    [included][0][attributes][billingAddress][company]    ${default_company}
    And Response body parameter should be:    [included][0][attributes][billingAddress][city]    ${default_city}
    And Response body parameter should be:    [included][0][attributes][billingAddress][zipCode]    ${default_zipCode}
    And Response body parameter should be:    [included][0][attributes][billingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][phone]    ${default_phone}
    And Response body parameter should be:    [included][0][attributes][billingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][country]    ${default_country}
    And Response body parameter should be:    [included][0][attributes][billingAddress][iso2Code]    ${default_iso2Code}
    #shippingAddress
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
    #items
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumPrice]    0
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][taxRate]    0
    And Response body parameter should be:    [included][0][attributes][items][0][unitNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][items][0][sumNetPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitTaxAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumTaxAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][refundableAmount]    0
    And Response body parameter should be:    [included][0][attributes][items][0][canceledAmount]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumSubtotalAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitSubtotalAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][unitProductOptionPriceAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][sumProductOptionPriceAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][unitExpensePriceAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][sumExpensePriceAggregation]    None
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitDiscountAmountAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumDiscountAmountAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitDiscountAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumDiscountAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitPriceToPayAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumPriceToPayAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][taxRateAverageAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][taxAmountAfterCancellation]    None
    And Response body parameter should be:    [included][0][attributes][items][0][orderReference]    None
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][uuid]
    And Response body parameter should be:    [included][0][attributes][items][0][isReturnable]    False
    And Response body parameter should be greater than:    [included][0][attributes][items][0][idShipment]    0
    And Response body parameter should be:    [included][0][attributes][items][0][bundleItemIdentifier]    None
    And Response body parameter should be:    [included][0][attributes][items][0][relatedBundleItemIdentifier]    None
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][metadata][superAttributes]    0
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][metadata][image]
    And Response body parameter should be greater than:    [included][0][attributes][items][0][calculatedDiscounts][0][unitAmount]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][calculatedDiscounts][0][sumAmount]    0
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][calculatedDiscounts][0][displayName]
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][calculatedDiscounts][0][description]
    And Response body parameter should be:    [included][0][attributes][items][0][calculatedDiscounts][0][voucherCode]    None
    And Response body parameter should be:    [included][0][attributes][items][0][calculatedDiscounts][0][quantity]    1
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][productOptions]    0
    #expenses
    And Response body parameter should be:    [included][0][attributes][expenses][0][type]    SHIPMENT_EXPENSE_TYPE
    And Response body parameter should be:    [included][0][attributes][expenses][0][name]    ${shipment_method_name}
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][taxRate]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][canceledAmount]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitDiscountAmountAggregation]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumDiscountAmountAggregation]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitTaxAmount]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumTaxAmount]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitPriceToPayAggregation]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumPriceToPayAggregation]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][taxAmountAfterCancellation]    None
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][idShipment]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][idSalesExpense]    0
    #payments
    And Response body parameter should be greater than:    [included][0][attributes][payments][0][amount]    0
    And Response body parameter should be:    [included][0][attributes][payments][0][paymentProvider]    ${payment_provider_name}
    And Response body parameter should be:    [included][0][attributes][payments][0][paymentMethod]    ${payment_method_name}
    #shipments
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment_method_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency_code_eur}
    #calculatedDiscounts
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity

Create_order_with_bundle_product
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${bundle_product_concrete_sku}","quantity": 1}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${bundle_product_concrete_sku}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store_de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    #items
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${bundled_product_1_concrete_sku}
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${bundled_product_1_concrete_name}
    And Response body parameter should be:    [included][0][attributes][items][1][sku]    ${bundled_product_2_concrete_sku}
    And Response body parameter should be:    [included][0][attributes][items][1][name]    ${bundled_product_2_concrete_name}
    And Response body parameter should be:    [included][0][attributes][items][2][sku]    ${bundled_product_3_concrete_sku}
    And Response body parameter should be:    [included][0][attributes][items][2][name]    ${bundled_product_3_concrete_name}
    And Response body has correct self link internal

Create_order_with_chf_currency_&_express_shipment_method
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    Save Header value to a variable:    ETag    header_tag
    ...  AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    ...  AND    I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_chf}","store": "${store_de}"}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 20}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 5},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store_de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body parameter should be:    [included][0][attributes][currencyIsoCode]    ${currency_code_chf}
    And Response body parameter should be:    [included][0][attributes][priceMode]    ${gross_mode}
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment_method_name_5}
    And Response body has correct self link internal

Create_order_with_product_options
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_options}","quantity": 1, "productOptions": [{"sku": "${product_option_1}"}]}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}", "${concrete_product_with_options}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store_de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response should contain the array of a certain size:    [included][0][attributes][items]    2
    And Response body has correct self link internal
    #product_1
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][productOptions]    0
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    #product_2
    And Response body parameter should be:    [included][0][attributes][items][1][name]    ${concrete_product_with_options_name}
    And Response body parameter should be:    [included][0][attributes][items][1][sku]    ${concrete_product_with_options}
    And Response body parameter should be:    [included][0][attributes][items][1][productOptions][0][optionGroupName]    Warranty
    And Response body parameter should be:    [included][0][attributes][items][1][productOptions][0][sku]    ${product_option_1}
    And Response body parameter should be:    [included][0][attributes][items][1][productOptions][0][optionName]    ${product_option_1_name}
    And Response body parameter should be greater than:    [included][0][attributes][items][1][productOptions][0][price]    0
    And Response body parameter should be:    [included][0][attributes][items][1][quantity]    1

Create_order_with_split_shipments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_options}","quantity": 1}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user_salutation}","email": "${yves_user_email}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentMethodName": "${payment_method_name}","paymentProviderName": "${payment_provider_name}"}],"shipments": [{"items": ["${concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": "${delivery_date}"},{"items": ["${concrete_product_with_options}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${changed_address1}","address2": "${changed_address2}","address3": "${changed_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${changed_phone}","isDefaultBilling": False,"isDefaultShipping": False},"idShipmentMethod": 4,"requestedDeliveryDate": None}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store_de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [included][0][attributes][items][0][idShipment]    0
    And Response body parameter should be:    [included][0][attributes][items][1][name]    ${concrete_product_with_options_name}
    And Response body parameter should be:    [included][0][attributes][items][1][sku]    ${concrete_product_with_options}
    And Response body parameter should be:    [included][0][attributes][items][1][quantity]    1
    And Response body parameter should be greater than:    [included][0][attributes][items][1][idShipment]    0
    And Response should contain the array of a certain size:    [included][0][attributes][shipments]    0
    And Response should contain certain number of values:    [included][0][attributes][expenses]    idShipment    2

Create_order_with_split_shipments_&_same_shipping_address
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_options}","quantity": 1}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user_salutation}","email": "${yves_user_email}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentMethodName": "${payment_method_name}","paymentProviderName": "${payment_provider_name}"}],"shipments": [{"items": ["${concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": None},{"items": ["${concrete_product_with_options}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": None}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store_de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    And Response body parameter should be:    [included][0][attributes][items][1][name]    ${concrete_product_with_options_name}
    And Response body parameter should be:    [included][0][attributes][items][1][sku]    ${concrete_product_with_options}
    And Response body parameter should be:    [included][0][attributes][items][1][quantity]    1
    And Response should contain certain number of values:    [included][0][attributes]    shipments    1
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment_method_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency_code_eur}

Create_order_with_same_items_in_different_shipments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user_salutation}","email": "${yves_user_email}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentMethodName": "${payment_method_name}","paymentProviderName": "${payment_provider_name}"}],"shipments": [{"items": ["${concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": None},{"items": ["${concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${changed_address1}","address2": "${changed_address2}","address3": "${changed_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${changed_phone}","isDefaultBilling": False,"isDefaultShipping": False},"idShipmentMethod": 1,"requestedDeliveryDate": None}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store_de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [included][0][attributes][items][0][idShipment]    0
    And Response should contain certain number of values:    [included][0][attributes]    shipments    1
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment_method_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency_code_eur}
    And Response should contain certain number of values:    [included][0][attributes][expenses]    idShipment    1

Create_order_with_free_shipping_discount
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 3}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should be:    [included][0][attributes][totals][expenseTotal]    ${discount_1_total_sum}
    And Response body parameter should be greater than:    [included][0][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][subtotal]    20000
    And Save value to a variable:    [included][0][attributes][totals][discountTotal]    discount_total_sum
    And Save value to a variable:    [included][0][attributes][totals][subtotal]    sub_total_sum
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${sub_total_sum}    -    ${discount_total_sum}
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${grand_total_sum}    +    ${discount_1_total_sum}
    And Response body parameter with rounding should be:    [included][0][attributes][totals][grandTotal]    ${grand_total_sum}
    And Response body parameter should be:    [included][0][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][remunerationTotal]    0
    And Response should contain the array of a certain size:    [included][0][attributes][items]    3
    #shipments
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment_method_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultGrossPrice]    ${discount_1_total_sum}
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency_code_eur}
    #calculatedDiscounts - "Free standard delivery" discount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount: None
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount: ${discount_1_total_sum}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName: ${discount_1_name}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description: ${discount_1_description}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode: None
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity: 1