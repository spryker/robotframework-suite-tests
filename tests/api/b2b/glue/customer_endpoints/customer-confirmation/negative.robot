*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
# # can't receive the confirmation from email
# Customer_confirmation_with_wrong_confirmation_key
#     I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"maxmusterman@spryker.com","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
#     Response status code should be:    201
#     And Save value to a variable:    [data][id]    userId
#     And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"39085d16b04b34265910c7ea2a35367ggh"}}}
#     Response status code should be:    422
#     And Response should return error message:    This email confirmation code is invalid or has been already used.
#     And Response should return error code:    423
#     And Response header parameter should be:    Content-Type    ${default_header_content_type}
#      # need receive the confirmation key from email
#     And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
#     Response status code should be:    204
#     And Response reason should be:    No Content
#     I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"max@spryker.com","password":"${yves_user_password}"}}}
#     And Response status code should be:    201
#     And Save value to a variable:    [data][attributes][accessToken]    token
#     And I set Headers:    Authorization=token
#     When I set Headers:    Authorization=Bearer ${token}
#     And I send a GET request:    /customers/${userId}
#     Response status code should be:    200
#     And Response reason should be:    OK
#     And Response header parameter should be:    Content-Type    ${default_header_content_type}
#     And Response body has correct self link internal
#     [Teardown]    Run Keywords    I send a DELETE request:    /customers/${userId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# # can't receive the confirmation from email
# Customer_confirmation_with_empty_confirmation_key
#     I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"maxmusterman@spryker.com","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
#     Response status code should be:    201
#     And Save value to a variable:    [data][id]    userId
#     And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":""}}}
#     Response status code should be:    422
#     And Response should return error code:    901
#     And Response should return error message:    registrationKey => This value should not be blank.
#     And Response header parameter should be:    Content-Type    ${default_header_content_type}
#      # need receive the confirmation key from email
#     And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
#     Response status code should be:    204
#     And Response reason should be:    No Content
#     I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"max@spryker.com","password":"${yves_user_password}"}}}
#     And Response status code should be:    201
#     And Save value to a variable:    [data][attributes][accessToken]    token
#     And I set Headers:    Authorization=token
#     When I set Headers:    Authorization=Bearer ${token}
#     And I send a GET request:    /customers/${userId}
#     Response status code should be:    200
#     And Response reason should be:    OK
#     And Response header parameter should be:    Content-Type    ${default_header_content_type}
#     And Response body has correct self link internal
#     [Teardown]    Run Keywords    I send a DELETE request:    /customers/${userId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# # can't receive the confirmation from email
# Customer_confirmation_without_confirmation_key
#     I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"maxmusterman@spryker.com","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
#     Response status code should be:    201
#     And Save value to a variable:    [data][id]    userId
#     And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{}}}
#     Response status code should be:    422
#     And Response should return error code:    901
#     And Response should return error message:    registrationKey => This field is missing.
#     And Response header parameter should be:    Content-Type    ${default_header_content_type}
#      # need receive the confirmation key from email
#     And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
#     Response status code should be:    204
#     And Response reason should be:    No Content
#     I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"max@spryker.com","password":"${yves_user_password}"}}}
#     And Response status code should be:    201
#     And Save value to a variable:    [data][attributes][accessToken]    token
#     And I set Headers:    Authorization=token
#     When I set Headers:    Authorization=Bearer ${token}
#     And I send a GET request:    /customers/${userId}
#     Response status code should be:    200
#     And Response reason should be:    OK
#     And Response header parameter should be:    Content-Type    ${default_header_content_type}
#     And Response body has correct self link internal
#     [Teardown]    Run Keywords    I send a DELETE request:    /customers/${userId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# # can't receive the confirmation from email
# Customer_confirmation_with_empty_type
#     I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"maxmusterman@spryker.com","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
#     Response status code should be:    201
#     And Save value to a variable:    [data][id]    userId
#     And I send a POST request:    /customer-confirmation   {"data":{"type":"","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
#     Response status code should be:    400
#     And Response should return error message:    Invalid type.
#     And Response header parameter should be:    Content-Type    ${default_header_content_type}
#      # need receive the confirmation key from email
#     And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
#     Response status code should be:    204
#     And Response reason should be:    No Content
#     I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"max@spryker.com","password":"${yves_user_password}"}}}
#     And Response status code should be:    201
#     And Save value to a variable:    [data][attributes][accessToken]    token
#     And I set Headers:    Authorization=token
#     When I set Headers:    Authorization=Bearer ${token}
#     And I send a GET request:    /customers/${userId}
#     Response status code should be:    200
#     And Response reason should be:    OK
#     And Response header parameter should be:    Content-Type    ${default_header_content_type}
#     And Response body has correct self link internal
#     [Teardown]    Run Keywords    I send a DELETE request:    /customers/${userId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content    