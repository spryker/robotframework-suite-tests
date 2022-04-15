*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
ENABLER
    TestSetup


Request_product_labels_by_product_id
    When I send a GET request:    /product-labels/${label_id_manual}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    # And Response body parameter should be:    [data][type]    product_labels
    # And Response body parameter should be:    [data][id]    ${company_id}
    # And Response body parameter should be:    [data][attributes][name]    ${company_name}
    # And Response body parameter should be:    [data][attributes][status]    approved
    # And Response body parameter should be:    [data][attributes][isActive]    True
    # And Response should contain the array of a certain size:    [data][attributes]    3






