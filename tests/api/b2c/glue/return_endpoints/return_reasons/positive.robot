*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup        SuiteSetup
Test Setup         TestSetup
Default Tags    glue

*** Test Cases ***
#GET requests
ENABLER
    TestSetup
Get_return_reason
    When I send a GET request:    /return-reasons
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:    [data]    type    return-reasons
    And Each array element of array in response should contain nested property:    [data]    [attributes]    reason    
    And Response should contain the array of a certain size:    [data]    ${return_reasons_qty}
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property with value NOT in:    [data]    [links][self]    None
    And Response body has correct self link