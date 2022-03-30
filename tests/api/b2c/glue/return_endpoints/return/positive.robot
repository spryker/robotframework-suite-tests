*** Settings ***
Suite Setup       SuiteSetup
Default Tags      glue
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
####POST####
Create_a_return
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"GROSS_MODE","currency":"EUR","store":"DE"}}}
    ...    AND    I send a GET request:    /customers/${yves_second_user_reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":"1"}}}
    ...    AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_product_sku}"]}}}
    ...    AND    Save value to a variable:    [data][attributes][orderReference]    OrderId
    ...    AND    I send a GET request:    /orders/${OrderId}
    ...    AND    Save value to a variable:    [data][attributes][items][0][uuid]    Uuid
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_resaon}"}]}}}
    Then Response status code should be:     201
    And Response reason should be:     Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_second_user_reference}
    And Response body has correct self link


####GET####
Get_lists_of_returns
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"GROSS_MODE","currency":"EUR","store":"DE"}}}
    ...    AND    I send a GET request:    /customers/${yves_second_user_reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":"1"}}}
    ...    AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_product_sku}"]}}}
    ...    AND    Save value to a variable:    [data][attributes][orderReference]    OrderId
    ...    AND    I send a GET request:    /orders/${OrderId}
    ...    AND    Save value to a variable:    [data][attributes][items][0][uuid]    Uuid
    ...    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_resaon}"}]}}}
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
    And Response body has correct self link


####GET####
Get_return_by_Id
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"GROSS_MODE","currency":"EUR","store":"DE"}}}
    ...    AND    I send a GET request:    /customers/${yves_second_user_reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":"1"}}}
    ...    AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_product_sku}"]}}}
    ...    AND    Save value to a variable:    [data][attributes][orderReference]    OrderId
    ...    AND    I send a GET request:    /orders/${OrderId}
    ...    AND    Save value to a variable:    [data][attributes][items][0][uuid]    Uuid
    ...    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_resaon}"}]}}}
    ...    AND    Save value to a variable:    [data][0][id]    returnOrderId
    When I send a GET request:     /returns/${returnOrderId}
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response header parameter should be:     Content-Type     ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][id]    ${returnOrderId}
    And Response body parameter should be:    [data][attributes][returnReference]    ${returnReference}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_second_user_reference}
    And Response body parameter should not be EMPTY:     [data][attributes][returnTotals][refundTotal]
    And Response body parameter should not be EMPTY:     [data][attributes][returnTotals][remunerationTotal]





