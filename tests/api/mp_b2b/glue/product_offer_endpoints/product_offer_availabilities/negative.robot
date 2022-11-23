*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

# There is a bug https://spryker.atlassian.net/browse/CC-17140
Get_not_existing_product_offer_availabilities
    When I send a GET request:    /product-offers/test/product-offer-availabilities
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

# There is a bug https://spryker.atlassian.net/browse/CC-17140
Get_empty_product_offer_availabilities
    When I send a GET request:    /product-offers//product-offer-availabilities
    Then Response status code should be:    400
    And Response should return error code:    3702
    And Response reason should be:    Bad Request
    And Response should return error message:    Product offer ID is not specified.

# There is a bug https://spryker.atlassian.net/browse/CC-17140
Get_not_existing_product_offer_availabilities_for_inactive_product_offer
    When I send a GET request:    /product-offers/${inactive_offer_with_volume_price}/product-offer-availabilities
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

# There is a bug https://spryker.atlassian.net/browse/CC-17140
Get_not_existing_product_offer_availabilities_for_waiting_for_approval_product_offer
    When I send a GET request:    /product-offers/${waiting_for_approval_offer_with_volume_price}/product-offer-availabilities
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}