*** Settings ***
Library    Browser
Library    String
Library    Dialogs
Library    OperatingSystem
Library    Collections
Library    BuiltIn
Library    DateTime
Library    ../../Resources/Libraries/common.py
Library    Telnet
Resource                  ../Pages/Yves/Yves_Header_section.robot
Resource                  ../Pages/Yves/Yves_Login_page.robot

*** Variables ***
# *** SUITE VARIABLES ***
${env}                 b2b
${headless}            false
${browser}             chromium
${host}                http://yves.de.spryker.local/
${zed_url}             http://backoffice.de.spryker.local/
${email_domain}        @spryker.com
${default_password}    change123
${loading_time}        3s
${admin_email}         admin@spryker.com
# ${fake_email}          test.spryker+${random}@gmail.com

*** Keywords ***
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
        ${var_value}=   Get Variable Value  ${${key}}   ${value}
        Set Test Variable    ${${key}}    ${var_value}    
    END
    [Return]    &{arguments}

SuiteSetup
    [documentation]  Basic steps before each suite
    Remove Files    ${OUTPUTDIR}/selenium-screenshot-*.png
    Remove Files    Resources/Libraries/__pycache__/*
    Load Variables    ${env}
    New Browser    ${browser}    headless=${headless}    args=['--ignore-certificate-errors']
    Set Browser Timeout    60 seconds
    Run Keyword if    '${headless}=true'    Create default Main Context
    Run Keyword if    '${headless}=false'    Create default Main Context
    New Page    ${host}
    ${random}=    Generate Random String    5    [NUMBERS]
    Set Global Variable    ${random}
    ${test_customer_email}=     set variable    test.spryker+${random}@gmail.com
    Set Global Variable  ${test_customer_email}
    [Teardown]
    [Return]    ${random}

SuiteTeardown
    Close Browser    ALL

TestSetup
    # ${random}=    Generate Random String    5    [NUMBERS]
    # Set Global Variable    ${random}
    Go To    ${host}

TestTeardown
    # Run Keyword If Test Failed    Pause Execution
    Delete All Cookies

Create default Main Context
    ${main_context}=    New Context    viewport={'width': 1440, 'height': 1080}
    Set Suite Variable    ${main_context}

Select Random Option From List
    [Arguments]    ${dropDownLocator}    ${dropDownOptionsLocator}
    ${getOptionsCount}=    Get Element Count    ${dropDownOptionsLocator}
    ${index}=    Evaluate    random.randint(0, ${getOptionsCount}-1)    random
    ${index}=    Convert To String    ${index}
    Select From List By Index    ${dropDownLocator}    ${index}

Click Element by xpath with JavaScript
    [Arguments]    ${xpath}
    Execute Javascript    document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click()

Click Element by id with JavaScript
    [Arguments]    ${id}
    Execute Javascript    document.getElementById("${id}").click()

Remove element from HTML with JavaScript
    [Arguments]    ${xpath}
    Execute Javascript    var element=document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;element.parentNode.removeChild(element);

Add/Edit element attribute with JavaScript:
    [Arguments]    ${xpath}    ${attribute}    ${attributeValue}
    Log    ${attribute}
    Log    ${attributeValue}
    Execute Javascript    (document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue).setAttribute("${attribute}", "${attributeValue}");

Remove element attribute with JavaScript:
    [Arguments]    ${xpath}    ${attribute}
    Execute Javascript    var element=document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;element.removeAttribute("${attribute}"");

#Migration to the Browser Library    
Wait Until Element Is Visible
    [Arguments]    ${locator}    ${timeout}=None    ${error}=None
    Wait For Elements State    ${locator}    visible    ${timeout}    ${error}

Wait Until Page Contains Element
    [Arguments]    ${locator}    ${timeout}=0:00:20    ${error}=None
    Wait For Elements State    ${locator}    attached    ${timeout}    ${error}

Wait Until Element Is Enabled
# Todo: update 'attached' on real usage
    [Arguments]    ${locator}    ${timeout}=None    ${error}=None
    Wait For Elements State    ${locator}    attached    ${timeout}    ${error}

Element Should Be Visible
    [Arguments]    ${locator}    ${message}=None
    Wait For Elements State    ${locator}    visible

Page Should Contain Element
    [Arguments]    ${locator}    ${error}=None    ${timeout}=0:00:20
    Wait For Elements State    ${locator}    attached    ${timeout}    ${error}

Get Location
    Get URL

Wait Until Element Is Not Visible
    [Arguments]    ${locator}    ${timeout}=None    ${error}=None
    Wait For Elements State    ${locator}    hidden    ${timeout}    ${error}

Page Should Contain Link
    [Arguments]    ${url}    ${message}=None
    ${hrefs}=    Execute JavaScript    Array.from(document.querySelectorAll('a')).map(e => e.getAttribute('href'))
    Should Contain    ${hrefs}    ${url}

Scroll Element Into View
    [Arguments]    ${locator}
    Hover    ${locator}

Input Text
    [Arguments]    ${locator}    ${text}
    Type Text    ${locator}    ${text}    0ms

Table Should Contain
    [Arguments]    ${locator}    ${expected}    ${Message}=None    ${Ignore_case}=None
    Browser.Get Text    ${locator}    contains    ${expected}

Element Should Contain
    [Arguments]    ${locator}    ${expected}    ${Message}=None    ${Ignore_case}=None
    Browser.Get Text    ${locator}    contains    ${expected}

Wait Until Element Contains
    [Arguments]    ${locator}    ${text}    ${timeout}=None    ${error}=None
    Browser.Get Text    ${locator}    contains    ${text}

Page Should Not Contain Element
    [Arguments]    ${locator}    ${message}=None
    Wait For Elements State    ${locator}    detached

Element Should Not Contain
    [Arguments]    ${locator}    ${text}
    Browser.Get Text    ${locator}    validate    "${text}" not in value

Checkbox Should Be Selected
    [Arguments]    ${locator}
    Get Checkbox State    ${locator}    ==    checked

Checkbox Should Not Be Selected
    [Arguments]    ${locator}
    Get Checkbox State    ${locator}    ==    unchecked

Select Checkbox
    [Arguments]    ${locator}
    Check Checkbox    ${locator}

Mouse Over
    [Arguments]    ${locator}
    Hover    ${locator}

Element Should Not Be Visible
    [Arguments]    ${locator}    ${timeout}=None    ${error}=None
    Wait For Elements State    ${locator}    hidden    ${timeout}    ${error}

Get Element Attribute
    [Arguments]    ${locator}    ${attribute}
    Get Attribute    ${locator}    ${attribute}

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