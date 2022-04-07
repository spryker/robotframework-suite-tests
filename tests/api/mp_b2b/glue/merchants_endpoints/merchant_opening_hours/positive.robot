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
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
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