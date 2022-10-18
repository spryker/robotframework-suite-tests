*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common_zed.robot
Resource    ../../resources/pages/zed/zed_warehouse_page.robot


*** Keywords ***
Zed: Enter a warehouse name
    [Arguments]    ${name}
    Type Text    ${zed_warehouse_name}    ${name}
    
Zed: Navigate to view mode
    Click    ${zed_warehouse_view_button}
zed: edit warehouse
    Click    ${zed_warehouse_edit_button}

Zed: Is the warehouse avaialbe:
    [Documentation]    ${type} can be: yes, no
    [Arguments]    ${type}
    IF    '${type}' == 'yes'    Click   ${zed_warehouse_avaialbe_radio_button}   
    IF  '${type}' == 'no'  Click   ${zed_warehouse_not_avaialbe_radio_button}

Zed: activate warehouse:
    [Arguments]    ${name}
    Zed: go to second navigation item level:    Administration    Warehouses
     Zed: perform search by:    ${name}
    zed: edit warehouse
    Zed: go to tab:    Store Relation
    Zed: Check checkbox by Label:    DE
    Zed: Check checkbox by Label:    AT
    Zed: submit the form