*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Get_cart_permission_group_with_unauthenicated_user
    When I send a GET request:    /cart-permission-groups/1
    Then Response status code should be:    403
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Get_cart_permission_group_by_non_exist_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /cart-permission-groups/111111
    Then Response status code should be:    404
    And Response should return error code:    2501
    And Response should return error message:    Cart permission group not found.
