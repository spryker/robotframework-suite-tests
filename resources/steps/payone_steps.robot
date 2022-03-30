*** Settings ***
Resource    ../../resources/pages/zed/zed_aop_payone_datails_page.robot
Library    Browser

*** Keywords ***
Zed:Payone provide configuration pbc payone: 
    Type Text    ${pbc_payone_credentials_key_input}    ${credentials_key_Payone_for_lokal_env}
    Type Text    ${pbc_payone__merchant_id_input}    ${merchant_id_Payone_for_lokal_env}
    Type Text    ${pbc_payone_sub_account_id_input}    ${sub_account_id_Payone_for_lokal_env}
    Type Text    ${pbc_payone_payment_portal_id_input}    ${payment_portal_id_Payone_for_lokal_env}
