*** Settings ***
Library    BuiltIn
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Resource    ../../Resources/Common/Common.robot

*** Test Cases ***
test_new_function
    Set Up Keyword Arguments    || first name | last name | email           | street name    | zip code | telephone     || 
    ...                         || Mike       | Miller    | test@spyker.com | My Street 123  | 12345    | +123123456789 ||
