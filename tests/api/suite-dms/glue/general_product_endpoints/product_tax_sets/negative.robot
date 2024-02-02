*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Default Tags    glue_dms_eu

*** Test Cases ***
ENABLER
    API_test_setup
Get_a_tax_set_with_invalid_concrete_sku
    When I send a GET request:    /abstract-products/test123/product-tax-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    310
    And Response should return error message:    Product tax sets not found.

Get_a_tax_set_with_missing_sku
    When I send a GET request:    /abstract-products//product-tax-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    301
    And Response should return error message:    Abstract product is not found.

Get_a_tax_set_with_non_existing_sku
    When I send a GET request:    /abstract-products/fake/product-tax-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    310
    And Response should return error message:    Product tax sets not found.
