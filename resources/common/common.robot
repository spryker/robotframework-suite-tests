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
Library    DatabaseLibrary
Resource                  ../pages/yves/yves_header_section.robot
Resource                  ../pages/yves/yves_login_page.robot

*** Variables ***
# *** SUITE VARIABLES ***
${env}                 b2b
${headless}            true
${verify_ssl}          false
${browser}             chromium
${browser_timeout}     60 seconds
${email_domain}        @spryker.com
${default_password}    change123
${admin_email}         admin@spryker.com
${device}
# *** DB VARIABLES ***
${default_db_host}         127.0.0.1
${default_db_name}         eu-docker
${default_db_password}     secret
${default_db_port}         3306
${default_db_port_postgres}    5432
${default_db_user}         spryker
${default_db_engine}       pymysql
${db_engine}
${yves_env}
${yves_at_env}
${zed_env}
${mp_env}
${glue_env}
${db_port}
# ${default_db_engine}       psycopg2
# ${device}              Desktop Chrome
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
        ${var_value}=   Set Variable    ${value}
        Set Test Variable    ${${key}}    ${var_value}
    END
    [Return]    &{arguments}

Overwrite env variables
    IF    '${yves_env}' == '${EMPTY}'
            Set Suite Variable    ${yves_url}    ${yves_url}
    ELSE
            Set Suite Variable    ${yves_url}    ${yves_env}
    END
    IF    '${yves_at_env}' == '${EMPTY}'
            Set Suite Variable    ${yves_at_url}    ${yves_at_url}
    ELSE
            Set Suite Variable    ${yves_at_url}    ${yves_at_env}
    END
    IF    '${zed_env}' == '${EMPTY}'
            Set Suite Variable    ${zed_url}   ${zed_url}
    ELSE
            Set Suite Variable    ${zed_url}   ${zed_env}
    END
    IF    '${mp_env}' == '${EMPTY}'
            Set Suite Variable    ${mp_url}    ${mp_url} 
    ELSE
            Set Suite Variable    ${mp_url}   ${mp_env}
    END
    IF    '${glue_env}' == '${EMPTY}'
            Set Suite Variable    ${glue_url}    ${glue_url} 
    ELSE
            Set Suite Variable    ${glue_url}   ${glue_env}
    END
    &{urls}=    Create Dictionary    yves_url    ${yves_url}    yves_at_url    ${yves_at_url}    zed_url    ${zed_url}    mp_url    ${mp_url}    glue_url    ${glue_url}
    FOR    ${key}    ${url}    IN    &{urls}
        Log    Key is '${key}' and value is '${url}'.
        ${url_last_character}=    Get Regexp Matches    ${url}    .$    flags=IGNORECASE
        ${url_last_character}=    Convert To String    ${url_last_character}
        ${url_last_character}=    Replace String    ${url_last_character}    '   ${EMPTY}
        ${url_last_character}=    Replace String    ${url_last_character}    [   ${EMPTY}
        ${url_last_character}=    Replace String    ${url_last_character}    ]   ${EMPTY}
        IF    '${url_last_character}' != '/' and '${key}' != 'glue_url'
            ${url}=    Set Variable    ${url}${/}
        END
        ${var_url}=   Set Variable    ${url}
        Set Suite Variable    ${${key}}    ${var_url}
    END
