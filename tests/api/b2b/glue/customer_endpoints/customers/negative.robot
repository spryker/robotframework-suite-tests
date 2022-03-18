*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases *** 
Create_a_customer_with_already_exists_email
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"${yves_user_email}","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
    Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    400
    And Response should return error message:    Customer with this email already exists.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_too_short_password
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"${yves_user_email}","password":"Test12!","confirmPassword":"Test12!","acceptedTerms":True}}}
    Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    password => This value is too short. It should have 8 characters or more.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_too_long_password
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"${yves_user_email}","password":"tests1234567890tests1234567890tests1234567890tests1234567890tests1234567890","confirmPassword":"tests1234567890tests1234567890tests1234567890tests1234567890tests1234567890","acceptedTerms":True}}}
    Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    password => This value is too long. It should have 64 characters or less.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_too_weak_password
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"${yves_user_email}","password":"12345678","confirmPassword":"12345678","acceptedTerms":True}}}
    Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    420
    And Response should return error message:    The password character set is invalid.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_not_equal_passwords
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"${yves_user_email}","password":"${yves_user_password}","confirmPassword":"12345678","acceptedTerms":True}}}
    Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    406
    And Response should return error message:    Value in field password should be identical to value in the confirmPassword field.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_not_accepted_terms_and_coditions
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"${yves_user_email}","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":False}}}
    Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    acceptedTerms => This value should be true.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Get_a_customer_with_wrong_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a GET request:    /customers/DE35
    Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    402
    And Response should return error message:    Customer not found.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Get_a_cusomer_without_access_token
    I send a GET request:    /customers/DE35
    Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}    

Update_a_customer_with_wrong_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a POST request:    /customers/DE--35    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"max@spryker.com","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
    Response status code should be:    404
    And Response reason should be:    Not Found
    And Response header parameter should be:    Content-Type    ${default_header_content_type} 

Update_a_customer_without_access_token
    I send a PATCH request:    /customers/DE--35    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"max@spryker.com","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
    Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}   

Update_a_customer_without_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"Max","lastName":"Musterman","gender":"Male","salutation":"Mr","email":"max@spryker.com","password":"${yves_user_password}","confirmPassword":"${yves_user_password}","acceptedTerms":True}}}
    Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Delete_a_cusomer_without_access_token
    I send a DELETE request:    /customers/DE--35
    Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Delete_a_customer_without_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a DELETE request:    /customers/
    Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Delete_a_customer_with_wrong_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a DELETE request:    /customers/DE35
    Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    402
    And Response should return error message:    Customer not found.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
