*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Get_new_product_label_by_id
    When I send a GET request:    /product-labels/${new_label_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${new_label_id}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${new_label}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal

Get_sale_product_label_by_id
    When I send a GET request:    /product-labels/${sale_label_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${sale_label_id}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${sale_label}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal   

Get_discontinued_product_label_by_id
    When I send a GET request:    /product-labels/${discontinued_label_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${discontinued_label_id}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${discontinued_label}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal  

Get_alternatives_product_label_by_id
    When I send a GET request:    /product-labels/${alternatives_label_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${alternatives_label_id}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${alternatives_label}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal           