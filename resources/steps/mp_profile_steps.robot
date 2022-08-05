*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_mp.robot
Resource    ../pages/mp/mp_profile_page.robot


*** Keywords ***
MP: open profile tab:
    [Arguments]    ${profileTabName}
    Wait Until Element Is Visible    xpath=//div[@class='ant-tabs-nav-list']//div[contains(text(),'${profileTabName}')]
    Click    xpath=//div[@class='ant-tabs-nav-list']//div[contains(text(),'${profileTabName}')]

MP: change store status
    Wait Until Element Is Visible    ${store_status_checkbox}
    Click    ${store_status_checkbox}

MP: update profile fields:
    [Arguments]    ${merchantProfileEmail}    ${merchantProfilePhone}    ${merchantProfileDeliveryTime}    ${merchantProfileDataPrivacy}
    Wait Until Element Is Visible    ${store_status_checkbox}
    Type Text    ${merchant_profile_email_field}    ${merchantProfileEmail}
    Type Text    ${merchant_profile_phone_field}    ${merchantProfilePhone}
    Type Text    ${merchant_profile_delivery_time_en_field}    ${merchantProfileDeliveryTime}
    Type Text    ${merchant_profile_data_privacy_en_field}     ${merchantProfileDataPrivacy}
