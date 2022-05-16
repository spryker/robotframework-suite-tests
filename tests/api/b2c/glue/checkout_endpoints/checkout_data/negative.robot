*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

#POST requests
Provide_checkout_data_with_invalid_access_token
# Created the bug-ticket https://spryker.atlassian.net/browse/CC-16699
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    I set Headers:    Authorization=fake_token
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001

Provide_checkout_data_without_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    I set Headers:    Authorization=
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    1105
    And Response should return error message:    One of Authorization or X-Anonymous-Customer-Unique-Id headers is required.

Provide_checkout_data_with_invalid_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "fake_type","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Provide_checkout_data_with_empty_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Provide_checkout_data_without_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Post data is invalid.

Provide_checkout_data_with_invalid_email
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "fake_email","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    customer.email => Email is invalid.

Provide_checkout_data_with_invalid_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "fake_cart_id","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    1103
    And Response should return error message:    Cart not found.

Provide_checkout_data_with_cart_id_from_another_customer
        [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Save value to a variable:    [data][attributes][accessToken]    first_user_token
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    1103
    And Response should return error message:    Cart not found.

Provide_checkout_data_with_empty_customer_attributes_and_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "","salutation": "","firstName": "","lastName": ""},"idCart": "","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    422
    And Array in response should contain property with value:    [errors]    detail    idCart => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    customer.salutation => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    customer.email => Email is invalid.

Provide_checkout_data_without_customer_attributes_and_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {},"billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    422
    And Array in response should contain property with value:    [errors]    detail    idCart => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    customer.salutation => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    customer.email => This field is missing.

Provide_checkout_data_with_empty_billing_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "","firstName": "","lastName": "","address1": "","address2": "","address3": "","zipCode": "","city": "","iso2Code": "","company": "","phone": "","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    422
    And Array in response should contain property with value:    [errors]    detail    billingAddress.salutation => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.firstName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.lastName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.address1 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.address2 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.zipCode => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.city => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.city => This value is too short. It should have 3 characters or more.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.iso2Code => This value should not be blank.

Provide_checkout_data_without_billing_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    422
    And Array in response should contain property with value:    [errors]    detail    billingAddress.salutation => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.firstName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.lastName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.address1 => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.address2 => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.zipCode => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.city => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.iso2Code => This field is missing.

Provide_checkout_data_with_empty_shipping_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "","firstName": "","lastName": "","address1": "","address2": "","address3": "","zipCode": "","city": "","iso2Code": "","company": "","phone": "","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    422
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.salutation => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.firstName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.lastName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.address1 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.address2 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.zipCode => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.city => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.city => This value is too short. It should have 3 characters or more.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.iso2Code => This value should not be blank.

Provide_checkout_data_without_shipping_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    422
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.salutation => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.firstName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.lastName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.address1 => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.address2 => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.zipCode => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.city => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.iso2Code => This field is missing.

Provide_checkout_data_with_empty_payments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "","paymentMethodName": ""}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    payments.0.paymentMethodName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    payments.0.paymentProviderName => This value should not be blank.
    And Response should return error message:    payments.0.paymentMethodName => This value should not be blank.
    
Provide_checkout_data_without_payments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    422
    And Array in response should contain property with value:    [errors]    detail    payments.0.paymentMethodName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    payments.0.paymentProviderName => This field is missing.

Provide_checkout_data_without_shipment_method_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {},"items": ["${concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    shipment.idShipmentMethod => This field is missing.
    And Response should return error code:    901