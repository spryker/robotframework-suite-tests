*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_aop_pbc_details_page.robot
Resource    ../pages/zed/zed_aop_usercentrics_details_page.robot
Resource    ../pages/yves/yves_usercentrics_form.robot

*** Keywords ***
Zed: configure usercentrics pbc:
    [Documentation]    Possible argument names: type, settingId, isActive (true | false)
    [Arguments]    @{args}
    ${condifurationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{condifurationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='type' and '${value}' != '${EMPTY}'    Click    ${pbc_usercentrics_integration_type_group} >> xpath=//label[@nz-radio]//span[contains(text(), '${value}')]/ancestor::label
        IF    '${key}'=='settingId' and '${value}' != '${EMPTY}'    Type Text    ${pbc_usercentrics_setting_id_input}    ${value}
        IF    '${key}'=='isActive' and '${value}' == 'true'    Click    ${pbc_usercentrics_is_active_input} >> xpath=//ancestor::spy-checkbox//label[not(contains(@class, 'ant-checkbox-wrapper-checked'))]
        IF    '${key}'=='isActive' and '${value}' == 'false'    Click    ${pbc_usercentrics_is_active_input} >> xpath=//ancestor::spy-checkbox//label[contains(@class, 'ant-checkbox-wrapper-checked')]
    END

Yves: page should/shouldn't contain usercentrics privacy settings form:
    [Arguments]    ${shouldContain}
    IF    '${shouldContain}'=='true'
        Run Keywords
            Try reloading page until element is/not appear:    ${usercentrics_form}    true
            Wait Until Page Contains Element    ${usercentrics_form}
    ELSE
        Wait Until Page Does Not Contain Element    ${usercentrics_form}
    END

Yves: usercentrics accept/deny all:
    [Arguments]    ${accept}
    Try reloading page until element is/not appear:    ${usercentrics_form}    true
    Wait Until Page Contains Element    ${usercentrics_form}
    IF    '${accept}'=='true'
        Click    ${usercentrics_form_accept_button}
    ELSE
        Click    ${usercentrics_form_deny_button}
    END

Yves: usercentrics successfully saved config
    [Arguments]    ${timeout}=30s
    ${response}=    Wait for response    matcher=usercentrics.*?graphql     timeout=${timeout}
    Should be true    ${response}[ok]
