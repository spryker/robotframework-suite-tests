*** Settings ***
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Library           SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Resource          ../../Resources/Common/Common_Zed.robot

*** Test Cases ***
Warehouse_Management
    [Documentation]    Checks that a user can create a warehouse
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Administration    Warehouses
    Zed: click button in Header:    Create Warehouse
    Wait For Document Ready
    Element Should Be Visible    xpath=//body//*[contains(text(),'Create Warehouse')]    message=Page for Warehouse creation is not opened
    Input text into field    id=stock-name   Test-PBC