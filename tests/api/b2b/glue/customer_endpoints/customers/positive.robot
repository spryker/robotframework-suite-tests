*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
# can't receive the confirmation from email
Create_customer
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"max@spryker.com","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
    Response status code should be:    201
    # And Save value to a variable:    [data][id]    userId
    # I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"max@spryker.com","password":"${yves_user_password}"}}}
    # And Response status code should be:    201
    # And Save value to a variable:    [data][attributes][accessToken]    token
    # And I set Headers:    Authorization=token
    # When I set Headers:    Authorization=Bearer ${token}
    # I send a GET request:    /customers/${userId}

Get_customer_contains_all_available_fields
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a GET request:    /customers/${yves_user_reference}
    Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should not be EMPTY:    [data][type]
    And Response body parameter should be:    [data][type]    customers
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][id]    ${yves_user_reference}
    And Response body parameter should not be EMPTY:    [data][attributes][firstName]
    And Response body parameter should be:    [data][attributes][firstName]    ${yves_user_reference}
    And Response body parameter should not be EMPTY:    [data][attributes][lastName]
    And Response body parameter should be:    [data][attributes][lastName]    ${yves_user_last_name}
    And Response body parameter should not be EMPTY:    [data][attributes][email]
    And Response body parameter should be:    [data][attributes][email]    ${yves_user_email}
    And Response body parameter should not be EMPTY:    [data][attributes][gender]
    And Response body parameter should be:    [data][attributes][gender]    Female
    And Response body parameter should not be EMPTY:    [data][attributes][salutation]
    And Response body parameter should be:    [data][attributes][salutation]    ${yves_user_salutation}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should not be EMPTY:    [data][attributes][updatedAt]
    And Response body has correct self link internal

Update_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /customers/${yves_user_reference}    {"data":{"type":"customers","attributes":{"firstName":"${yves_user_first_name}","lastName":"${yves_user_last_name}","gender":"Female","salutation":"${yves_second_user_salutation}","email":"${yves_user_email}","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
    Response status code should be:    200
    And Response body has correct self link internal
    And I send a GET request:    /customers/${yves_user_reference}
    Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][attributes][salutation]    ${yves_second_user_salutation}
    [Teardown]    Run Keywords    I send a PATCH request:    /customers/${yves_user_reference}    {"data":{"type":"customers","attributes":{"firstName":"${yves_user_first_name}","lastName":"${yves_user_last_name}","gender":"Female","salutation":"${yves_user_salutation}","email":"${yves_user_email}","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
    ...    AND    Response status code should be:    200
    ...    AND    And Response body parameter should be:    [data][attributes][salutation]    ${yves_user_salutation}
