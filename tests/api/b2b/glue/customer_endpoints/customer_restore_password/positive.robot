*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Restore_password_with_all_required_fields_and_valid_data
    I send a PATCH request:    /customer-restore-password/${yves_user_reference}   {"data":{"type":"customer-restore-password","attributes":{"restorePasswordKey":"a46b40a8e1befff4cf0df9c7c2ace5f2","password":"${yves_user_password}","confirmPassword":"${yves_user_password}"}}}
    And Response status code should be:    204
    And Response reason should be:    No Content