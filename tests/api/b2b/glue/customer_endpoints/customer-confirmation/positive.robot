*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
# need receive the confirmation key from email
# Customer_confirmation
#     [Setup]    Run Keywords    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user_first_name}","lastName":"${yves_third_user_last_name}","gender":"${gender_male}","salutation":"${yves_third_user_salutation}","email":"${email_name}${random}${email_domain}","password":"${yves_third_user_password}","confirmPassword":"${yves_third_user_password}","acceptedTerms":True}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    userId
#     ...    AND    Save value to a variable:    [data][attributes][email]    userEmail
#     And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
#     Response status code should be:    204
#     And Response reason should be:    No Content
#     [Teardown]    Run Keywords    I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${userEmail}","password":"${yves_third_user_password}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][attributes][accessToken]    token
#     ...    AND    I set Headers:    Authorization=token
#     ...    AND    I set Headers:    Authorization=Bearer ${token}
#     ...    AND    I send a GET request:    /customers/${userId}
#     ...    AND    Response status code should be:    200
#     ...    AND    Response reason should be:    OK
#     ...    AND    I send a DELETE request:    /customers/${userId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content