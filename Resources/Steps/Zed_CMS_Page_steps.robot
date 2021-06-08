*** Settings ***
Resource    ../Pages/Zed/Zed_CMS_page_page.robot
Resource    ../Common/Common_Zed.robot
Resource    ../Common/Common.robot

*** Keywords ***
Zed: create a cms page and publish it:
    [Arguments]    ${enName}    ${enURL}    ${enTitlePlaceholder}    ${enContentPlaceholder}    
    ${currentURL}=    Get Location
    Run Keyword Unless    'list-page' in '${currentURL}'
    ...    Zed: go to second navigation item level:    Content    Pages
    Scroll and Click Element    ${zed_new_cms_page_create_button}
    Wait For Document Ready    
# General page information input
    Element Should Be Visible    xpath=//body//*[contains(text(),'Create CMS Page')]    message=Page for CMS creation is not opened
    Select Checkbox    ${zed_cms_page_general_is_searchable_checkbox}
    Input text into field    ${zed_cms_page_general_enUS_name_field}    ${enName}
    Input text into field    ${zed_cms_page_general_enUS_url_field}    ${enURL}
    ${deTitleSectionExpanded}=    Run Keyword And Return Status    Element Should Be Visible    ${zed_cms_page_general_deDE_name_field}
    Run keyword if    '${deTitleSectionExpanded}'=='False'    Scroll and Click Element    ${zed_cms_page_general_deDE_translation_collapsed_section}
    Input text into field    ${zed_cms_page_general_deDE_name_field}    ${enName}
    Input text into field    ${zed_cms_page_general_deDE_url_field}    ${enURL}
    Scroll and Click Element    ${zed_cms_page_save_button}
    Wait For Document Ready    
    Element Should Be Visible    ${zed_cms_page_create_success_flashmessage}    message=Success message is not displayed
# Placeholder information input
    Element Should Be Visible    xpath=//body//*[contains(text(),'Edit Placeholders: ${enName}')]    message=Page for CMS creation is not opened
    Input text into field    ${zed_cms_page_placeholder_title_enUS_field}    ${enTitlePlaceholder}
    ${deContentTitleSectionExpanded}=    Run Keyword And Return Status    Element Should Be Visible    ${zed_cms_page_placeholder_title_deDE_field}
    Run keyword if    '${deContentTitleSectionExpanded}'=='False'    Scroll and Click Element    ${zed_cms_page_general_deDE_translation_collapsed_section}
    Input text into field    ${zed_cms_page_placeholder_title_deDE_field}    ${enTitlePlaceholder}
    Zed: go to tab:    Content
    Wait For Document Ready    
    Input text into field    ${zed_cms_page_placeholder_content_enUS_field}    ${enContentPlaceholder}
    ${deContentContentSectionExpanded}=    Run Keyword And Return Status    Element Should Be Visible    ${zed_cms_page_placeholder_content_deDE_field}
    ${elements}=    Get Element Count    ${zed_cms_page_placeholder_content_deDE_translation_collapsed_section}
    Log    ${elements} 
#    Run keyword if    '${deContentContentSectionExpanded}'=='False'    Scroll and Click Element    ${zed_cms_page_placeholder_content_deDE_translation_collapsed_section}
#    Input text into field    ${zed_cms_page_placeholder_content_deDE_field}    ${enContentPlaceholder}
# Save and publish
    Scroll and Click Element    ${zed_cms_page_save_button}
    Wait For Document Ready    
    Element Should Be Visible    ${zed_cms_page_update_placeholder_success_flashmessage}    message=Success message is not displayed
    Scroll and Click Element    ${zed_cms_page_publish_button}
    Element Should Be Visible    ${zed_cms_page_publish_success_flashmessage}    message=Success message is not displayed 
# Check the CMS page in   
    Zed: go to second navigation item level:    Content    Pages
    Zed: perform search by:    ${enName}
    Element Should Be Visible    xpath=//td[contains(@class,'name') and contains(text(),'${enName}')]/following-sibling::td[contains(@class,'status')]//span[contains(@class,'label') and contains(text(),'Active')]    message=CMS page is not found or not activated
