*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue

*** Test Cases ***
## Important CHECKOUT and CHECKOUT-DATA endpoints require Item ID and NOT intem sku. To get item id add include to the cart endpoint.
## Example:  
##I send a POST request:    /carts/${cartId}/items?include=items   {"data": {"type": "items","attributes": {"sku": "${concrete_product.random_weight.sku}","quantity": 1,"salesUnit": {"id": "${sales_unit_id}","amount": 5}}}}
## Save value to a variable:    [included][0][id]    test
## I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${test}"]}}}
 
#POST requests
Create_order
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Cleanup all customer carts
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_second_user.email}","salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal

Create_order_include_orders
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
     ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
  ...  AND    Response status code should be:    201
  ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_second_user.email}","salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [data][relationships][orders][data][0][type]    orders
    And Response body parameter should contain:    [data][relationships][orders][data][0][id]    ${store.de}--
    And Response body parameter should be:    [included][0][type]    orders
    And Response body parameter should contain:    [included][0][id]    ${store.de}--
    And Response body parameter should not be EMPTY:    [included][0][attributes][createdAt]
    And Response body parameter should be:    [included][0][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [included][0][attributes][priceMode]    ${mode.gross}
    #totals
    And Response body parameter should be greater than:    [included][0][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][remunerationTotal]    0
    #billingAddress
    And Response body parameter should be:    [included][0][attributes][billingAddress][salutation]    ${yves_second_user.salutation}
    And Response body parameter should be:    [included][0][attributes][billingAddress][firstName]    ${yves_second_user.first_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][lastName]    ${yves_second_user.last_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][billingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][billingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][billingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][billingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][billingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][billingAddress][iso2Code]    ${default.iso2Code}
    #shippingAddress
    And Response body parameter should be:    [included][0][attributes][shippingAddress][salutation]    ${yves_second_user.salutation}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][firstName]    ${yves_second_user.first_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][lastName]    ${yves_second_user.last_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][iso2Code]    ${default.iso2Code}
    #items
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock}
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
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][metadata][superAttributes]    1
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][metadata][image]
    And Each array element of array in response should contain property:    [included][0][attributes][items]    calculatedDiscounts
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][productOptions]    0
    #expenses
    And Response body parameter should be:    [included][0][attributes][expenses][0][type]    SHIPMENT_EXPENSE_TYPE
    And Response body parameter should be:    [included][0][attributes][expenses][0][name]    ${shipment.method_name_1}
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][taxRate]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][canceledAmount]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitDiscountAmountAggregation]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumDiscountAmountAggregation]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitTaxAmount]    78
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumTaxAmount]    78
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitPriceToPayAggregation]    490
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumPriceToPayAggregation]    490
    And Response body parameter should be:    [included][0][attributes][expenses][0][taxAmountAfterCancellation]    None
    And Response body parameter should not be EMPTY:    [included][0][attributes][expenses][0][idShipment]
    And Response body parameter should not be EMPTY:    [included][0][attributes][expenses][0][idSalesExpense]
    #payments
    And Response body parameter should be greater than:    [included][0][attributes][payments][0][amount]    0
    And Response body parameter should be:    [included][0][attributes][payments][0][paymentProvider]    ${payment.provider_name_1}
    And Response body case-insensitive parameter should be:    [included][0][attributes][payments][0][paymentMethod]    ${payment.method_name}
    #shipments
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name_1}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}
    #calculatedDiscounts
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity

Create_order_with_net_mode_&_chf_currency_&_express_shipment_method
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.net}","currency":"${currency.chf.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 12}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_second_user.email}","salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 5},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal

