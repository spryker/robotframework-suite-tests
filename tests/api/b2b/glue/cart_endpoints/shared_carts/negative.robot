*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Share_not_owned_shopping_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    ...    AND    Then I get access token for the customer:    ${yves_shared_shopping_cart_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":1}}}
    Then Response status code should be:    403
    And Response should return error code:    2701
    And Response reason should be:    Forbidden
    And Response should return error message:    Action is forbidden.
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Share_shopping_cart_with_incorrect_permission_group
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    When I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":3}}}
    Then Response status code should be:    422
    And Response should return error code:    2501
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    Cart permission group not found.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Share_shopping_cart_with_empty_permission_group_value
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    When I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":""}}}
    Then Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    idCartPermissionGroup => This value should not be blank.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Share_shopping_cart_with_empty_company_user_value
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    When I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"","idCartPermissionGroup":2}}}
    Then Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    idCompanyUser => This value should not be blank.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Share_shopping_cart_without_company_user_attribute
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    When I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCartPermissionGroup":2}}}
    Then Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    idCompanyUser => This field is missing.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Share_shopping_cart_to_the_other_company_user
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_fourth_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    ...    AND    Then I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    When I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":1}}}
    Then Response status code should be:    403
    And Response should return error code:    2703
    And Response reason should be:    Forbidden
    And Response should return error message:    Cart can be shared only with company users from same company.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Share_shopping_cart_without_access_token
    When I send a POST request:    /carts/shoppingCartId/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":1}}}
    Then Response status code should be:    403
    And Response should return error code:    002
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.

Share_shopping_cart_with_wrong_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}1
    When I send a POST request:    /carts/shoppingCartId/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":1}}}
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Share_shopping_cart_with_empty_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /carts//shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":1}}}
    Then Response status code should be:    400
    And Response should return error code:    104
    And Response reason should be:    Bad Request
    And Response should return error message:    Cart uuid is missing.

Share_shopping_cart_with_empty_company_user_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /carts/shoppingCartId/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"","idCartPermissionGroup":1}}}
    Then Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    idCompanyUser => This value should not be blank.

Share_shopping_cart_with_incorrect_cart_permission_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    When I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":3}}}
    Then Response status code should be:    422
    And Response should return error code:    2501
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    Cart permission group not found.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Share_shopping_cart_to_non_existing_company_user
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    When I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"nonExistingCompanyUserId","idCartPermissionGroup":2}}}
    Then Response status code should be:    404
    And Response should return error code:    1404
    And Response reason should be:    Not Found
    And Response should return error message:    Company user not found
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Update_permissions_of_shared_shopping_cart_without_access_token
    When I send a PATCH request:    /shared-carts/sharedCardId    {"data":{"type":"shared-carts","attributes":{"idCartPermissionGroup":1}}}
    Then Response status code should be:    403
    And Response should return error code:    002
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.

Update_permissions_of_shared_shopping_cart_with_wrong_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}1
    When I send a PATCH request:    /shared-carts/sharedCardId    {"data":{"type":"shared-carts","attributes":{"idCartPermissionGroup":1}}}
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Update_permissions_of_shared_shopping_cart_without_shared_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    When I send a PATCH request:    /shared-carts    {"data":{"type":"shared-carts","attributes":{"idCartPermissionGroup":1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Update_permissions_of_shared_shopping_cart_with_incorrect_permission_group
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    ...    AND    I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":2}}}
    ...    AND    Save value to a variable:    [data][id]    sharedCardId
    When I send a PATCH request:    /shared-carts/${sharedCardId}    {"data":{"type":"shared-carts","attributes":{"idCartPermissionGroup":3}}}
    Then Response status code should be:    422
    And Response should return error code:    2501
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    Cart permission group not found.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Update_permissions_of_shared_shopping_cart_with_empty_permission_group_value
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    ...    AND    I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":2}}}
    ...    AND    Save value to a variable:    [data][id]    sharedCardId
    When I send a PATCH request:    /shared-carts/${sharedCardId}    {"data":{"type":"shared-carts","attributes":{"idCartPermissionGroup":""}}}
    Then Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    idCartPermissionGroup => This value should not be blank.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Update_permissions_of_shared_shopping_cart_without_permission_group_attribute
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    ...    AND    I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":2}}}
    ...    AND    Save value to a variable:    [data][id]    sharedCardId
    When I send a PATCH request:    /shared-carts/${sharedCardId}    {"data":{"type":"shared-carts","attributes":{}}}
    Then Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    idCartPermissionGroup => This field is missing.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_an_item_to_the_shared_shopping_cart_by_user_without_access
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    ...    AND    I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":1}}}
    ...    AND    Then I get access token for the customer:    ${yves_shared_shopping_cart_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    Then Response status code should be:    403
    And Response should return error code:    115
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized cart action.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Update_an_item_quantity_at_the_shared_shopping_cart_by_user_without_access
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    ...    AND    I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Then I get access token for the customer:    ${yves_shared_shopping_cart_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a PATCH request:    /carts/${cartId}/items/${concrete_available_product_sku}    {"data":{"type":"items","attributes":{"quantity":2}}}
    Then Response status code should be:    403
    And Response should return error code:    115
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized cart action.
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Remove_an_item_from_the_shared_shopping_cart_by_user_without_access
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    ...    AND    I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Then I get access token for the customer:    ${yves_shared_shopping_cart_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:    /carts/${cartId}/items/${concrete_available_product_sku}
    Then Response status code should be:    403
    And Response should return error code:    115
    And Response reason should be:    Forbidden
    And Response should return error message:    Unauthorized cart action.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Remove_the_shared_shopping_cart_by_user_without_access
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    ...    AND    I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":1}}}
    ...    AND    Save value to a variable:    [data][id]    sharedCardId
    ...    AND    Then I get access token for the customer:    ${yves_shared_shopping_cart_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:    /shared-carts/${sharedCardId}
    Then Response status code should be:    403
    And Response should return error code:    2701
    And Response reason should be:    Forbidden
    And Response should return error message:    Action is forbidden.
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Remove_the_already_deleted_shared_shopping_cart_by_user_with_access
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a GET request:    /company-users
    ...    AND    Save value to a variable:    [data][0][id]    companyUserId
    ...    AND    I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":1}}}
    ...    AND    Save value to a variable:    [data][id]    sharedCardId
    ...    AND    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
    ...    AND    Then I get access token for the customer:    ${yves_shared_shopping_cart_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:    /shared-carts/${sharedCardId}
    Then Response status code should be:    404
    And Response should return error code:    2705
    And Response reason should be:    Not Found
    And Response should return error message:    Shared cart not found.