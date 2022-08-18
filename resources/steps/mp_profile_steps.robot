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

MP: update profile fields with following data:
    [Arguments]    @{args}
    ${profileData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${store_status_checkbox}
    FOR    ${key}    ${value}    IN    &{profileData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='email' and '${value}' != '${EMPTY}'    Type Text    ${merchant_profile_email_field}    ${value}
        IF    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    ${merchant_profile_phone_field}    ${value}
        IF    '${key}'=='delivery time' and '${value}' != '${EMPTY}'    Type Text    ${merchant_profile_delivery_time_en_field}    ${value}
        IF    '${key}'=='data privacy' and '${value}' != '${EMPTY}'     Type Text    ${merchant_profile_data_privacy_en_field}    ${value}
    END  
