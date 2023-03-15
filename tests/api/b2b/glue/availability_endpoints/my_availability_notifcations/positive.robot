*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Get_my_availability_notifications
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /availability-notifications    {"data": {"type": "availability-notifications","attributes": {"sku": "${concrete.alternative_products.product_1.sku}","email": "${yves_user.email}"}}}
    ...    AND    Save value to a variable:    [data][id]    availability_notification_id
    ...    AND    Response status code should be:    201
    When I send a GET request:    /my-availability-notifications
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][type]    availability-notifications
    And Response body parameter should be:    [data][0][id]    ${availability_notification_id}
    And Response body parameter should be:    [data][0][attributes][localeName]    ${locale.EN.name}
    And Response body parameter should be:    [data][0][attributes][email]    ${yves_user.email}
    And Response body parameter should be:
    ...    [data][0][attributes][sku]
    ...    ${concrete.alternative_products.product_1.sku}
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain nested property:    [data]    [attributes]    localeName
    And Each array element of array in response should contain nested property:    [data]    [attributes]    email
    And Each array element of array in response should contain nested property:    [data]    [attributes]    sku
    And Response body has correct self link
    [Teardown]    Run Keywords    I send a DELETE request:    /availability-notifications/${availability_notification_id}
    ...    AND    Response status code should be:    204