Create_order_with_split_shipments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items   {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    Save value to a variable:    [included][0][id]    concrete_product_1
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items   {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    Save value to a variable:    [included][1][id]    concrete_product_2
    ...  AND    Response body parameter should be:    [data][type]    carts
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_second_user.email}","salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipments": [{"items": ["${concrete_product_1}"],"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": null},{"items": ["${concrete_product_2}"],"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${changed.phone}","isDefaultBilling": false,"isDefaultShipping": false},"idShipmentMethod": 1,"requestedDeliveryDate": null}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [included][0][attributes][items][0][idShipment]    0
    And Response body parameter should be:    [included][0][attributes][items][1][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku_name}
    And Response body parameter should be:    [included][0][attributes][items][1][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    And Response body parameter should be:    [included][0][attributes][items][1][quantity]    1
    And Response body parameter should be greater than:    [included][0][attributes][items][1][idShipment]    0
    And Response should contain the array of a certain size:    [included][0][attributes][shipments]    0
    And Response should contain certain number of values:    [included][0][attributes][expenses]    idShipment    2

Create_order_with_split_shipments_&_same_shipping_address
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
     ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
  ...  AND    Response status code should be:    201
  ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    Save value to a variable:    [included][0][id]    concrete_product_1
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items   {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    Save value to a variable:    [included][1][id]    concrete_product_2
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_second_user.salutation}","email": "${yves_second_user.email}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentMethodName": "${payment.method_name}","paymentProviderName": "${payment.provider_name_1}","paymentSelection": "${payment.selection_name}"}],"shipments": [{"items": ["${concrete_product_1}"],"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": null},{"items": ["${concrete_product_2}"],"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": null}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    And Response body parameter should be:    [included][0][attributes][items][1][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku_name}
    And Response body parameter should be:    [included][0][attributes][items][1][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    And Response body parameter should be:    [included][0][attributes][items][1][quantity]    1
    And Response should contain certain number of values:    [included][0][attributes]    shipments    1
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name_1}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}


Create_order_with_same_items_in_different_shipments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
     ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
  ...  AND    Response status code should be:    201
  ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    Save value to a variable:    [included][0][id]    concrete_product_1
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_second_user.salutation}","email": "${yves_second_user.email}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentMethodName": "${payment.method_name}","paymentProviderName": "${payment.provider_name_1}","paymentSelection": "${payment.selection_name}"}],"shipments": [{"items": ["${concrete_product_1}"],"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": null},{"items": ["${concrete_product_1}"],"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${changed.phone}","isDefaultBilling": false,"isDefaultShipping": false},"idShipmentMethod": 1,"requestedDeliveryDate": null}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [included][0][attributes][items][0][idShipment]    0
    And Response should contain certain number of values:    [included][0][attributes]    shipments    1
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name_1}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}
    And Response should contain certain number of values:    [included][0][attributes][expenses]    idShipment    1

Create_order_with_free_shipping_discount
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 5}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_second_user.email}","salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": ${shipment.method_1.id}},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should be:    [included][0][attributes][totals][expenseTotal]    ${shipment.method_1.price_eur}
    And Response body parameter should be greater than:    [included][0][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][subtotal]    49000
    And Save value to a variable:    [included][0][attributes][totals][discountTotal]    discount_total_sum
    And Save value to a variable:    [included][0][attributes][totals][subtotal]    sub_total_sum
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${sub_total_sum}    -    ${discount_total_sum}
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${grand_total_sum}    +    ${discount_3.total_sum}
    And Response body parameter with rounding should be:    [included][0][attributes][totals][grandTotal]    ${grand_total_sum}
    And Response body parameter should be:    [included][0][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][remunerationTotal]    0
    And Response should contain the array of a certain size:    [included][0][attributes][items]    5
    #shipments
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_1.name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${shipment.method_1.carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultGrossPrice]    ${shipment.method_1.price_eur}
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}
    #calculatedDiscounts - "Free standard delivery" discount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount: None
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount: ${shipment.method_1.price_eur}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName: ${discount_3.name}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description: ${discount_3.description}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode: None
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity: 1

