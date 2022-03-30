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
    And Response body parameter should be:    [data][0][type]    return-reasons
    And Response body parameter should be:    [data][0][id]    None
    And Response body has correct self link
    And Response body parameter should not be EMPTY:    [data][0][attributes][reason]
    And Save value to a variable:    [links][self]    self_link
    @{data1}=    Get Value From Json    ${response_body}    [data]
    ${list_length}=    Get Length    @{data1}
    ${log_list}=    Log List    @{data1}
    FOR    ${index}    IN RANGE    0    ${list_length}
        And Response body parameter should be:    [data][${index}][links][self]    ${self_link}        
    END
    ${list_length}=    Convert To String    ${list_length} 
    And Response should contain the array of a certain size:    [data]    ${list_length}