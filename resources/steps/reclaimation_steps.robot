*** Settings ***
Resource   ../common/common_zed.robot
Resource   ../common/common.robot
Resource   ../../resources/pages/zed/zed_reclaimation_page.robot

*** Keywords ***
Zed: check checkbox of reclaimation of whole order
   Click    ${all_product_checkbox}
 
Zed: submit reclaimation
   Click    ${create_reclamation_button_locator}
   Zed: flash message should be shown:    success
 
Zed: reclamation table sorting in descending order
   ${first}    Get Text    xpath=(//tbody/tr/td[@class="column-spy_sales_reclamation.id_sales_reclamation sorting_1"])[1]
   ${second}    Get Text    xpath=(//tbody/tr/td[@class="column-spy_sales_reclamation.id_sales_reclamation sorting_1"])[2]
   IF   '${first}'<'${second}'
       Click    xpath=//th[@id="spy_sales_reclamation.id_sales_reclamation" and contains(text(),'#')]
   END
 
Zed: create reclaimation for part of order:
   [Arguments]    ${sku}    ${reclaim}=1
   IF    '${env}' in ['b2b','b2c']
       ${elementSelector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${reclaim}]/tbody//td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td/input[@type="checkbox"]
   ELSE
      ${elementSelector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${reclaim}]/tbody//td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td/input[@type="checkbox"]
   END
   Check Checkbox    ${elementSelector}

Zed: check details of latest created reclaimation:
    [Arguments]    ${sku}
    Zed: reclamation table sorting in descending order
    Wait Until Element Is Visible    ${first_view_reclaimation} 
    Click    ${first_view_reclaimation} 
    Page Should Contain Element    //div[@class="sku" and contains(text(),'${sku}')]

Zed: close latest created reclaimation
    Zed: reclamation table sorting in descending order
    Wait Until Element Is Visible    ${close_button_reclaimation}
    Click    ${close_button_reclaimation}

Zed: check state of latest reclaimation:
    [Documentation]    state can be open, Closed
    [Arguments]    ${state}
    ${actual_state}    Get Text    ${state_reclaimation_locator}
    Should Be Equal As Strings    ${actual_state}    ${state}