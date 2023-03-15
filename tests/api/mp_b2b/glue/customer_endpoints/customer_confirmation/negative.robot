*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***

ENABLER
    TestSetup

Customer_confirmation_with_wrong_confirmation_key
    And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"39085d16b04b34265910c7ea2a35367ggh"}}}
    Response status code should be:    ${422}
    And Response should return error message:    This email confirmation code is invalid or has been already used.
    And Response should return error code:    423
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Customer_confirmation_with_empty_confirmation_key
    And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":""}}}
    Response status code should be:    ${422}
    And Response should return error code:    901
    And Response should return error message:    registrationKey => This value should not be blank.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Customer_confirmation_without_confirmation_key
    And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{}}}
    Response status code should be:    ${422}
    And Response should return error code:    901
    And Response should return error message:    registrationKey => This field is missing.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Customer_confirmation_with_empty_type
    And I send a POST request:    /customer-confirmation   {"data":{"type":"","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
    Response status code should be:    400
    And Response should return error message:    Invalid type.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Customer_confirmation_with_already_used_confirmation_key
    [Setup]    Run Keywords    I send a POST request:    /customers    {"data":{"type":"customers","attributes":{"firstName":"${yves_user.first_name}","lastName":"${yves_user.last_name}","gender":"${gender.female}","salutation":"${yves_user.salutation}","email":"${yves_user.first_name}+${random}@spryker.com","password":"${yves_user.password}","confirmPassword":"${yves_user.password}","acceptedTerms":True}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    user_reference_id
    ...    AND    Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where customer_reference = '${user_reference_id}'    confirmation_key
    ...    AND    I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
    When I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
    Then Response status code should be:    ${422}
    And Response should return error code:    423
    And Response should return error message:    This email confirmation code is invalid or has been already used.
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_user.first_name}+${random}@spryker.com
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a DELETE request:    /customers/${user_reference_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
