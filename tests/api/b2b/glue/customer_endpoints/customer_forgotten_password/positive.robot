*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Forgot_password_is_working
    I send a POST request:    /customer-forgotten-password    {"data":{"type":"customer-forgotten-password","attributes":{"email":"${yves_user_email}"}}}
    Response status code should be:    204