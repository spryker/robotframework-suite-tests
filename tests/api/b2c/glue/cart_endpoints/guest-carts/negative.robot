*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
Get_guest_cart_without_anonymous_customer_unique_id
    When I send a GET request:    /guest-carts
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Anonymous customer unique id is empty.
    And Response should return error code:    109

Get_guest_cart_wth_empty_anonymous_customer_unique_id
    [Setup]    I set Headers:     X-Anonymous-Customer-Unique-Id=
    When I send a GET request:    /guest-carts
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Anonymous customer unique id is empty.
    And Response should return error code:    109

Get_guest_cart_wth_non_existing_cart_id
    [Setup]    I set Headers:     X-Anonymous-Customer-Unique-Id=fake
    When I send a GET request:    /guest-carts/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.
    And Response should return error code:    101
