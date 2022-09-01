*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup

Default Tags    glue

Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
ENABLER
    TestSetup


Create_git_card_code_with_invalid_access_token
     [Setup]    Run Keyword   I set Headers:    Authorization=345A9
    When I send a POST request:    /carts/cart_id/cart-codes?include=vouchers,gift-cards    {"data": {"type": "cart-codes","attributes": {"code": "${random}"}}}
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Create_git_card_code_without_access_token
    When I send a POST request:    /carts/cart_id/cart-codes?include=vouchers,gift-cards    {"data": {"type": "cart-codes","attributes": {"code": "${random}"}}}
    Then Response status code should be:    403
    And Response should return error code:    002
    And Response reason should be:    Forbidden 
    And Response should return error message:    Missing access token.
Create_git_card_code_with_invalid_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
     When I send a POST request:    /carts/123/cart-codes?include=vouchers,gift-cards    {"data": {"type": "cart-codes","attributes": {"code": "${random}"}}}
    Then Response status code should be:    404
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.


Adding_eur_gift_cart_code_in_chf_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.chf.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
     When I send a POST request:    /carts/${cart_id}/cart-codes?include=vouchers,gift-cards    {"data": {"type": "cart-codes","attributes": {"code": "${random}"}}}
    Then Response status code should be:    422
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."




adding_invalid_cart_code
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    When I send a POST request:    /carts/${cart_id}/cart-codes?include=vouchers,gift-cards    {"data": {"type": "cart-codes","attributes": {"code": "123"}}}
    Then Response status code should be:    422
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."


   