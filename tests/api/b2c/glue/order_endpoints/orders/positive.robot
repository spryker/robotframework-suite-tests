*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Default Tags    glue
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
ENABLER
    TestSetup
# #GET requests

Get_order_by_order_id
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    #totals
    And Response body parameter should be greater than:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [data][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [data][attributes][totals][remunerationTotal]    0
    #billingAddress
    And Response body parameter should be:    [data][attributes][billingAddress][salutation]    ${yves_user.salutation}
    And Response body parameter should be:    [data][attributes][billingAddress][firstName]    ${yves_user.first_name}
    And Response body parameter should be:    [data][attributes][billingAddress][middleName]    None
    And Response body parameter should be:    [data][attributes][billingAddress][lastName]    ${yves_user.last_name}
    And Response body parameter should be:    [data][attributes][billingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [data][attributes][billingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [data][attributes][billingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [data][attributes][billingAddress][company]    ${default.company}
    And Response body parameter should be:    [data][attributes][billingAddress][city]    ${default.city}
    And Response body parameter should be:    [data][attributes][billingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [data][attributes][billingAddress][poBox]    None
    And Response body parameter should be:    [data][attributes][billingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [data][attributes][billingAddress][cellPhone]    None
    And Response body parameter should be:    [data][attributes][billingAddress][description]    None
    And Response body parameter should be:    [data][attributes][billingAddress][comment]    None
    And Response body parameter should be:    [data][attributes][billingAddress][email]    None
    And Response body parameter should be:    [data][attributes][billingAddress][country]    ${default.country}
    And Response body parameter should be:    [data][attributes][billingAddress][iso2Code]    ${default.iso2Code}
    #shippingAddress
    And Response body parameter should be:    [data][attributes][shippingAddress][salutation]    ${yves_user.salutation}
    And Response body parameter should be:    [data][attributes][shippingAddress][firstName]    ${yves_user.first_name}
    And Response body parameter should be:    [data][attributes][shippingAddress][middleName]    None
    And Response body parameter should be:    [data][attributes][shippingAddress][lastName]    ${yves_user.last_name}
    And Response body parameter should be:    [data][attributes][shippingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [data][attributes][shippingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [data][attributes][shippingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [data][attributes][shippingAddress][company]    ${default.company}
    And Response body parameter should be:    [data][attributes][shippingAddress][city]    ${default.city}
    And Response body parameter should be:    [data][attributes][shippingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [data][attributes][shippingAddress][poBox]    None
    And Response body parameter should be:    [data][attributes][shippingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [data][attributes][shippingAddress][cellPhone]    None
    And Response body parameter should be:    [data][attributes][shippingAddress][description]    None
    And Response body parameter should be:    [data][attributes][shippingAddress][comment]    None
    And Response body parameter should be:    [data][attributes][shippingAddress][email]    None
    And Response body parameter should be:    [data][attributes][shippingAddress][country]    ${default.country}
    And Response body parameter should be:    [data][attributes][shippingAddress][iso2Code]    ${default.iso2Code}
    #items
    And Response body parameter should be:    [data][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
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
    And Response body parameter should be greater than:    [data][attributes][items][0][calculatedDiscounts][0][unitAmount]    0
    And Response body parameter should be greater than:    [data][attributes][items][0][calculatedDiscounts][0][sumAmount]    0
    And Response body parameter should not be EMPTY:    [data][attributes][items][0][calculatedDiscounts][0][displayName]
    And Response body parameter should not be EMPTY:    [data][attributes][items][0][calculatedDiscounts][0][description]
    And Response body parameter should be:    [data][attributes][items][0][calculatedDiscounts][0][voucherCode]    None
    And Response body parameter should be:    [data][attributes][items][0][calculatedDiscounts][0][quantity]    1
    And Response should contain the array of a certain size:    [data][attributes][items][0][productOptions]    0
    #expenses
    And Response body parameter should be:    [data][attributes][expenses][0][type]    SHIPMENT_EXPENSE_TYPE
    And Response body parameter should be:    [data][attributes][expenses][0][name]    ${shipment.method_name}
    And Response body parameter should be greater than:    [data][attributes][expenses][0][sumPrice]    0
    And Response body parameter should be greater than:    [data][attributes][expenses][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [data][attributes][expenses][0][sumGrossPrice]    0
    And Response body parameter should be greater than:    [data][attributes][expenses][0][taxRate]    0
    And Response body parameter should be:    [data][attributes][expenses][0][unitNetPrice]    0
    And Response body parameter should be:    [data][attributes][expenses][0][sumNetPrice]    0
    And Response body parameter should be:    [data][attributes][expenses][0][canceledAmount]    None
    And Response body parameter should be:    [data][attributes][expenses][0][unitDiscountAmountAggregation]    None
    And Response body parameter should be:    [data][attributes][expenses][0][sumDiscountAmountAggregation]    None
    And Response body parameter should contain:    [data][attributes][expenses][0]    unitTaxAmount
    And Response body parameter should contain:    [data][attributes][expenses][0]    sumTaxAmount
    And Response body parameter should contain:    [data][attributes][expenses][0]    unitTaxAmount
    And Response body parameter should contain:    [data][attributes][expenses][0]    unitPriceToPayAggregation
    And Response body parameter should contain:    [data][attributes][expenses][0]    sumPriceToPayAggregation
    And Response body parameter should be:    [data][attributes][expenses][0][taxAmountAfterCancellation]    None
    And Response body parameter should be greater than:    [data][attributes][expenses][0][idShipment]    0
    And Response body parameter should be greater than:    [data][attributes][expenses][0][idSalesExpense]    0
    #payments
    And Response body parameter should be greater than:    [data][attributes][payments][0][amount]    0
    And Response body parameter should be:    [data][attributes][payments][0][paymentProvider]    ${payment.provider_name}
    And Response body parameter should be:    [data][attributes][payments][0][paymentMethod]    ${payment.method_name}
    #shipments
    And Response body parameter should be:    [data][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name}
    And Response body parameter should be:    [data][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [data][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [data][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [data][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [data][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}
    #calculatedDiscounts
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    unitAmount
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    sumAmount
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    displayName
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    description
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    voucherCode
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    quantity
    And Response body has correct self link internal

Get_order_by_order_id_with_bundle_product
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${bundle_product.concrete_sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${bundle_product.concrete_sku}"]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    #items
    And Response should contain the array of a certain size:    [data][attributes][items]    3
    And Each array element of array in response should contain property with value:    [data][attributes][items]    bundleItemIdentifier    ${None}
    And Each array element of array in response should contain property:    [data][attributes][items]    relatedBundleItemIdentifier
    And Response body parameter should be:    [data][attributes][items][0][name]    ${bundled.product_1.concrete_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${bundled.product_1.concrete_sku}
    And Response body parameter should be:    [data][attributes][items][1][name]    ${bundled.product_2.concrete_name}
    And Response body parameter should be:    [data][attributes][items][1][sku]    ${bundled.product_2.concrete_sku}
    And Response body parameter should be:    [data][attributes][items][2][name]    ${bundled.product_3.concrete_name}
    And Response body parameter should be:    [data][attributes][items][2][sku]    ${bundled.product_3.concrete_sku}
    #bundleItems
    And Response body parameter should be:    [data][attributes][bundleItems][0][name]    ${bundle_product.product_name}
    And Response body parameter should be:    [data][attributes][bundleItems][0][sku]    ${bundle_product.concrete_sku}
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
    And Response should contain the array of a certain size:    [data][attributes][bundleItems][0][calculatedDiscounts]    0
    And Response should contain the array of a certain size:    [data][attributes][bundleItems][0][productOptions]    0
    And Response body has correct self link internal



Get_customer_orders_list_without_order_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"]}}}
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


Get_customer_orders_list_without_order_id_with_pagination
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"]}}}
    ...  AND    I send a GET request:    /orders
    ...  AND    Save value to a variable:    [data][2][id]    order_id
    When I send a GET request:    /customers/${yves_user.reference}/orders?page[offset]=2&page[limit]=1
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



Get_order_by_order_id_with_different_items_and_quantity
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product.with_options.sku}","quantity": 2}}}
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user.salutation}","email": "${yves_user.email}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentMethodName": "${payment.method_name}","paymentProviderName": "${payment.provider_name}"}],"shipments": [{"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": None},{"items": ["${concrete_product.with_options.sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": None}]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    #items
    And Response should contain the array of a certain size:    [data][attributes][items]    3
    And Response body parameter should be:    [data][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    And Response body parameter should be:    [data][attributes][items][0][quantity]    1
    And Response body parameter should be:    [data][attributes][items][1][name]    ${concrete_product.with_options.name}
    And Response body parameter should be:    [data][attributes][items][1][sku]    ${concrete_product.with_options.sku}
    And Response body parameter should be:    [data][attributes][items][1][quantity]    1
    And Response body parameter should be:    [data][attributes][items][2][name]    ${concrete_product.with_options.name}
    And Response body parameter should be:    [data][attributes][items][2][sku]    ${concrete_product.with_options.sku}
    And Response body parameter should be:    [data][attributes][items][2][quantity]    1




Get_order_by_order_id_with_nonsplit_item
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 10}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    #items
    And Response should contain the array of a certain size:    [data][attributes][items]    1
    And Response body parameter should be:    [data][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    And Response body parameter should be:    [data][attributes][items][0][quantity]    10



Get_order_by_order_id_with_net_mode_&_chf_currency_&_express_shipment_method
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 20}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 2},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    And Response body parameter should be:    [data][attributes][items][0][quantity]    20
    #shipments
    And Response body parameter should be:    [data][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name_2}
    And Response body parameter should be:    [data][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [data][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [data][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [data][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [data][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}




Get_order_by_order_id_with_split_shipment
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product.with_options.sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user.salutation}","email": "${yves_user.email}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentMethodName": "${payment.method_name}","paymentProviderName": "${payment.provider_name}"}],"shipments": [{"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": "${shipment.delivery_date}"},{"items": ["${concrete_product.with_options.sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${changed.phone}","isDefaultBilling": False,"isDefaultShipping": False},"idShipmentMethod": 4,"requestedDeliveryDate": None}]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][shippingAddress]    None
    And Response body parameter should be:    [data][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    And Response body parameter should be:    [data][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [data][attributes][items][0][idShipment]    0
    And Response body parameter should be:    [data][attributes][items][1][name]    ${concrete_product.with_options.name}
    And Response body parameter should be:    [data][attributes][items][1][sku]    ${concrete_product.with_options.sku}
    And Response body parameter should be:    [data][attributes][items][1][quantity]    1
    And Response body parameter should be greater than:    [data][attributes][items][1][idShipment]    0
    And Response should contain the array of a certain size:    [data][attributes][shipments]    0
    And Response should contain certain number of values:    [data][attributes][expenses]    idShipment    2
    And Response body has correct self link internal



Get_order_by_order_id_with_split_shipment_&_include
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product.with_options.sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user.salutation}","email": "${yves_user.email}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentMethodName": "${payment.method_name}","paymentProviderName": "${payment.provider_name}"}],"shipments": [{"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": "${shipment.delivery_date}"},{"items": ["${concrete_product.with_options.sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${changed.phone}","isDefaultBilling": False,"isDefaultShipping": False},"idShipmentMethod": 1,"requestedDeliveryDate": None}]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}?include=order-shipments
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should be:    [data][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][shippingAddress]    None
    And Response body parameter should be:    [data][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [data][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    And Response body parameter should be:    [data][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [data][attributes][items][0][idShipment]    0
    And Response body parameter should be:    [data][attributes][items][1][name]    ${concrete_product.with_options.name}
    And Response body parameter should be:    [data][attributes][items][1][sku]    ${concrete_product.with_options.sku}
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
    And Response body parameter should be:    [included][0][attributes][methodName]    ${shipment.method_name}
    And Response body parameter should be:    [included][0][attributes][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][0][attributes][requestedDeliveryDate]    ${shipment.delivery_date}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][salutation]    ${yves_user.salutation}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][firstName]    ${yves_user.first_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][lastName]    ${yves_user.last_name}
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
    And Response body parameter should not be EMPTY:    [included][0][links]
    #included 2
    And Response body parameter should be:    [included][1][type]    order-shipments
    And Response body parameter should be greater than:    [included][1][id]    0
    And Response body parameter should not be EMPTY:    [included][1][attributes][itemUuids][0]
    And Response body parameter should be:    [included][1][attributes][methodName]    ${shipment.method_name}
    And Response body parameter should be:    [included][1][attributes][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][1][attributes][requestedDeliveryDate]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][salutation]    ${yves_user.salutation}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][firstName]    ${yves_user.first_name}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][middleName]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][lastName]    ${yves_user.last_name}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][address1]    ${changed.address1}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][address2]    ${changed.address2}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][address3]    ${changed.address3}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][poBox]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][phone]    ${changed.phone}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][cellPhone]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][description]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][comment]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][email]    None
    And Response body parameter should be:    [included][1][attributes][shippingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][1][attributes][shippingAddress][iso2Code]    ${default.iso2Code}
    And Response body parameter should not be EMPTY:    [included][1][links]



Get_customer_orders_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"]}}}
    When I send a GET request:    /customers/${yves_user.reference}/orders
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

Get_order_by_order_id_with_free_shipping_discount
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    I send a POST request:    /carts/${cartId}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 3}}}
    ...  AND    Save value to a variable:    [included][0][id]    item_shipping_order
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_shipping_order}"]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    orders
    And Response body parameter should be:    [data][id]    ${order_id}
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    ${discount.discount_1.total_sum}
    And Response body parameter should be greater than:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    7800
    And Save value to a variable:    [data][attributes][totals][discountTotal]    discount_total_sum
    And Save value to a variable:    [data][attributes][totals][subtotal]    sub_total_sum
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${sub_total_sum}    -    ${discount_total_sum}
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${grand_total_sum}    +    ${discount.discount_1.total_sum}
    And Response body parameter with rounding should be:    [data][attributes][totals][grandTotal]    ${grand_total_sum}
    And Response body parameter should be:    [data][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [data][attributes][totals][remunerationTotal]    0
    And Response should contain the array of a certain size:    [data][attributes][items]    3
    #shipments
    And Response body parameter should be:    [data][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name}
    And Response body parameter should be:    [data][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [data][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be:    [data][attributes][shipments][0][defaultGrossPrice]    ${discount.discount_1.total_sum}
    And Response body parameter should be:    [data][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [data][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}
    #calculatedDiscounts - "Free standard delivery" discount
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    unitAmount: None
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    sumAmount: ${discount.discount_1.total_sum}
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    displayName: ${discount.discount_1.name}
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    description: ${discount.discount_1.description}
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    voucherCode: None
    And Response body parameter should contain:    [data][attributes][calculatedDiscounts]    quantity: 1