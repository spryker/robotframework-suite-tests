*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common_yves.robot
Resource    ../../resources/pages/zed/zed_administration_page.robot

*** Keywords ***

Zed: check the avaialbe Stores
    [Arguments]    ${store_id_1}    ${store_id_2}
    Element Text Should Be    ${administration_store_id_1_locator}    AT
    Element Text Should Be    ${administration_store_id_2_locator}    DE