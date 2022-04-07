*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***


Create_a_return_with_order_is_not_returnable
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cartId
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":"1"}}}
    ...  AND    Response status code should be:    201
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_product_sku}"]}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [included][0][items][0][uuid]    returnableSalesOrderItemUuid
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store_de}","returnItems":[{"salesOrderItemUuid":"${returnableSalesOrderItemUuid}","reason":"${return_reason_damaged}"}]}}}
    Then Response status code should be:     422
    And Response reason should be:     Unprocessable Content
    And Response should return error message:    "Return cant be created."    
    And Response should return error code:    3601



Retrieves_a_return_with_non_exists_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /returns/fake_returns_id
    Then Response status code should be:     404
    And Response reason should be:     Not Found
    And Response should return error message:    "Cant find return by the given return reference."
    And Response should return error code:    3602

Retrieves_a_return_with_missing_auth_token
    When I send a GET request:    /returns/DE--21-R1
    Then Response status code should be:     403
    And Response reason should be:     Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002


Retrieves_list_of_returns_with_missing_auth_token
    When I send a GET request:    /returns
    Then Response status code should be:     403
    And Response reason should be:     Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002