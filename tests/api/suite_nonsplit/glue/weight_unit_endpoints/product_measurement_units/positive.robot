*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup    TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
Get_product_measurement_unit_by_id
    When I send a GET request:    /product-measurement-units/${measurement_unit.m}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${measurement_unit.m}
    And Response body parameter should be:    [data][type]    product-measurement-units
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should not be EMPTY:    [data][attributes][defaultPrecision]
    And Response body parameter should have datatype:    [data][attributes][defaultPrecision]    int
    And Response body has correct self link internal
