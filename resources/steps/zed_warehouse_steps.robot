*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common_zed.robot
Resource    ../../resources/pages/zed/zed_warehouse_page.robot


*** Keywords ***
Zed: create a warehouse:
    [Arguments]    ${name}
    Zed: go to second navigation item level:    Administration    Warehouses
    Zed: click button in Header:    Create Warehouse
    Type Text    ${zed_warehouse_name}    ${name}
    Zed: set the status of warehouse as 'Active':    True
    Zed: go to tab:    Store Relation
    Zed: Check checkbox by Label:    DE
    Zed: Check checkbox by Label:    AT
    Zed: submit the form
    Zed: message should be shown:    Warehouse has been successfully saved

Zed: set the status of warehouse as 'Active':
    [Documentation]    ${type} can be: True, False
    [Arguments]    ${type}
    IF    '${type}' == 'True'    Click   ${zed_warehouse_avaialbe_radio_button}   
    IF  '${type}' == 'False'  Click   ${zed_warehouse_not_avaialbe_radio_button}

Zed: activate/deactivate warehouse:
    [Arguments]    ${name}    ${type}
    Zed: go to second navigation item level:    Administration    Warehouses
    Zed: click Action Button in a table for row that contains:    ${name}    Edit
    Zed: set the status of warehouse as 'Active':    ${type}
    Zed: go to tab:    Store Relation
    Zed: Check checkbox by Label:    DE
    Zed: Check checkbox by Label:    AT
    Zed: submit the form
    Zed: message should be shown:    Warehouse has been successfully updated
    
Zed: set warehouse for particular store:
    [Arguments]    ${name}    ${store_1}    ${store_2}=DE
    Zed: go to second navigation item level:    Administration    Warehouses
    Zed: click Action Button in a table for row that contains:    ${name}    Edit
    Zed: set the status of warehouse as 'Active':    True
    Zed: go to tab:    Store Relation
    Zed: Uncheck Checkbox by Label:    ${store_2}
    Zed: Check checkbox by Label:    ${store_1}
    Zed: submit the form
    Zed: message should be shown:    Warehouse has been successfully updated

Zed: check the warehouse status:
    [Arguments]    ${warehouse}    ${store}    ${status}
    Zed: table should contain:    ${warehouse}
    Zed: table should contain non-searchable value:    ${store}
    Zed: table should contain non-searchable value:    ${status}

Zed: check the warehouse details in view mode:
    [Arguments]    ${name}    ${header_text}
    Zed: click Action Button in a table for row that contains:    ${name}    View
    Element Text Should Be    ${zed_warehouse_view_mode_header_locator}    ${header_text}