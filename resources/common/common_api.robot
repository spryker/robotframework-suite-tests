*** Settings ***
Library    RequestsLibrary
Library    String
Library    Dialogs
Library    OperatingSystem
Library    Collections
Library    BuiltIn
Library    DateTime
Library    JSONLibrary
Library    ../../resources/libraries/common.py

*** Variables ***
# *** SUITE VARIABLES ***
${current_url}                 http://glue.de.spryker.local
${glue_url}                    http://glue.de.spryker.local
${bapi_url}                    http://backend-api.de.spryker.local
${api_timeout}                 60
${default_password}            change123
${default_allow_redirects}     true
${default_auth}                ${NONE}

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
    Run Keyword if    '${tag}'=='bapi'    Set Suite Variable    ${current_url}    ${bapi_url}    
    Run Keyword if    '${tag}'=='glue'    Set Suite Variable    ${current_url}    ${glue_url}   
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
    ...    ``I get access token for the customer:    ${yves_user_email}``
    [Arguments]    ${email}    ${password}=${default_password}
    ${data}=    Evaluate    {"data":{"type":"access-tokens","attributes":{"username":"${email}","password":"${password}"}}}
    ${response}=    POST    ${current_url}/access-tokens    json=${data}
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
    ...    ``I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent_email}","password": "${agent_password}"}}}``
    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${json}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    POST    ${current_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    POST    ${current_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=ANY
    ${response_body}=    Set Variable    ${response.json()}
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
    ...    ``I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent_email}","password": "${agent_password}"}}}``
    [Arguments]   ${path}    ${data}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${data}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    POST    ${current_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    POST    ${current_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    Set Variable    ${response.json()}
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
    ${response}=    Run Keyword if    ${hasValue}    PUT    ${current_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    PUT    ${current_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    Set Variable    ${response.json()}
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
    ${response}=    Run Keyword if    ${hasValue}    PUT    ${current_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    PUT    ${current_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    Set Variable    ${response.json()}
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
    ${response}=    Run Keyword if    ${hasValue}    PATCH   ${current_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    PATCH    ${current_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    Set Variable    ${response.json()}
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
    ${response}=    Run Keyword if    ${hasValue}    PATCH    ${current_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    PATCH    ${current_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    Set Variable    ${response.json()}
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
    ${response}=    Run Keyword if    ${hasValue}    GET    ${current_url}${path}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    GET    ${current_url}${path}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    Set Variable    ${response.json()}
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
    ${response}=    Run Keyword if    ${hasValue}    DELETE    ${current_url}${path}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    DELETE    ${current_url}${path}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response}    ${response}
    ${response_body}=    Run Keyword if    ${response.status_code} != 204    Set Variable    ${response.json()}
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
    Should Not Be Equal    ${data}    ${expected_value}

Response body parameter should have datatype:
    [Documentation]    This keyword checks that the response saved  in ``${response_body}`` test variable contsains the speficied parameter ``${parameter}`` and that parameter has the specified data type ``${expected_data_type}``.
    ...
    ...    Some types that can be used are: ``int``, ``str``. It uses a custom keyword ``Evaluate datatype of a variable:`` to evaluate the datatype.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should have datatype:    [data][0][attributes][name]    str``
    [Arguments]    ${parameter}    ${expected_data_type}
    ${actual_data_type}=    Evaluate datatype of a variable:    ${parameter}
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
    ...    *Example:*
    ...
    ...    ``Response body parameter should not be EMPTY:    [data][attributes][description]``
    [Arguments]    ${json_path}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Should Not Be Equal    ${data}    None    ${data} is not empty but shoud be

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
    Should Be Equal    ${result}    True    Actula ${data} is not less than expected ${expected_value}

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
    ...   ``Each array element of array in response should contain value:    [data][0][attributes][prices]    ${currency_code_eur}``
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
        Run Keyword if    ${result}    Exit For Loop     
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
        ${link_found}=    Run Keyword if    ${result}    Get Value From Json    ${include_element}    [links][self]
        Run Keyword if    ${link_found}    Should Not Be Equal    ${link_found}    None    ${link_found} is  empty for ${expected_value} include section
        Run Keyword if    ${result}    Exit For Loop     
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
        Run Keyword if    ${result}    Exit For Loop    
    END
    Should Be Equal As Strings    ${result}    True    Value ${expected_value} was not found in the array

Cleanup existing customer addresses:
    [Documentation]    This keyword deletes any and all addresses customer with the specified customer reference has.
    ...    
    ...    Before using this method you should get customer token and set it into the headers with the help of ``I get access token for the customer:`` and ``I set Headers:``
    ...
    ...    *Example:*
    ...
    ...    ``Cleanup existing customer addresses:    ${yves_user_reference}``
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
