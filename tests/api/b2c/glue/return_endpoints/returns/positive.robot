*** Settings ***
Suite Setup       SuiteSetup
Default Tags      glue
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
ENABLER
    TestSetup

####POST####
Create_a_return
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"GROSS_MODE","currency":"EUR","store":"DE"}}}
    ...    AND    I send a GET request:    /customers/${yves_user_reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_with_stock_and_never_out_of_stock}","quantity":"1"}}}
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    Uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    productPrice
    ...    AND    Update order status in Database:    shipped
    
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
    Then Save value to a variable:    [data][id]    returnId
    And Response status code should be:     201
    And Response reason should be:     Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should contain:    [data]    id
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user_reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${productPrice}
    And Response body has correct self link for created entity:    ${returnId}

Create_a_return_include_return_items
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"GROSS_MODE","currency":"EUR","store":"DE"}}}
    ...    AND    I send a GET request:    /customers/${yves_user_reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_with_stock_and_never_out_of_stock}","quantity":"1"}}}
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    Uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    productPrice
    ...    AND    Update order status in Database:    shipped

    When I send a POST request:     /returns?include=return-items     {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
    Then Response status code should be:     201
    And Response reason should be:     Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should contain:    [data]    id
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user_reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${productPrice}
    And Response body parameter should contain:    [data]    relationships
    And Response body parameter should be:    [data][relationships][return-items][data][0][type]    return-items
    And Response body parameter should contain:    [data][relationships][return-items][data][0]    id
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should be:    [included][0][type]    return-items
    And Response body parameter should contain:    [included][0]    id
    And Response body parameter should not be empty:    [included][0][attributes][uuid]
    And Response body parameter should be:    [included][0][attributes][reason]    ${return_reason_damaged}
    And Response body parameter should contain:    [included][0][attributes]    orderItemUuid


#GET####
Get_lists_of_returns
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"GROSS_MODE","currency":"EUR","store":"DE"}}}
    ...    AND    I send a GET request:    /customers/${yves_user_reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_with_stock_and_never_out_of_stock}","quantity":"1"}}}
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    Uuid
    ...    AND    Update order status in Database:    shipped
    ...    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
    When I send a GET request:     /returns
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Each array element of array in response should contain property with value:    [data]    type    returns
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    links
    And Each array element of array in response should contain nested property:    [data]    [attributes]    returnReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    store
    And Each array element of array in response should contain nested property:    [data]    [attributes]    customerReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    returnTotals
    And Each array element of array in response should contain nested property:    [data]    [attributes][returnTotals]    refundTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][returnTotals]    remunerationTotal
    And Each array element of array in response should contain nested property:    [data]    [links]    self


Get_lists_of_returns_include_return-items
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"GROSS_MODE","currency":"EUR","store":"DE"}}}
    ...    AND    I send a GET request:    /customers/${yves_user_reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":"1"}}}
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    Uuid
    ...    AND    Update order status in Database:    shipped
    ...    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
    When I send a GET request:     /returns?include=return-items 
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Each array element of array in response should contain property with value:    [data]    type    returns
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    links
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
    And Response body has correct self link 

###GET####
Get_return_by_Id
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"GROSS_MODE","currency":"EUR","store":"DE"}}}
    ...    AND    I send a GET request:    /customers/${yves_user_reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_with_stock_and_never_out_of_stock}","quantity":"1"}}}
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    Uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    productPrice
    ...    AND    Update order status in Database:    shipped
    ...    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
    ...    AND    Save value to a variable:    [data][attributes][returnReference]    returnReference
    ...    AND    Save value to a variable:    [data][id]    returnId

    When I send a GET request:     /returns/${returnReference}
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response header parameter should be:     Content-Type     ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][id]    ${returnReference}
    And Response body parameter should be:    [data][attributes][returnReference]    ${returnReference}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user_reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${productPrice}
    And Response body has correct self link internal

Get_return_by_Id_include_return-items
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"GROSS_MODE","currency":"EUR","store":"DE"}}}
    ...    AND    I send a GET request:    /customers/${yves_user_reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_with_stock_and_never_out_of_stock}","quantity":"1"}}}
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    Uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    productPrice
    ...    AND    Update order status in Database:    shipped
    ...    AND    I send a POST request:    /returns?include=return-items    {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
    ...    AND    Save value to a variable:    [data][attributes][returnReference]    returnReference
    ...    AND    Save value to a variable:    [included][0][attributes][orderItemUuid]    orderItemUuid
    ...    AND    Save value to a variable:    [data][id]    returnId
    When I send a GET request:     /returns/${returnReference}?include=return-items 
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response header parameter should be:     Content-Type     ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][id]    ${returnReference}
    And Response body parameter should be:    [data][attributes][returnReference]    ${returnReference}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user_reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${productPrice}
    And Response body parameter should contain:    [data]    relationships
    And Response body parameter should be:    [data][relationships][return-items][data][0][type]    return-items
    And Response body parameter should contain:    [data][relationships][return-items][data][0]    id
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should be:    [included][0][type]    return-items
    And Response body parameter should contain:    [included][0]    id
    And Response body parameter should be:    [included][0][type]    return-items
    And Response body parameter should contain:    [included][0]    id
    And Response body parameter should be:    [included][0][attributes][reason]    ${return_reason_damaged}
    And Response body parameter should be:    [included][0][attributes][orderItemUuid]    ${orderItemUuid}