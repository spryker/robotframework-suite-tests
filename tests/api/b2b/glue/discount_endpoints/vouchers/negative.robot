*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Test_adding_not_existing_voucher_code_to_cart_of_logged_in_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${GROSS_MODE}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "419901","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "1111111"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response body parameter should not be EMPTY:    [errors]
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204


Test_adding_voucher_code_that_could_not_be_applied_to_cart_of_logged_in_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${GROSS_MODE}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "464012","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "sprykerje7p"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response body parameter should not be EMPTY:    [errors]
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204