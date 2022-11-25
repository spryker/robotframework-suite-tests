*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common_zed.robot
Resource    ../../resources/pages/zed/zed_warehouse_page.robot

*** Keywords ***
Zed: create a warehouse:
    [Arguments]    ${name}    ${warehouse_status}    ${store_name_de}    ${store_name_at}    ${state_de}    ${state_at}
    Zed: go to second navigation item level:    Administration    Warehouses
    Zed: click button in Header:    Create Warehouse
    Type Text    ${zed_warehouse_name}    ${name}
    Zed: set the status of warehouse:    ${warehouse_status}
    Zed: go to tab:    Store Relation
    Zed: checkbox/uncheckbox store relation in warehouse:    ${store_name_de}    ${state_de}
    Zed: checkbox/uncheckbox store relation in warehouse:    ${store_name_at}    ${state_at}
    Zed: submit the form
    Zed: message should be shown:    Warehouse has been successfully saved

Zed: set the status of warehouse:
    [Documentation]    type can be: activate, deactivate
    [Arguments]    ${type}
    IF    '${type}' == 'activate'    Click   ${zed_warehouse_available_radio_button}   
    IF  '${type}' == 'deactivate'  Click   ${zed_warehouse_not_available_radio_button}

Zed: activate/deactivate warehouse:
    [Documentation]    type can be: activate, deactivate
    [Arguments]    ${name}    ${type}
    Zed: go to second navigation item level:    Administration    Warehouses
    Zed: click Action Button in a table for row that contains:    ${name}    Edit
    Zed: set the status of warehouse:    ${type}
    Zed: submit the form
    Zed: message should be shown:    Warehouse has been successfully updated
    
Zed: set warehouse for particular store:
    [Arguments]    ${name}    ${store_name_de}    ${store_name_at}    ${state_de}    ${state_at}        
    Zed: go to second navigation item level:    Administration    Warehouses
    Zed: perform search by:    ${name}
    Zed: click Action Button in a table for row that contains:    ${name}    Edit
    Zed: go to tab:    Store Relation
    Zed: checkbox/uncheckbox store relation in warehouse:    ${store_name_de}    ${state_de}
    Zed: checkbox/uncheckbox store relation in warehouse:    ${store_name_at}    ${state_at}
    Zed: submit the form
    Zed: message should be shown:    Warehouse has been successfully updated

Zed: check the warehouse status:
    [Arguments]    ${warehouse}    ${status}    @{store}
    Zed: table should contain:    ${warehouse}
    FOR    ${element}    IN    @{store}
        Zed: table should contain non-searchable value:    ${element}
    END
    Zed: table should contain non-searchable value:    ${status}

Zed: check the warehouse details in view mode:
    [Arguments]    ${name}    ${header_text}
    Zed: click Action Button in a table for row that contains:    ${name}    View
    Element Text Should Be    ${zed_warehouse_view_mode_header_locator}    ${header_text}

Zed: checkbox/uncheckbox store relation in warehouse:
    [Documentation]    Passing argument store name and state as check/uncheck.
    [Arguments]    ${store_name}    ${state}
    ${checkboxState}=    Set Variable    ${EMPTY}
    ${checkboxState}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//input[@type='checkbox']/../../label[contains(text(),'${store_name}')]//input[@checked]
    IF    '${checkboxState}'=='False' and '${state}' == 'check'    Click     xpath=//input[@type='checkbox']/../../label[contains(text(),'${store_name}')]//input
    IF    '${checkboxState}'=='True' and '${state}' == 'uncheck'    Click     xpath=//input[@type='checkbox']/../../label[contains(text(),'${store_name}')]//input