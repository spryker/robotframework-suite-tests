*** Settings ***
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Library           SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Resource          ../../Resources/Common/Common_Zed.robot

# Environment variables
# ${warehouse_name}

*** Variables ***
${navigation_item_level1}       Administration
${navigation_item_level2}       Warehouses
${button_to_create_warehouse}   Create Warehouse
${warehouse_name_field}         id=stock_name
${warehouse_is_active_true}     id=stock_isActive_0
${warehouse_is_active_false}    id=stock_isActive_1
${warehouse_tab_1}              Configuration
${warehouse_tab_2}              Store Relation
${store_1}                      DE
${store_2}                      AT
${store_3}                      US
${warehouse_submit_form}        id=submit-stock


*** Test Cases ***
Warehouse_Management_Creation
    [Documentation]    Checks that a user can create a warehouse
    Zed: Go to the warehouse list
    Zed: click button in Header:                    ${button_to_create_warehouse}
    Wait For Document Ready
    Element Should Be Visible                       xpath=//body//*[contains(text(),'Create Warehouse')]    message=Page for Warehouse creation is not opened
    Input text into field                           ${warehouse_name_field}   ${warehouse_name}
    Scroll and Click Element                        ${warehouse_is_active_true}
    Zed: go to tab:                                 ${warehouse_tab_2}
    Zed: select checkbox by Label:                  ${store_1}
    Zed: select checkbox by Label:                  ${store_2}
    Zed: select checkbox by Label:                  ${store_3}
    Zed: submit the form:                           ${warehouse_submit_form}
    Zed: table should contain:                      ${warehouse_name}

Warehouse_Management_Edition
    [Documentation]    Checks that a user can edit a warehouse
    Zed: Go to the warehouse list
    Zed: table should contain:                      ${warehouse_name}
    Scroll and Click Element                        xpath=/html/body/div[1]/div/div[3]/div[2]/div/div/div[2]/div/div[2]/div/div[1]/div[2]/table/tbody/tr/td[5]/a[2]
    Wait For Document Ready
    Element Should Be Visible                       xpath=//body//*[contains(text(),'Edit Warehouse')]    message=Page for Warehouse edition is not opened
    Input text into field                           ${warehouse_name_field}   ${warehouse_name}-updated
    Scroll and Click Element                        ${warehouse_is_active_false}
    Zed: go to tab:                                 ${warehouse_tab_2}
    Zed: unselect checkbox by Label:                ${store_2}
    Zed: unselect checkbox by Label:                ${store_3}
    Zed: submit the form:                           ${warehouse_submit_form}
    Zed: table should contain:                      ${warehouse_name}

#Warehouse_Management_Deletion
#    [Documentation]    Checks that a user can delete a warehouse
#    This capability is missing at the moment, see https://spryker.aha.io/features/INV-5


*** Keywords ***
Zed: Go to the warehouse list
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:        ${navigation_item_level1}    ${navigation_item_level2}
