*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

Get_list_of_abstract_products
    ### POST ###
    When I set Headers:    Content-Type=application/x-www-form-urlencoded
    And I send a POST request with data:    /token    'grantType=password&username=admin@spryker.com&password=change123'
    Then Response status code should be:    201
    And Response body parameter should be:    [0][token_type]    Bearer
    And Response body parameter should be greater than:    [0][expires_in]    0
    And Response body parameter should be less than:    [0][expires_in]    30000
    And Response body parameter should not be EMPTY:    [0][token_type]
    And Response body parameter should not be EMPTY:    [0][access_token]
    And Response body parameter should not be EMPTY:    [0][refresh_token]
    ### GET WITH INVALID TOKEN ###
    When Save value to a variable:    [0][access_token]    token
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /product-abstract?page[offset]=0&page[limit]=10&sort=-sku
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
    ### GET WITH VALID TOKEN (DOESN'T WORK :( ))###
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    And I send a GET request:    /product-abstract?page[offset]=0&page[limit]=10&sort=-sku
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    007
    And Response should return error message:    Not found