Create_order_with_2_product_discounts
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Cleanup all customer carts
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${discount_concrete_product.product_1.sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${discount_concrete_product.product_2.sku}","quantity": 1}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_second_user.email}","salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock}", "${discount_concrete_product.product_2.sku}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body has correct self link internal
    And Save value to a variable:    [included][0][attributes][totals][expenseTotal]    expense_total_sum
    And Save value to a variable:    [included][0][attributes][totals][discountTotal]    discount_total_sum
    And Save value to a variable:    [included][0][attributes][totals][subtotal]    sub_total_sum
    #discountTotal
    And Perform arithmetical calculation with two arguments:    discount_total_sum    ${discount_1.total_sum_for_discounts_for_products_1_and_2}    +    ${discount_2.total_sum_for_discounts_for_products_1_2}
    And Perform arithmetical calculation with two arguments:    discount_total_sum    ${discount_total_sum}    +    ${discount_3.total_sum_for_discounts_for_products_1_2}
    And Response body parameter with rounding should be:    [included][0][attributes][totals][discountTotal]    ${discount_total_sum}
    #grandTotal
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${sub_total_sum}    -    ${discount_total_sum}
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${grand_total_sum}    +    ${expense_total_sum}
    And Response body parameter with rounding should be:    [included][0][attributes][totals][grandTotal]    ${grand_total_sum}
    #item 1 - "10% off minimum order" and "20% off cameras" discounts
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][calculatedDiscounts]    2
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be in:    [included][0][attributes][items][0][calculatedDiscounts][0][unitAmount]    ${discount_concrete_product.product_1.discount_20_percentage_off_cameras_amount}    ${discount_concrete_product.product_1.discount_10_percentage_off_above_100_amount}
    And Response body parameter should be in:    [included][0][attributes][items][0][calculatedDiscounts][0][sumAmount]    ${discount_concrete_product.product_1.discount_20_percentage_off_cameras_amount}    ${discount_concrete_product.product_1.discount_10_percentage_off_above_100_amount}
    And Response body parameter should be in:    [included][0][attributes][items][0][calculatedDiscounts][0][displayName]    ${discount_1.name}    ${discount_2.name}
    And Response body parameter should be in:    [included][0][attributes][items][0][calculatedDiscounts][0][description]    ${discount_1.description}    ${discount_2.description}
    And Response body parameter should be:    [included][0][attributes][items][0][calculatedDiscounts][0][voucherCode]    None
    And Response body parameter should be:    [included][0][attributes][items][0][calculatedDiscounts][0][quantity]    1
    #item 2 - "10% off minimum order" and "20% off cameras" discounts
    And Response should contain the array of a certain size:    [included][0][attributes][items][1][calculatedDiscounts]    2
    And Response body parameter should be:    [included][0][attributes][items][1][name]    ${discount_concrete_product.product_2.name}
    And Response body parameter should be:    [included][0][attributes][items][1][sku]    ${discount_concrete_product.product_2.sku}
    And Response body parameter should be in:    [included][0][attributes][items][1][calculatedDiscounts][0][unitAmount]    ${discount_concrete_product.product_2.discount_20_percentage_off_cameras_amount}    ${discount_concrete_product.product_2.discount_10_percentage_off_above_100_amount}
    And Response body parameter should be in:    [included][0][attributes][items][1][calculatedDiscounts][0][sumAmount]    ${discount_concrete_product.product_2.discount_20_percentage_off_cameras_amount}    ${discount_concrete_product.product_2.discount_10_percentage_off_above_100_amount}
    And Response body parameter should be in:    [included][0][attributes][items][1][calculatedDiscounts][0][displayName]    ${discount_1.name}    ${discount_2.name}
    And Response body parameter should be in:    [included][0][attributes][items][1][calculatedDiscounts][0][description]    ${discount_1.description}    ${discount_2.description}
    And Response body parameter should be:    [included][0][attributes][items][1][calculatedDiscounts][0][voucherCode]    None
    And Response body parameter should be:    [included][0][attributes][items][1][calculatedDiscounts][0][quantity]    1
    #item 2 - "10% off minimum order" discount
    And Response body parameter should be in:    [included][0][attributes][items][1][calculatedDiscounts][0][unitAmount]    ${discount_concrete_product.product_2.discount_20_percentage_off_cameras_amount}    ${discount_concrete_product.product_2.discount_10_percentage_off_above_100_amount}
    And Response body parameter should be in:    [included][0][attributes][items][1][calculatedDiscounts][0][sumAmount]    ${discount_concrete_product.product_2.discount_20_percentage_off_cameras_amount}    ${discount_concrete_product.product_2.discount_10_percentage_off_above_100_amount}
    And Response body parameter should be in:    [included][0][attributes][items][1][calculatedDiscounts][1][displayName]    ${discount_1.name}    ${discount_2.name}
    And Response body parameter should be in:    [included][0][attributes][items][1][calculatedDiscounts][1][description]    ${discount_1.description}    ${discount_2.description}
    And Response body parameter should be:    [included][0][attributes][items][1][calculatedDiscounts][1][voucherCode]    None
    And Response body parameter should be:    [included][0][attributes][items][1][calculatedDiscounts][1][quantity]    1
    #calculatedDiscounts - "20% off storage" discount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount: None
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount: ${discount_1.total_sum_for_discounts_for_products_1_and_2}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName: ${discount_1.name}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description: ${discount_1.description}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode: None
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity: 2
    #calculatedDiscounts - "10% off minimum order" discount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount: None
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount: ${discount_2.total_sum_for_discounts_for_products_1_2}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName: ${discount_2.name}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description: ${discount_2.description}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode: None
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity: 2
    #calculatedDiscounts - "Free standard delivery" discount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount: None
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount: ${discount_3.total_sum_for_discounts_for_products_1_2}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName: ${discount_3.name}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description: ${discount_3.description}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode: None
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity: 1 

