*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_aop_pbc_details_page.robot

*** Variables ***
${appTitle}    ${pbc_datails_title_locator}
${appShortDescription}    ${pbc_datails_short_description_locator}
${appLogo}    ${pbc_datails_app_logo_locator}
${appAuthor}   ${pbc_datails_author_link_locator}
${appPendingStatus}    ${pbc_details_pending_status_locator}
${appConnectedStatus}    ${pbc_details_connected_status_locator}

*** Keywords ***
Zed: AOP catalog page should contain the following apps:
    [Documentation]    check that pbc is displayed in the aop catalog page. Possible arguments: pbc title (multiple titles are supported, case sensitive)
    [Arguments]    @{pbc_title_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${pbc_titles_list_count}=   get length  ${pbc_title_list}
    FOR    ${index}    IN RANGE    0    ${pbc_titles_list_count}
        ${pbc_title_to_check}=    Get From List    ${pbc_title_list}    ${index}
        Run Keywords
        ...    Log    ${pbc_title_to_check}
        ...    AND    Wait Until Element Is Visible    xpath=//app-application-card//*[contains(@class,'application-card')][contains(@class,'title')][text()='${pbc_title_to_check}']
        ...    AND    Page Should Contain Element    xpath=//app-application-card//*[contains(@class,'application-card')][contains(@class,'title')][text()='${pbc_title_to_check}']

    END

Zed: go to the PBC details page:
    [Arguments]    ${pbc_title}
    Wait Until Page Contains Element    xpath=//app-application-card//*[contains(@class,'application-card')][contains(@class,'title')][text()='${pbc_title}']
    Click    xpath=//app-application-card//*[contains(@class,'application-card')][contains(@class,'title')][text()='${pbc_title}']
    Wait Until Element Is Visible    ${pbc_details_main_content_locator}
    Page Should Contain Element    ${pbc_details_main_content_locator}

Zed: PBC details page should contain the following elements:
    [Arguments]    @{pbc_elements_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${pbc_elements_list_coumt}=   get length  ${pbc_elements_list}
    FOR    ${index}    IN RANGE    0    ${pbc_elements_list_coumt}
        ${pbc_element_to_check}=    Get From List    ${pbc_elements_list}    ${index}
        Log    ${pbc_element_to_check}
        ${is_element_image}=    Run Keyword And Ignore Error     Should Be Equal    ${pbc_element_to_check}    ${pbc_datails_app_logo_locator}
        IF    'FAIL' in ${is_element_image}    Page Should Contain Element    ${pbc_element_to_check}
        IF    'PASS' in ${is_element_image}    Verify the src attribute of the image is accessible:    ${pbc_element_to_check}
    END

Zed: click button on the PBC details page:
    [Documentation]    Possible values: 'connect' or 'configure'
    [Arguments]    ${buttonName}
    IF    '${buttonName}'=='connect'
        Run keywords
            Click    ${pbc_details_connect_button_locator}
            Reload
            Wait Until Element Is Visible    ${pbc_details_configure_button_locator}
    END
    IF    '${buttonName}'=='configure'
        Run keywords
            Click    ${pbc_details_configure_button_locator}
            Wait Until Element Is Visible    ${pbc_configuration_form_main_content_locator}
    END

Zed: submit pbc configuration form
    Click    ${pbc_configuration_form_save_button}

Zed: Disconnect pbc
    Click    ${pbc_common_details_actions_menu_button}
    Wait Until Element Is Visible    ${pbc_actions_menu_disconnect_button}
    Click    ${pbc_actions_menu_disconnect_button}
    Wait Until Element Is Visible    ${pbc_actions_menu_confirm_disconnect_button}
    Click    ${pbc_actions_menu_confirm_disconnect_button}
    Reload
    Wait Until Element Is Visible    ${pbc_details_connect_button_locator}
