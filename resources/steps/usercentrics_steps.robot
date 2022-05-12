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
        Run keyword if    '${key}'=='type' and '${value}' != '${EMPTY}'    Click    ${pbc_usercentrics_integration_type_group} >> xpath=//label[@nz-radio]//span[contains(text(), '${value}')]/ancestor::label
        Run keyword if    '${key}'=='settingId' and '${value}' != '${EMPTY}'    Type Text    ${pbc_usercentrics_setting_id_input}    ${value}
        Run keyword if    '${key}'=='isActive' and '${value}' == 'true'    Click    ${pbc_usercentrics_is_active_input} >> xpath=//ancestor::spy-checkbox//label[not(contains(@class, 'ant-checkbox-wrapper-checked'))]
        Run keyword if    '${key}'=='isActive' and '${value}' == 'false'    Click    ${pbc_usercentrics_is_active_input} >> xpath=//ancestor::spy-checkbox//label[contains(@class, 'ant-checkbox-wrapper-checked')]
    END

Yves: page should contain script with attribute:
    [Arguments]    ${attribute}    ${value}
    Try reloading page until element is/not appear:    xpath=//head//script[@${attribute}='${value}']    true
    Page Should Contain Element    xpath=//head//script[@${attribute}='${value}']

Yves: page should/shouldn't contain usercentrics privacy settings form:
    [Arguments]    ${shouldContain}
    Run Keyword If    '${shouldContain}'=='true'    Run Keywords
    ...    Try reloading page until element is/not appear:    ${usercentrics_form}    true
    ...    AND    Wait Until Page Contains Element    ${usercentrics_form}
    ...    ELSE    Wait Until Page Does Not Contain Element    ${usercentrics_form}

Yves: usercentrics accept/deny all:
    [Arguments]    ${accept}
    Try reloading page until element is/not appear:    ${usercentrics_form}    true
    Wait Until Page Contains Element    ${usercentrics_form}
    Run Keyword If    '${accept}'=='true'    Click    ${usercentrics_form_accept_button}
    ...    ELSE    Click    ${usercentrics_form_deny_button}

Yves: usercentrics successfully saved config
    [Arguments]    ${timeout}=30s
    ${response}=    Wait for response    matcher=usercentrics.*?graphql     timeout=${timeout}
    Should be true    ${response}[ok]
