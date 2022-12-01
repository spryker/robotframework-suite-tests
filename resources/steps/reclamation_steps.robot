
*** Settings ***
Resource   ../common/common_zed.robot
Resource   ../common/common.robot
Resource   ../../resources/pages/zed/zed_reclamation_page.robot
Resource    pdp_steps.robot

*** Keywords ***
Zed: submit reclamation
   Click    ${create_reclamation_button_locator}
   Zed: flash message should be shown:    success

Zed: sort reclamation table in ascending/descending order:
    [Arguments]    ${sort}
    ${sorting}=    Get Element Attribute    id=spy_sales_reclamation.id_sales_reclamation    class
    IF    '${sort}'=='desc' and 'desc' not in '${sorting}'           
      Click    xpath=//th[@id="spy_sales_reclamation.id_sales_reclamation" and contains(text(),'#')]
    ELSE
      Click    xpath=//th[@id="spy_sales_reclamation.id_sales_reclamation" and contains(text(),'#')]
   END

Zed: create reclamation for part of order:
   [Arguments]    @{sku}    
   FOR    ${SKU}    IN    @{sku}
       Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(text(),'${SKU}')]/ancestor::tr/td/input[@type="checkbox"]
   END

Zed: verify latest created reclamation contains product with SKU(s):
    [Arguments]    @{sku}
    Zed: sort reclamation table in ascending/descending order:    desc
    Wait Until Element Is Visible    ${first_view_reclamation} 
    Click    ${first_view_reclamation} 
    FOR    ${SKU}    IN    @{sku}
         Page Should Contain Element    //div[@class="sku" and contains(text(),'${sku}')]
    END

Zed: close latest created reclamation
    Zed: sort reclamation table in ascending/descending order:    desc
    Wait Until Element Is Visible    ${close_button_reclamation}
    Click    ${close_button_reclamation}

Zed: check state of latest reclamation is open/closed:
    [Documentation]    state can be Open, Closed
    [Arguments]    ${state}
    ${actual_state}=    Get Text    ${state_reclamation_locator}
    Should Be Equal As Strings    ${actual_state}    ${state}