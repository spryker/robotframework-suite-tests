*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Retrieves_a_shipment_type_with_non_existed_shipment_type_uuid
    When I send a GET request:   /shipment-types/NON_EXISTED_SHIPMENT_TYPE_UUID
    Then Response status code should be:    404
    And Response reason should be:  Not Found
    And Response should return error code:    5501
    And Response should return error message:    A delivery type entity was not found.

Retrieves_a_shipment_type_by_uuid_with_a_wrong_uri
    When I send a GET request:   /shipment-type/${shipment_type_delivery_test.uuid}
    Then Response status code should be:    404
    And Response reason should be:  Not Found

Retrieves_a_shipment_type_collection_with_a_wrong_uri
    When I send a GET request:    /shipment-type
    Then Response status code should be:    404
    And Response reason should be:  Not Found
