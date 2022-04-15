*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
    
Get_products_with_invalid_label_id
    When I send a GET request:    /product-labels/${label_id_manual}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][id]    ${label_id_manual}
    And Response body parameter should be:    [data][attributes][name]    ${label_name_manual}
    And Response body parameter should have datatype:    [data][attributes][isExclusive]    bool
    And Response body parameter should have datatype:    [data][attributes][position]    int
    And Response body parameter should have datatype:    [data][attributes][frontEndReference]    str
    And Response body parameter should be greater than:    [data][attributes][position]    0
    And Response body has correct self link internal