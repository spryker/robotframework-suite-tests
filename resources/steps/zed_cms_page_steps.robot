*** Settings ***
Resource    ../pages/zed/zed_cms_page_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***
Zed: create a cms page and publish it:
    [Arguments]    ${enName}    ${enURL}    ${enTitlePlaceholder}    ${enContentPlaceholder}
    ${currentURL}=    Get Location
    IF    'list-page' not in '${currentURL}'    Zed: go to second navigation item level:    Content    Pages
    Click    ${zed_new_cms_page_create_button}
# General page information input
    Page Should Contain Element    xpath=//body//*[contains(text(),'Create CMS Page')]    message=Page for CMS creation is not opened
    Element Should Be Visible    ${zed_cms_page_general_first_locale_name_field}    message=First locale section of CMS page is not open
    Scroll Element Into View    ${zed_cms_page_general_second_locale_collapsed_section}
    Set Browser Timeout    5s
    TRY
        Click    ${zed_cms_page_general_second_locale_collapsed_section}
    EXCEPT    
        Log    Second locale section of CMS is already open
    END
    Set Browser Timeout    ${browser_timeout}
    ${second_locale_section_expanded}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${zed_cms_page_general_second_locale_name_field}    message=DE section of CMS page is not open    timeout=3s
    IF    '${second_locale_section_expanded}'=='False'
        Scroll Element Into View    ${zed_cms_page_general_second_locale_collapsed_section}
        Click    ${zed_cms_page_general_second_locale_collapsed_section}
    END
    Wait Until Element Is Visible    ${zed_cms_page_general_second_locale_name_field}    message=Second locale section of CMS page is not open
    Check checkbox    ${zed_cms_page_general_is_searchable_checkbox}
    Type Text    ${zed_cms_page_general_first_locale_name_field}    ${enName}
    Type Text    ${zed_cms_page_general_first_locale_url_field}    ${enURL}
    Type Text    ${zed_cms_page_general_second_locale_name_field}    ${enName}
    Type Text    ${zed_cms_page_general_second_locale_url_field}    ${enURL}
    Click    ${zed_cms_page_save_button}
# Placeholder information input
    ${page_was_created}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//body//*[contains(text(),'Edit Placeholders: ${enName}')]
    IF    '${page_was_created}'=='False'    Click    ${zed_cms_page_save_button}
    Page Should Contain Element    xpath=//body//*[contains(text(),'Edit Placeholders: ${enName}')]    message=CMS page was not created
    Scroll Element Into View    ${zed_cms_page_content_second_locale_title_collapsed_section}
    Click    ${zed_cms_page_content_second_locale_title_collapsed_section}
    ${second_locale_section_expanded}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${zed_cms_page_placeholder_title_deDE_field}    message=DE section of CMS page is not open    timeout=3s
    IF    '${second_locale_section_expanded}'=='False'
        Scroll Element Into View    ${zed_cms_page_content_second_locale_title_collapsed_section}
        Click    ${zed_cms_page_content_second_locale_title_collapsed_section}
    END
    Wait Until Element Is Visible    ${zed_cms_page_placeholder_title_deDE_field}    message=DE section of Title tab is not open
    Clear Text    ${zed_cms_page_placeholder_title_enUS_field}
    Type Text    ${zed_cms_page_placeholder_title_enUS_field}    ${enTitlePlaceholder}
    Clear Text    ${zed_cms_page_placeholder_title_deDE_field}
    Type Text    ${zed_cms_page_placeholder_title_deDE_field}    ${enTitlePlaceholder}
    Zed: go to tab:    Content
    Page Should Contain Element    ${zed_cms_page_placeholder_content_enUS_field}    message=EN section of Content tab is not visible
    Scroll Element Into View    ${zed_cms_page_content_second_locale_content_collapsed_section}
    Click    ${zed_cms_page_content_second_locale_content_collapsed_section}
    ${second_locale_section_expanded}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${zed_cms_page_placeholder_content_deDE_field}    message=DE section of CMS page is not open    timeout=3s
    IF    '${second_locale_section_expanded}'=='False'
        Scroll Element Into View    ${zed_cms_page_content_second_locale_content_collapsed_section}
        Click    ${zed_cms_page_content_second_locale_content_collapsed_section}
    END
    Clear Text    ${zed_cms_page_placeholder_content_enUS_field}
    Type Text    ${zed_cms_page_placeholder_content_enUS_field}    ${enContentPlaceholder}
    Clear Text    ${zed_cms_page_placeholder_content_deDE_field}
    Type Text    ${zed_cms_page_placeholder_content_deDE_field}    ${enContentPlaceholder}
# Save and publish
    Click    ${zed_cms_page_save_button}
    Zed: message should be shown:    Placeholder translations successfully updated.
    Click    ${zed_cms_page_publish_button}
    Zed: message should be shown:    successfully published
# Check the CMS page in
    Zed: go to second navigation item level:    Content    Pages
    Zed: perform search by:    ${enName}
    Page Should Contain Element    xpath=//td[contains(@class,'name') and contains(text(),'${enName}')]/following-sibling::td[contains(@class,'status')]//span[contains(@class,'label') and contains(text(),'Active')]    message=CMS page is not found or not activated

Zed: update cms page and publish it:
    [Arguments]    @{args}
    ${cmsPageData}=    Set Up Keyword Arguments    @{args}
    Zed: go to second navigation item level:    Content    Pages
    Zed: perform search by:    ${cmsPage}
    Zed: click Action Button in a table for row that contains:     ${cmsPage}     Edit
    Click    xpath=(//a[contains(@href,'edit-page')])[1]
    Wait Until Element Is Visible    ${zed_cms_page_general_is_searchable_checkbox}
    FOR    ${key}    ${value}    IN    &{cmsPageData}
        IF    '${key}'=='unselect store' and '${value}' != '${EMPTY}'    
            Zed: Uncheck Checkbox by Label:    ${value}
        END
    END
    Click    ${zed_cms_page_save_button}
    Click    ${zed_cms_page_publish_button}
    Zed: message should be shown:    successfully published