*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***

Get_product_measurement_unit_by_id
    When I send a GET request:    /product-measurement-units/${packaging_unit_m}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${packaging_unit_m}
    And Response body parameter should be:    [data][type]    product-measurement-units
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should not be EMPTY:    [data][attributes][defaultPrecision]
    And Response body parameter should have datatype:    [data][attributes][defaultPrecision]    int
    And Response body has correct self link internal
