*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Search_without_query_parameter
   [Documentation]   bug https://spryker.atlassian.net/browse/CC-15983
   [Tags]    skip-due-to-issue 
    When I send a GET request:    /catalog-search?
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    q parameter is missing.

Search_with_invalid_currency
    When I send a GET request:    /catalog-search?q=&currency=InvalidCurrency
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    313
    And Response should return error message:    Currency is invalid.

Search_with_invalid_price_mode
    When I send a GET request:    /catalog-search?q=&priceMode=InvalidPriceMode
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    314
    And Response should return error message:    Price mode is invalid.

Search_with_invalid_rating_min
    When I send a GET request:    /catalog-search?q=&rating[min]=InvalidMinRating5
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    503
    And Response should return error message:    Value of rating.min must be of type integer.

Search_with_invalid_rating_max
    When I send a GET request:    /catalog-search?q=&rating[max]=InvalidMinRating5
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    503
    And Response should return error message:    Value of rating.max must be of type integer.

Search_with_invalid_category
    When I send a GET request:    /catalog-search?q=&category=!@!@!
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    503
    And Response should return error message:    Value of category must be of type integer.