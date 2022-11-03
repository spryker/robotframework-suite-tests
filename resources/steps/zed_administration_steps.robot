*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common_zed.robot

*** Keywords ***

Zed: check the avaialbe Stores:
    [Arguments]    @{stores}
    FOR    ${element}    IN    @{stores}
         Zed: table should contain:    ${element}  
    END