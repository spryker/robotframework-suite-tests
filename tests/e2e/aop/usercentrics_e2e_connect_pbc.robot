*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Test Teardown     TestTeardown
Suite Teardown    SuiteTeardown
Resource    ../../resources/common/common.robot
Resource    ../../resources/common/common_zed.robot

*** Test Cases ***
Usercentrics_connect_application_zed
    Open Browser    ${zed_url}    chromium
    delete all cookies
    Reload    
    Wait Until Element Is Visible    ${zed_user_name_field}
    Type Text    ${zed_user_name_field}    admin@spryker.com
    Type Text    ${zed_password_field}    change123
    Click    ${zed_login_button}
    Click    ${zed_apps_button}
    Wait For Elements State    ${App_ocrchestration_platform_catalog}
    Sleep    5s
    Click    ${App_usercentrics} 
    Sleep    5s
    Wait For Elements State    ${weryfy_that_descriprion_displayed} 
    Click    ${conect_button_usercentrics} 
    Click     ${configure_button}
    Sleep    5s
     #provide data for connect PBC Usercentrics (STORE SETTINGS)
    Click    ${enаble_smart_data_protection_defalt}
    Sleep    5s
    click    ${add_store_setings} 
    click    ${open_store_setings}
    click    ${select_DE_store} 
    Type Text    ${seting_id_form}    ${seting_id_usercentrics} 
    Click    ${store_is_active}
    Click    ${save_configure_button_usercentrics} 
    Click    ${closed_store_setings}
    Sleep    5s
    # Verify that application in status connected
    Wait For Elements State    ${aplication_in_status_connected} 
    Sleep    2s
    Close Browser
     

*** Test Cases ***
Usercentrics_connect_application_eves 
    #Open Browser    ${host}    chromium
    #открыл стейдж
    Open Browser    https://www.de.app-store-staging.demo-spryker.com/en    chromium 
    #Wait Until Element Is Enabled    ${UserCentrics_window}
    #Click     dom:document.querySelector("#usercentrics-root").shadowRoot.querySelector('[data-testid="uc-accept-all-button"]')
    Sleep    5s
    Close Browser
    #try accept all cookie (Problem to find selector for Shadow DOM )
    
# robot tests/e2e_aop/usercentrics_e2e_connect_pbc.robot