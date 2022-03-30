*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Test Teardown     TestTeardown
Suite Teardown    SuiteTeardown
Resource    ../../../resources/common/common.robot
Resource    ../../../resources/common/common_yves.robot
Resource    ../../../resources/common/common_zed.robot
Resource    ../../../resources/steps/aop_catalog_steps.robot
Resource    ../../../resources/steps/bazaarvoice_steps.robot
Resource    ../../../resources/steps/bazaarvoice_steps.robot
Resource    ../../../resources/steps/pdp_steps.robot
Resource    ../../../resources/pages/zed/zed_login_page.robot





*** Test Cases ***
Connect_pbc_payone
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed:Payone_connect_application:



Zed:Payone_connect_application:
#Payone_connect_application_zed
    #Open Browser    ${zed_url}    chromium
    #delete all cookies
    #Reload    
    #Wait Until Element Is Visible    ${zed_user_name_field}
    #Type Text    ${zed_user_name_field}    admin@spryker.com
    #Type Text    ${zed_password_field}    change123
    #Click    ${zed_login_button}
    #Click    ${zed_apps_button}
    #Wait For Elements State    ${App_ocrchestration_platform_catalog}
    #Sleep    5s
    #Click    ${App_Payone} 
    #Sleep    5s
    #click    ${connect_pbc_payone}
    #Sleep    3s
    #configure 
    #Click    ${configure_pbc_payone}
    #Sleep    5s
    #Provide data Credentials
    Type Text    ${placeholder_credentials_key}    ${credentials_key_Payone_for_lokal_env}
    Sleep    5s
    Type Text    ${placeholder_merchant_id}    ${merchant_id_Payone_for_lokal_env}
    Sleep    5s
    Type Text    ${placeholder_sub_account_id}    ${sub_account_id_Payone_for_lokal_env}
    Type Text    ${placeholder_payment_portal_id}   ${payment_portal_id_Payone_for_lokal_env}

    Click    xpath=//div[@class="spy-radio spy-radio-group__item ng-star-inserted"][1]
    click    xpath=//*[@id="cdk-overlay-0"]/spy-drawer-container-proxy/spy-drawer-container/spy-drawer-wrapper/div[2]/span/app-configuration/div/spy-spinner/nz-spin/div/sf-form/form/sf-form-element/div/sf-widget-chooser/app-object-widget/spy-card[3]/nz-card/div/span/div[2]/sf-form-element/div/sf-widget-chooser/app-checkbox-widget/spy-form-item/nz-form-item/nz-form-control/div/div/spy-checkbox[1]/label/span[2]
    sleep    5s
    Click    xpath=//spy-button[@class='app-configuration__save-button spy-button spy-button-core spy-button--default spy-button-core--default spy-button--md spy-button-core--md spy-button--primary spy-button-core--primary']
    sleep    5s 
    click    xpath=//spy-icon[@class="spy-icon-remove"]
    Wait Until Element Is Visible    xpath=//span[@class="connected-badge__text"]
    Close Browser

payone_connect_application_edit_payment_method_Credit_Card
    Open Browser    ${zed_url}    chromium
    delete all cookies
    Reload    
    Wait Until Element Is Visible    ${zed_user_name_field}
    Type Text    ${zed_user_name_field}    admin@spryker.com
    Type Text    ${zed_password_field}    change123
    Click    ${zed_login_button}
    
    #redirect to Payment Methods
    Click    ${administration_navigation_button}
    Click    ${payment_methods_navigation_button}
    Sleep    5s
    Reload
    Wait Until Element Is Visible    ${payment_method_payone_credit_card}
    click    ${edit_payment_method_payone_credit_card}
    Click    ${payment_method_form_isActive}
    Sleep    3s
    click    ${store_relation_payone_credit_card}
    click    ${available_in_the_following_store_DE} 
    Sleep    3s
    click    ${submit_payment_method_save_config}
    Sleep    7s
    Close Browser
    
    #disconnect PBC PayOne 

Payone_disconnect_application
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
    Click    ${App_Payone} 
    Click    xpath=//button[@class="spy-button-icon__button spy-button-icon__button--sm"]    
    click    xpath=//span[@class='spy-dropdown-item__text']
    #Wait Until Element Is Visible    
    Close Browser 


#robot tests/e2e_aop/payone_e2e_connect_pbc.robot