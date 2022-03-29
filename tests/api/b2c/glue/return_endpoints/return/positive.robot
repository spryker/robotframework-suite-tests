*** Settings ***
Suite Setup       SuiteSetup
Default Tags      glue
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
####POST####
Create_a_return
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user_email}
    ...     AND     I set Headers:     Authorization=${token}
    

    When I send a POST request with data:     /returns     {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${salesOrderItemUuid}","reason":"${return_resaon}"}]}}}
    Then Response status code should be:     201
    And Response reason should be:     Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    ${return_type}
    And Response body has correct self link

Get_lists_of_returns
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user_email}
    ...     AND     I set Headers:     Authorization=${token}
    When I send a GET request:     /returns
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response header parameter should be:     Content-Type     ${default_header_content_type}
    And Response body parameter should be:     [data][0][type]     ${return_type}
    And Response body parameter should not be EMPTY:     [data][0][id]
    And Save value to a variable:     [data][0][id]     returnId
    And Response body parameter should be:     [data][0][attributes][returnReference]     ${returnId}
    And Response body parameter should be:     [data][0][attributes][store]     DE
    And Response body parameter should be:     [data][0][attributes][customerReference]     DE--4
    And Response body parameter should be:     [data][0][attributes][returnTotals][refundTotal]     0
    And Response body has correct self link

Get_return_by_Id
    [Setup]     Run Keywords    I get access token for the customer:    ${yves_second_user_email}
    ...     AND     I set Headers:     Authorization=${token}
    When I send a GET request:     /returns/DE--4-R2
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response header parameter should be:     Content-Type     ${default_header_content_type}
    And Response body parameter should be:     [data][type]     ${return_type}
    And Response body parameter should not be EMPTY:     [data][id]
    And Response body parameter should be:     [data][id]     DE--4-R2
    And Response body parameter should be:     [data][attributes][returnReference]     DE--4-R2
    And Response body parameter should be:     [data][attributes][store]     DE
    And Response body parameter should be:     [data][attributes][customerReference]     DE--4
    And Response body parameter should be:     [data][attributes][returnTotals][refundTotal]     0
