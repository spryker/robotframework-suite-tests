*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Customer_confirmation_with_wrong_confirmation_key
    And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"39085d16b04b34265910c7ea2a35367ggh"}}}
    Response status code should be:    422
    And Response should return error message:    This email confirmation code is invalid or has been already used.
    And Response should return error code:    423
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Customer_confirmation_with_empty_confirmation_key
    And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":""}}}
    Response status code should be:    422
    And Response should return error code:    901
    And Response should return error message:    registrationKey => This value should not be blank.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Customer_confirmation_without_confirmation_key
    And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{}}}
    Response status code should be:    422
    And Response should return error code:    901
    And Response should return error message:    registrationKey => This field is missing.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Customer_confirmation_with_empty_type
    And I send a POST request:    /customer-confirmation   {"data":{"type":"","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
    Response status code should be:    400
    And Response should return error message:    Invalid type.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

# need receive the confirmation key from email
# Customer_confirmation_with_already_used_confirmation_key
#     [Setup]    Run Keywords    I send a POST request:    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user_first_name}","lastName":"${yves_third_user_last_name}","gender":"${gender_male}","salutation":"${yves_third_user_salutation}","email":"${email_name}${random}${email_domain}","password":"${yves_third_user_password}","confirmPassword":"${yves_third_user_password}","acceptedTerms":True}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    userId
#     ...    AND    I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content
#     I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
#     Response status code should be:    422
#     And Response should return error code:    423
#     And Response should return error message:    This email confirmation code is invalid or has been already used.
#     [Teardown]    Run Keywords    I get access token for the customer: ${email_name}${random}${email_domain}
#     ...    AND    I set Headers: Content-Type=${default_header_content_type} Authorization=${token}
#     ...    AND    I send a DELETE request:    /customers/${userId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content