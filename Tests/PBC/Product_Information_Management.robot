*** Settings ***
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Library           SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Resource          ../../Resources/Common/Common_Zed.robot
Resource          ../../Resources/Common/Product_Information_Management.robot

# Environment variables

*** Variables ***
${button_to_create_attribute}   Create Product Attribute


*** Test Cases ***
Attribute_Creation_Basic
    [Documentation]                                 Checks that a user can create a product
    Zed: Go to the attribute list
    Zed: click button in Header:                    ${button_to_create_attribute}
    Wait For Document Ready
    Element Should Be Visible                       xpath=//body//*[contains(text(),'Product Attributes')]    message=Page for Attribute creation is not opened


*** Keywords ***
Zed: Go to the attribute list
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:        Catalog    Attributes

Zed: Go to the category list
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:        Catalog    Categories