Create_order_with_configurable_bundle_item
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Cleanup all customer carts
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    Response status code should be:    201
    ...  AND    I send a POST request:    /carts/${cart_id}/configured-bundles?include=items    {"data": {"type": "configured-bundles","attributes": {"quantity": ${configured_bundle_quantity},"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle_first_slot_item_sku2}","quantity": 10,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_second_user.email}","salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${configurable_bundle_first_slot_item_sku}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [data][relationships][orders][data][0][type]    orders
    And Response body parameter should contain:    [data][relationships][orders][data][0][id]    ${store.de}--
    And Response body parameter should be:    [included][0][type]    orders
    And Response body parameter should contain:    [included][0][id]    ${store.de}--
    And Response body parameter should not be EMPTY:    [included][0][attributes][createdAt]
    And Response body parameter should be:    [included][0][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [included][0][attributes][priceMode]    ${mode.gross}
    #totals
    And Response body parameter should be greater than:    [included][0][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][remunerationTotal]    0
    #billingAddress
    And Response body parameter should be:    [included][0][attributes][billingAddress][salutation]    ${yves_second_user.salutation}
    And Response body parameter should be:    [included][0][attributes][billingAddress][firstName]    ${yves_second_user.first_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][lastName]    ${yves_second_user.last_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][billingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][billingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][billingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][billingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][billingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][billingAddress][iso2Code]    ${default.iso2Code}
    #shippingAddress
    And Response body parameter should be:    [included][0][attributes][shippingAddress][salutation]    ${yves_second_user.salutation}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][firstName]    ${yves_second_user.first_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][lastName]    ${yves_second_user.last_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][iso2Code]    ${default.iso2Code}
    #items
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${configurable_bundle_first_slot_item_name2}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${configurable_bundle_first_slot_item_sku2}
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
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][metadata][superAttributes]    1
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][metadata][image]
    And Each array element of array in response should contain property:    [included][0][attributes][items]    calculatedDiscounts
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][productOptions]    0
    #expenses
    And Response body parameter should be:    [included][0][attributes][expenses][0][type]    SHIPMENT_EXPENSE_TYPE
    And Response body parameter should be:    [included][0][attributes][expenses][0][name]    ${shipment.method_name_1}
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][taxRate]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][canceledAmount]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitDiscountAmountAggregation]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumDiscountAmountAggregation]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitTaxAmount]    78
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumTaxAmount]    78
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitPriceToPayAggregation]    490
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumPriceToPayAggregation]    490
    And Response body parameter should be:    [included][0][attributes][expenses][0][taxAmountAfterCancellation]    None
    And Response body parameter should not be EMPTY:    [included][0][attributes][expenses][0][idShipment]
    And Response body parameter should not be EMPTY:   [included][0][attributes][expenses][0][idSalesExpense]
    #payments
    And Response body parameter should be greater than:    [included][0][attributes][payments][0][amount]    0
    And Response body parameter should be:    [included][0][attributes][payments][0][paymentProvider]    ${payment.provider_name_1}
    And Response body case-insensitive parameter should be:    [included][0][attributes][payments][0][paymentMethod]    ${payment.method_name}
    #shipments
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name_1}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}
    #calculatedDiscounts
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity

