*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***

ENABLER
    TestSetup

Update_customer_password_with_not_equal_new_password
    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    AND I send a PATCH request:    /customer-password/${yves_user.reference}   {"data":{"type":"customer-password","attributes":{"password":"${yves_user.password}","newPassword":"${yves_user.password}","confirmPassword":"${yves_user.password_new}"}}}
    Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    406
    And Response should return error message:    Value in field newPassword should be identical to value in the confirmPassword field.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_customer_password_with_empty_data_type
    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    AND I send a PATCH request:    /customer-password/${yves_user.reference}   {"data":{"type":"","attributes":{"password":"${yves_user.password}","newPassword":"${yves_user.password}","confirmPassword":"${yves_user.password_new}"}}}
    Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_customer_password_with_empty_current_password
    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    AND I send a PATCH request:    /customer-password/${yves_user.reference}   {"data":{"type":"customer-password","attributes":{"password":"","newPassword":"${yves_user.password}","confirmPassword":"${yves_user.password_new}"}}}
    Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    password => This value should not be blank.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_customer_password_with_empty_new_password
    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    AND I send a PATCH request:    /customer-password/${yves_user.reference}   {"data":{"type":"customer-password","attributes":{"password":"${yves_user.password}","newPassword":"","confirmPassword":"${yves_user.password_new}"}}}
    Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    newPassword => This value should not be blank.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_customer_password_with_empty_new_password_confirmation
    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    AND I send a PATCH request:    /customer-password/${yves_user.reference}   {"data":{"type":"customer-password","attributes":{"password":"${yves_user.password}","newPassword":"${yves_user.password_new}","confirmPassword":""}}}
    Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    confirmPassword => This value is too short. It should have 8 characters or more.
    And Array in response should contain property with value:    [errors]    detail    confirmPassword => This value should not be blank.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_customer_password_with_non_autorizated_user
    AND I send a PATCH request:    /customer-password/${yves_user.reference}   {"data":{"type":"customer-password","attributes":{"password":"${yves_user.password}","newPassword":"${yves_user.password_new}","confirmPassword":"${yves_user.password_new}"}}}
    Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_customer_password_with_not_valid_user_password
    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    AND I send a PATCH request:    /customer-password/${yves_user.reference}   {"data":{"type":"customer-password","attributes":{"password":"${yves_user.password_new}","newPassword":"${yves_user.password}","confirmPassword":"${yves_user.password}"}}}
    Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    408
    And Response should return error message:    Invalid password
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_customer_password_with_too_short_password
    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    AND I send a PATCH request:    /customer-password/${yves_user.reference}   {"data":{"type":"customer-password","attributes":{"password":"${yves_user.password_new}","newPassword":"test","confirmPassword":"test"}}}
    Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    newPassword => This value is too short. It should have 8 characters or more.
    And Array in response should contain property with value:    [errors]    detail    confirmPassword => This value is too short. It should have 8 characters or more.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_customer_password_with_too_long_password
    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    AND I send a PATCH request:    /customer-password/${yves_user.reference}   {"data":{"type":"customer-password","attributes":{"password":"${yves_user.password_new}","newPassword":"tests1234567890tests1234567890tests1234567890tests1234567890tests1234567890","confirmPassword":"tests1234567890tests1234567890tests1234567890tests1234567890tests1234567890"}}}
    Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    newPassword => This value is too long. It should have 64 characters or less.
    And Array in response should contain property with value:    [errors]    detail    confirmPassword => This value is too long. It should have 64 characters or less.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_customer_password_with_too_weak_password
    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    AND I send a PATCH request:    /customer-password/${yves_user.reference}   {"data":{"type":"customer-password","attributes":{"password":"${yves_user.password_new}","newPassword":"12345678","confirmPassword":"12345678"}}}
    Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    408
    And Response should return error message:    Invalid password
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_customer_password_with_wrong_customer_reference
    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    AND I send a PATCH request:    /customer-password/test123   {"data":{"type":"customer-password","attributes":{"password":"${yves_user.password_new}","newPassword":"12345678","confirmPassword":"12345678"}}}
    Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    411
    And Response should return error message:    Unauthorized request.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_customer_password_with_missing_customer_reference
    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    AND I send a PATCH request:    /customer-password/   {"data":{"type":"customer-password","attributes":{"password":"${yves_user.password_new}","newPassword":"12345678","confirmPassword":"12345678"}}}
    Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_customer_password_with_missing_mandatory_fields
    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    AND I send a PATCH request:    /customer-password/test123   {"data":{"type":"customer-password","attributes":{"newPassword":"${yves_user.password}"}}}
    Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    password => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    confirmPassword => This field is missing.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_customer_password_with_invalid_access_token
    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    AND I send a PATCH request:    /customer-password/${yves_user.reference}   {"data":{"type":"customer-password","attributes":{"password":"${yves_user.password}","newPassword":"${yves_user.password}","confirmPassword":"${yves_user.password_new}"}}}
    Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    411
    And Response should return error message:    Unauthorized request.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
