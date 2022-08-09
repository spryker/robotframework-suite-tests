*** Settings ***
Resource    ../common/common.robot
Resource    ../pages/yves/yves_merchant_profile.robot
Resource    ../pages/yves/yves_header_section.robot

*** Variable ***

*** Keywords ***
Yves: assert name of merchant on profile page:
    [Arguments]    ${merchantName}
    Wait Until Element Is Visible    ${merchant_profile_main_content_locator}
    Try reloading page until element does/not contain text:    ${merchant_profile_name_header_locator}     ${merchantName}     true    10    15s

Yves: assert merchant profile fields:
    [Arguments]    ${merchantProfileEmail}    ${merchantProfilePhone}    ${merchantProfileDeliveryTime}    ${merchantProfileDataPrivacy}
    Wait Until Element Is Visible    ${merchant_profile_main_content_locator}
    Try reloading page until element does/not contain text:    ${merchant_profile_email_locator}    ${merchantProfileEmail}    true    10    15s      
    Element Text Should Be    ${merchant_profile_phone_locator}    ${merchantProfilePhone}
    Element Text Should Be    ${merchant_profile_delivery_time_locator}    ${merchantProfileDeliveryTime}
    Element Text Should Be    ${merchant_profile_data_privacy_locator}    ${merchantProfileDataPrivacy}


