*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Create_customer
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user_first_name}","lastName":"${yves_third_user_last_name}","gender":"${yves_third_user_gender}","salutation":"${yves_third_user_salutation}","email":"${email_name}${random}${email_domain}","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
    Response status code should be:    201
    And Save value to a variable:    [data][id]    userId
    And Save value to a variable:    [data][attributes][email]    userEmail
    # [Teardown]    Run Keywords    I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
    # ...    AND    Response status code should be:    204
    # ...    AND    Response reason should be:    No Content
    # can't receive the confirmation from email
    # ...    AND    I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${userEmail}","password":"${yves_user_password}"}}}
    # ...    AND    Response status code should be:    201
    # ...    AND    Save value to a variable:    [data][attributes][accessToken]    token
    # ...    AND    I set Headers:    Authorization=token
    # ...    AND    I set Headers:    Authorization=Bearer ${token}
    # ...    AND    Response reason should be:    OK
    # ...    AND    Response body has correct self link internal
    # ...    AND    I send a DELETE request:    /customers/${userId}
    # ...    AND    Response status code should be:    204
    # ...    AND    Response reason should be:    No Content

# Send_customer_confirmation_after_user_creation
#     [Setup]    Run Keywords    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user_first_name}","lastName":"${yves_third_user_last_name}","gender":"${yves_third_user_gender}","salutation":"${yves_third_user_salutation}","email":"${email_name}${random}${email_domain}","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    userId
#     ...    AND    Save value to a variable:    [data][attributes][email]    userEmail
# # can't receive the confirmation from email
#     I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
#     And Response status code should be:    204
#     And Response reason should be:    No Content
#     [Teardown]    Run Keywords    I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${userEmail}","password":"${yves_user_password}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][attributes][accessToken]    token
#     ...    AND    I set Headers:    Authorization=token
#     ...    AND    I set Headers:    Authorization=Bearer ${token}
#     ...    AND    Response reason should be:    OK
#     ...    AND    Response body has correct self link internal
#     ...    AND    I send a DELETE request:    /customers/${userId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content    

Get_customer_contains_all_available_fields
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a GET request:    /customers/${yves_user_reference}
    Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    customers
    And Response body parameter should be:    [data][id]    ${yves_user_reference}
    And Response body parameter should be:    [data][attributes][firstName]    ${yves_user_first_name}
    And Response body parameter should be:    [data][attributes][lastName]    ${yves_user_last_name}
    And Response body parameter should be:    [data][attributes][email]    ${yves_user_email}
    And Response body parameter should be:    [data][attributes][gender]    Fe${yves_third_user_gender}
    And Response body parameter should be:    [data][attributes][salutation]    ${yves_user_salutation}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should not be EMPTY:    [data][attributes][updatedAt]
    And Response body has correct self link internal

Update_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /customers/${yves_user_reference}    {"data":{"type":"customers","attributes":{"firstName":"${yves_second_user_first_name}","lastName":"${yves_second_user_last_name}","gender":"${yves_third_user_gender}","salutation":"${yves_second_user_salutation}","email":"${yves_user_email}","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
    Response status code should be:    200
    And Response body has correct self link internal
    And I send a GET request:    /customers/${yves_user_reference}
    Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][attributes][salutation]    ${yves_second_user_salutation}
    And Response body parameter should be:    [data][attributes][firstName]    ${yves_second_user_first_name}
    And Response body parameter should be:    [data][attributes][lastName]    ${yves_second_user_last_name}
    And Response body parameter should be:    [data][attributes][gender]    ${yves_third_user_gender}
    [Teardown]    Run Keywords    I send a PATCH request:    /customers/${yves_user_reference}    {"data":{"type":"customers","attributes":{"firstName":"${yves_user_first_name}","lastName":"${yves_user_last_name}","gender":"Fe${yves_third_user_gender}","salutation":"${yves_user_salutation}","email":"${yves_user_email}","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
    ...    AND    Response status code should be:    200
    ...    AND    Response body parameter should be:    [data][attributes][salutation]    ${yves_user_salutation}

Get_customer_contains_all_available_fields
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a GET request:    /customers/
    And Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    customers
    And Response body parameter should be:    [data][0][id]    ${yves_user_reference}
    And Response body parameter should be:    [data][0][attributes][firstName]    ${yves_user_first_name}
    And Response body parameter should be:    [data][0][attributes][lastName]    ${yves_user_last_name}
    And Response body parameter should be:    [data][0][attributes][email]    ${yves_user_email}
    And Response body parameter should be:    [data][0][attributes][gender]    Fe${yves_third_user_gender}
    And Response body parameter should be:    [data][0][attributes][salutation]    ${yves_user_salutation}
    And Response body parameter should not be EMPTY:    [data][0][attributes][createdAt]
    And Response body parameter should not be EMPTY:    [data][0][attributes][updatedAt]

# Delete_customer
#     [Setup]    Run Keywords    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user_first_name}","lastName":"${yves_third_user_last_name}","gender":"${yves_third_user_gender}","salutation":"${yves_third_user_salutation}","email":"${yves_third_user_email}","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    userId
#     # need receive the confirmation key from email
#     ...    AND    I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content
#     ...    AND    I get access token for the customer:    ${yves_third_user_email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
#     I send a DELETE request:    /customers/${userId}
#     And Response status code should be:    204
#     And Response reason should be:    No Content