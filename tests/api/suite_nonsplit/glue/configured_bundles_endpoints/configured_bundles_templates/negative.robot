*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Get_configurable_bundle_templates_by_invalid_configurable_bundle_template_id
    When I send a GET request:    /configurable-bundle-templates/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    3901
    And Response should return error message:    Configurable bundle template not found.