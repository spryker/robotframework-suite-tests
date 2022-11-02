*** Settings ***
Resource    ../pages/zed/zed_customer_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_glossary_page.robot

*** Keywords ***
Zed: add details to glossary section:
    [Documentation]    fill the input fields required for creating translation.
    [Arguments]    @{args}
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{registrationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='Name'    Type Text    ${zed_translation_name}    ${value}
        IF    '${key}'=='EN_US'    Type Text    ${zed_translation_EN_US}    ${value}
        IF    '${key}'=='DE_DE'    Type Text    ${zed_translation_DE_DE}     ${value}
    END

Zed: edit a glossary translation
    [Arguments]    ${glossary_name}
    Zed: click Action Button in a table for row that contains:    ${glossary_name}    Edit

Zed: enter original text in edited glossary:
    [Arguments]    ${original_DE}    ${original_EN}
    Input Text     ${zed_translation_DE_DE}     ${original_DE}
    Input Text     ${zed_translation_EN_US}     ${original_EN}

Zed: undo the changes in glossary translation:
    [Arguments]    ${glossary_name}    ${original_DE}    ${original_EN}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Administration    Glossary 
    Zed: edit a glossary translation    	${glossary_name}   
    Zed: enter original text in edited glossary:    ${original_DE}    ${original_EN}
    Zed: submit the form