SuiteSetup
    [documentation]  Basic steps before each suite
    Remove Files    ${OUTPUTDIR}/selenium-screenshot-*.png
    Remove Files    resources/libraries/__pycache__/*
    Remove Files    ${OUTPUTDIR}/*.png
    Load Variables    ${env}
    ${verify_ssl}=    Convert To Lower Case    ${verify_ssl}
    IF    '${verify_ssl}' == 'true'
        New Browser    ${browser}    headless=${headless}
        Set Global Variable    ${verify_ssl}    ${True}
    ELSE
        New Browser    ${browser}    headless=${headless}    args=['--ignore-certificate-errors']
        Set Global Variable    ${verify_ssl}    ${False}
    END
    Set Browser Timeout    ${browser_timeout}
    Create default Main Context
    Overwrite env variables
    New Page    ${yves_url}
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
    Delete All Cookies
    Go To    ${yves_url}

TestTeardown
    # Run Keyword If Test Failed    Pause Execution
    Delete All Cookies

Create default Main Context
    Log    ${device}
    IF  '${device}' == '${EMPTY}'
        ${main_context}=    New Context    viewport={'width': 1440, 'height': 1080}
    ELSE
        ${device}=    Get Device    ${device}
        ${main_context}=    New Context    &{device}
    END
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
    Evaluate Javascript     ${None}     document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click()

Click Element by id with JavaScript
    [Arguments]    ${id}
    Evaluate Javascript     ${None}    document.getElementById("${id}").click()

Remove element from HTML with JavaScript
    [Arguments]    ${xpath}
    Evaluate Javascript     ${None}    var element=document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;element.parentNode.removeChild(element);

Add/Edit element attribute with JavaScript:
    [Arguments]    ${xpath}    ${attribute}    ${attributeValue}
    Log    ${attribute}
    Log    ${attributeValue}
    Evaluate Javascript     ${None}    (document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue).setAttribute("${attribute}", "${attributeValue}");

Remove element attribute with JavaScript:
    [Arguments]    ${xpath}    ${attribute}
    Evaluate Javascript     ${None}    var element=document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;element.removeAttribute("${attribute}"");

# Helper keywords for migration from Selenium Library to Browser Library
Wait Until Element Is Visible
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=${browser_timeout}
    Wait For Elements State    ${locator}    visible    ${timeout}    ${message}

Wait Until Page Contains Element
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=${browser_timeout}
    Wait For Elements State    ${locator}    attached    ${timeout}    ${message}

Wait Until Page Does Not Contain Element
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=${browser_timeout}
    Wait For Elements State    ${locator}    detached    ${timeout}    ${message}

Wait Until Element Is Enabled
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=${browser_timeout}
    Wait For Elements State    ${locator}    enabled    ${timeout}    ${message}

Element Should Be Visible
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=0:00:05
    Wait For Elements State    ${locator}    visible    ${timeout}    ${message}

Page Should Contain Element
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=0:00:05
    Wait For Elements State    ${locator}    attached    ${timeout}    ${message}

Get Location
    ${current_location}=    Get URL
    ${location}=    Set Variable    ${current_location}
    Set Test Variable    ${location}    ${location}
    [Return]    ${location}

Save current URL
    ${current_url}=    Get URL
    ${url}=    Set Variable    ${current_url}
    Set Test Variable    ${url}    ${url}
    [Return]    ${url}

Wait Until Element Is Not Visible
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=${browser_timeout}
    Wait For Elements State    ${locator}    hidden    ${timeout}    ${message}

Page Should Contain Link
    [Arguments]    ${url}    ${message}=${EMPTY}
    ${hrefs}=    Evaluate Javascript     ${None}    Array.from(document.querySelectorAll('a')).map(e => e.getAttribute('href'))
    Should Contain    ${hrefs}    ${url}

Scroll Element Into View
    [Arguments]    ${locator}
    Hover    ${locator}

Input Text
    [Arguments]    ${locator}    ${text}
    Type Text    ${locator}    ${text}    0ms

Table Should Contain
    [Arguments]    ${locator}    ${expected}    ${message}=${EMPTY}    ${ignore_case}=${EMPTY}
    Get Text    ${locator}    contains    ${expected}    ${message}

Table Should Not Contain
    [Arguments]    ${locator}    ${expected}    ${message}=${EMPTY}    ${ignore_case}=${EMPTY}
    Get Text    ${locator}    not contains    ${expected}    ${message}

Element Should Contain
    [Arguments]    ${locator}    ${expected}    ${message}=${EMPTY}    ${ignore_case}=${EMPTY}
    Get Text    ${locator}    contains    ${expected}    ${message}

Element Text Should Be
    [Arguments]    ${locator}    ${expected}    ${message}=${EMPTY}    ${ignore_case}=${EMPTY}
    Get Text    ${locator}    equal    ${expected}    ${message}

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
    New Page    ${yves_url}

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
    [Arguments]    ${element}    ${shouldBeDisplayed}    ${tries}=20    ${timeout}=1s    ${message}='Timeout exceeded, element state doesn't match the expected'
    ${shouldBeDisplayed}=    Convert To Lower Case    ${shouldBeDisplayed}
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
        Fail    ${message}
    END

Try reloading page until element does/not contain text:
    [Documentation]    will reload the page until an element text will be updated. The second argument is the expected condition (true[contains]/false[doesn't contain]) for the element text.
    [Arguments]    ${element}    ${expectedText}    ${shouldContain}    ${tries}=20    ${timeout}=1s
    ${shouldContain}=    Convert To Lower Case    ${shouldContain}
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
        Take Screenshot
        Fail    'Timeout exceeded, element text doesn't match the expected'
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

Connect to Spryker DB
    ${db_name}=    Set Variable If    '${db_name}' == '${EMPTY}'    ${default_db_name}    ${db_name}
    ${db_user}=    Set Variable If    '${db_user}' == '${EMPTY}'    ${default_db_user}    ${db_user}
    ${db_password}=    Set Variable If    '${db_password}' == '${EMPTY}'    ${default_db_password}    ${db_password}
    ${db_host}=    Set Variable If    '${db_host}' == '${EMPTY}'    ${default_db_host}    ${db_host}
    ${db_engine}=    Set Variable If    '${db_engine}' == '${EMPTY}'    ${default_db_engine}    ${db_engine}
    IF    '${db_engine}' == 'mysql'
        ${db_engine}=    Set Variable    pymysql
    ELSE IF    '${db_engine}' == 'postgresql'
        ${db_engine}=    Set Variable    psycopg2
    ELSE IF    '${db_engine}' == 'postgres'
        ${db_engine}=    Set Variable    psycopg2
    END    
    IF    '${db_engine}' == 'psycopg2'
        ${db_port}=    Set Variable If    '${db_port}' == '${EMPTY}'    ${db_port_postgres_env}    ${db_port}
        IF    '${db_port_postgres_env}' == '${EMPTY}'
        ${db_port}=    Set Variable If    '${db_port_postgres_env}' == '${EMPTY}'    ${default_db_port_postgres}    ${db_port_postgres_env}
        END
    ELSE
    ${db_port}=    Set Variable If    '${db_port}' == '${EMPTY}'    ${db_port_env}    ${db_port}
        IF    '${db_port_env}' == '${EMPTY}'
        ${db_port}=    Set Variable If    '${db_port_env}' == '${EMPTY}'    ${default_db_port}    ${db_port_env}
        END
    END
    Set Test Variable    ${db_engine}
    Connect To Database    ${db_engine}    ${db_name}    ${db_user}    ${db_password}    ${db_host}    ${db_port}

Save the result of a SELECT DB query to a variable:
    [Documentation]    This keyword saves any value which you receive from DB using SQL query ``${sql_query}`` to a test variable called ``${variable_name}``.
    ...
    ...    It can be used to save a value returned by any query into a custom test variable.
    ...    This variable, once created, can be used during the specific test where this keyword is used and can be re-used by the keywords that follow this keyword in the test.
    ...    It will not be visible to other tests.
    ...    NOTE: Make sure that you expect only 1 value from DB, you can also check your query via external SQL tool.
    ...
    ...    *Examples:*
    ...
    ...    ``Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where customer_reference = '${user_reference_id}'    confirmation_key``
    [Arguments]    ${sql_query}    ${variable_name}
    Connect to Spryker DB
    ${var_value} =    Query    ${sql_query}
    Disconnect From Database
    ${var_value}=    Convert To String    ${var_value}
    ${var_value}=    Replace String    ${var_value}    '   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    ,   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    (   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    )   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    [   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    ]   ${EMPTY}
    Set Test Variable    ${${variable_name}}    ${var_value}
    [Return]    ${variable_name}

Ping and go to URL:
    [Arguments]    ${url}    ${timeout}=${EMPTY}
    ${accessible}=    Run Keyword And Ignore Error    Send GET request and return status code:    ${url}    ${timeout}
    ${successful}=    Run Keyword And Ignore Error    Should Contain Any    '${response.status_code}'    '200'    '201'    '202'    '301'    '302'
    IF    'PASS' in ${accessible} and 'PASS' in ${successful}
        Go To    ${url}
    ELSE
        Fail    '${url}' URL is not accessible of throws an error
    END
        
Send GET request and return status code:
    [Arguments]    ${url}    ${timeout}=5
    ${response}=    GET    ${url}    timeout=${timeout}    allow_redirects=true    expected_status=ANY
    Set Test Variable    ${response.status_code}    ${response.status_code}
    [Return]    ${response.status_code}

## Example of intercepting the network request
##     [Arguments]    ${eventName}    ${timeout}=30s
##     ${response}=    Wait for response    matcher=bazaarvoice\\.com\\/\\w+\\.gif\\?.*type=${eventName}    timeout=${timeout}
##     Should be true    ${response}[ok]
## OR
##    [Arguments]    ${timeout}=30s
##    ${response}=    Wait for response    matcher=usercentrics.*?graphql     timeout=${timeout}
##    Should be true    ${response}[ok]

Run console command:
    [Arguments]    ${command}    ${timeout}=5s
    ${rc}    ${output}=    Run And Return RC And Output    ${command}
    Log    ${output}
    Should Be Equal As Integers    ${rc}    0
    Sleep    ${timeout}

Trigger p&s
    [Arguments]    ${timeout}=5s
    IF    '.local' in '${yves_url}' or '.local' in '${zed_url}' or '.local' in '${glue_url}' or '.local' in '${bapi_url}'
        ${rc}    ${output}=    Run And Return RC And Output    cd .. && APPLICATION_STORE=DE docker/sdk testing console queue:worker:start --stop-when-empty
        Log    ${output}
        ${rc}    ${output}=    Run And Return RC And Output    cd .. && APPLICATION_STORE=AT docker/sdk testing console queue:worker:start --stop-when-empty    
        Log    ${output}
        Should Be Equal As Integers    ${rc}    0
        Sleep    ${timeout}
    END  

Trigger oms
    [Arguments]    ${timeout}=5s
    IF    '.local' in '${yves_url}' or '.local' in '${zed_url}' or '.local' in '${glue_url}' or '.local' in '${bapi_url}'
        ${rc}    ${output}=    Run And Return RC And Output    cd .. && APPLICATION_STORE=DE docker/sdk testing console order:invoice:send
        Log    ${output}
        ${rc}    ${output}=    Run And Return RC And Output    cd .. && APPLICATION_STORE=AT docker/sdk testing console order:invoice:send
        Log    ${output}
        Should Be Equal As Integers    ${rc}    0
        ${rc}    ${output}=    Run And Return RC And Output    cd .. && APPLICATION_STORE=DE docker/sdk testing console oms:check-timeout
        Log    ${output}
        ${rc}    ${output}=    Run And Return RC And Output    cd .. && APPLICATION_STORE=AT docker/sdk testing console oms:check-timeout
        Log    ${output}
        Should Be Equal As Integers    ${rc}    0
        ${rc}    ${output}=    Run And Return RC And Output    cd .. && APPLICATION_STORE=DE docker/sdk testing console oms:check-condition
        Log    ${output}
        ${rc}    ${output}=    Run And Return RC And Output    cd .. && APPLICATION_STORE=AT docker/sdk testing console oms:check-condition
        Log    ${output}
        Should Be Equal As Integers    ${rc}    0
        Sleep    ${timeout}
    END