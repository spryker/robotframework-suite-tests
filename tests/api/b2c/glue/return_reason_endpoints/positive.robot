*** Settings ***
Resource    ../../../../../resources/common/common_api.robot
Suite Setup        SuiteSetup
Test Setup         TestSetup

Default Tags    glue

*** Test Cases ***
#GET requests
Get_return_reason
     When I send a GET request:    /return-reasons
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:    [data]    type    return-reasons
    And Each array element of array in response should contain property with value:    [data]    id    None
    And Each array element of array in response should contain nested property:    [data]    [attributes]    reason    
    And Response body has correct self link
    And Response body parameter should not be EMPTY:    [data][0][attributes][reason]
    And Save value to a variable:    [links][self]    self_link
    And Each array element of array in response should contain nested property with value:    [data]    [links][self]    ${self_link}
    ${length}=    And Get length of array:    [data] 
    And Response should contain the array of a certain size:    [data]    ${length}
    