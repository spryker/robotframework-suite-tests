*** Settings ***
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Library           SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Resource          ../../Resources/Common/Common_Zed.robot
Resource          ../../Resources/Common/Product_Information_Management.robot


# Environment variables
# ${warehouse_name}

*** Variables ***
${button_to_create_warehouse}   Create Warehouse
${warehouse_name_field}         id=stock_name
${warehouse_is_active_true}     id=stock_isActive_0
${warehouse_is_active_false}    id=stock_isActive_1
${warehouse_edit_tab_1}         Configuration
${warehouse_edit_tab_2}         Store Relation
${store_1}                      DE
${store_2}                      AT
${store_3}                      US
@{assign_stores}=               ${store_1}    ${store_2}    ${store_3}
@{remove_stores}=               ${store_2}    ${store_3}
${warehouse_submit_form}        id=submit-stock
${warehouse_table}              stock_data_table


*** Test Cases ***
Warehouse_Creation
    [Documentation]                                 Checks that a user can create a warehouse
    Zed: Go to the warehouse list
    Zed: click button in Header:                    ${button_to_create_warehouse}
    Wait For Document Ready
    Element Should Be Visible                       xpath=//body//*[contains(text(),'Create Warehouse')]    message=Page for Warehouse creation is not opened
    Zed: Define a Warehouse name:                   ${warehouse_name}
    Zed: Activate/Deactivate a Warehouse:           'true'
    Zed: Assign stores to a Warehouse:              @{assign_stores}
    Zed: submit the form:                           ${warehouse_submit_form}
    Zed: table should contain:                      ${warehouse_name}
    Zed: Table column value should be equal to:     ${warehouse_table}    2    ${warehouse_name}

Warehouse_View
    [Documentation]                                 Checks that a user can view a warehouse
    Zed: Go to the warehouse list
    Zed: table should contain:                      ${warehouse_name}
    Scroll and Click Element                        xpath=/html/body/div[1]/div/div[3]/div[2]/div/div/div[2]/div/div[2]/div/div[1]/div[2]/table/tbody/tr/td[5]/a[1]
    Wait For Document Ready
    Element Should Be Visible                       xpath=//body//*[contains(text(),'View Warehouse: ${warehouse_name}')]    message=Page for Warehouse view page is not opened
    Element Text Should Be                          xpath=/html/body/div[1]/div/div[3]/div[2]/div/div/div[2]/div[1]/div/dl/dd    ${warehouse_name}

# Availability_Define_Stock_For_Warehouse_And_Product
#     [Documentation]                                 Checks that a user can define a stock for a product for the new warehouse
#     Zed: Go to the product list
#     Zed: Edit a Concrete Product:                   ${one_variant_product_abstract_sku}    ${one_variant_product_concrete_sku}
#     Zed: go to tab:                                 ${concrete_product_edit_tab_2}

Warehouse_Edition
    [Documentation]                                 Checks that a user can edit a warehouse. Make some changes and roll-back.
    Zed: Go to the warehouse list
    Zed: Edit a Warehouse:                          ${warehouse_name}
    Zed: Define a Warehouse name:                   ${warehouse_name}-updated
    Zed: Activate/Deactivate a Warehouse:           'false'
    Zed: Remove stores from a Warehouse:            @{remove_stores}
    Zed: submit the form:                           ${warehouse_submit_form}
    Zed: table should contain:                      ${warehouse_name}
    Zed: Table column value should be equal to:     ${warehouse_table}    2    ${warehouse_name}-updated

#Warehouse_Management_Deletion
#    [Documentation]    Checks that a user can delete a warehouse
#    This capability is missing at the moment, see https://spryker.aha.io/features/INV-5


*** Keywords ***
Zed: Go to the warehouse list
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:        Administration    Warehouses

Zed: Edit a Warehouse:
    [Documentation]                                 Enter the edit page of a warehouse. Expect to be in the Warehouse list page.
    [Arguments]                                     ${warehouse_name}
    Zed: table should contain:                      ${warehouse_name}
    Scroll and Click Element                        xpath=/html/body/div[1]/div/div[3]/div[2]/div/div/div[2]/div/div[2]/div/div[1]/div[2]/table/tbody/tr/td[5]/a[2]
    Wait For Document Ready
    Element Should Be Visible                       xpath=//body//*[contains(text(),'Edit Warehouse')]    message=Page for Warehouse edition is not opened

Zed: Activate/Deactivate a Warehouse:
    [Documentation]                                 Toggle the is_active property of a warehouse. Expect to be in the edit page of a warehouse
    [Arguments]                                     ${state}
    Zed: go to tab:                                 ${warehouse_edit_tab_1}
    IF    ${state} == 'true'
    Scroll and Click Element                        ${warehouse_is_active_true}
    ELSE
    Scroll and Click Element                        ${warehouse_is_active_false}
    END

Zed: Assign stores to a Warehouse:
    [Documentation]                                 Assign stores to a warehouse. Expect to be in the edit page of a warehouse
    [Arguments]                                     @{stores}
    Zed: go to tab:                                 ${warehouse_edit_tab_2}
    FOR    ${store}    IN    @{stores}
        Zed: select checkbox by Label:              ${store}
    END

Zed: Remove stores from a Warehouse:
    [Documentation]                                 Remove stores from a warehouse. Expect to be in the edit page of a warehouse
    [Arguments]                                     @{stores}
    Zed: go to tab:                                 ${warehouse_edit_tab_2}
    FOR    ${store}    IN    @{stores}
        Zed: unselect checkbox by Label:            ${store}
    END

Zed: Define a Warehouse name:
    [Documentation]                                 Expect to be in the edit page of a warehouse
    [Arguments]                                     ${warehouse_name}
    Zed: go to tab:                                 ${warehouse_edit_tab_1}
    Input text into field                           ${warehouse_name_field}   ${warehouse_name}
