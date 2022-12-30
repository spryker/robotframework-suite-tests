*** Settings ***
Library    Browser
Library    String
Library    Dialogs
Library    OperatingSystem
Library    Collections
Library    BuiltIn
Library    DateTime
Library    ../../resources/libraries/common.py
Library    Telnet
Library    RequestsLibrary
Resource                  ../pages/yves/yves_header_section.robot
Resource                  ../pages/yves/yves_login_page.robot

*** Variables ***
# *** SUITE VARIABLES ***
${env}                 b2b
${headless}            true
${browser}             chromium
${browser_timeout}     60 seconds
${email_domain}        @spryker.com
${default_password}    change123
${admin_email}         admin@spryker.com
${device}
# ${device}              Desktop Chrome
# ${fake_email}          test.spryker+${random}@gmail.com

*** Keywords ***
Load Varia
Wait Until Element Contains
    [Arguments]    ${locator}    ${text}    ${timeout}=${browser_timeout}    ${message}=${EMPTY}
    Get Text    ${locator}    contains    ${text}    ${message}

Page Should Not Contain Element
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=0:00:05
    Wait For Elements State    ${locator}    detached    ${timeout}    ${message}

Element Should Not Contain
    [Arguments]    ${locator}    ${text}
    Get Text    ${locator}    validate    "${text}" not in value

Checkbox Should Be Selected
    [Arguments]    ${locator}
    Get Checkbox State    ${locator}    ==    checked

Checkbox Should Not Be Selected
    [Arguments]    ${locator}
    Get Checkbox State    ${locator}    ==    unchecked

Mouse Over
    [Arguments]    ${locator}
    Hover    ${locator}

Element Should Not Be Visible
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=0:00:05
    Wait For Elements State    ${locator}    hidden    ${timeout}    ${message}

Get Element Attribute
    [Arguments]    ${locator}    ${attribute}
    ${element_attribute}=    Get Attribute    ${locator}    ${attribute}
    [Return]    ${element_attribute}

Select From List By Label
    [Arguments]    ${locator}    ${value}
    Select Options By    ${locator}    label    ${value}

Select From List By Value
    [Arguments]    ${locator}    ${value}
    Select Options By    ${locator}    value    ${value}

Select From List By Index
    [Arguments]    ${locator}    ${value}
    Select Options By    ${locator}    index    ${value}

Select From List By Text
    [Arguments]    ${locator}    ${value}
    Select Options By    ${locator}    text    ${value}

Create New Context
    ${new_context}=    New Context
    New Page    ${host}

Switch back to the Main Context
    Switch Context    ${main_context}

Verify the src attribute of the image is accessible:
    [Arguments]    @{image_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${image_list_count}=   get length  ${image_list}
    FOR    ${index}    IN RANGE    0    ${image_list_count}
        ${image_to_check}=    Get From List    ${image_list}    ${index}
        ${image_src}=    Get Element Attribute    ${image_to_check}    src
        ${response}=    GET    ${image_src}
        Should Be Equal    '${response.status_code}'    '200'
    END

Conver string to List by separator:
    [Arguments]    ${string}    ${separator}=,
    ${convertedList}=    Split String    ${string}    ${separator}
    ${convertedList}=    Set Test Variable    ${convertedList}
    [Return]    ${convertedList}

Try reloading page until element is/not appear:
    [Documentation]    will reload the page until an element is shown or disappears. The second argument is the expected condition (true[shown]/false[disappeared]) for the element.
    [Arguments]    ${element}    ${shouldBeDisplayed}    ${tries}=20    ${timeout}=1s
    FOR    ${index}    IN RANGE    0    ${tries}
        ${elementAppears}=    Run Keyword And Return Status    Page Should Contain Element    ${element}
        IF    '${shouldBeDisplayed}'=='true' and '${elementAppears}'=='False'
            Run Keywords    Sleep    ${timeout}    AND    Reload
        ELSE IF     '${shouldBeDisplayed}'=='false' and '${elementAppears}'=='True'
            Run Keywords    Sleep    ${timeout}    AND    Reload
        ELSE
            Exit For Loop
        END
    END
    IF    ('${shouldBeDisplayed}'=='true' and '${elementAppears}'=='False') or ('${shouldBeDisplayed}'=='false' and '${elementAppears}'=='True')
        Take Screenshot
        Fail    'Timeout exceeded, element state doesn't match the expected'
    END

Try reloading page until element does/not contain text:
    [Documentation]    will reload the page until an element text will be updated. The second argument is the expected condition (true[contains]/false[doesn't contain]) for the element text.
    [Arguments]    ${element}    ${expectedText}    ${shouldContain}    ${tries}=20    ${timeout}=1s
    FOR    ${index}    IN RANGE    0    ${tries}
        ${textAppears}=    Run Keyword And Return Status    Element Text Should Be    ${element}    ${expectedText}
        IF    '${shouldContain}'=='true' and '${textAppears}'=='False'
            Run Keywords    Sleep    ${timeout}    AND    Reload
        ELSE IF     '${shouldContain}'=='false' and '${textAppears}'=='True'
            Run Keywords    Sleep    ${timeout}    AND    Reload
        ELSE
            Exit For Loop
        END
    END
    IF    ('${shouldContain}'=='true' and '${textAppears}'=='False') or ('${shouldContain}'=='false' and '${textAppears}'=='True')
        Fail    'Timeout exceeded'
    END

Type Text When Element Is Visible
    [Arguments]    ${selector}    ${text}
    Run keywords
        ...    Wait Until Element Is Visible    ${selector}
        ...    AND    Type Text    ${selector}     ${text}

Select From List By Value When Element Is Visible
    [Arguments]    ${selector}    ${value}
    Run keywords
        ...    Wait Until Element Is Visible    ${selector}
        ...    AND    Select From List By Value    ${selector}     ${value}

Remove leading and trailing whitespace from a string:
    [Arguments]    ${string}
    ${string}=    Replace String Using Regexp    ${string}    (^[ ]+|[ ]+$)    ${EMPTY}
    Set Global Variable    ${string}
    [Return]    ${string}


Load Variables
    [Arguments]    ${env}
    &{vars}=   Define Environment Variables From Json File    ${env}
    FOR    ${key}    ${value}    IN    &{vars}
        Log    Key is '${key}' and value is '${value}'.
        ${var_value}=   Get Variable Value  ${${key}}   ${value}
        Set Global Variable    ${${key}}    ${var_value}
    END

Set Up Keyword Arguments
    [Arguments]    @{args}
    &{arguments}=    Fill Variables From Text String    @{args}
    FOR    ${key}    ${value}    IN    &{arguments}
        Log    Key is '${key}' and value is '${value}'.
        ${var_value}=   Set Variable    ${value}
        Set Test Variable    ${${key}}    ${var_value}
    END
    [Return]    &{arguments}