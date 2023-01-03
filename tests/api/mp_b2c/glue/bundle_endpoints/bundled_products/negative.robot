*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
    
Get_bundled_products_with_nonexisting_concrete_sku
    [Documentation]   there is a bug - https://spryker.atlassian.net/browse/CC-15994
    [Tags]     skip-due-to-issue
    When I send a GET request:    /concrete-products/fake/bundled-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.

Get_bundled_products_with_invalid_concrete_sku
    [Documentation]   there is a bug - https://spryker.atlassian.net/browse/CC-15994
    [Tags]     skip-due-to-issue
    When I send a GET request:    /concrete-products/:sku/bundled-products
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    312
    And Response should return error message:    Concrete product sku is not specified.

Get_bundled_products_with_missing_concrete_sku
    When I send a GET request:    /concrete-products//bundled-products
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    312
    And Response should return error message:    Concrete product sku is not specified.