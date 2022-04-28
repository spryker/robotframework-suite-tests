*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
# can't receive the confirmation from email so cannot check end to end
# Restore_password_with_all_required_fields_and_valid_data
#     # need receive the confirmation key from email
#     I send a PATCH request:    /customer-restore-password/${yves_user_reference}   {"data":{"type":"customer-restore-password","attributes":{"restorePasswordKey":"98ffa3ecccac2b7f0815e0417784cd54","password":"${yves_user_password}","confirmPassword":"${yves_user_password}"}}}
#     And Response status code should be:    204
#     And Response reason should be:    No Content