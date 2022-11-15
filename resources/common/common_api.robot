*** Settings ***
Library    RequestsLibrary
Library    String
Library    Dialogs
Library    OperatingSystem
Library    Collections
Library    BuiltIn
Library    DateTime
Library    JSONLibrary
Library    DatabaseLibrary
Library    ../../resources/libraries/common.py

*** Variables ***
# *** SUITE VARIABLES ***
${api_timeout}                 60
${default_password}            change123
${default_allow_redirects}     true
${default_auth}                ${NONE}
# *** DB VARIABLES ***
${default_db_host}         127.0.0.1
${default_db_name}         eu-docker
${default_db_password}     secret
${default_db_port}         3306
${default_db_user}         spryker

*** Keywords ***
SuiteSetup
    [Documentation]    Basic steps before each suite. Should be sed with the ``Suite Setup`` tag.
    ...
    ...    *Example:*
    ...
    ...    ``Suite Setup       SuiteSetup``
    Remove Files    ${OUTPUTDIR}/selenium-screenshot-*.png
    Remove Files    resources/libraries/__pycache__/*
    Load Variables    ${env}
    ${random}=    Generate Random String    5    [NUMBERS]
    Set Global Variable    ${random}
    ${today}=    Get Current Date    result_format=%Y-%m-%d
    Set Global Variable    ${today}
    [Teardown]
    [Return]    ${random}

TestSetup
    [Documentation]   This setup should be called in Settings of every test suite. It defines which url variable will be used in the test suite.
    ...
    ...    At the moment it is used to define if the test is for GLUE (``glue`` tag) or BAPI (``bapi`` tag) by checking for the default or test tag.
    ...    If the tag is there it replaces the domein URL with bapi url.
    ...
    ...    To set a tag to a test case use ``[Tags]`` under the test name.
    ...    To set default tags for the whole test suite (.robotframework file), use ``Default Tags`` keyword in the suite Settings.
    ...
    ...    *Notes*:
    ...
    ...    1. If a test suite has no Test Setup and/or tests in the suite have no bapi/glue tags, GLUE URL will be used by default as the current URL.
    ...
    ...    2. Do not set both tags to a suite, each suite/robot file should have tests only for GLUE or only for BAPI.
    ...
    ...    3. You can set other tags for tests and suites with no restrictions, they will be ignored in suite setup.
    ...
    ...    *Example:*
    ...
    ...    ``*** Settings ***``
    ...
    ...    ``Test Setup    TestSetup``
    ...
    ...    ``Default Tags    bapi``
    FOR  ${tag}  IN  @{Test Tags}
    Log   ${tag}
    IF    '${tag}'=='bapi'    Set Suite Variable    ${current_url}    ${bapi_url}
    IF    '${tag}'=='glue'    Set Suite Variable    ${current_url}    ${glue_url}
    END
    Log    ${current_url}

Load Variables
    [Documentation]    Keyword is used to load variable values from the environment file passed during execution. This Keyword is used during suite setup.
    ...    It accepts the name of the environment as specified at the beginning of an environment file e.g. ``"environment": "api_suite"``.
    ...
    ...    These variables are loaded and usable throughtout all tests of the test suite, if this keyword is called during suite setup.
    ...
    ...    *Example:*
    ...
    ...    ``Load Variables    ${env}``
    ...
    ...    ``Load Variables    api_suite``
    [Arguments]    ${env}
    &{vars}=   Define Environment Variables From Json File    ${env}
    FOR    ${key}    ${value}    IN    &{vars}
        Log    Key is '${key}' and value is '${value}'.
        Set Global Variable    ${${key}}    ${value}
    END

I set Headers:
    [Documentation]    Keyword sets any number of headers for the further endpoint calls.
    ...    Headers can have any name and any value, they are set as test variable - which means they can be used throughtout one test if set once.
    ...    This keyword can be used to add access token to the next endpoint calls or to set header for the guest customer, etc.
    ...
    ...    It accepts a list of pairs haader-name=header-value as an argument. The list items should be separated by 4 spaces.
    ...
    ...    *Example:*
    ...
    ...    ``I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}``

    [Arguments]    &{headers}
    Set Test Variable    &{headers}
    [Return]    &{headers}

I get access token for the customer:
    [Documentation]    This is a helper keyword which helps get access token for future use in the headers of the following requests.
    ...
    ...    It gets the token for the specified customer ``${email}`` and saves it into the test variable ``${token}``, which can then be used within the scope of the test where this keyword was called.
    ...    After the test ends the ``${token}`` variable is cleared. This keyword needs to be called separately for each test where you expect to need a customer token.
    ...
    ...    The password in this case is not passed to the keyword and the default password stored in ``${default_password}`` will be used when getting token.
    ...
    ...    *Example:*
    ...
    ...    ``I get access token for the customer:    ${yves_user.email}``
    [Arguments]    ${email}    ${password}=${default_password}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${data}=    Evaluate    {"data":{"type":"access-tokens","attributes":{"username":"${email}","password":"${password}"}}}
    ${response}=    IF    ${hasValue}       run keyword    POST    ${current_url}/access-tokens    json=${data}    headers=${headers}
    ...    ELSE    POST    ${current_url}/access-tokens    json=${data}
    ${token}=    Set Variable    Bearer ${response.json()['data']['attributes']['accessToken']}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${token}    ${token}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${expected_self_link}    ${current_url}/access-tokens
    Log    ${token}
    [Return]    ${token}

I send a POST request:
    [Documentation]    This keyword is used to make POST requests. It accepts the endpoint *without the domain* and the body in JOSN.
    ...    Variables can and should be used in the endpoint url and in the body JSON.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    ``I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}``
    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${json}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${hasValue}   run keyword    POST    ${current_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    POST    ${current_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=ANY
    ${response_body}=    IF    ${response.status_code} != 204    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    [Return]    ${response_body}

I send a POST request with data:
    [Documentation]    This keyword is used to make POST requests. It accepts the endpoint *without the domain* and the body in plain text.
    ...    Variables can and should be used in the endpoint url and in the body.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    ``I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}``
    [Arguments]   ${path}    ${data}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${data}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${hasValue}   run keyword    POST    ${current_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    POST    ${current_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    IF    ${response.status_code} != 204    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    [Return]    ${response_body}

I send a PUT request:
    [Documentation]    This keyword is used to make POST requests. It accepts the endpoint *without the domain* and the body in JSON.
    ...    Variables can and should be used in the endpoint url and in the body JSON.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    ``I send a PUT request:    /some-endpoint/${someID}    {"data": {"type": "some-type"}}``
    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${json}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${hasValue}   run keyword    PUT    ${current_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    PUT    ${current_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    IF    ${response.status_code} != 204    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    [Return]    ${response_body}

I send a PUT request with data:
    [Documentation]    This keyword is used to make POST requests. It accepts the endpoint *without the domain* and the body in plain text.
    ...    Variables can and should be used in the endpoint url and in the body plain text.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    ``I send a PUT request:    /some-endpoint/${someID}    This is plain text body``
    [Arguments]   ${path}    ${data}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${data}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${hasValue}   run keyword    PUT    ${current_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    PUT    ${current_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    IF    ${response.status_code} != 204    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    [Return]    ${response_body}

I send a PATCH request:
    [Documentation]    This keyword is used to make PATCH requests. It accepts the endpoint *without the domain* and the body in JOSN.
    ...    Variables can and should be used in the endpoint url and in the body JSON.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...    If this keyword was already called within this test case (e.g. before POST request), there is no need to call it again.
    ...
    ...    Usually for PATCH requests you need to know and use the ID (UID) if the resource you need to update.
    ...    To  get the ID you need forst to make a POST or GET request to get the data and then call ``Save value to a variable:`` endpoint to save the ID to a test variable to be able to use it in the PATCH request.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    ``I send a PATCH request:    /carts/${cartUID}/items/${itemUID}    {"data": {"type": "items","attributes": {"quantity": 5}}}``

    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${json}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${hasValue}   run keyword    PATCH   ${current_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    PATCH    ${current_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    IF    ${response.status_code} != 204    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    [Return]    ${response_body}

I send a PATCH request with data
    [Documentation]    This keyword is used to make PATCH requests. It accepts the endpoint *without the domain* and the body in plain text.
    ...    Variables can and should be used in the endpoint url and in the body JSON.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...    If this keyword was already called within this test case (e.g. before POST request), there is no need to call it again.
    ...
    ...    Usually for PATCH requests you need to know and use the ID (UID) if the resource you need to update.
    ...    To  get the ID you need forst to make a POST or GET request to get the data and then call ``Save value to a variable:`` endpoint to save the ID to a test variable to be able to use it in the PATCH request.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    At the moment Spryker does not offer this type of calls, so example is theoretical.
    ...
    ...    ``I send a PATCH request:    /some-endpoint/${someID}   This is plain text body``
    [Arguments]   ${path}    ${data}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${data}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${hasValue}   run keyword    PATCH    ${current_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    PATCH    ${current_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    IF    ${response.status_code} != 204    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    [Return]    ${response_body}

I send a GET request:
    [Documentation]    This keyword is used to make GET requests. It accepts the endpoint *without the domain*.
    ...    Variables can and should be used in the endpoint url.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...    If this keyword was already called within this test case (e.g. before POST request), there is no need to call it again.
    ...
    ...    Sometimes for GET requests you need to know and use the ID (UID) if the resource you need to view.
    ...    To  get the ID you need forst to make a POST or GET request to get the data and then call ``Save value to a variable:`` endpoint to save the ID to a test variable to be able to use it in the GET request.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    ``I send a GET request:    /abstract-products/${abstract_sku}``
    [Arguments]   ${path}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${hasValue}   run keyword    GET    ${current_url}${path}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    GET    ${current_url}${path}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    IF    ${response.status_code} != 204    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    [Return]    ${response_body}

I send a DELETE request:
    [Documentation]    This keyword is used to make DELETE requests. It accepts the endpoint *without the domain*.
    ...    Variables can and should be used in the endpoint url.
    ...
    ...    This endpoint usually needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...    If this keyword was already called within this test case (e.g. before POST request), there is no need to call it again.
    ...
    ...    For DELETE requests you need to know and use the ID (UID) if the resource you need to delete.
    ...    To  get the ID you need forst to make a POST or GET request to get the data and then call ``Save value to a variable:`` endpoint to save the ID to a test variable to be able to use it in the GET request.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...    Body is recorded only in case there was an error, if DELETE endpoint worked without errors, reqponse body is empty and so not recorded.
    ...
    ...    *Example:*
    ...
    ...    For example below you will need to set headers and get address UID and customer reference recorded into a variables before you can call the DELETE request.
    ...
    ...    ``I send a DELETE request:    /customers/${customer_reference}/addresses/addressUID``
    [Arguments]   ${path}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${hasValue}   run keyword    DELETE    ${current_url}${path}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    DELETE    ${current_url}${path}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response}    ${response}
    ${response_body}=    IF    ${response.status_code} != 204    Set Variable    ${response.json()}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    [Return]    ${response_body}

Response reason should be:
    [Documentation]    This keyword checks that response reason saved  in ``${response}`` test variable matches the reason passed as an argument.
    ...
    ...    *Example:*
    ...
    ...    ``Response reason should be:    Created``
    [Arguments]    ${reason}
    Should Be Equal As Strings    ${reason}    ${response.reason}

Response status code should be:
    [Documentation]    This keyword checks that response status code saved  in ``${response}`` test variable matches the status code passed as an argument.
    ...
    ...    *Example:*
    ...
    ...    ``Response status code should be:    201``
    [Arguments]    ${status_code}
    Should Be Equal As Strings    ${response.status_code}    ${status_code}

Response body should contain:
    [Documentation]    This keyword checks that the response saved  in ``${response_body}`` test variable contsains the string passed as an argument.
    ...
    ...    *Example:*
    ...
    ...    ``Response body should contain:    "localizedName": "Weight"``
    [Arguments]    ${value}
    ${response_body}=    Convert To String    ${response_body}
    ${response_body}=    Replace String    ${response_body}    '    "
    Should Contain    ${response_body}    ${value}

Response body parameter should be:
    [Documentation]    This keyword checks that the response saved  in ``${response_body}`` test variable contsains the speficied parameter ``${json_path}`` with he specified value ``${expected_value}``.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should be:    [data][0][type]    abstract-product-availabilities``
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Be Equal    ${data}    ${expected_value}

Perform arithmetical calculation with two arguments:
    [Documentation]    This keyword calculates ``${expected_value1}``, ``${expected_value2}`` and saves  in ``${variable_name}`` variable.
    ...
    ...    First you need to set variable name. You can use also existing variable name, in this case variable should be overwritten.
    ...    Set integer values for ${expected_value1} and ${expected_value2}, add supported math symbol {'+', '-', '*', '/'} for ``${math_symbol}``.
    ...
    ...    *Example:*
    ...
    ...    ``Perform arithmetical calculation with two arguments:    discount_total_sum    ${discount_total_sum}    +    ${discount.product_3.with_10%_discount}``
    [Arguments]    ${variable_name}    ${expected_value1}    ${math_symbol}    ${expected_value2}
    IF    '${math_symbol}' == '+'
        ${result}    Evaluate    ${expected_value1} + ${expected_value2}
    ELSE IF    '${math_symbol}' == '-'
        ${result}    Evaluate    ${expected_value1} - ${expected_value2}
    ELSE IF    '${math_symbol}' == '*'
        ${result}    Evaluate    ${expected_value1} * ${expected_value2}
    ELSE IF    '${math_symbol}' == '/'
        ${result}    Evaluate    ${expected_value1} / ${expected_value2}
    ELSE
        ${result}    Set Variable    None
    END
    ${result}=    Convert To String    ${result}
    Set Test Variable    ${${variable_name}}    ${result}
    [Return]    ${variable_name}

Response body parameter should be in:
    [Documentation]    This keyword checks that the response saved  in ``${response_body}`` test variable contsains the speficied parameter ``${json_path}`` with the value that matches one of the parameters ``${expected_value1}``, ``${expected_value2}``.
    ...
    ...    The minimal number of arguments are 2, maximum is 4
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should be in:    [data][attributes][allowInput]    true    false``
    [Arguments]    ${json_path}    ${expected_value1}    ${expected_value2}    ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Contain Any   ${data}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True

Response body parameter with rounding should be:
    [Documentation]    This keyword checks that the response saved  in ``${response_body}`` test variable contains the speficied parameter ``${json_path}`` that was rounded and can differ from the expected value by 1 more cent or 1 less cent.
    ...    It can be used if you need to check value with rounding for prices etg.
    ...
    ...    Range is calculated as
    ...
    ...    Minimal range: ``${expected_value}`` - ``1``
    ...    Maximum range: ``${expected_value}`` + ``1``
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter with rounding should be:    [data][attributes][discounts][0][amount]    ${discount.product_3.with_10%_discount}``
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    ${range_value_min}=    Evaluate    ${expected_value} - 1
    ${range_value_max}=    Evaluate    ${expected_value} + 1
    IF    ${data} >= ${range_value_min} and ${data} <= ${range_value_max}
        ${result}    Set Variable    True
    ELSE
        ${result}    Set Variable    False
    END
    Should Be Equal    ${result}    True    Actual ${data} is not in expected Range [${range_value_min}; ${range_value_max}]

Response body parameter should be NOT in:
    [Documentation]    This keyword checks that the response saved  in ``${response_body}`` test variable contsains the speficied parameter ``${json_path}`` with the value that matches one of the parameters ``${expected_value1}``, ``${expected_value2}``.
    ...
    ...    The minimal number of arguments is 1, maximum is 4
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should be NOT in:    [data][attributes][allowInput]    None``
    [Arguments]    ${json_path}    ${expected_value1}    ${expected_value2}=robotframework-dummy-value    ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should NOT Contain Any   ${data}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True

Response body parameter should NOT be:
    [Documentation]    This keyword checks that the response saved in ``${response_body}`` test variable contsains the speficied parameter ``${json_path}`` has a value that is DIFFERENT from the value passed as an argument ``${expected_value}``.
    ...
    ...    This keyword can be conveniently used when you need to make sure the parameter is not empty. To check for ``null`` value in robot Framework use ``None`` keyword as shown in the example below.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should NOT be:    data.id    None``
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Not Be Empty    ${data} ${data} is empty but should not be
    Should Not Be Equal    ${data}    ${expected_value}

Response body parameter should have datatype:
    [Documentation]    This keyword checks that the response saved  in ``${response_body}`` test variable contsains the speficied parameter ``${parameter}`` and that parameter has the specified data type ``${expected_data_type}``.
    ...
    ...    Some types that can be used are: ``int``, ``str``, ``list``. It uses a custom keyword ``Evaluate datatype of a variable:`` to evaluate the datatype.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should have datatype:    [data][0][attributes][name]    str``
    ...    ``Response body parameter should have datatype:    [data][0][attributes][sort][sortParamNames]    list``
    [Arguments]    ${parameter}    ${expected_data_type}
    @{parameter}=    Get Value From Json    ${response_body}    ${parameter}
    ${actual_data_type}=    Evaluate datatype of a variable:    @{parameter}
    Should Be Equal    ${actual_data_type}    ${expected_data_type}

Evaluate datatype of a variable:
    [Documentation]    This is a technical keyword that is used in ``Response body parameter should have datatype:`` and is used to evaluate the actual data type of a variable.
    ...
    ...        Example of assertions:
    ...
    ...    ``${is int}=      Evaluate     isinstance($variable, int) ``    will be True
    ...
    ...    ``${is string}=   Evaluate     isinstance($variable, str) ``    will be False
    [Arguments]    ${variable}
    ${data_type}=    Evaluate     type($variable).__name__
    [Return]    ${data_type}


Response header parameter should be:
    [Documentation]    This keyword checks that the response header saved previiously in ``${response_headers}`` test variable has the expected header with name ``${header_parameter}`` and this header has value ``${header_value}``
    ...
    ...    *Example:*
    ...
    ...    ``Response header parameter should be:    Content-Type    ${default_header_content_type}``
    [Arguments]    ${header_parameter}    ${header_value}
    ${actual_header_value}=    Get From Dictionary    ${response_headers}    ${header_parameter}
    Should Be Equal    ${actual_header_value}    ${header_value}

Response header parameter should contain:
    [Documentation]    This keyword checks that the response header saved previiously in ``${response_headers}`` test variable has the expected header with name ``${header_parameter}`` and this header contains substring ``${header_value}``
    ...
    ...    *Example:*
    ...
    ...    ``Response header parameter should be:    Content-Type    ${default_header_content_type}``
    [Arguments]    ${header_parameter}    ${header_value}
    ${actual_header_value}=    Get From Dictionary    ${response_headers}    ${header_parameter}
    Should Contain    ${actual_header_value}    ${header_value}

Response body has correct self link
    [Documentation]    This keyword checks that the actual selflink retrieved from the test variable ``${response_body}`` matches the self link recorded into the ``${expected_self_link}`` test variable on endpoint call.
    ...
    ...     This keyword does not accept any arguments. Expected self link on the endpoint call as assembled from the domain and the endpoint passed to the request.
    ...
    ...    *NOTE:* this keyword checks the first link that is OUTSUDE of the ``data[]`` array in the response
    ${actual_self_link}=    Get Value From Json    ${response_body}    $.links.self    #Exampleof path: $..address.streetAddress
    ${actual_self_link}=    Convert To String    ${actual_self_link}
    ${actual_self_link}=    Replace String    ${actual_self_link}    [    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    ]    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    '    ${EMPTY}
    Should Be Equal    ${actual_self_link}    ${expected_self_link}

Response body has correct self link internal
    [Documentation]    This keyword checks that the actual selflink retrieved from the test variable ``${response_body}`` matches the self link recorded into the ``${expected_self_link}`` test variable on endpoint call.
    ...
    ...     This keyword does not accept any arguments. Expected self link on the endpoint call as assembled from the domain and the endpoint passed to the request.
    ...
    ...    *NOTE:* this keyword checks the first link that is INSIDE of the ``data[]`` array in the response.
    ${actual_self_link}=    Get Value From Json    ${response_body}    [data][links][self]    #Exampleof path: $..address.streetAddress
    ${actual_self_link}=    Convert To String    ${actual_self_link}
    ${actual_self_link}=    Replace String    ${actual_self_link}    [    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    ]    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    '    ${EMPTY}
    Log    ${response_body}
    Should Be Equal    ${actual_self_link}    ${expected_self_link}

Response body has correct self link for created entity:
    [Documentation]    This keyword checks that the actual selflink retrieved from the test variable ``${response_body}`` plus the UID of the entity that was created and matches the self link recorded into the ``${expected_self_link}`` test variable on endpoint call.
    ...
    ...     This keyword requires one argument which is the ending of the URL usually containing the UID of the created resource. Expected self link on the endpoint call as assembled from the domain, the endpoint passed to the request and the end of the URTL passed as the argument.
    ...
    ...    *NOTE:* this keyword checks the first link that is INSIDE of the ``data[]`` array in the response.
    ...
    ...    *Example:*
    ...
    ...    ``Response body has correct self link for created entity:    ${address_uid_1}``
    ...
    ...    ``Response body has correct self link for created entity:    687b806f-2fab-555f-90ae-e32d96b6aa71``
    ...
    ...    In the case above the self link for create cart would be ``glue.domain/carts/687b806f-2fab-555f-90ae-e32d96b6aa71``, ``${expected_self_link}`` would be ``glue.domain/carts/`` and the UID will come from the argument.
    [Arguments]    ${url}    #the ending of the url, usually the ID
    ${actual_self_link}=    Get Value From Json    ${response_body}    [data][links][self]    #Exampleof path: $..address.streetAddress
    ${actual_self_link}=    Convert To String    ${actual_self_link}
    ${actual_self_link}=    Replace String    ${actual_self_link}    [    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    ]    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    '    ${EMPTY}
    Log    ${response_body}
    Should Be Equal    ${actual_self_link}    ${expected_self_link}/${url}

Response body parameter should not be EMPTY:
    [Documentation]    This keyword checks that the body parameter sent in ``${json_path}`` argument is not empty. If the parameter value is other that ``null`` the keyword will fail.
    ...
    ...    This keyword checks both that the parameter does not have null value or that it does not have an empty string value and makes sure that the pagameter actually exists.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should not be EMPTY:    [data][attributes][description]``
    [Arguments]    ${json_path}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Should Not Be Empty    ${data}    ${data} is empty but shoud not be
    Should Not Be Equal    ${data}    None    Propewrty value is ${data} which is null, but it shoud be a non-null value

Response body parameter should be greater than:
    [Documentation]    This keyword checks that the body parameter sent in ``${json_path}`` argument is greater than a specific integer value ``${expected_value}``.
    ...    It can be used to check that the number of items in stock is more than the minimum, that the number of returned products or cms pages in search is more than the minimum.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should be greater than:    [data][0][attributes][price]   100``
    ...
    ...    ``Response body parameter should be greater than:    data[0].attributes.dateSchedule[0].date    ${today}``
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    ${result}=    Evaluate    '${data}' > '${expected_value}'
    ${result}=    Convert To String    ${result}
    Should Be Equal    ${result}    True    Actual ${data} is not greater than expected ${expected_value}

Response body parameter should be less than:
    [Documentation]    This keyword checks that the body parameter sent in ``${json_path}`` argument is less than a specific integer value ``${expected_value}``.
    ...    It can be used to check that the default price of the product is less than the original price, that the date of the order is before the certain date.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should be less than:    [data][0][attributes][price]   100``
    ...
    ...    ``Response body parameter should be less than:    data[0].attributes.dateSchedule[0].date    2019-01-01``
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    ${result}=    Evaluate    '${data}' < '${expected_value}'
    ${result}=    Convert To String    ${result}
    Should Be Equal    ${result}    True    Actual ${data} is not less than expected ${expected_value}

Response should contain the array of a certain size:
    [Documentation]    This keyword checks that the body array sent in ``${json_path}`` argument contains the specific number of items ``${expected_size}``. The expected size should be an integer value.
    ...    It can be used to check how many products, adderesses, etc. were returned, if you know the exact number of emelents that should be returned.
    ...
    ...    *Example:*
    ...
    ...    ``Response should contain the array of a certain size:    [data][0][relationships][abstract-product-image-sets][data]    1``
    [Arguments]    ${json_path}    ${expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    Log    @{data}
    ${list_length}=    Get Length    @{data}
    ${list_length}=    Convert To String    ${list_length}
    #${log_list}=    Log List    @{data}
    Should Be Equal    ${list_length}    ${expected_size}    actual size ${list_length} doesn't equal expected ${expected_size}

Response should contain the array larger than a certain size:
    [Documentation]    This keyword checks that the body array sent in ``${json_path}`` argument contains the number of items that is more than ``${expected_size}``.
    ...    The expected size should be an integer value that is less than you expect elements. So if you expect an array to have at least 2 elements, the ``${expected_size}`` should be 1.
    ...
    ...    It can be used to check how many elements were returned, if you know the exact number of emelents that should be returned, but know there should be at least 1 for example.
    ...
    ...    *Example:*
    ...
    ...    `` Response should contain the array larger than a certain size:    [data][relationships][category-nodes][data]    1``
    [Arguments]    ${json_path}    ${expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    Log    @{data}
    ${list_length}=    Get Length    @{data}
    ${list_length}=    Convert To Integer    ${list_length}
    ${result}=    Evaluate   ${list_length} > ${expected_size}
    ${result}=    Convert To String    ${result}
    Should Be Equal    ${result}    True    Actual array length is ${list_length} and it is not greater than expected ${expected_size}

Response should contain the array smaller than a certain size:
    [Documentation]    This keyword checks that the body array sent in ``${json_path}`` argument contains the number of items that is fewer than ``${expected_size}``.
    ...    The expected size should be an integer value that is less than you expect elements. So if you expect an array to have 0 or 1 elements, the ``${expected_size}`` should be 2.
    ...
    ...    It can be used to check how many elements were returned, if you know the exact number of emelents that should be returned, but know there should be fewer, than the default value for example.
    ...    It is useful when you check search and know how many values are there if there is no filtering, but you also know that with filtering, there should be fewer values than without it.
    ...
    ...    *Example:*
    ...
    ...    ``Response should contain the array smaller than a certain size:    [data][0][attributes][valueFacets][1]    5``
    [Arguments]    ${json_path}    ${expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    Log    @{data}
    ${list_length}=    Get Length    @{data}
    ${list_length}=    Convert To Integer    ${list_length}
    ${result}=    Evaluate   ${list_length} < ${expected_size}
    ${result}=    Convert To String    ${result}
    Should Be Equal    ${result}    True    Actual array length is ${list_length} and it is not greater than expected ${expected_size}

Each array element of array in response should contain property:
    [Documentation]    This keyword checks whether the array ``${json_path}`` that is present in the ``${response_body}`` test variable contsains a property with ``${expected_property}`` name in every of it's array elements.
    ...
    ...    It does not take into account the property value, just checks it is there for every element. If some of the elements have this property and others do not, the keyword will fail.
    ...
    ...    *Example:*
    ...
    ...   ``Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    quantity``
    ...
    ...    The example above checks if ALL prices returened in volumePrices array have quantity property, while quantity value can be any and even null.
    [Arguments]    ${json_path}    ${expected_property}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        List Should Contain Value    ${list_element}    ${expected_property}
    END

Each array element of array in response should contain value:
        [Documentation]    This keyword checks whether the array ``${json_path}`` that is present in the ``${response_body}`` test variable contsains a value ``${expected_value}`` in every of it's array elements.
    ...
    ...    It does not take into account the property name, just checks if the value is there for every element. If some of the array elements have this value and others do not, the keyword will fail.
    ...
    ...    *Example:*
    ...
    ...   ``Each array element of array in response should contain value:    [data][0][attributes][prices]    ${currency.eur.code}``
    ...
    ...    The example above checks if ALL prices returened in volumePrices array have currency code, regardless of which property has this value.
    [Arguments]    ${json_path}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${sub_list_element}=    Create List    ${list_element}
        ${sub_list_element}=    Convert To String    ${sub_list_element}
        Should Contain    : ${sub_list_element}    ${expected_value}
    END

Each array element of array in response should a nested array of a certain size:
        [Documentation]    This keyword checks whether the array ``${paret_array}`` that is present in the ``${response_body}`` test variable contsains an array ``${nested_array}`` in every of it's array elements and for every its occurrence that nested array has sixe ``${array_expected_size}``.
    ...
    ...    If the nested arrays are of different sizes, this keyword will fail.
    ...
    ...    *Example:*
    ...
    ...   ``Each array element of array in response should a nested array of a certain size:    [data]    [prices]    2``

    [Arguments]    ${parent_array}    ${nested_array}    ${array_expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${parent_array}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        @{list_element2}=    Get Value From Json    ${list_element}    ${nested_array}
        ${list_length2}=    Get Length    @{list_element2}
        ${list_length2}=    Convert To String    ${list_length2}
        Should Be Equal    ${list_length2}    ${array_expected_size}    Actual array length is ${list_length2} and it is not the same as than expected ${array_expected_size}
    END

Each array element of array in response should contain property with value:
    [Documentation]    This keyword checks that each element in the array specified as ``${json_path}`` contains the specified property ``${expected_property}`` with the specified value ``${expected_value}``.
    ...
    ...    If at least one array element has this property with another value, the keyword will fail.
    ...
    ...    *NOTE*: ``${expected_property}`` is a first level property in an array like this ``"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...] e.g. ``attributes``.
    ...    While second level property is `attributes.sku`` and it won't be identified with this keyword.
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain property with value:    [errors]    status    422``
    ...
    ...    ``Each array element of array in response should contain property with value:    [data][0][attributes][prices]    volumePrices    []``
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        Dictionary Should Contain Item    ${list_element}    ${expected_property}    ${expected_value}
    END

Each array element of array in response should contain property with value in:
    [Documentation]    This keyword checks that each array element contsains the speficied parameter ``${expected_property}`` with the value that matches one of the parameters ``${expected_value1}``, ``${expected_value2}``, etc..
    ...
    ...    The minimal number of arguments are 2, maximum is 4
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain property with value in:    [data]    [attributes][allowInput]    True    False``
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value1}    ${expected_value2}    ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value

    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    ${expected_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        Should Contain Any   ${list_element}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
    END

Each array element of array in response should contain property with value NOT in:
    [Documentation]    This keyword checks that each array element contsains the speficied parameter ``${expected_property}`` with the value that does not match any of the parameters ``${expected_value1}``, ``${expected_value2}``, etc..
    ...
    ...    The minimal number of arguments is 1, maximum is 4
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain property with value in:    [data]    [attributes][isSuper]    None``
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value1}    ${expected_value2}=robotframework-dummy-value    ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value

    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    ${expected_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        Should Not Contain Any   ${list_element}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
    END

Each array element of nested array should contain property with value in:
    [Documentation]    This keyword checks that each array element of ``${nested_array} that is inside the parent array ``${json_path}`` contains the speficied parameter ``${expected_property}`` with the value that matches any of the parameters ``${expected_value1}``, ``${expected_value2}``, etc..
    ...
    ...    The minimal number of arguments is 1, maximum is 4
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of nested array should contain property with value in:    [data]    [attributes][localizedKeys]    translation    en_US    de_DE``
    [Arguments]    ${json_path}    ${nested_array}    ${expected_property}    ${expected_value1}    ${expected_value2}    ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value

    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length1}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index1}    IN RANGE    0    ${list_length1}
        ${list_element}=    Get From List    @{data}    ${index1}
        @{list_element2}=    Get Value From Json    ${list_element}    ${nested_array}
        ${list_length2}=    Get Length    @{list_element2}
        FOR    ${index2}    IN RANGE    0    ${list_length2}
            ${list_element}=    Get From List    @{list_element2}    ${index2}
            ${list_element}=    Get Value From Json    ${list_element}    ${expected_property}
            ${list_element}=    Convert To String    ${list_element}
            ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
            ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
            ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
            Should Contain Any   ${list_element}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
        END
    END

Each array element of nested array should contain property with value NOT in:
    [Documentation]    This keyword checks that each array element of ``${nested_array} that is inside the parent array ``${json_path}`` contsains the speficied parameter ``${expected_property}`` with the value that does not match any of the parameters ``${expected_value1}``, ``${expected_value2}``, etc..
    ...
    ...    The minimal number of arguments is 1, maximum is 4
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of nested array should contain property with value NOT in:    [data]    [attributes][localizedKeys]    translation    None``
    [Arguments]    ${json_path}    ${nested_array}    ${expected_property}    ${expected_value1}    ${expected_value2}=robotframework-dummy-value   ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value

    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length1}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index1}    IN RANGE    0    ${list_length1}
        ${list_element}=    Get From List    @{data}    ${index1}
        @{list_element2}=    Get Value From Json    ${list_element}    ${nested_array}
        ${list_length2}=    Get Length    @{list_element2}
        FOR    ${index2}    IN RANGE    0    ${list_length2}
            ${list_element}=    Get From List    @{list_element2}    ${index2}
            ${list_element}=    Get Value From Json    ${list_element}    ${expected_property}
            ${list_element}=    Convert To String    ${list_element}
            ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
            ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
            ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
            Should Not Contain Any   ${list_element}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
        END
    END

Each array element of array in response should contain nested property with value:
    [Documentation]    This keyword checks that each element in the array specified as ``${json_path}`` contains the specified property ``${expected_nested_property}`` with the specified value ``${expected_value}``.
    ...
    ...    If at least one array element has this property with another value, the keyword will fail.
    ...
    ...    *NOTES*:
    ...
    ...    1. ``${expected_nested_property}`` is a second level property. In an array like this
    ...
    ...    ``{"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...]}``
    ...
    ...    it will be ``attributes.sku``.
    ...
    ...    2. The first level property in the above array is just ``attributes``, but it cannot be checked by this keyword.
    ...
    ...    3. Syntax for the second level property is ``[firstlevel][secondlevel]`` or ``firstlevel.secondlevel``.
    ...
    ...    4. This keyword supports any level of nesting.
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain nested property with value:    [data]    [attributes][sku]    "M1234"``
    ...
    ...    ``Each array element of array in response should contain nested property with value:    [data]    attributes.sku    "M1234"``
    ...
    ...    ``Each array element of array in response should contain nested property with value:    [data]    [relationships][concrete-products][data][0][type]    concrete-products``
    [Arguments]    ${json_path}    ${expected_nested_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    $.${expected_nested_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        Should Be Equal    ${list_element}    ${expected_value}
    END

Each array element of array in response should contain nested property in range:
    [Documentation]    This keyword checks that each element in the array specified as ``${json_path}`` contains the specified property ``${expected_nested_property}`` that's in the range between ``${lower_value}`` and  ``${higher_value}``
    ...
    ...    If at least one array element has this property not in this range, the keyword will fail.
    ...
    ...    *NOTES*:
    ...
    ...    1. ``${expected_nested_property}`` is a second level property. In an array like this
    ...
    ...    ``{"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...]}``
    ...
    ...    it will be ``attributes.sku``.
    ...
    ...    2. The first level property in the above array is just ``attributes``, but it cannot be checked by this keyword.
    ...
    ...    3. Syntax for the second level property is ``[firstlevel][secondlevel]`` or ``firstlevel.secondlevel``.
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain nested property in range:    [data]    [attributes][sku]    0    10``
    ...
    ...    ``Each array element of array in response should contain nested property in range:    [data]    attributes.sku    20    100``
    ...
    ...    ``Each array element of array in response should contain nested property in range:    [data]    [relationships][concrete-products][data][0][price]    10     500``
    [Arguments]    ${json_path}    ${expected_nested_property}    ${lower_value}    ${higher_value}
    IF    ${lower_value} == ${higher_value}    Fail    Your higher and lower values cannot be the same.
    IF    ${lower_value} > ${higher_value}    Fail    Your lower value cannot be greater than the lower value.
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    $.${expected_nested_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        IF    ${list_element} < ${lower_value}    Fail    Value ${list_element} is less than lower value ${lower_value}.
        IF    ${list_element} > ${higher_value}    Fail    Value ${list_element} is greater than higher value ${higher_value}.
    END
Each array element of array in response should be greater than:
    [Documentation]    This keyword checks that each element in the array specified as ``${json_path}`` contains the specified property ``${expected_nested_property}`` that's greater than ``${expected_value}``
    ...
    ...    If at least one array element has this property not greater than ``${expected_value}``, the keyword will fail.
    ...
    ...    *NOTES*:
    ...
    ...    1. ``${expected_nested_property}`` is a second level property. In an array like this
    ...
    ...    ``{"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...]}``
    ...
    ...    it will be ``attributes.sku``.
    ...
    ...    2. The first level property in the above array is just ``attributes``, but it cannot be checked by this keyword.
    ...
    ...    3. Syntax for the second level property is ``[firstlevel][secondlevel]`` or ``firstlevel.secondlevel``.
    ...
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should be greater than:    [data]    [attributes][price]    1000``
    ...
    ...    ``Each array element of array in response should be greater than:    [data]    attributes.price    2000``
    ...
    ...    ``Each array element of array in response should be greater than:    [data]    [relationships][concrete-products][data][0][price]     5000``
    [Arguments]    ${json_path}    ${expected_nested_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    $.${expected_nested_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        ${result}=    Evaluate    '${list_element}' > '${expected_value}'
        ${result}=    Convert To String    ${result}
        Should Be Equal    ${result}    True    Actual ${list_element} is not greater than expected ${expected_value}
    END

Each array element of array in response should be less than:
    [Documentation]    This keyword checks that each element in the array specified as ``${json_path}`` contains the specified property ``${expected_nested_property}`` that's less than ``${expected_value}``
    ...
    ...    If at least one array element has this property not less than ``${expected_value}``, the keyword will fail.
    ...
    ...    *NOTES*:
    ...
    ...    1. ``${expected_nested_property}`` is a second level property. In an array like this
    ...
    ...    ``{"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...]}``
    ...
    ...    it will be ``attributes.sku``.
    ...
    ...    2. The first level property in the above array is just ``attributes``, but it cannot be checked by this keyword.
    ...
    ...    3. Syntax for the second level property is ``[firstlevel][secondlevel]`` or ``firstlevel.secondlevel``.
    ...
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should be less than:    [data]    [attributes][price]    1000``
    ...
    ...    ``Each array element of array in response should be less than:    [data]    attributes.price    2000``
    ...
    ...    ``Each array element of array in response should be less than:    [data]    [relationships][concrete-products][data][0][price]     5000``
    [Arguments]    ${json_path}    ${expected_nested_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    $.${expected_nested_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        ${result}=    Evaluate    '${list_element}' < '${expected_value}'
        ${result}=    Convert To String    ${result}
        Should Be Equal    ${result}    True    Actual ${list_element} is not less than expected ${expected_value}
    END

Each array element of array in response should contain nested property with datatype:
    [Documentation]    This keyword checks that each element in the array specified as ``${json_path}`` contains the specified property ``${expected_nested_property}`` with the value of the specified data type ``${expected_type}``.
    ...
    ...    If at least one array element has this property with another value, the keyword will fail.
    ...
    ...    *NOTES*:
    ...
    ...    1. ``${expected_nested_property}`` is a second level property. In an array like this
    ...
    ...    ``{"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...]}``
    ...
    ...    it will be ``attributes.sku``.
    ...
    ...    2. The first level property in the above array is just ``attributes``, but it cannot be checked by this keyword.
    ...
    ...    3. Syntax for the second level property is ``[firstlevel][secondlevel]`` or ``firstlevel.secondlevel``.
    ...
    ...    4. This keyword supports any level of nesting.
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain nested property with datatype:    [data]    [attributes][sku]    str``
    ...
    ...    ``Each array element of array in response should contain nested property with datatype:    [data]    attributes.price    int``
    [Arguments]    ${json_path}    ${expected_nested_property}    ${expected_type}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        @{list_element}=    Get Value From Json    ${list_element}    $.${expected_nested_property}
        ${actual_data_type}=    Evaluate datatype of a variable:    @{list_element}
        Should Be Equal    ${actual_data_type}    ${expected_type}
    END

Each array element of array in response should contain nested property with datatype in:
    [Documentation]    This keyword checks that each element in the array specified as ``${json_path}`` contains the specified property ``${expected_nested_property}`` with the value of one of the specified data types ``${expected_type1}``, ``${expected_type1}``, etc..
    ...
    ...    This keyword requires 2 parameters and may optionally use up to 4 datatypes
    ...
    ...    *NOTES*:
    ...
    ...    1. ``${expected_nested_property}`` is a second level property. In an array like this
    ...
    ...    ``{"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...]}``
    ...
    ...    it will be ``attributes.sku``.
    ...
    ...    2. The first level property in the above array is just ``attributes``, but it cannot be checked by this keyword.
    ...
    ...    3. Syntax for the second level property is ``[firstlevel][secondlevel]`` or ``firstlevel.secondlevel``.
    ...
    ...    4. This keyword supports any level of nesting.
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain nested property with datatype in:    [data]    attributes.price    int    float``
    [Arguments]    ${json_path}    ${expected_nested_property}    ${expected_type1}    ${expected_type2}    ${expected_type3}=test    ${expected_type4}=test
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        @{list_element}=    Get Value From Json    ${list_element}    $.${expected_nested_property}
        ${actual_data_type}=    Evaluate datatype of a variable:    @{list_element}
        Should Contain Any    ${actual_data_type}    ${expected_type1}    ${expected_type2}    ${expected_type3}    ${expected_type4}
    END

Each array element of array in response should contain nested property:
    [Documentation]    This keyword checks that each element in the array specified as ``${json_path}`` contains the specified property ``${level1_property}``, that is not an array and contains a certain second level property ``${level2_property}``,.
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain nested property:    [data]    [attributes]    sku``
    ...
    ...    The example above checks if inside [data] array there is property attributes and inside that there is sku property
    [Arguments]    ${json_path}    ${level1_property}    ${level2_property}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    ${level1_property}
        ${list_element}=    Convert To String    ${list_element}
        Should Contain    ${list_element}    ${level2_property}
    END


Response should return error message:
    [Documentation]    This keyword checks if the ``${response_body}`` test variable that contains the response of the previous request contains the specific  ``${error_message}``.
    ...
    ...    Call only for negative tests where you expect an error. NOTE: it checks only the first error, if there are more than one, better use this keyword: ``Array in response should contain property with value``.
    ...
    ...    *Example:*
    ...
    ...    ``Response should return error message:    Can`t find abstract product image sets.``
    [Arguments]    ${error_message}
    ${data}=    Get Value From Json    ${response_body}    [errors][0][detail]
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Be Equal    ${data}    ${error_message}    Actual ${data} doens't equal expected ${error_message}

Response should return error code:
    [Documentation]    This keyword checks if the ``${response_body}`` test variable that contains the response of the previous request contains the specific  ``${error_code}``.
    ...
    ...    Call only for negative tests where you expect an error. NOTE: it checks only the first error code in the array, if there are more than one error, better use this keyword: ``Array in response should contain property with value``.
    ...
    ...    *Example:*
    ...
    ...    ``Response should return error code:    204``
    [Arguments]    ${error_code}
    ${data}=    Get Value From Json    ${response_body}    [errors][0][code]
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Be Equal    ${data}    ${error_code}    Actual ${data} doens't equal expected ${error_code}

Response should contain certain number of values:
    [Documentation]    This keyword checks if a certain response paratemeter ``${json_path} `` in the ``${response_body}`` test variable has the specified number ``${expected_count}`` of the specified values ``${expected_value}`` in it.
    ...
    ...    It can check that response contains 5 categories or 4 cms pages.
    ...
    ...    *Example:*
    ...
    ...    ``Response should contain certain number of values:    [data][attributes][nodes]    cms_page    4``
    [Arguments]    ${json_path}    ${expected_value}    ${expected_count}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${log_list}=    Log List    @{data}
    ${list_as_string}=    Convert To String    @{data}
    ${count}=    Get Count    : ${list_as_string}    ${expected_value}
    ${count}=    Convert To String    ${count}
    Should Be Equal    ${count}    ${expected_count}    Actual ${count} doesn't equal expected ${expected_count}

Response include should contain certain entity type:
    [Documentation]    This keyword checks that a certain entity with type ``${expected_value}`` is included into the ``[included]`` section of the ``${response_body}`` test variable.
    ...    It accepts the type of the included entity (usually can be found in [included][index][type]) and checks if such entity exists in the responce at least once.
    ...
    ...    *Example:*
    ...
    ...    ``Response include should contain certain entity type:    concrete-products``
    [Arguments]    ${expected_value}    #this should be the 'type' of the included item, e.g. abstract-product-prices
    @{include}=    Get Value From Json    ${response_body}    [included]
    ${list_length}=    Get Length    @{include}
    ${log_list}=    Log List    @{include}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${include_element}=    Get From List    @{include}    ${index}
        ${type}=    Get Value From Json    ${include_element}    [type]
        ${type}=    Convert To String    ${type}
        ${type}=    Replace String    ${type}    '   ${EMPTY}
        ${type}=    Replace String    ${type}    [   ${EMPTY}
        ${type}=    Replace String    ${type}    ]   ${EMPTY}
        ${result}=    Evaluate    '${type}' == '${expected_value}'
        IF    ${result}    Exit For Loop
    END
    Should Be Equal As Strings    ${result}    True    Include section ${expected_value} was not found

Response include element has self link:
    [Documentation]    This keyword checks that the ``[included]`` section of the response contains a self link in the included element with ``${expected_value}`` type.
    ...
    ...     This keyword does accepts type of the included element as the parameter. If there is not include with this type or the include with this type does not have/has wrong selflink, the keyword will fail.
    ...
    ...    *Example:*
    ...
    ...    ``Response include element has self link:   concrete-products``
    [Arguments]    ${expected_value}    #this should be the 'type' of the included item, e.g. abstract-product-prices
    @{include}=    Get Value From Json    ${response_body}    [included]
    ${list_length}=    Get Length    @{include}
    ${log_list}=    Log List    @{include}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${include_element}=    Get From List    @{include}    ${index}
        ${type}=    Get Value From Json    ${include_element}    [type]
        ${type}=    Convert To String    ${type}
        ${type}=    Replace String    ${type}    '   ${EMPTY}
        ${type}=    Replace String    ${type}    [   ${EMPTY}
        ${type}=    Replace String    ${type}    ]   ${EMPTY}
        ${result}=    Evaluate    '${type}' == '${expected_value}'
        ${link_found}=    IF    ${result}    Get Value From Json    ${include_element}    [links][self]
        IF    ${link_found}    Should Not Be Equal    ${link_found}    None    ${link_found} is  empty for ${expected_value} include section
        IF    ${result}    Exit For Loop
    END
    Should Be Equal As Strings    ${result}    True    Include section ${expected_value} was not found

Save value to a variable:
    [Documentation]    This keyword saves any value located in a response parameter ``${json_path}`` to a test variable called ``${name}``.
    ...
    ...    It can be used to save a value returned by any request into a custom test variable.
    ...    This variable, once created, can be used during the cpecific test where this keyword is used and can be re-used by the keywords that follow this keyword in the test.
    ...    It will not be visible to other tests.
    ...
    ...    *Examples:*
    ...
    ...    ``Save value to a variable:    [data][id]    cart_uid``
    ...
    ...    The example above should be called after POST request for cart creation. It gets cart ID from the ``${response_body}`` test vatialbe and saves it into ``${cart_uid}`` test variable whcih can then be used in other requests, e.g. in a checkout request.
    [Arguments]    ${json_path}    ${name}
    ${var_value}=    Get Value From Json    ${response_body}    ${json_path}
    ${var_value}=    Convert To String    ${var_value}
    ${var_value}=    Replace String    ${var_value}    '   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    [   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    ]   ${EMPTY}
    Set Test Variable    ${${name}}    ${var_value}
    [Return]    ${name}

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
    Connect To Database    pymysql    ${default_db_name}    ${default_db_user}    ${default_db_password}    ${default_db_host}    ${default_db_port}
    ${var_value} =    Query    ${sql_query}
    Disconnect From Database
    ${var_value}=    Convert To String    ${var_value}
    ${var_value}=    Replace String    ${var_value}    '   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    ,   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    (   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    )   ${EMPTY}
    Set Test Variable    ${${variable_name}}    ${var_value}
    [Return]    ${variable_name}

Save Header value to a variable:
    [Documentation]    This keyword saves any value located in a response Header parameter ``${header_parameter}`` to a test variable called ``${name}``.
    ...
    ...    It can be used to save a value returned by any request into a custom test variable.
    ...    This variable, once created, can be used during the cpecific test where this keyword is used and can be re-used by the keywords that follow this keyword in the test.
    ...    It will not be visible to other tests.
    ...
    ...    *Examples:*
    ...
    ...    ``Save Header value to a variable:    ETag    header_tag``
    ...
    ...    The example above should be called after POST request for cart creation. It gets ETag from the ``${response_headers}`` test vatialbe and saves it into ``${header_tag}`` test variable which can then be used in other requests, e.g. in a PATCH request.
    [Arguments]    ${header_parameter}    ${name}
    ${actual_header_value}=    Get From Dictionary    ${response_headers}    ${header_parameter}
    Set Test Variable    ${${name}}    ${actual_header_value}
    [Return]    ${name}

Response body parameter should contain:
    [Documentation]    This keyword checks that response parameter with name ``${json_path}`` contains the specified substing ``${expected_value}``.
    ...    It can check that a long value has the required substing without needing to know the whole value. It is a partial patch check.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should contain:    [data][attributes][superAttributes]    ${abstract_sku}``
    ...
    ...    The example above checks that ``superAttributes`` parameter contains the sku of the concrete product.
    ...    In fact this is abstract product request and this array returns the list of concrete products that are variants of this abstract.
    ...    Since in Spryker often concrete SKU includes abstract sku, this checks that the list contains abstract sku.
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Contain   ${data}    ${expected_value}

Response body parameter should start with:
    [Documentation]    This keyword checks that response parameter with name ``${json_path}`` starts with the specified substing ``${expected_value}``.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should start with:    [data][attributes][name]    Comp``
    ...
    ...    The example above checks that ``name`` parameter starts with 'comp', e.g. as in Computer.
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Start With   ${data}    ${expected_value}

Array in response should contain property with value:
    [Documentation]    This keyword checks is the specified array (usually error array) ``${json_path} `` contains the specified property name ``${expected_property}`` with the specified value ``${expected_value}``.
    ...
    ...    This keyword can be used in negative tests where you expect more than one error to be returned by the request. But it can also be used for checking that property-value combination exists in an array element of the array.
    ...
    ...    *Example:*
    ...
    ...    ``Array in response should contain property with value:    [errors]    detail    iso2Code => This field is missing.``
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        Log    list: ${list_element}
        ${value}=    Get Value From Json    ${list_element}    ${expected_property}
        ${value}=    Convert To String    ${value}
        ${value}=    Replace String    ${value}    '   ${EMPTY}
        ${value}=    Replace String    ${value}    [   ${EMPTY}
        ${value}=    Replace String    ${value}    ]   ${EMPTY}
        ${result}=    Evaluate    '${value}' == '${expected_value}'
        IF    ${result}    Exit For Loop
    END
    Should Be Equal As Strings    ${result}    True    Value ${expected_value} was not found in the array

Cleanup existing customer addresses:
    [Documentation]    This keyword deletes any and all addresses customer with the specified customer reference has.
    ...
    ...    Before using this method you should get customer token and set it into the headers with the help of ``I get access token for the customer:`` and ``I set Headers:``
    ...
    ...    *Example:*
    ...
    ...    ``Cleanup existing customer addresses:    ${yves_user.reference}``
    [Arguments]    ${customer_reference}
    ${response}=    GET    ${current_url}/customers/${customer_reference}/addresses    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=200
    ${response_body}=    Set Variable    ${response.json()}
    Set Variable    ${response_body}    ${response_body}
    Set Variable    ${response}    ${response}
    Should Be Equal As Strings    ${response.status_code}    200    Could not get customer addresses
    @{data}=    Get Value From Json    ${response_body}    [data]
    ${list_length}=    Get Length    @{data}
    ${list_length}=    Convert To Integer    ${list_length}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        Log    list: ${list_element}
        ${address_uid}=    Get Value From Json    ${list_element}    [id]
        ${address_uid}=    Convert To String    ${address_uid}
        ${address_uid}=    Replace String    ${address_uid}    '   ${EMPTY}
        ${address_uid}=    Replace String    ${address_uid}    [   ${EMPTY}
        ${address_uid}=    Replace String    ${address_uid}    ]   ${EMPTY}
        ${response_delete}=    DELETE    ${current_url}/customers/${customer_reference}/addresses/${address_uid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204
        Set Variable    ${response_delete}    ${response_delete}
        Should Be Equal As Strings    ${response_delete.status_code}    204    Could not delete a customer address
    END

Find or create customer cart
    [Documentation]    This keyword creates or retrieves cart for the current customer token. This keyword sets ``${cart_id} `` variable
        ...                and it can be re-used by the keywords that follow this keyword in the test
        ...
        ...     This keyword does not accept any arguments. Makes GET request in order to fetch cart for the customer or creates it otherwise.
        ...
        ${response}=    I send a GET request:    /carts
        Save value to a variable:    [data][0][id]    cart_id
        ${hasCart}    Run Keyword and return status     Should not be empty    ${cart_id}
        Log    cart_id:${cart_id}
        IF    not ${hasCart}    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}"}}}
        IF    not ${hasCart}    Save value to a variable:    [data][id]    cart_id


Get ETag header value from cart
    [Documentation]    This keyword first retrieves cart for the current customer token.
        ...   and then It gets the Etag header value and saves it into the test variable ``${Etag}``, which can then be used within the scope of the test where this keyword was called.
        ...
        ...    and it can be re-used by the keywords that follow this keyword in the test
        ...    This keyword does not accept any arguments. This keyword is used for removing unused/unwanted (ex. W/"") characters from ETag header value.


        ${response}=    I send a GET request:    /carts
        ${Etag}=    Get Value From Json   ${response_headers}    [ETag]
        ${Etag}=    Convert To String    ${Etag}
        ${Etag}=    Replace String    ${Etag}    '   ${EMPTY}
        ${Etag}=    Replace String    ${Etag}    [   ${EMPTY}
        ${Etag}=    Replace String    ${Etag}    ]   ${EMPTY}
        ${Etag}=    Replace String    ${Etag}    W   ${EMPTY}
        ${Etag}=    Replace String    ${Etag}    /   ${EMPTY}
        ${Etag}=    Replace String    ${Etag}    "   ${EMPTY}
        Log    ${Etag}
        Set Test Variable    ${Etag}
        [Return]    ${Etag}

Create giftcode in Database:
    [Documentation]    This keyword creates a new entry in the table spy_gift_card with the name, value and gift-card code.
     [Arguments]    ${spy_gift_card_code}    ${spy_gift_card_value}
    ${amount}=   Evaluate    ${spy_gift_card_value} / 100
    ${amount}=    Evaluate    "%.f" % ${amount}
    Connect To Database    pymysql    ${default_db_name}    ${default_db_user}    ${default_db_password}    ${default_db_host}    ${default_db_port}
    Execute Sql String    insert ignore into spy_gift_card (code,name,currency_iso_code,value) value ('${spy_gift_card_code}','Gift_card_${amount}','EUR','${spy_gift_card_value}')
    Disconnect From Database


Create a guest cart:
    [Documentation]    This keyword creates guest cart and sets ``${x_anonymous_customer_unique_id}`` that specify guest reference
        ...             and ``${guest_cart_id}`` that specify guest cart, variables
        ...             can be re-used by the keywords that follow this keyword in the test
        ...
        ...     This keyword does not accept any arguments. Makes POST request in order to create cart for the guest.
        ...    *Example:*
        ...
        ...    ``Create guest cart: ${random}    ${concrete_product_with_concrete_product_alternative_sku}    1``
        [Arguments]    ${x_anonymous_customer_unique_id}    ${product_sku}    ${product_quantity}
        Set Test Variable    ${x_anonymous_customer_unique_id}    ${x_anonymous_customer_unique_id}
        I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}    Content-Type=${default_header_content_type}
        ${response}=    I send a POST request:    /guest-cart-items    {"data": {"type": "guest-cart-items","attributes": {"sku": "${product_sku}","quantity": ${product_quantity}}}}
        Save value to a variable:    [data][id]    guest_cart_id
        Log    x_anonymous_customer_unique_id:${x_anonymous_customer_unique_id} guest_cart_id:${guest_cart_id}

Cleanup all items in the cart:
    [Documentation]    This keyword deletes any and all items in the given cart uid.
        ...
        ...    Before using this method you should get customer token and set it into the headers with the help of ``I get access token for the customer:`` and ``I set Headers:``
        ...
        ...    *Example:*
        ...
        ...    ``Cleanup items in the cart:    ${cart_id}``
        [Arguments]    ${cart_id}
        ${response}=    GET    ${current_url}/carts/${cart_id}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}  params=include=items,bundle-items     expected_status=200
        ${response_body}=    Set Variable    ${response.json()}
        @{included}=    Get Value From Json    ${response_body}    [included]
        ${list_length}=    Evaluate    len(@{included})
        Log    list_length: ${list_length}
        FOR    ${index}    IN RANGE    0    ${list_length}
                ${list_element}=    Get From List    @{included}    ${index}
                ${cart_item_uid}=    Get Value From Json    ${list_element}    [id]
                ${cart_item_uid}=    Convert To String    ${cart_item_uid}
                ${cart_item_uid}=    Replace String    ${cart_item_uid}    '   ${EMPTY}
                ${cart_item_uid}=    Replace String    ${cart_item_uid}    [   ${EMPTY}
                ${cart_item_uid}=    Replace String    ${cart_item_uid}    ]   ${EMPTY}
                ${response_delete}=    DELETE    ${current_url}/carts/${cart_id}/items/${cart_item_uid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204
        END

Cleanup all items in the guest cart:
    [Documentation]    This keyword deletes any and all items in the given GUEST cart uid.
        ...
        ...    Before using this method you should set any value as X-Anonymous-Customer-Unique-Id into the headers with the help of ``I set Headers:``
        ...
        ...    *Example:*
        ...
        ...    ``Cleanup all items in the guest cart:    ${cart_id}``
        [Arguments]    ${cart_id}
        ${response}=    GET    ${current_url}/guest-carts/${cart_id}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}  params=include=guest-cart-items,bundle-items    expected_status=200
        ${response_body}=    Set Variable    ${response.json()}
        @{included}=    Get Value From Json    ${response_body}    [included]
        ${list_length}=    Get length    @{included}
        Log    list_length: ${list_length}
        FOR    ${index}    IN RANGE    0    ${list_length}
                ${list_element}=    Get From List    @{included}    ${index}
                ${cart_item_uid}=    Get Value From Json    ${list_element}    [id]
                ${cart_item_uid}=    Convert To String    ${cart_item_uid}
                ${cart_item_uid}=    Replace String    ${cart_item_uid}    '   ${EMPTY}
                ${cart_item_uid}=    Replace String    ${cart_item_uid}    [   ${EMPTY}
                ${cart_item_uid}=    Replace String    ${cart_item_uid}    ]   ${EMPTY}
                ${response_delete}=    DELETE    ${current_url}/guest-carts/${cart_id}/guest-cart-items/${cart_item_uid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204
        END

Cleanup all availability notifications:
    [Documentation]    This keyword deletes any and all availability notifications related to the given customer reference.
        ...
        ...    Before using this method you should get customer token and set it into the headers with the help of ``I get access token for the customer:`` and ``I set Headers:``
        ...
        ...    *Example:*
        ...
        ...    ``Cleanup all availability notifications in the guest cart:    ${yves_user.reference}``
        [Arguments]    ${yves_user.reference}
        ${response}=    GET    ${current_url}/customers/${yves_user.reference}/availability-notifications    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}   expected_status=200
        ${response_body}=    Set Variable    ${response.json()}
        @{data}=    Get Value From Json    ${response_body}    [data]
        ${list_length}=    Get Length    @{data}
        ${list_length}=    Convert To Integer    ${list_length}
        ${log_list}=    Log List    @{data}
        Log    list_length: ${list_length}
        FOR    ${index}    IN RANGE    0    ${list_length}
                ${list_element}=    Get From List    @{data}    ${index}
                ${availability_notification_id}=    Get Value From Json    ${list_element}    [id]
                ${availability_notification_id}=    Convert To String    ${availability_notification_id}
                ${availability_notification_id}=    Replace String    ${availability_notification_id}    '   ${EMPTY}
                ${availability_notification_id}=    Replace String    ${availability_notification_id}    [   ${EMPTY}
                ${availability_notification_id}=    Replace String    ${availability_notification_id}    ]   ${EMPTY}
                Log    availability_notification_id: ${availability_notification_id}
                ${response_delete}=    DELETE    ${current_url}/availability-notifications/${availability_notification_id}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204
        END
Update order status in Database:
    [Documentation]    This keyword updates order status in database to any required status. This allows to skip going through the order workflow manually 
    ...    but just switch to the status you need to create a test. 
    ...    There is no separate endpoint to update order status and this keyword allows to do this via database value update.
    ...    *Example:*
    ...    
    ...    ``Update order status in Database:    7    shipped``
    
    [Arguments]    ${order_item_status_name}
    Connect To Database    pymysql    ${default_db_name}    ${default_db_user}    ${default_db_password}    ${default_db_host}    ${default_db_port}
    Execute Sql String    insert ignore into spy_oms_order_item_state (name) values ('${order_item_status_name}')
    Disconnect From Database
    Save the result of a SELECT DB query to a variable:    select id_oms_order_item_state from spy_oms_order_item_state where name like '${order_item_status_name}'    state_id
    Connect To Database    pymysql    ${default_db_name}    ${default_db_user}    ${default_db_password}    ${default_db_host}    ${default_db_port}
    Execute Sql String    update spy_sales_order_item set fk_oms_order_item_state = '${state_id}' where uuid = '${Uuid}'
    Disconnect From Database

Create giftcode in Database:
    [Documentation]    This keyword creates a new entry in the table spy_gift_card with the name, value and gift-card code.
     [Arguments]    ${spy_gift_card_code}    ${spy_gift_card_value}
    ${amount}=   Evaluate    ${spy_gift_card_value} / 100
    ${amount}=    Evaluate    "%.f" % ${amount}
    Connect To Database    pymysql    ${default_db_name}    ${default_db_user}    ${default_db_password}    ${default_db_host}    ${default_db_port}
    Execute Sql String    insert ignore into spy_gift_card (code,name,currency_iso_code,value) value ('${spy_gift_card_code}','Gift_card_${amount}','EUR','${spy_gift_card_value}')
    Disconnect From Database

Get voucher code by discountId from Database:
    [Documentation]    This keyword allows to get voucher code according to the discount ID. Discount_id can be found in Backoffice > Merchandising > Discount page
    ...        and set this id as an argument of a keyword.
    ...
    ...    *Example:*
    ...    ``Get voucher code by discountId from Database:    3``

    [Arguments]    ${discount_id}
    Save the result of a SELECT DB query to a variable:    select fk_discount_voucher_pool from spy_discount where id_discount = ${discount_id}    discount_voucher_pool_id
    Save the result of a SELECT DB query to a variable:    select code from spy_discount_voucher where fk_discount_voucher_pool = ${discount_voucher_pool_id} and is_active = 1 limit 1    discount_voucher_code
Create giftcode in Database:
    [Documentation]    This keyword creates a new entry in the table spy_gift_card with the name, value and gift-card code.
     [Arguments]    ${spy_gift_card_code}    ${spy_gift_card_value}
    ${amount}=   Evaluate    ${spy_gift_card_value} / 100
    ${amount}=    Evaluate    "%.f" % ${amount}
    Connect To Database    pymysql    ${default_db_name}    ${default_db_user}    ${default_db_password}    ${default_db_host}    ${default_db_port}
    Execute Sql String    insert ignore into spy_gift_card (code,name,currency_iso_code,value) value ('${spy_gift_card_code}','Gift_card_${amount}','EUR','${spy_gift_card_value}')
    Disconnect From Database