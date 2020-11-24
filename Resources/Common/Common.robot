*** Settings ***

Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Library    String
Library    OperatingSystem
Resource                  ../Pages/Yves/Yves_Header_Section.robot
Resource                  ../Pages/Yves/Yves_Login_page.robot

*** Variables ***
# *** SUITE VARIABLES ***
#${browser}             headlesschrome
${browser}             chrome
${host}                https://www.de.b2b.demo-spryker.com/
${zed_url}             https://os.de.b2b.demo-spryker.com/
${email_domain}        @spryker.com
${default_password}    change123
${loading_time}        3s
${admin_email}         admin@spryker.com
#${test_customer_email}      test.spryker+${random}@gmail.com

*** Keywords ***
SuiteSetup
    [documentation]  Basic steps before each suite
    [tags]  common
    Remove Files    ${OUTPUTDIR}/selenium-screenshot-*.png    
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
    Go To    ${host}

TestTeardown
    Delete All Cookies

Select Random Option From List
    [Arguments]    ${dropDownLocator}    ${dropDownOptionsLocator}
    ${getOptionsCount}=    Get Matching Xpath Count    ${dropDownOptionsLocator}
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
    Scroll Element Into View    ${locator}
    Click Element    ${locator}
