*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue

*** Test Cases ***
### Important CHECKOUT and CHECKOUT-DATA endpoints require Item ID and NOT intem sku. To get item id and include to the cart endpoint.
### Example:  
###I send a POST request:    /carts/${cartId}/items?include=items   {"data": {"type": "items","attributes": {"sku": "${concrete_product.random_weight.sku}","quantity": 1,"salesUnit": {"id": "${sales_unit_id}","amount": 5}}}}
### Save value to a variable:    [included][0][id]    test
### I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${test}"]}}}
 
#POST requests
Provide_checkout_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][id]    1
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][name]    ${shipment.method_name_1}
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be greater than:    [data][attributes][selectedShipmentMethods][0][price]    0
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][taxRate]    None
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][deliveryTime]    None
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][currencyIsoCode]    ${currency.eur.code}
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Provide_checkout_with_only_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data", "attributes": {"idCart": "${cart_id}","payments": []}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response should contain the array of a certain size:    [data][attributes][selectedShipmentMethods]    0
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Provide_checkout_data_with_invalid_billing_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "fake_salutation","firstName": "fake_first_name","lastName": "fake_last_name","address1": "fake_address1","address2": "fake_address2","address3": "fake_address3","zipCode": "fake_zipCode","city": "fake_city","iso2Code": "fake_iso2Code","company": "fake_company","phone": "fake_phone","isDefaultBilling": true,"isDefaultShipping": true},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][id]    1
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][name]    ${shipment.method_name_1}
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be greater than:    [data][attributes][selectedShipmentMethods][0][price]    0
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][taxRate]    None
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][deliveryTime]    None
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][currencyIsoCode]    ${currency.eur.code}
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Provide_checkout_data_with_invalid_shipping_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"shippingAddress": {"salutation": "fake_salutation","firstName": "fake_first_name","lastName": "fake_last_name","address1": "fake_address1","address2": "fake_address2","address3": "fake_address3","zipCode": "fake_zipCode","city": "fake_city","iso2Code": "fake_iso2Code","company": "fake_company","phone": "fake_phone","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][id]    1
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][name]    ${shipment.method_name_1}
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be greater than:    [data][attributes][selectedShipmentMethods][0][price]    0
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][taxRate]    None
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][deliveryTime]    None
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][currencyIsoCode]    ${currency.eur.code}
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Provide_checkout_data_with_invalid_payments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "fake_provider_name","paymentMethodName": "fake_method_name"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][id]    1
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][name]    ${shipment.method_name_1}
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be greater than:    [data][attributes][selectedShipmentMethods][0][price]    0
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][taxRate]    None
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][deliveryTime]    None
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][currencyIsoCode]    ${currency.eur.code}
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Provide_checkout_data_with_invalid_shipment_method_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 0},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response should contain the array of a certain size:    [data][attributes][selectedShipmentMethods]    0
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Provide_checkout_data_with_empty_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response should contain the array of a certain size:    [data][attributes][selectedShipmentMethods]    0
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Provide_checkout_data_with_bundle_product
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${bundle_product.concrete.product_2_sku}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][id]    1
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][name]    ${shipment.method_name_1}
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be greater than:    [data][attributes][selectedShipmentMethods][0][price]    0
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][taxRate]    None
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][deliveryTime]    None
    And Response body parameter should be:    [data][attributes][selectedShipmentMethods][0][currencyIsoCode]    ${currency.eur.code}
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204