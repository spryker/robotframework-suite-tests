*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
#GET requests
Get_availability_notifications_for_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /availability-notifications    {"data": {"type": "availability-notifications","attributes": {"sku": "${concrete_product_with_alternative_sku}","email": "${yves_user_email}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    availability_notification_id
    I send a GET request:    /customers/${yves_user_reference}/availability-notifications
    Response status code should be:    200
    And Response reason should be:    OK
    And Response body should contain:    availability-notifications
    And Response body should contain:    ${availability_notification_id}
    And Response body parameter should not be EMPTY:    [data][attributes][localeName]
    And Response body should contain:    ${yves_user_email}
    And Response body should contain:    ${concrete_product_with_alternative_sku}
    And Response body should contain:    ${availability_notification_id}
    And Response body has correct self link
    [Teardown]    Run Keywords    I send a DELETE request:    /availability-notifications/${availability_notification_id}
    ...  AND    Response status code should be:    204

Get_empty_list_of_availability_notifications_for_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    I send a GET request:    /customers/${yves_user_reference}/availability-notifications
    Response status code should be:    200
    And Response reason should be:    OK
    And Response body has correct self link



#POST requests
Subscribe_to_availability_notifications_for_customer
    I send a POST request:    /availability-notifications    {"data": {"type": "availability-notifications","attributes": {"sku": "${concrete_product_with_alternative_sku}","email": "${yves_user_email}"}}}
    Save value to a variable:    [data][id]    availability_notification_id
    Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    availability-notifications
    And Response body parameter should be:    [data][id]    ${availability_notification_id}
    And Response body parameter should not be EMPTY:    [data][attributes][localeName]
    And Response body parameter should be:    [data][attributes][email]    ${yves_user_email}
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product_with_alternative_sku}
    And Response body has correct self link for created entity:    ${availability_notification_id}
    [Teardown]    Run Keywords    I send a DELETE request:    /availability-notifications/${availability_notification_id}
    ...  AND    Response status code should be:    204

Subscribe_to_availability_notifications_with_non_existed_email
    I send a POST request:    /availability-notifications    {"data": {"type": "availability-notifications","attributes": {"sku": "${concrete_product_with_alternative_sku}","email": "test1234546@gmail.com"}}}
    Save value to a variable:    [data][id]    availability_notification_id
    Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    availability-notifications
    And Response body parameter should be:    [data][id]    ${availability_notification_id}
    And Response body parameter should not be EMPTY:    [data][attributes][localeName]
    And Response body parameter should be:    [data][attributes][email]    test1234546@gmail.com
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product_with_alternative_sku}
    And Response body has correct self link for created entity:    ${availability_notification_id}
    [Teardown]    Run Keywords    I send a DELETE request:    /availability-notifications/${availability_notification_id}
    ...  AND    Response status code should be:    204



#DELETE requests
Delete_availability_notifications_for_customer
    [Setup]    Run Keywords    I send a POST request:    /availability-notifications    {"data": {"type": "availability-notifications","attributes": {"sku": "${concrete_product_with_alternative_sku}","email": "${yves_user_email}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    availability_notification_id
    I send a DELETE request:    /availability-notifications/${availability_notification_id}
    Response status code should be:    204
    And Response reason should be:    No Content