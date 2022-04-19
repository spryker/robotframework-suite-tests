*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
    
Create_a_return
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cartId
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":"1"}}}
    ...  AND    Response status code should be:    201
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_product_sku}"]}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_reference
    ...  AND    Save value to a variable:    [included][0][items][0][uuid]    returnable_item_uuid
    ...  AND    Save value to a variable:    [included][0][items][0][refundableAmount]    refundable_amount
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store_de}","returnItems":[{"salesOrderItemUuid":"${returnable_item_uuid}","reason":"${return_reason_damaged}"}]}}}
    Then Response status code should be:     201
    And Response reason should be:     Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should contain:    [data][attributes]    merchantReference
    And Response body parameter should be:    [data][id]    ${order_reference}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_second_user_reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${refundable_amount}
    And Response body has correct self link


Create_a_return_with_return_items
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cartId
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":"1"}}}
    ...  AND    Response status code should be:    201
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_product_sku}"]}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_reference
    ...  AND    Save value to a variable:    [included][0][items][0][uuid]    returnable_item_uuid
    ...  AND    Save value to a variable:    [included][0][items][0][refundableAmount]    refundable_amount
    When I send a POST request:     /returns?include=return-items     {"data":{"type":"returns","attributes":{"store":"${store_de}","returnItems":[{"salesOrderItemUuid":"${returnable_item_uuid}","reason":"${return_reason_damaged}"}]}}}
    Then Response status code should be:     201
    And Response reason should be:     Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should contain:    [data][attributes]    merchantReference
    And Response body parameter should be:    [data][id]    ${order_reference}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_second_user_reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${refundable_amount}
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array larger than a certain size:    [data][relationships]    0    
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response should contain the array of a certain size:    [data][relationships][return-items][data]    1
    And Response body parameter should not be EMPTY:    [data][relationships][return-items]
    And Response body parameter should contain:    [data][relationships][return-items][data]    type
    And Response body parameter should contain:    [data][relationships][return-items][data]    id
    And Response body parameter should not be EMPTY:    [included]  
    And Response include should contain certain entity type:    return-items
    And Response body parameter should be:    [included][0][attributes][uuid]    ${returnable_item_uuid}
    And Response body parameter should be:    [included][0][attributes][reason]    ${return_reason_damaged}
    And Response body has correct self link



Retrieves_list_of_returns
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cartId
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":"1"}}}
    ...  AND    Response status code should be:    201
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_product_sku}"]}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [included][0][items][0][uuid]    returnable_item_uuid
    ...  AND    I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store_de}","returnItems":[{"salesOrderItemUuid":"${returnable_item_uuid}","reason":"${return_reason_damaged}"}]}}}
    When I send a GET request:     /returns
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Each array element of array in response should contain property with value:    [data]    type    returns
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    links
    And Each array element of array in response should contain nested property:    [data]    [attributes]    merchantReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    returnReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    store
    And Each array element of array in response should contain nested property:    [data]    [attributes]    customerReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    returnTotals
    And Each array element of array in response should contain nested property:    [data]    [attributes][returnTotals]    refundTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][returnTotals]    remunerationTotal
    And Response body has correct self link
    

Retrieves_list_of_returns_included_return_items

    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cartId
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":"1"}}}
    ...  AND    Response status code should be:    201
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_product_sku}"]}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [included][0][items][0][uuid]    returnable_item_uuid
    ...  AND    I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store_de}","returnItems":[{"salesOrderItemUuid":"${returnable_item_uuid}","reason":"${return_reason_damaged}"}]}}}
    When I send a GET request:     /returns?include=return-items 
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Each array element of array in response should contain property with value:    [data]    type    returns
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    links
    And Each array element of array in response should contain nested property:    [data]    [attributes]    merchantReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    returnReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    store
    And Each array element of array in response should contain nested property:    [data]    [attributes]    customerReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    returnTotals
    And Each array element of array in response should contain nested property:    [data]    [attributes][returnTotals]    refundTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][returnTotals]    remunerationTotal
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Each array element of array in response should contain property:    [data]    relationships
    And Each array element of array in response should contain nested property:    [data]    [relationships]    return-items
    And Each array element of array in response should contain nested property:    [data]    [relationships][return-items][data][0]    type
    And Each array element of array in response should contain nested property:    [data]    [relationships][return-items][data][0]    id
    And Each array element of array in response should contain nested property with value:    [data]    [relationships][return-items][data][0][type]    return-items
    And Response include element has self link:    return-items
    And Response include should contain certain entity type:    return-items
    And Response body parameter should be:    [included][0][attributes][uuid]    ${returnable_item_uuid}
    And Response body parameter should be:    [included][0][attributes][reason]    ${return_reason_damaged}
    And Response body has correct self link





Retrieves_return_by_id_with_returns_items_included
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cartId
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":"1"}}}
    ...  AND    Response status code should be:    201
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_product_sku}"]}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [included][0][items][0][uuid]    returnable_item_uuid
    ...  AND    Save value to a variable:    [included][0][items][0][refundableAmount]    refundable_amount
    ...  AND    I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store_de}","returnItems":[{"salesOrderItemUuid":"${returnable_item_uuid}","reason":"${return_reason_damaged}"}]}}}
    ...  AND    Save value to a variable:    [data][id]    returnId
    When I send a GET request:    /returns/${returnId}?include=return-items
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][id]    ${returnId}
    And Response body parameter should be:    [data][attributes][returnReference]    ${returnId}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user_reference}
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${refundable_amount}
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array larger than a certain size:    [data][relationships]    0
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][return-items]
    And Each array element of array in response should contain property:    [data][relationships][return-items][data]    type
    And Each array element of array in response should contain property:    [data][relationships][return-items][data]    id
    And Response body parameter should not be EMPTY:    [included]
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain nested property:    [included]    [attributes]    uuid
    And Each array element of array in response should contain property with value:    [included]    type    return-items
    And Each array element of array in response should contain property with value in:    [included]    [attributes][orderItemUuid]    ${returnable_item_uuid}    ${returnable_item_uuid}
    And Each array element of array in response should contain property with value in:    [included]    [attributes][reason]    ${return_reason_damaged}    ${return_reason_damaged}  
    And Response body has correct self link



Retrieves_return_by_id_for_sales_order

    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cartId
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":"1"}}}
    ...  AND    Response status code should be:    201
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_product_sku}"]}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [included][0][items][0][uuid]    returnable_item_uuid
    ...  AND    Save value to a variable:    [included][0][items][0][refundableAmount]    refundable_amount
    ...  AND    I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store_de}","returnItems":[{"salesOrderItemUuid":"${returnable_item_uuid}","reason":"${return_reason_damaged}"}]}}}
    ...  AND    Save value to a variable:    [data][id]    returnId
    When I send a GET request:    /returns/${returnId}?include=return-items
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should contain:    [data][attributes]    merchantReference
    And Response body parameter should be:    [data][id]    ${returnId}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_second_user_reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${refundable_amount}
    And Response body has correct self link

