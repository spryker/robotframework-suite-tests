*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
No_cart_is_passing_to_upselling_products_request
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /carts//up-selling-products
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    104
    And Response should return error message:    Cart uuid is missing.
    
Nonexistent_cart_id_is_passing_to_upselling_products_request
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /carts/not_a_cart/up-selling-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Get_upselling_products_with_invalid token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_of_product_with_relations_upselling_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    ...    AND    I set Headers:    Authorization=None
    When I send a GET request:    /carts/${cart_id}/up-selling-products
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...    AND    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Get_upselling_products_without_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_of_product_with_relations_upselling_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    ...  AND    I set Headers:    Authorization=
    When I send a GET request:    /carts/${cart_id}/up-selling-products
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...    AND    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Get_upselling_products_using_cart_of_other_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Save value to a variable:    [data][attributes][accessToken]    first_user_token
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    Response status code should be:    201
    ...  AND    I get access token for the customer:    ${yves_second_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /carts/${cart_id}/up-selling-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.
    And Response should return error code:    101
    [Teardown]    Run Keywords    I set Headers:    Authorization=Bearer ${first_user_token}
    ...  AND    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204