Create_checkout_with_gift_card
    [Tags]    skip-due-to-issue
    [Documentation]    bug https://spryker.atlassian.net/browse/CC-21301
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    Create giftcode in Database:    checkout_${random}    ${gift_card.amount}
    ...  AND    I send a POST request:    /carts/${cart_id}/cart-codes?include=vouchers,gift-cards    {"data": {"type": "cart-codes","attributes": {"code": "checkout_${random}"}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_second_user.email}","salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    AND Response body parameter should not be EMPTY:    [data][attributes][orderReference]
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [data][relationships][orders][data][0][type]    orders
    And Response body parameter should contain:    [data][relationships][orders][data][0][id]    ${store.de}--
    And Response body parameter should be:    [included][0][type]    orders
    And Response body parameter should contain:    [included][0][id]    ${store.de}--
    And Response body parameter should not be EMPTY:    [included][0][attributes][createdAt]
    And Response body parameter should be:    [included][0][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [included][0][attributes][priceMode]    ${mode.gross}
    #totals
    And Response body parameter should be greater than:    [included][0][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][remunerationTotal]    0
    #billingAddress
    And Response body parameter should be:    [included][0][attributes][billingAddress][salutation]    ${yves_second_user.salutation}
    And Response body parameter should be:    [included][0][attributes][billingAddress][firstName]    ${yves_second_user.first_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][lastName]    ${yves_second_user.last_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][billingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][billingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][billingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][billingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][billingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][billingAddress][iso2Code]    ${default.iso2Code}
    #shippingAddress
    And Response body parameter should be:    [included][0][attributes][shippingAddress][salutation]    ${yves_second_user.salutation}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][firstName]    ${yves_second_user.first_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][lastName]    ${yves_second_user.last_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][iso2Code]    ${default.iso2Code}
    #items
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock}
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
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][metadata][superAttributes]    1
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][metadata][image]
    And Each array element of array in response should contain property:    [included][0][attributes][items]    calculatedDiscounts
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][productOptions]    0
    #expenses
    And Response body parameter should be:    [included][0][attributes][expenses][0][type]    SHIPMENT_EXPENSE_TYPE
    And Response body parameter should be:    [included][0][attributes][expenses][0][name]    ${shipment.method_name_1}
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
    And Response body parameter should not be EMPTY:    [included][0][attributes][expenses][0][idShipment]
    And Response body parameter should not be EMPTY:    [included][0][attributes][expenses][0][idSalesExpense]
    #payments
    And Response body parameter should be:    [included][0][attributes][payments][0][amount]    ${gift_card.amount}
    And Response body parameter should be:    [included][0][attributes][payments][0][paymentProvider]    ${gift_card.paymentProvider}
    And Response body case-insensitive parameter should be:    [included][0][attributes][payments][0][paymentMethod]    ${gift_card.paymentMethod}
    And Response body parameter should be greater than:    [included][0][attributes][payments][1][amount]    0
    And Response body parameter should be:    [included][0][attributes][payments][1][paymentProvider]    ${payment.provider_name_1}
    And Response body case-insensitive parameter should be:    [included][0][attributes][payments][1][paymentMethod]    ${payment.method_name}
    #shipments
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name_1}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}
    #calculatedDiscounts
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity
    
