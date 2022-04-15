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
Resource    ../libraries/migration.robot
Resource    ../pages/yves/yves_header_section.robot
Resource    ../pages/yves/yves_login_page.robot

*** Variables ***
# *** SUITE VARIABLES ***
${env}                 b2b
${headless}            true
${browser}             chromium
${browser_timeout}     60 seconds
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
    Remove Files    resources/libraries/__pycache__/*
    Load Variables    ${env}
    New Browser    ${browser}    headless=${headless}    args=['--ignore-certificate-errors']
    Set Browser Timeout    ${browser_timeout}
    Run Keyword if    '${headless}=true'    Create default Main Context
    Run Keyword if    '${headless}=false'    Create default Main Context
    New Page    ${host}
    ${random}=    Generate Random String    5    [NUMBERS]
    Set Global Variable    ${random}
    ${today}=    Get Current Date    result_format=%Y-%m-%d
    Set Global Variable    ${today}
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

Variable datatype should be:
    [Arguments]    ${variable}    ${expected_data_type}
    ${actual_data_type}=    Evaluate datatype of a variable:    ${variable}
    Should Be Equal    ${actual_data_type}    ${expected_data_type}

Evaluate datatype of a variable:
    [Arguments]    ${variable}
    ${data_type}=    Evaluate     type($variable).__name__
    [Return]    ${data_type}
    #Example of assertions:
    # ${is int}=      Evaluate     isinstance($variable, int)    # will be True
    # ${is string}=   Evaluate     isinstance($variable, str)    # will be False

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
    ${covertedList}=    Split String    ${string}    ${separator}
    ${covertedList}=    Set Test Variable    ${covertedList}
    [Return]    ${covertedList}

Try reloading page until element is/not appear:
    [Documentation]    will reload the page until an element is shown or disappears. The second argument is the expected condition (true[shown]/false[disappeared]) for the element.
    [Arguments]    ${element}    ${shouldBeDisplayed}
    FOR    ${index}    IN RANGE    0    21
        ${elementAppears}=    Run Keyword And Return Status    Page Should Contain Element    ${element}
        Run Keyword If    '${shouldBeDisplayed}'=='true' and '${elementAppears}'=='False'    Run Keywords    Sleep    1s    AND    Reload
        ...    ELSE    Run Keyword If    '${shouldBeDisplayed}'=='false' and '${elementAppears}'=='True'    Run Keywords    Sleep    1s    AND    Reload
        ...    ELSE    Exit For Loop
    END
