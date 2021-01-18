*** Settings ***

Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Library    String
Library    Dialogs
Library    OperatingSystem
Library    ../../Resources/Libraries/common.py
Resource                  ../Pages/Yves/Yves_Header_Section.robot
Resource                  ../Pages/Yves/Yves_Login_Page.robot

*** Variables ***
# *** SUITE VARIABLES ***
${env}                 b2b
${browser}             headlesschrome
# ${browser}             chrome
# ${host}                https://www.de.b2b.demo-spryker.com/
# ${zed_url}             https://os.de.b2b.demo-spryker.com/
${email_domain}        @spryker.com
${default_password}    change123
${loading_time}        3s
${admin_email}         admin@spryker.com
# ${fake_email}          test.spryker+${random}@gmail.com

*** Keywords ***
Load Variables
    [Arguments]    ${env}
    &{vars}=   Define Environment Variables From Json File    ${env}
    Log Variables
    FOR    ${key}    ${value}    IN    &{vars}
        Log    Key is '${key}' and value is '${value}'.
        ${temp}=   Get Variable Value  ${${key}}   ${value}
        Set Global Variable    ${${key}}    ${temp}
    END
    Log Variables

SuiteSetup
    [documentation]  Basic steps before each suite
    Remove Files    ${OUTPUTDIR}/selenium-screenshot-*.png
    Remove Files    Resources/Libraries/__pycache__/*
    Load Variables    ${env}
    Open Browser    ${host}    ${browser}
    Run Keyword if    'headless' in '${browser}'    Set Window Size    1440    1080
    Run Keyword Unless    'headless' in '${browser}'    Maximize Browser Window
    # Maximize Browser Window
    ${random}=    Generate Random String    5    [NUMBERS]
    Set Global Variable    ${random}
    ${test_customer_email}=     set variable    test.spryker+${random}@gmail.com
    set global variable  ${test_customer_email}
    [Teardown]
    [Return]    ${random}

SuiteTeardown
    Delete All Cookies
    Close All Browsers

TestSetup
    Delete All Cookies
    ${random}=    Generate Random String    5    [NUMBERS]
    Set Global Variable    ${random}
    Go To    ${host}

TestTeardown
    # Run Keyword If Test Failed    Pause Execution
    Delete All Cookies

Select Random Option From List
    [Arguments]    ${dropDownLocator}    ${dropDownOptionsLocator}
    ${getOptionsCount}=    Get Element Count    ${dropDownOptionsLocator}
    ${index}=    Evaluate    random.randint(0, ${getOptionsCount}-1)    random
    ${index}=    Convert To String    ${index}
    Select From List By Index    ${dropDownLocator}    ${index}

Click Element with JavaScript
    [Arguments]    ${xpath}
    Execute Javascript    document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click()

Remove element from HTML with JavaScript
    [Arguments]    ${xpath}
    Execute Javascript
    ...    var element=document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
    ...    element.parentNode.removeChild(element);

Add/Edit element attribute with JavaScript:
    [Arguments]    ${xpath}    ${attribute}    ${attributeValue}
    Execute Javascript
    ...    var element=document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
    ...    element.setAttribute("${attribute}", "${attributeValue}");

Scroll and Click Element
    [Arguments]    ${locator}
    Wait Until Page Contains Element    ${locator}
    Scroll Element Into View    ${locator}
    Wait Until Element Is Enabled    ${locator}
    Wait Until Element Is Visible    ${locator}
    Click Element    ${locator}
    
Input text into field
    [Arguments]    ${locator}    ${text}
    Wait Until Page Contains Element    ${locator}
    Scroll Element Into View    ${locator}
    Wait Until Element Is Enabled    ${locator}
    Wait Until Element Is Visible    ${locator}
    Input Text    ${locator}    ${text}
    
# Wait until page is loaded
#     FOR    ${INDEX}    IN RANGE    1    5000
#         ${isPageLoaded}=    Execute JavaScript    return window.addEventListener("load",function(n){console.log("All resources finished loading!")});
#         ${isPageLoaded}=    Convert To String    ${isPageLoaded}
#         Log    ${INDEX}
#         Log    ${isPageLoaded}
#         Run Keyword If    '${isPageLoaded}' == 'true'    Exit For Loop
#     END
