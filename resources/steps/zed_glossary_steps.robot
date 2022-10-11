*** Settings ***
Resource    ../pages/zed/zed_customer_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_glossary_page.robot

*** Keywords ***
Zed: Add details to glossary section:
    [Documentation]    fill the input fields required for creating translation.
    [Arguments]    @{args}
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{registrationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='Name'    Type Text    ${zed_translation_name}    ${value}
        IF    '${key}'=='EN_US'    Type Text    ${zed_translation_EN_US}    ${value}
        IF    '${key}'=='DE_DE'    Type Text    ${zed_translation_DE_DE}     ${value}
    END

Zed: Edit a glossary translation
    [Arguments]    ${glossary_name}
    Zed: perform search by:    ${glossary_name}
    Click    ${zed_translation_edit}

Zed: Clear text
    Clear Text    ${zed_translation_EN_US}
    Clear Text     ${zed_translation_DE_DE}

Zed: Undo the changes in glossary translation
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to first navigation item level:    Administration
    Zed: go to second navigation item level:    Administration    Glossary 
    Zed:Edit a glossary translation    	cart.add.items.success   
    Zed:Clear text
    Input Text     ${zed_translation_EN_US}     Items added successfully
    Input Text     ${zed_translation_DE_DE}     Produkte erfolgreich der Wunschliste hinzugefügt
    Zed: submit the form