Create_checkout_with_gift_card_when_gift_amount_partially_used
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_alternative.product_sku1}","quantity": 1}}}
    ...  AND    Create giftcode in Database:    partially_${random}    ${gift_card.amount}
    ...  AND    I send a POST request:    /carts/${cart_id}/cart-codes?include=vouchers,gift-cards    {"data": {"type": "cart-codes","attributes": {"code": "partially_${random}"}}}
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_second_user.email}","salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_product_with_alternative.product_sku1}"]}}}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_alternative.product_sku1}","quantity": 3}}}
    ...  AND    I send a POST request:    /carts/${cart_id}/cart-codes?include=vouchers,gift-cards    {"data": {"type": "cart-codes","attributes": {"code": "partially_${random}"}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_second_user.email}","salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_product_with_alternative.product_sku1}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    AND Response body parameter should not be EMPTY:    [data][attributes][orderReference]
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [data][relationships][orders][data][0][type]    orders
    And Response body parameter should contain:    [data][relationships][orders][data][0][id]    ${store.de}--
    And Response body parameter should be:    [included][0][type]    orders
    And Response body parameter should contain:    [included][0][id]    ${store.de}--
    And Response body parameter should not be EMPTY:    [included][0][attributes][createdAt]
    And Response body parameter should be:    [included][0][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [included][0][attributes][priceMode]    ${mode.gross}
    #totals
    And Response body parameter should be greater than:    [included][0][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][remunerationTotal]    0
    #billingAddress
    And Response body parameter should be:    [included][0][attributes][billingAddress][salutation]    ${yves_second_user.salutation}
    And Response body parameter should be:    [included][0][attributes][billingAddress][firstName]    ${yves_second_user.first_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][lastName]    ${yves_second_user.last_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][billingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][billingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][billingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][billingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][billingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][billingAddress][iso2Code]    ${default.iso2Code}
    #shippingAddress
    And Response body parameter should be:    [included][0][attributes][shippingAddress][salutation]    ${yves_second_user.salutation}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][firstName]    ${yves_second_user.first_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][lastName]    ${yves_second_user.last_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][iso2Code]    ${default.iso2Code}
    #items
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${concrete_product_with_alternative.product_sku1_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${concrete_product_with_alternative.product_sku1}
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
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][metadata][superAttributes]    1
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][metadata][image]
    And Each array element of array in response should contain property:    [included][0][attributes][items]    calculatedDiscounts
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][productOptions]    0
    #expenses
    And Response body parameter should be:    [included][0][attributes][expenses][0][type]    SHIPMENT_EXPENSE_TYPE
    And Response body parameter should be:    [included][0][attributes][expenses][0][name]    ${shipment.method_name_1}
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][taxRate]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][canceledAmount]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitDiscountAmountAggregation]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumDiscountAmountAggregation]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitTaxAmount]    78
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumTaxAmount]    78
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitPriceToPayAggregation]    490
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumPriceToPayAggregation]    490
    And Response body parameter should be:    [included][0][attributes][expenses][0][taxAmountAfterCancellation]    None
    And Response body parameter should not be EMPTY:    [included][0][attributes][expenses][0][idShipment]
    And Response body parameter should not be EMPTY:    [included][0][attributes][expenses][0][idSalesExpense]
    #payments
    And Response body parameter should be:    [included][0][attributes][payments][0][amount]    ${gift_card.amount}
    And Response body parameter should be:    [included][0][attributes][payments][0][paymentProvider]    ${gift_card.paymentProvider}
    And Response body case-insensitive parameter should be:    [included][0][attributes][payments][0][paymentMethod]    ${gift_card.paymentMethod}
    
    And Response body parameter should be greater than:    [included][0][attributes][payments][1][amount]    0
    And Response body parameter should be:    [included][0][attributes][payments][1][paymentProvider]    ${payment.provider_name_1}
    And Response body case-insensitive parameter should be:    [included][0][attributes][payments][1][paymentMethod]    ${payment.method_name}
    #shipments
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name_1}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}
    #calculatedDiscounts
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity

