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
${headless}            true
${browser}             chromium
${browser_timeout}     65 seconds
${host}                http://yves.de.spryker.local/
${zed_url}             http://backoffice.de.spryker.local/
${email_domain}        @spryker.com
${default_password}    change123
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
    Set Browser Timeout    ${browser_timeout}
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
    Run Keyword If Test Failed    
    ...    Run Keywords 
        # ...    Pause Execution
    ...    Take screenshot
    ...    Get Location
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
    [Arguments]    ${locator}    ${message}=None    ${timeout}=None
    Wait For Elements State    ${locator}    visible    ${timeout}    ${message}

Wait Until Page Contains Element
    [Arguments]    ${locator}    ${message}=None    ${timeout}=0:00:20
    Wait For Elements State    ${locator}    attached    ${timeout}    ${message}

Wait Until Page Does Not Contain Element
    [Arguments]    ${locator}    ${message}=None    ${timeout}=0:00:20
    Wait For Elements State    ${locator}    detached    ${timeout}    ${message}

Wait Until Element Is Enabled
# Todo: update 'attached' on real usage
    [Arguments]    ${locator}    ${message}=None    ${timeout}=None
    Wait For Elements State    ${locator}    enabled    ${timeout}    ${message}

Element Should Be Visible
    [Arguments]    ${locator}    ${message}=None    ${timeout}=None
    Wait For Elements State    ${locator}    visible    ${timeout}    ${message}

Page Should Contain Element
    [Arguments]    ${locator}    ${message}=None    ${timeout}=0:00:20
    Wait For Elements State    ${locator}    attached    ${timeout}    ${message}

Get Location
    ${current_url}=    Get URL
    [Return]    ${current_url}
    
Wait Until Element Is Not Visible
    [Arguments]    ${locator}    ${message}=None    ${timeout}=None
    Wait For Elements State    ${locator}    hidden    ${timeout}    ${message}

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
    [Arguments]    ${locator}    ${expected}    ${message}=None    ${ignore_case}=None
    Browser.Get Text    ${locator}    contains    ${expected}    ${message}

Element Should Contain
    [Arguments]    ${locator}    ${expected}    ${message}=None    ${ignore_case}=None
    Browser.Get Text    ${locator}    contains    ${expected}    ${message}

Element Text Should Be
    [Arguments]    ${locator}    ${expected}    ${message}=None    ${ignore_case}=None
    Browser.Get Text    ${locator}    equal    ${expected}    ${message} 

Wait Until Element Contains
    [Arguments]    ${locator}    ${text}    ${timeout}=None    ${message}=None
    Browser.Get Text    ${locator}    contains    ${text}    ${message}

Page Should Not Contain Element
    [Arguments]    ${locator}    ${message}=None    ${timeout}=None
    Wait For Elements State    ${locator}    detached    ${timeout}    ${message}

Element Should Not Contain
    [Arguments]    ${locator}    ${text}    
    Browser.Get Text    ${locator}    validate    "${text}" not in value

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
    [Arguments]    ${locator}    ${message}=None    ${timeout}=None
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