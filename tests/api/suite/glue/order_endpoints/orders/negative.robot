*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
### Important CHECKOUT and CHECKOUT-DATA endpoints require Item ID and NOT intem sku. To get item id and include to the cart endpoint.
### Example:  
###I send a POST request:    /carts/${cartId}/items?include=items   {"data": {"type": "items","attributes": {"sku": "${concrete_product.random_weight.sku}","quantity": 1,"salesUnit": {"id": "${sales_unit_id}","amount": 5}}}}
### Save value to a variable:    [included][0][id]    test
### I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${test}"]}}}
     
#GET requests
Get_order_by_order_id_with_invalid_access_token
    [Setup]    I set Headers:    Authorization=fake_token
    When I send a GET request:    /orders/order_id
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001

Get_order_by_order_id_without_access_token
    [Setup]    I set Headers:    Authorization=
    When I send a GET request:    /orders/order_id
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Get_order_with_invalid_order_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /orders/fake_order_id
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    "Cant find order by the given order reference"
    And Response should return error code:    801


Get_order_by_order_id_from_another_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...  AND    Save value to a variable:    [included][0][id]    item_id_another_customer   
    ...  AND    I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_another_customer}"]}}}
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_id
    ...  AND    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /orders/${order_id}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    "Cant find order by the given order reference"
    And Response should return error code:    801

Get_customer_orders_list_with_invalid_access_token
    [Setup]    I set Headers:    Authorization=fake_token
    When I send a GET request:    /customers/${yves_user.reference}/orders
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001

Get_customer_orders_list_without_access_token
    [Setup]    I set Headers:    Authorization=
    When I send a GET request:    /customers/${yves_user.reference}/orders
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Get_customer_orders_list_with_invalid_customer_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /customers/yves_user.reference/orders
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized request.
    And Response should return error code:    802

Get_customer_orders_list_without_customer_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /customers//orders
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized request.
    And Response should return error code:    802

Get_customer_orders_list_from_another_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /customers/${yves_second_user.reference}/orders
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized request.
    And Response should return error code:    802