Create_order_with_configurable_product
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...  AND    Cleanup all customer carts
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    Response status code should be:    201
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${configurable_product.sku}","quantity":1,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":1,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Save value to a variable:    [data][id]    CartItemId
    And Response body parameter should be:    [included][0][attributes][sku]    ${configurable_product.sku}
    And Response body parameter should be:    [included][0][attributes][quantity]    1
    And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"}
    And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][isComplete]  True
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_second_user.email}","salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${configurable_product.sku}"]}}}
    And Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [data][relationships][orders][data][0][type]    orders
    And Response body parameter should contain:    [data][relationships][orders][data][0][id]    ${store.de}--
    And Response body parameter should be:    [included][0][type]    orders
    And Response body parameter should contain:    [included][0][id]    ${store.de}--
    And Response body parameter should not be EMPTY:    [included][0][attributes][createdAt]
    And Response body parameter should be:    [included][0][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [included][0][attributes][priceMode]    ${mode.gross}
    #totals
    And Response body parameter should be greater than:    [included][0][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][remunerationTotal]    0
    #billingAddress
    And Response body parameter should be:    [included][0][attributes][billingAddress][salutation]    ${yves_second_user.salutation}
    And Response body parameter should be:    [included][0][attributes][billingAddress][firstName]    ${yves_second_user.first_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][lastName]    ${yves_second_user.last_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][billingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][billingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][billingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][billingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][billingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][billingAddress][iso2Code]    ${default.iso2Code}
    #shippingAddress
    And Response body parameter should be:    [included][0][attributes][shippingAddress][salutation]    ${yves_second_user.salutation}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][firstName]    ${yves_second_user.first_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][lastName]    ${yves_second_user.last_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][iso2Code]    ${default.iso2Code}
    # #items
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${configurable_product.name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${configurable_product.sku}
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
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][metadata][superAttributes]    1
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][metadata][image]
    And Response body parameter should be:    [included][0][attributes][items][0][salesOrderItemConfiguration][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"}
    And Each array element of array in response should contain property:    [included][0][attributes][items]    calculatedDiscounts
    #expenses
    And Response body parameter should be:    [included][0][attributes][expenses][0][type]    SHIPMENT_EXPENSE_TYPE
    And Response body parameter should be:    [included][0][attributes][expenses][0][name]    ${shipment.method_name_1}
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][taxRate]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][canceledAmount]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitDiscountAmountAggregation]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumDiscountAmountAggregation]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][taxAmountAfterCancellation]    None
    And Response body parameter should not be EMPTY:    [included][0][attributes][expenses][0][idShipment]
    And Response body parameter should not be EMPTY:   [included][0][attributes][expenses][0][idSalesExpense]
    #payments
    And Response body parameter should be greater than:    [included][0][attributes][payments][0][amount]    0
    And Response body parameter should be:    [included][0][attributes][payments][0][paymentProvider]    ${payment.provider_name_1}
    And Response body case-insensitive parameter should be:    [included][0][attributes][payments][0][paymentMethod]    ${payment.method_name}
    #shipments
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name_1}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}
    #calculatedDiscounts
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity
