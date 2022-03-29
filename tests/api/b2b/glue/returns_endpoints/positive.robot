*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***

Create_returns
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
        ...  AND    I set Headers:    Authorization=${token}
        ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
        ...  AND    Save value to a variable:    [data][id]    cartId
        ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
        ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
        ...  AND    Save value to a variable:    [data][attributes][items][0][uuid]    returnableSalesOrderItemUuid
    When I send a POST request:    /returns    {"data": {"type": "returns","attributes": {"store": "${store_de}","returnItems": [{"salesOrderItemUuid": "${returnableSalesOrderItemUuid}","reason": "${return_reason_damaged}"}]}}}
    Then Response status code should be:    201
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    returns
    [Teardown]    Run Keywords        I get access token for the customer:    ${yves_user_email}
        ...  AND    I set Headers:    Authorization=${token}
        ...  AND    I send a DELETE request:    /carts/${cartId}
        ...  AND    Then Response status code should be:    204
        ...  AND    Response reason should be:    OK
    