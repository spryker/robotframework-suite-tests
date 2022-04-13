*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Retrieves_merchant_opening_hours
    When I send a GET request:  /merchants/${merchant_id}/merchant-opening-hours
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${merchant_id}
    And Response body parameter should be:    [data][0][type]    merchant-opening-hours
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    merchant-opening-hours
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][weekdaySchedule]    list
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][dateSchedule]    list
    And Each array element of array in response should contain nested property:    [data]    [attributes][weekdaySchedule]    day
    And Each array element of array in response should contain nested property:    [data]    [attributes][weekdaySchedule]    timeFrom
    And Each array element of array in response should contain nested property:    [data]    [attributes][weekdaySchedule]    timeTo
    And Each array element of array in response should contain nested property:    [data]    [attributes][dateSchedule]    date
    And Each array element of array in response should contain nested property:    [data]    [attributes][dateSchedule]    timeFrom
    And Each array element of array in response should contain nested property:    [data]    [attributes][dateSchedule]    timeTo
    And Each array element of array in response should contain nested property:    [data]    [attributes][dateSchedule]    noteGlossaryKey
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link



Retrieves_merchant_with_include_merchant_opening_hours
    When I send a GET request:  /merchants/${merchant_id}?include=merchant-opening-hours
    Then Response status code should be:    200
    And Response reason should be:    OK    
    And Response body parameter should be:    [data][type]    merchants
    And Response body parameter should be:    [data][id]    ${merchant_id}
    And Response Should Contain The Array Larger Than a Certain Size:    [included]    0
    And Response Should Contain The Array Larger Than a Certain Size:    [data][relationships]    0
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][merchant-opening-hours]
    And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][merchant-opening-hours][data]    type
    And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][merchant-opening-hours][data]    id
    And Response body parameter should not be EMPTY:    [included]
    And Each Array Element Of Array In Response Should Contain Property:    [included]    type
    And Each Array Element Of Array In Response Should Contain Property:    [included]    id
    And Each Array Element Of Array In Response Should Contain Property:    [included]    attributes
    And Each Array Element Of Array In Response Should Contain Property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain property with value:    [included]    type    merchant-opening-hours
    And Each array element of array in response should contain nested property:    [included]    [attributes][weekdaySchedule]    day
    And Each array element of array in response should contain nested property:    [included]    [attributes][weekdaySchedule]    timeFrom
    And Each array element of array in response should contain nested property:    [included]    [attributes][weekdaySchedule]    timeTo
    And Each array element of array in response should contain nested property:    [included]    [attributes][dateSchedule]    date
    And Each array element of array in response should contain nested property:    [included]    [attributes][dateSchedule]    timeFrom
    And Each array element of array in response should contain nested property:    [included]    [attributes][dateSchedule]    timeTo
    And Each array element of array in response should contain nested property:    [included]    [attributes][dateSchedule]    noteGlossaryKey