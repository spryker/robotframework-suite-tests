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
${verify_ssl}                 false
${default_password}            change123
${default_allow_redirects}     true
${default_auth}                ${NONE}
# *** DB VARIABLES ***
${default_db_host}         127.0.0.1
${default_db_name}         eu-docker
${default_db_password}     secret
${default_db_port}         3306
${default_db_port_postgres}    5432
${default_db_user}         spryker
${default_db_engine}       pymysql
${db_engine}
${glue_env}
${bapi_env}
${db_port}
# ${default_db_engine}       psycopg2

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
    ${verify_ssl}=    Convert To String    ${verify_ssl}
    ${verify_ssl}=    Convert To Lower Case    ${verify_ssl}
    IF    '${verify_ssl}' == 'true'
        Set Global Variable    ${verify_ssl}    ${True}
    ELSE
        Set Global Variable    ${verify_ssl}    ${False}
    END
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
    IF    '${glue_env}' == '${EMPTY}'
        IF    '${tag}'=='glue'  
            Set Suite Variable    ${current_url}    ${glue_url}
            Set Suite Variable    ${tag}    glue
        END
    ELSE
        IF    '${tag}'=='glue'   
            Set Suite Variable    ${current_url}    ${glue_env}
            Set Suite Variable    ${tag}    glue
        END
    END
    IF    '${bapi_env}' == '${EMPTY}'
        IF    '${tag}'=='bapi'  
            Set Suite Variable    ${current_url}    ${bapi_url}
            Set Suite Variable    ${tag}    bapi
        END
    ELSE
        IF    '${tag}'=='bapi'  
            Set Suite Variable    ${current_url}    ${bapi_env}
            Set Suite Variable    ${tag}    bapi
        END
    END
    END
    ${current_url_last_character}=    Get Regexp Matches    ${current_url}    .$    flags=IGNORECASE
    ${current_url_last_character}=    Convert To String    ${current_url_last_character}
    ${current_url_last_character}=    Replace String    ${current_url_last_character}    '   ${EMPTY}
    ${current_url_last_character}=    Replace String    ${current_url_last_character}    [   ${EMPTY}
    ${current_url_last_character}=    Replace String    ${current_url_last_character}    ]   ${EMPTY}
    IF    '${current_url_last_character}' == '/'
        ${current_url}=    Replace String Using Regexp    ${current_url}    .$    ${EMPTY}
        Set Suite Variable    ${current_url}
    END

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
        ${var_value}=   Get Variable Value  ${${key}}   ${value}
        Set Global Variable    ${${key}}    ${var_value}
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
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${data}=    Evaluate    {"data":{"type":"access-tokens","attributes":{"username":"${email}","password":"${password}"}}}
    ${response}=    IF    ${headers_not_empty}       run keyword    POST    ${current_url}/access-tokens    json=${data}    headers=${headers}    verify=${verify_ssl}
    ...    ELSE    POST    ${current_url}/access-tokens    json=${data}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204    
        TRY    
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${token}=    Set Variable    Bearer ${response.json()['data']['attributes']['accessToken']}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${token}    ${token}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${expected_self_link}    ${current_url}/access-tokens
    Log    ${token}
    [Return]    ${token}

I add 'admin' role to company user and get company_user_uuid:
    [Documentation]    This is a helper keyword which sets the 'Admin' role to the company user if it is not already set and returns the uuid of this company user. Requires: company user email, company key and business unit key
    ...    *Example:*
    ...
    ...    ``Add 'admin' role to company user and return company_user_uuid:    anne.boleyn@spryker.com    BoB-Hotel-Jim    business-unit-jim-1``
    [Arguments]    ${email}    ${company_key}    ${business_unit_key}
    Connect to Spryker DB
    ${id_customer}=    Query    select id_customer from spy_customer WHERE email='${email}'
    ${id_customer}=    Evaluate    ${id_customer[0][0]}+0
    IF    '${db_engine}' == 'pymysql'
        ${id_business_unit}=    Query    select id_company_business_unit from spy_company_business_unit where `key`='${business_unit_key}'
    ELSE
        ${id_business_unit}=    Query    select id_company_business_unit from spy_company_business_unit where "key"='${business_unit_key}'
    END
    ${id_business_unit}=    Evaluate    ${id_business_unit[0][0]}+0
    IF    '${db_engine}' == 'pymysql'
        ${id_company}=    Query    select id_company from spy_company WHERE `key`='${company_key}'
    ELSE
        ${id_company}=    Query    select id_company from spy_company WHERE "key"='${company_key}'
    END
    ${id_company}=    Evaluate    ${id_company[0][0]}+0
    ${id_company_user}=    Query    select id_company_user from spy_company_user WHERE fk_customer=${id_customer} and fk_company_business_unit=${id_business_unit} and fk_company=${id_company}
    ${id_company_user}=    Evaluate    ${id_company_user[0][0]}+0
    ${id_company_role_admin}=    Query    select id_company_role from spy_company_role WHERE name='Admin' and fk_company='${id_company}'
    ${id_company_role_admin}=    Evaluate    ${id_company_role_admin[0][0]}+0
    ${is_role_set}=    Query    SELECT id_company_role_to_company_user FROM spy_company_role_to_company_user WHERE fk_company_role = ${id_company_role_admin} and fk_company_user = ${id_company_user}
    ${is_role_set_length}=    Get Length    ${is_role_set}
    IF    ${is_role_set_length} == 0
        ${last_id}=    Query    SELECT id_company_role_to_company_user FROM spy_company_role_to_company_user ORDER BY id_company_role_to_company_user DESC LIMIT 1;
        ${new_id}=    Evaluate    ${last_id[0][0]}+1
        Execute Sql String    INSERT INTO spy_company_role_to_company_user (id_company_role_to_company_user, fk_company_role, fk_company_user) VALUES (${new_id}, ${id_company_role_admin}, ${id_company_user});
    END
    ${company_user_uuid}=    Query    select uuid from spy_company_user where id_company_user=${id_company_user}
    ${company_user_uuid}=    Convert To String    ${company_user_uuid}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    '   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    ,   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    (   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    )   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    [   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    ]   ${EMPTY}
    Set Test Variable    ${company_user_uuid}    ${company_user_uuid}
    [Return]    ${company_user_uuid}

I get access token for the company user by uuid:
    [Documentation]    This is a helper keyword which helps get company user access token by uuid for future use in the headers of the following requests.
    ...
    ...    It gets the token for the specified company user by ``${company_user_uuid}`` and saves it into the test variable ``${token}``, which can then be used within the scope of the test where this keyword was called.
    ...    After the test ends the ``${token}`` variable is cleared. This keyword needs to be called separately for each test where you expect to need a company user token.
    ...
    ...    *Example:*
    ...
    ...    ``I get access token for the company user by uuid:    ${company_user_uuid}``
    [Arguments]    ${company_user_uuid}
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${data}=    Evaluate    {"data":{"type":"company-user-access-tokens","attributes":{"idCompanyUser":"${company_user_uuid}"}}}
    ${response}=    IF    ${headers_not_empty}       run keyword    POST    ${current_url}/company-user-access-tokens    json=${data}    headers=${headers}    verify=${verify_ssl}
    ...    ELSE    POST    ${current_url}/company-user-access-tokens    json=${data}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204    
        TRY    
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${token}=    Set Variable    Bearer ${response.json()['data']['attributes']['accessToken']}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${token}    ${token}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${expected_self_link}    ${current_url}/company-user-access-tokens
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
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}   run keyword    POST    ${current_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    POST    ${current_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=ANY    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204    
        TRY    
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204    
        ${response_body}=    Set Variable    ${EMPTY}
    END
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
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}   run keyword    POST    ${current_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    POST    ${current_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204    
        TRY    
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204    
        ${response_body}=    Set Variable    ${EMPTY}
    END
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
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}   run keyword    PUT    ${current_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    PUT    ${current_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204    
        TRY    
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204    
        ${response_body}=    Set Variable    ${EMPTY}
    END
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
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}   run keyword    PUT    ${current_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    PUT    ${current_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204    
        TRY    
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204    
        ${response_body}=    Set Variable    ${EMPTY}
    END
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
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}   run keyword    PATCH   ${current_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    PATCH    ${current_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204    
        TRY    
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204    
        ${response_body}=    Set Variable    ${EMPTY}
    END
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
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}   run keyword    PATCH    ${current_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    PATCH    ${current_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204    
        TRY    
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204    
        ${response_body}=    Set Variable    ${EMPTY}
    END
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
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}   run keyword    GET    ${current_url}${path}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    GET    ${current_url}${path}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204    
        TRY    
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204    
        ${response_body}=    Set Variable    ${EMPTY}
    END
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
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}   run keyword    DELETE    ${current_url}${path}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    DELETE    ${current_url}${path}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response_headers}=    Set Variable    ${response.headers}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204    
        TRY    
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    IF    ${response.status_code} == 204    
        ${response_body}=    Set Variable    ${EMPTY}
    END
    Set Test Variable    ${response}    ${response}
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
    Should Be Equal As Strings    ${reason}    ${response.reason}    Expected 'reason': '${reason}' does not equal actual 'reason': '${response.reason}'

Response status code should be:
    [Documentation]    This keyword checks that response status code saved  in ``${response}`` test variable matches the status code passed as an argument.
    ...
    ...    *Example:*
    ...
    ...    ``Response status code should be:    201``
    [Arguments]    ${status_code}
    Should Be Equal As Strings    ${response.status_code}    ${status_code}    Expected 'status code': '${status_code}' does not equal actual 'status code': '${response.status_code}'.

Response body should contain:
    [Documentation]    This keyword checks that the response saved  in ``${response_body}`` test variable contsains the string passed as an argument.
    ...
    ...    *Example:*
    ...
    ...    ``Response body should contain:    "localizedName": "Weight"``
    [Arguments]    ${value}
    ${response_body}=    Convert To String    ${response_body}
    ${response_body}=    Replace String    ${response_body}    '    "
    Should Contain    ${response_body}    ${value}    Response body does not contain expected: '${value}'.

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
    Should Be Equal    ${data}    ${expected_value}    Response data in: '${json_path}', does not equal expected: '${expected_value}', actual is: '${data}'.

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
    [Arguments]    ${json_path}    ${expected_value1}    ${expected_value2}    ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value    ${expected_value5}=robotframework-dummy-value    ${expected_value6}=robotframework-dummy-value    ${expected_value7}=robotframework-dummy-value    ${expected_value8}=robotframework-dummy-value    ${expected_value9}=robotframework-dummy-value
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    TRY    
        Should Contain Any   ${data}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ${expected_value5}    ${expected_value6}    ${expected_value7}    ${expected_value8}    ${expected_value9}      ignore_case=True
    EXCEPT
        Fail    Response data in: '${json_path}', does not contains any: '${expected_value1}', '${expected_value2}', '${expected_value3}', '${expected_value4}', '${expected_value5}', '${expected_value6}', '${expected_value7}', '${expected_value8}', '${expected_value9}', in '${data}'.
    END

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
    Should Be Equal    ${result}    True    Actual ${data} is not in expected Range [${range_value_min}; ${range_value_max}], json_path: '${json_path}'

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
    TRY    
        Should NOT Contain Any   ${data}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
    EXCEPT
        Fail    Response data in: '${json_path}', should not contain any: ${expected_value1}, ${expected_value2}, ${expected_value3}, ${expected_value4} in '${data}'.
    END

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
    Should Not Be Empty    ${data}    '${data}' in '${json_path}' is empty but should not be.
    Should Not Be Equal    ${data}    ${expected_value}    '${data}' in '${json_path}' should be equal to '${expected_value}'.

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
    Should Be Equal    ${actual_data_type}    ${expected_data_type}    Parameter: '${parameter}' should be '${expected_data_type}' but got: '${actual_data_type}'.

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
    Should Be Equal    ${actual_header_value}    ${header_value}    Header parameter: '${header_parameter}' should have value: '${header_value}' but got: '${actual_header_value}'.

Response header parameter should contain:
    [Documentation]    This keyword checks that the response header saved previiously in ``${response_headers}`` test variable has the expected header with name ``${header_parameter}`` and this header contains substring ``${header_value}``
    ...
    ...    *Example:*
    ...
    ...    ``Response header parameter should be:    Content-Type    ${default_header_content_type}``
    [Arguments]    ${header_parameter}    ${header_value}
    ${actual_header_value}=    Get From Dictionary    ${response_headers}    ${header_parameter}
    Should Contain    ${actual_header_value}    ${header_value}    Header parameter: '${header_parameter}' should contain value: '${header_value}' but got: '${actual_header_value}'.

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
    Should Be Equal    ${actual_self_link}    ${expected_self_link}    Expected self link: '${expected_self_link}' does not match: '${actual_self_link}'.

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
    Should Be Equal    ${actual_self_link}    ${expected_self_link}    Expected internal selft link: '${expected_self_link}' does not match the actual link: '${actual_self_link}'.

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
    Should Be Equal    ${actual_self_link}    ${expected_self_link}/${url}    Expected self link for created entity: '${expected_self_link}/${url}' does not match actual self link for created entity: '${actual_self_link}'.

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
    Should Not Be Empty    ${data}    '${json_path}' property value '${data}' is empty but shoud not be
    Should Not Be Equal    ${data}    None    '${json_path}' property value is '${data}' which is null, but it shoud be a non-null.

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
    ${result}=    Evaluate    float('${data}') > float('${expected_value}')
    ${result}=    Convert To String    ${result}
    Should Be Equal    ${result}    True    Actual '${data}' is not greater than expected '${expected_value}' in '${json_path}'.

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
    Should Be Equal    ${result}    True    Actual '${data}' is not less than expected '${expected_value}' in '${json_path}'.

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
    Should Be Equal    ${list_length}    ${expected_size}    actual size '${list_length}' doesn't equal expected '${expected_size}' in '${json_path}'.

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
    Should Be Equal    ${result}    True    Actual array length is '${list_length}' and it is not greater than expected '${expected_size}' in '${json_path}'.

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
    Should Be Equal    ${result}    True    Actual array length is '${list_length}' and it is not smaller than expected '${expected_size}' in '${json_path}'.

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
        List Should Contain Value    ${list_element}    ${expected_property}    msg=Array element '${list_element}' of array '${json_path}' does not contain property: '${expected_property}'.
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
        Should Contain    : ${sub_list_element}    ${expected_value}    msg=Array element:'${sub_list_element}' of array:'${json_path}' does not contain:'${expected_value}'.
    END

Each array element of array in response should contain a nested array of a certain size:
        [Documentation]    This keyword checks whether the array ``${paret_array}`` that is present in the ``${response_body}`` test variable contsains an array ``${nested_array}`` in every of it's array elements and for every its occurrence that nested array has sixe ``${array_expected_size}``.
    ...
    ...    If the nested arrays are of different sizes, this keyword will fail.
    ...
    ...    *Example:*
    ...
    ...   ``Each array element of array in response should contain a nested array of a certain size:    [data]    [prices]    2``

    [Arguments]    ${parent_array}    ${nested_array}    ${array_expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${parent_array}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        @{list_element2}=    Get Value From Json    ${list_element}    ${nested_array}
        ${list_length2}=    Get Length    @{list_element2}
        ${list_length2}=    Convert To String    ${list_length2}
        Should Be Equal    ${list_length2}    ${array_expected_size}    Actual nested array size:'${list_length2}' in '${nested_array}' does not match '${array_expected_size}'.
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
        Dictionary Should Contain Item    ${list_element}    ${expected_property}    ${expected_value}    msg='${json_path}' does not contain property: '${expected_property}' with value: '${expected_value}'.
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
        TRY
            Should Contain Any   ${list_element}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
        EXCEPT
            Fail    Array element: '${expected_property}' of array: '${json_path}' does not contain any: ${expected_value1}, ${expected_value2}, ${expected_value3}, ${expected_value4}
        END
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
        TRY
            Should Not Contain Any   ${list_element}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
        EXCEPT
            Fail    Array element: '${expected_property}' of array: '${json_path}' contain any but SHOULD NOT: ${expected_value1}, ${expected_value2}, ${expected_value3}, ${expected_value4}
        END
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
            TRY
                Should Contain Any   ${list_element}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
            EXCEPT
                Fail    Nested array:'${nested_array}' of array:'${json_path}' does NOT contain property:'${expected_property}' with value in: ${expected_value1}, ${expected_value2}, ${expected_value3}, ${expected_value4}
            END
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
            TRY
                Should Not Contain Any   ${list_element}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
            EXCEPT
                Fail    Nested array:'${nested_array}' of array:'${json_path}' contain property:'${expected_property}' with value in: '${expected_value1}', '${expected_value2}', '${expected_value3}', '${expected_value4}', BUT SHOULD NOT!
            END
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
    IF    '${tag}'=='bapi'   
        ${data}=    Get Value From Json    ${response_body}    [errors][0][message]
    ELSE
        ${data}=    Get Value From Json    ${response_body}    [errors][0][detail]
    END
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Be Equal    ${data}    ${error_message}    Actual '${data}' error reason doens't match expected '${error_message}'

Response should return error code:
    [Documentation]    This keyword checks if the ``${response_body}`` test variable that contains the response of the previous request contains the specific  ``${error_code}``.
    ...
    ...    Call only for negative tests where you expect an error. NOTE: it checks only the first error code in the array, if there are more than one error, better use this keyword: ``Array in response should contain property with value``.
    ...
    ...    *Example:*
    ...
    ...    ``Response should return error code:    204``
    [Arguments]    ${error_code}
    ${error_code}=    Convert To String    ${error_code}
    ${data}=    Get Value From Json    ${response_body}    [errors][0][code]
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Be Equal    ${data}    ${error_code}    Actual '${data}' response error code doesn't match expected '${error_code}'

Response should contain certain number of values:
    [Documentation]    This keyword checks if a certain response parameter ``${json_path} `` in the ``${response_body}`` test variable has the specified number ``${expected_count}`` of the specified values ``${expected_value}`` in it.
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
    Should Be Equal    ${count}    ${expected_count}    Actual count '${count}' of '${expected_value}' in '${json_path}' does not match '${expected_count}'

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
    Should Be Equal As Strings    ${result}    True    Include section '${expected_value}' was not found

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
    Should Be Equal As Strings    ${result}    True    Include section '${expected_value}' was not found

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
    Should Contain   ${data}    ${expected_value}    Body parameter:'${json_path}' does not contain '${expected_value}'

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
    Should Start With   ${data}    ${expected_value}    msg=Body parameter:'${json_path}' does not start with:'${expected_value}'

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
    Should Be Equal As Strings    ${result}    True    Property:'${expected_property}' with value '${expected_value}' was not found in the array:'${json_path}'

Cleanup existing customer addresses:
    [Documentation]    This keyword deletes any and all addresses customer with the specified customer reference has.
    ...
    ...    Before using this method you should get customer token and set it into the headers with the help of ``I get access token for the customer:`` and ``I set Headers:``
    ...
    ...    *Example:*
    ...
    ...    ``Cleanup existing customer addresses:    ${yves_user.reference}``
    [Arguments]    ${customer_reference}
    ${response}=    GET    ${current_url}/customers/${customer_reference}/addresses    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=200    verify=${verify_ssl}
    IF    ${response.status_code} != 204    
        TRY    
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    IF    ${response.status_code} == 204    
        ${response_body}=    Set Variable    ${EMPTY}
    END
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
        ${response_delete}=    DELETE    ${current_url}/customers/${customer_reference}/addresses/${address_uid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response_delete.status_code}
        IF    ${response.status_code} != 204    
            TRY    
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        Set Variable    ${response_delete}    ${response_delete}
        Should Be Equal As Strings    ${response_delete.status_code}    204    Could not delete a customer address
    END

Find or create customer cart
    [Documentation]    This keyword creates or retrieves cart (in gross price mode and with eur currency) for the current customer token. This keyword sets ``${cart_id} `` variable
        ...                and it can be re-used by the keywords that follow this keyword in the test
        ...
        ...     This keyword does not accept any arguments. Makes GET request in order to fetch cart for the customer or creates it otherwise.
        ...
        ${response}=    GET    ${current_url}/carts    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=200    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response.status_code}
        IF    ${response.status_code} != 204    
            TRY    
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        IF    ${response.status_code} == 204    
            ${response_body}=    Set Variable    ${EMPTY}
        END
        ${response_headers}=    Set Variable    ${response.headers}
        Set Test Variable    ${response_headers}    ${response_headers}
        @{data}=    Get Value From Json    ${response_body}    [data]
        ${cart_id}=    Get Value From Json    ${response_body}    [data][0][id]
        ${hasCart}    Run Keyword and return status     Should not be empty    ${cart_id}
        IF    ${hasCart}
            ${carts_number}=    Get Length    @{data}
            FOR    ${index}    IN RANGE    0    ${carts_number}
                    ${cart}=    Get From List    @{data}    ${index}
                    ${cart_id}=    Get Value From Json    ${cart}    [id]
                    ${cart_id}=    Convert To String    ${cart_id}
                    ${cart_id}=    Replace String    ${cart_id}    '   ${EMPTY}
                    ${cart_id}=    Replace String    ${cart_id}    [   ${EMPTY}
                    ${cart_id}=    Replace String    ${cart_id}    ]   ${EMPTY}
                    ${cart_mode}=    Get Value From Json    ${cart}    [attributes][priceMode]
                    ${cart_mode}=    Convert To String    ${cart_mode}
                    ${cart_mode}=    Replace String    ${cart_mode}    '   ${EMPTY}
                    ${cart_mode}=    Replace String    ${cart_mode}    [   ${EMPTY}
                    ${cart_mode}=    Replace String    ${cart_mode}    ]   ${EMPTY}
                    ${cart_currency}=    Get Value From Json    ${cart}    [attributes][currency]
                    ${cart_currency}=    Convert To String    ${cart_currency}
                    ${cart_currency}=    Replace String    ${cart_currency}    '   ${EMPTY}
                    ${cart_currency}=    Replace String    ${cart_currency}    [   ${EMPTY}
                    ${cart_currency}=    Replace String    ${cart_currency}    ]   ${EMPTY}
                    ${expected_cart_found}=    Run Keyword And Return Status    Should Be True    '${cart_mode}' == 'GROSS_MODE' and '${cart_currency}' == 'EUR'
                    IF    ${expected_cart_found} == 1
                        Set Test Variable    ${cart_id}    ${cart_id}
                        BREAK
                    END
                    IF    ${index} < ${carts_number}-1 and ${expected_cart_found} == 0    
                        Continue For Loop
                    ELSE
                        I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "dummyCart${random}"}}}
                        Save value to a variable:    [data][id]    cart_id
                    END
            END
        ELSE
            I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "dummyCart${random}"}}}
            Save value to a variable:    [data][id]    cart_id
        END

Create empty customer cart:
    [Documentation]    This keyword creates cart for the current customer token. This keyword sets ``${cart_id} `` variable
        ...                and it can be re-used by the keywords that follow this keyword in the test. 
        ...    
        ...    Note: work only for registered customers. For guest users use ``Create a guest cart:``
        ...
        ...    *Example:*
        ...
        ...    ``Create empty customer cart:    ${mode.gross}    ${currency.eur.code}    ${store.de}    cart_rules``
        ...    
        [Arguments]    ${price_mode}    ${currency_code}    ${store_code}    ${cart_name}
        I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${price_mode}","currency": "${currency_code}","store": "${store_code}","name": "${cart_name}-${random}"}}}
        Save value to a variable:    [data][id]    cart_id

Get ETag header value from cart
    [Documentation]    This keyword first retrieves cart for the current customer token.
        ...   and then It gets the Etag header value and saves it into the test variable ``${Etag}``, which can then be used within the scope of the test where this keyword was called.
        ...
        ...    and it can be re-used by the keywords that follow this keyword in the test
        ...    This keyword does not accept any arguments. This keyword is used for removing unused/unwanted (ex. W/"") characters from ETag header value.
        ...
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
    [Documentation]    This keyword creates a new entry in the DB table spy_gift_card with the name, value and gift-card code.
        ...    *Example:*
        ...
        ...    ``Create giftcode in Database:    checkout_${random}    ${gift_card.amount}``
        ... 
    [Arguments]    ${spy_gift_card_code}    ${spy_gift_card_value}
    ${amount}=   Evaluate    ${spy_gift_card_value} / 100
    ${amount}=    Evaluate    "%.f" % ${amount}
    Connect to Spryker DB
    ${last_id}=    Query    SELECT id_gift_card FROM spy_gift_card ORDER BY id_gift_card DESC LIMIT 1;
    ${new_id}=    Set Variable    ${EMPTY}
    ${last_id_length}=    Get Length    ${last_id}
    IF    ${last_id_length} > 0    
        ${new_id}=    Evaluate    ${last_id[0][0]} + 1
    ELSE
        ${new_id}=    Evaluate    1
    END
    Log    ${new_id}
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_gift_card (code,name,currency_iso_code,value) value ('${spy_gift_card_code}','Gift_card_${amount}','EUR','${spy_gift_card_value}')
    ELSE
        Execute Sql String    INSERT INTO spy_gift_card (id_gift_card, code, name, currency_iso_code, value) VALUES (${new_id}, '${spy_gift_card_code}', 'Gift_card_${amount}', 'EUR', '${spy_gift_card_value}');
    END
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
        ${response}=    GET    ${current_url}/carts/${cart_id}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}  params=include=items,bundle-items     expected_status=200    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response.status_code}
        IF    ${response.status_code} != 204    
            TRY    
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        IF    ${response.status_code} == 204    
            ${response_body}=    Set Variable    ${EMPTY}
        END
        @{included}=    Get Value From Json    ${response_body}    [included]
        ${list_not_empty}=    Get length    ${included}
        IF    ${list_not_empty} > 0
            ${list_length}=    Get length    @{included}
            Log    list_length: ${list_length}
            FOR    ${index}    IN RANGE    0    ${list_length}
                    ${list_element}=    Get From List    @{included}    ${index}
                    ${cart_item_uid}=    Get Value From Json    ${list_element}    [attributes][groupKey]
                    ${cart_item_sku}=    Get Value From Json    ${list_element}    [attributes][sku]
                    ${cart_item_uid}=    Convert To String    ${cart_item_uid}
                    ${cart_item_uid}=    Replace String    ${cart_item_uid}    '   ${EMPTY}
                    ${cart_item_uid}=    Replace String    ${cart_item_uid}    [   ${EMPTY}
                    ${cart_item_uid}=    Replace String    ${cart_item_uid}    ]   ${EMPTY}
                    ${cart_item_sku}=    Convert To String    ${cart_item_sku}
                    ${cart_item_sku}=    Replace String    ${cart_item_sku}    '   ${EMPTY}
                    ${cart_item_sku}=    Replace String    ${cart_item_sku}    [   ${EMPTY}
                    ${cart_item_sku}=    Replace String    ${cart_item_sku}    ]   ${EMPTY}
                    TRY
                        ${response_delete}=    DELETE    ${current_url}/carts/${cart_id}/items/${cart_item_uid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204    verify=${verify_ssl}
                    EXCEPT    
                        ${response_delete}=    DELETE    ${current_url}/carts/${cart_id}/items/${cart_item_sku}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204    verify=${verify_ssl}
                    END
            END
        END

Cleanup all customer carts
    [Documentation]    This keyword deletes all customer carts
        ...
        ...    Before using this method you should get customer token and set it into the headers with the help of ``I get access token for the customer:`` and ``I set Headers:``
        ...    This keyword does not accept any arguments.
        ...    
        ...    *Example:*
        ...
        ...    ``Cleanup all customer carts``
        ${response}=    GET    ${current_url}/carts    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}  params=include=items,bundle-items     expected_status=200    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response.status_code}
        IF    ${response.status_code} != 204    
            TRY    
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        IF    ${response.status_code} == 204    
            ${response_body}=    Set Variable    ${EMPTY}
        END
        @{data}=    Get Value From Json    ${response_body}    [data]
        ${list_not_empty}=    Get length    ${data}
        IF    ${list_not_empty} > 0
            ${list_length}=    Get Length    @{data}
            Log    list_length: ${list_length}
            FOR    ${index}    IN RANGE    0    ${list_length}-1
                    ${list_element}=    Get From List    @{data}    ${index}
                    ${cart_uuid}=    Get Value From Json    ${list_element}    [id]
                    ${cart_uuid}=    Convert To String    ${cart_uuid}
                    ${cart_uuid}=    Replace String    ${cart_uuid}    '   ${EMPTY}
                    ${cart_uuid}=    Replace String    ${cart_uuid}    [   ${EMPTY}
                    ${cart_uuid}=    Replace String    ${cart_uuid}    ]   ${EMPTY}
                    ${response_delete}=    DELETE    ${current_url}/carts/${cart_uuid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204    verify=${verify_ssl}
            END
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
        ${response}=    GET    ${current_url}/guest-carts/${cart_id}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}  params=include=guest-cart-items,bundle-items    expected_status=200    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response.status_code}
        IF    ${response.status_code} != 204    
            TRY    
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        IF    ${response.status_code} == 204    
            ${response_body}=    Set Variable    ${EMPTY}
        END
        @{included}=    Get Value From Json    ${response_body}    [included]
        ${list_not_empty}=    Get length    ${included}
        IF    ${list_not_empty} > 0
            ${list_length}=    Get length    @{included}
            Log    list_length: ${list_length}
            FOR    ${index}    IN RANGE    0    ${list_length}
                    ${list_element}=    Get From List    @{included}    ${index}
                    ${cart_item_uid}=    Get Value From Json    ${list_element}    [id]
                    ${cart_item_uid}=    Convert To String    ${cart_item_uid}
                    ${cart_item_uid}=    Replace String    ${cart_item_uid}    '   ${EMPTY}
                    ${cart_item_uid}=    Replace String    ${cart_item_uid}    [   ${EMPTY}
                    ${cart_item_uid}=    Replace String    ${cart_item_uid}    ]   ${EMPTY}
                    ${response_delete}=    DELETE    ${current_url}/guest-carts/${cart_id}/guest-cart-items/${cart_item_uid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204    verify=${verify_ssl}
            END
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
        ${response}=    GET    ${current_url}/customers/${yves_user.reference}/availability-notifications    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}   expected_status=200    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response.status_code}
        IF    ${response.status_code} != 204    
            TRY    
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        IF    ${response.status_code} == 204    
            ${response_body}=    Set Variable    ${EMPTY}
        END
        @{data}=    Get Value From Json    ${response_body}    [data]
        ${list_not_empty}=    Get length    ${data}
        IF    ${list_not_empty} > 0
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
                    ${response_delete}=    DELETE    ${current_url}/availability-notifications/${availability_notification_id}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204    verify=${verify_ssl}
            END
        END
Update order status in Database:
    [Documentation]    This keyword updates order status in database to any required status. This allows to skip going through the order workflow manually 
    ...    but just switch to the status you need to create a test. 
    ...    There is no separate endpoint to update order status and this keyword allows to do this via database value update.
    ...    *Example:*
    ...    
    ...    ``Update order status in Database:    7    shipped``
    [Arguments]    ${order_item_status_name}    ${uuid_to_use}
    Connect to Spryker DB
    ${new_id}=    Set Variable    ${EMPTY}
    ${state_id}=    Set Variable    ${EMPTY}
    ${last_id}=    Query    SELECT id_oms_order_item_state FROM spy_oms_order_item_state ORDER BY id_oms_order_item_state DESC LIMIT 1;
    ${expected_state_id}=    Query    SELECT id_oms_order_item_state FROM spy_oms_order_item_state WHERE name='${order_item_status_name}';
    ${last_id_length}=    Get Length    ${last_id}
    ${expected_state_id_length}=    Get Length    ${expected_state_id}
    IF    ${expected_state_id_length} > 0 
        ${state_id}=    Set Variable    ${expected_state_id[0][0]}
    ELSE
        ${new_id}=    Evaluate    ${last_id[0][0]} + 1
        Execute Sql String    INSERT INTO spy_oms_order_item_state (id_oms_order_item_state, name) VALUES (${new_id}, '${order_item_status_name}');
        ${state_id}=    Set Variable    ${new_id}
    END
    Execute Sql String    update spy_sales_order_item set fk_oms_order_item_state = '${state_id}' where uuid= '${uuid_to_use}'
    Disconnect From Database
 
Get voucher code by discountId from Database:
    [Documentation]    This keyword allows to get voucher code according to the discount ID. Discount_id can be found in Backoffice > Merchandising > Discount page
    ...        and set this id as an argument of a keyword.
    ...
    ...    *Example:*
    ...    ``Get voucher code by discountId from Database:    3``
    [Arguments]    ${discount_id}
    Save the result of a SELECT DB query to a variable:    select fk_discount_voucher_pool from spy_discount where id_discount = ${discount_id}    discount_voucher_pool_id
    IF    '${db_engine}' == 'pymysql'
        Save the result of a SELECT DB query to a variable:    select code from spy_discount_voucher where fk_discount_voucher_pool = ${discount_voucher_pool_id} and is_active = 1 limit 1    discount_voucher_code
    ELSE
        Save the result of a SELECT DB query to a variable:    select code from spy_discount_voucher where fk_discount_voucher_pool = ${discount_voucher_pool_id} and is_active = true limit 1    discount_voucher_code
    END

Connect to Spryker DB
    [Documentation]    This keyword allows to connect to Spryker DB. 
    ...        Supports both MariaDB and PostgeSQL.
    ...    
    ...        To specify the expected DB engine, use ``db_engine`` variabl. Default one -> *MariaDB*
    ...    
    ...    *Example:*
    ...    ``robot -v env:api_suite -v db_engine:psycopg2``
    ...    
    ...    with the example above you'll use PostgreSQL DB engine
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

Get the first company user id and its' customer email
    [Documentation]    This keyword sends the GET reguest to the ``/company-users?include=customers`` endpoint and returns first available company user id and its' customer email in
    ...    ``${companyUserId}``  and  ``${companyUserEmail}`` variables. 
    ...    If the fist company user is anne.boleyn@spryker.com - the next one will be taken and Anna is a 'BoB' user
    ...    
    I send a GET request:    /company-users?include=customers
    Save value to a variable:    [data][0][id]    companyUserId
    Save value to a variable:    [included][0][attributes][email]    companyUserEmail
    IF    '${companyUserEmail}' == 'anne.boleyn@spryker.com'
        Save value to a variable:    [included][1][attributes][email]    companyUserEmail
        Save value to a variable:    [data][1][id]    companyUserId
    END

Array element should contain nested array at least once:
    [Documentation]    This keyword checks whether the array ``${paret_array}`` that is present in the ``${response_body}`` test variable contsains an array ``${expected_nested_array}`` at least once.
    ...
    ...    *Example:*
    ...
    ...   ``Array element should contain nested array at least once:    [data]    [relationships]``
    ...    
    [Arguments]    ${parent_array}    ${expected_nested_array}
    @{data}=    Get Value From Json    ${response_body}    ${parent_array}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    [   ${EMPTY}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    ]   ${EMPTY}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    '   ${EMPTY}
    ${expected_nested_array}=    Create List    ${expected_nested_array}
    FOR    ${index}    IN RANGE    0    ${list_length}
        @{list_element}=    Get From List    @{data}    ${index}
        ${result}=    Run Keyword And Ignore Error    List Should Contain Sub List    ${list_element}    ${expected_nested_array}
        IF    'PASS' in ${result}    Exit For Loop
        IF    ${index} == ${list_length}-1
            Fail    expected '${expected_nested_array}' array is not present in '@{data}'
        END
        IF    'FAIL' in ${result}    Continue For Loop
    END

Array element should contain property with value at least once:
    [Documentation]    This keyword checks that element in the array specified as ``${json_path}`` contains the specified property ``${expected_property}`` with the specified value ``${expected_value}`` at least once.
    ...
    ...    *Example:*
    ...
    ...    ``And Array element should contain property with value at least once:    [data][0][attributes][categoryTreeFilter]    docCount    ${${category_lvl2.qty}}``
    ...
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${result}=    Run Keyword And Ignore Error    Dictionary Should Contain Item    ${list_element}    ${expected_property}    ${expected_value}
        IF    'PASS' in ${result}    Exit For Loop
        IF    ${index} == ${list_length}-1
            Fail    expected '${expected_property}' with value '${expected_value}' is not present in '@{data}' but should
        END
        IF    'FAIL' in ${result}    Continue For Loop
    END

Nested array element should contain sub-array at least once:
    [Documentation]    This keyword checks that nested array ``${parrent_array}`` in the array specified as ``${json_path}`` contains the specified sub-array ``${expected_nested_array}`` at least once.
    ...
    ...    *Example:*
    ...
    ...    ``And Nested array element should contain sub-array at least once:      [data]    [relationships]    company-role``
    ...
    [Arguments]    ${json_path}     ${parrent_array}    ${expected_nested_array}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${result}=    Set Variable    'FALSE'
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    [   ${EMPTY}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    ]   ${EMPTY}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    '   ${EMPTY}
    ${expected_nested_array}=    Create List    ${expected_nested_array}
    FOR    ${index}    IN RANGE    0    ${list_length}
        IF    'PASS' in ${result}    BREAK
        ${list_element}=    Get From List    @{data}    ${index}
        Log    ${list_element}
        @{list_element2}=    Get Value From Json    ${list_element}    ${parrent_array}
        @{list_element}=    Get From List    ${list_element2}    0
        ${result}=    Run Keyword And Ignore Error    List Should Contain Sub List   ${list_element}    ${expected_nested_array}    ignore_case=True
        IF    'PASS' in ${result}    Exit For Loop
        IF    ${index} == ${list_length}-1
                Fail    expected '${expected_nested_array}' array is not present in '@{data}'
        END
        IF    'FAIL' in ${result}    Continue For Loop
    END

Nested array element should contain sub-array with property and value at least once:
    [Documentation]    This keyword checks whether the nested array ``${expected_nested_array}`` that is present in the parrent array ``${parrent_array}`` under the json path ``${json_path}``  contsains propery ``${expected_property}`` with value ``${expected_value}`` at least once.
    ...
    ...    *Example:*
    ...
    ...   ``Nested array element should contain sub-array with property and value at least once:    [included]    [attributes]    [productConfigurationInstance]    configuration    {"time_of_day":"4"}``
    ...
    [Arguments]    ${json_path}     ${parrent_array}    ${expected_nested_array}    ${expected_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${result}=    Set Variable    'FALSE'
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    [   ${EMPTY}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    ]   ${EMPTY}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    '   ${EMPTY}
    ${expected_nested_array}=    Convert To String    ${expected_nested_array}
    FOR    ${index}    IN RANGE    0    ${list_length}
        IF    'PASS' in ${result}    BREAK
        ${parrent_array_element}=    Get From List    @{data}    ${index}
        Log    ${parrent_array_element}
        @{actual_parent_element}=    Get Value From Json    ${parrent_array_element}    ${parrent_array}
        Log List    @{actual_parent_element}
        ${actual_nested_array}=    Get From List    ${actual_parent_element}    0
        ${actual_property_array}=    Get Value From Json    ${actual_nested_array}    ${expected_nested_array}
        Log    @{actual_property_array}
        ${actual_property_value}=    Get From List    ${actual_property_array}    0
        ${actual_property_value}=    Get Value From Json    ${actual_property_value}    ${expected_property}
        ${actual_property_value}=    Convert To String    ${actual_property_value}
        ${actual_property_value}=    Replace String    ${actual_property_value}    '   ${EMPTY}
        ${actual_property_value}=    Replace String    ${actual_property_value}    [   ${EMPTY}
        ${actual_property_value}=    Replace String    ${actual_property_value}    ]   ${EMPTY}
        ${result}=    Run Keyword And Ignore Error    Should Contain   ${actual_property_value}    ${expected_value}    ignore_case=True
            IF    'PASS' in ${result}    BREAK
            IF    ${index} == ${list_length}-1
                Fail    expected '${expected_property}' with value '${expected_value}' is not present in '${expected_nested_array}' but should
            END
            IF    'FAIL' in ${result}    Continue For Loop
    END

Array element should contain nested array with property and value at least once:
    [Documentation]    This keyword checks whether the array ``${nested_array}`` that is present in the parrent array ``${json_path}``  contsains propery ``${expected_property}`` with value ``${expected_value}`` at least once.
    ...
    ...    *Example:*
    ...
    ...   ``And Array element should contain nested array with property and value at least once:    [data][0][attributes][categoryTreeFilter]    [children]    docCount    ${category_lvl2.qty}``
    ...    
    [Arguments]    ${json_path}    ${nested_array}    ${expected_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length1}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    ${result}=    Set Variable    'FALSE'
    FOR    ${index1}    IN RANGE    0    ${list_length1}
        IF    'PASS' in ${result}    BREAK
        ${list_element}=    Get From List    @{data}    ${index1}
        Log    ${list_element}
        @{list_element2}=    Get Value From Json    ${list_element}    ${nested_array}
        Log    @{list_element2}
        ${list_length2}=    Get Length    @{list_element2}
        FOR    ${index2}    IN RANGE    0    ${list_length2}
            ${list_element}=    Get From List    @{list_element2}    ${index2}
            Log    ${list_element}
            ${list_element}=    Get Value From Json    ${list_element}    ${expected_property}
            ${list_element}=    Convert To String    ${list_element}
            ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
            ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
            ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
            ${result}=    Run Keyword And Ignore Error    Should Contain   ${list_element}    ${expected_value}    ignore_case=True
            IF    'PASS' in ${result}    BREAK
            IF    ${index1} == ${list_length1}-1 and ${index2} == ${list_length2}-1
                Fail    expected '${expected_property}' with value '${expected_value}' is not present in '${nested_array}' but should
            END
            IF    'FAIL' in ${result}    Continue For Loop
        END
    END

Get company user id by customer reference:
    [Documentation]    This keyword sends the GET reguest to the ``/company-users?include=customers`` endpoint and returns company user id by customer reference. Sets variable : ``${companyUserId}``
    ...    
    ...    *Example:*
    ...    ``Get company user id by customer reference:    ${yves_fifth_user.reference}``
    ...    
    [Arguments]    ${customer_reference}
    I send a GET request:    /company-users?include=customers
    @{data}=    Get Value From Json    ${response_body}    [data]
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        Log    ${list_element}
        ${company_user_id}=    Get Value From Json    ${list_element}    id
        ${company_user_id}=    Convert To String    ${company_user_id}
        ${company_user_id}=    Replace String    ${company_user_id}    '   ${EMPTY}
        ${company_user_id}=    Replace String    ${company_user_id}    [   ${EMPTY}
        ${company_user_id}=    Replace String    ${company_user_id}    ]   ${EMPTY}
        Set Test Variable    ${companyUserId}    ${company_user_id}
        @{list_element2}=    Get Value From Json    ${list_element}    relationships
        Log    @{list_element2}
        ${company_user_customer_id}=    Get Value From Json    @{list_element2}    customers.data[0].id
        ${company_user_customer_id}=    Convert To String    ${company_user_customer_id}
        ${company_user_customer_id}=    Replace String    ${company_user_customer_id}    '   ${EMPTY}
        ${company_user_customer_id}=    Replace String    ${company_user_customer_id}    [   ${EMPTY}
        ${company_user_customer_id}=    Replace String    ${company_user_customer_id}    ]   ${EMPTY}
        IF    '${company_user_customer_id}' == '${customer_reference}'    BREAK
        IF    ${index} == ${list_length}-1
            Fail    expected customer reference '${customer_reference}' is not present in '@{data}' but should
        END        
    END

Cleanup all existing shopping lists
    [Documentation]    This keyword deletes all customer shopping lists
        ...
        ...    Before using this method you should get customer token and set it into the headers with the help of ``I get access token for the customer:`` and ``I set Headers:``
        ...    This keyword does not accept any arguments.
        ...    
        ...    *Example:*
        ...
        ...    ``Cleanup all existing shopping lists``
        ${response}=    GET    ${current_url}/shopping-lists    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}  params=include=items,bundle-items     expected_status=200    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response.status_code}
        IF    ${response.status_code} != 204    
            TRY    
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        IF    ${response.status_code} == 204    
            ${response_body}=    Set Variable    ${EMPTY}
        END
        @{data}=    Get Value From Json    ${response_body}    [data]
        ${list_not_empty}=    Get length    ${data}
        IF    ${list_not_empty} > 0
            ${list_length}=    Get Length    @{data}
            Log    list_length: ${list_length}
            FOR    ${index}    IN RANGE    0    ${list_length}
                    ${list_element}=    Get From List    @{data}    ${index}
                    ${shopping_list_uuid}=    Get Value From Json    ${list_element}    [id]
                    ${shopping_list_uuid}=    Convert To String    ${shopping_list_uuid}
                    ${shopping_list_uuid}=    Replace String    ${shopping_list_uuid}    '   ${EMPTY}
                    ${shopping_list_uuid}=    Replace String    ${shopping_list_uuid}    [   ${EMPTY}
                    ${shopping_list_uuid}=    Replace String    ${shopping_list_uuid}    ]   ${EMPTY}
                    ${response_delete}=    DELETE    ${current_url}/shopping-lists/${shopping_list_uuid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204
            END
        END

Create merchant order for the item in DB and change status:
    [Documentation]    This keyword creates new merchant order in the DB and sets the desired status . This allows to skip going through the order workflow manually 
    ...    but just switch to the status you need to create a test. 
    ...    There is no separate endpoint to update order status and this keyword allows to do this via database value update.
    ...    *Example:*
    ...    
    ...    ``Create merchant order for the item in DB and change status:    shipped    ${uuid}    ${merchants.sony_experts.merchant_reference}``
    [Arguments]    ${order_item_status_name}    ${uuid_to_use}    ${merchant_reference}
    Connect to Spryker DB
    ${new_id}=    Set Variable    ${EMPTY}
    ${state_id}=    Set Variable    ${EMPTY}
    ${last_id}=    Query    SELECT id_state_machine_item_state FROM spy_state_machine_item_state ORDER BY id_state_machine_item_state DESC LIMIT 1;
    ${expected_state_id}=    Query    SELECT id_state_machine_item_state FROM spy_state_machine_item_state WHERE name='${order_item_status_name}';
    ${last_id_length}=    Get Length    ${last_id}
    IF    ${last_id_length} == 0
        ${state_id}=    Set Variable    1
        ${state_id}=    Convert To String    ${state_id}
    END
    ${expected_state_id_length}=    Get Length    ${expected_state_id}
    IF    ${expected_state_id_length} > 0 
        ${state_id}=    Set Variable    ${expected_state_id[0][0]}
    ELSE
        ${state_id}=    Set Variable    ${state_id}
        Execute Sql String    INSERT INTO spy_state_machine_item_state (id_state_machine_item_state, fk_state_machine_process, name) VALUES (${state_id}, 2, '${order_item_status_name}');
    END
    ${last_order_item_id}=    Query    SELECT id_merchant_sales_order_item from spy_merchant_sales_order_item order by id_merchant_sales_order_item desc limit 1;
    ${last_order_item_id_length}=    Get Length    ${last_order_item_id}
    IF    ${last_order_item_id_length} == 0
        ${new_order_item_id}=    Set variable    1
        ${new_order_item_id}=    Convert To String    ${new_order_item_id}
    END
    IF    ${last_order_item_id_length} > 0
        ${new_order_item_id}=    Evaluate    ${last_order_item_id[0][0]} +1
    ELSE
        ${new_order_item_id}=    Set Variable    ${new_order_item_id}
    END
    ${last_merchant_order_id}=    Query    SELECT id_merchant_sales_order from spy_merchant_sales_order order by id_merchant_sales_order desc limit 1;
    ${last_merchant_order_id_length}=    Get Length    ${last_merchant_order_id}
    IF    ${last_merchant_order_id_length} == 0
        ${new_merchant_order_id}=    Set Variable    1
        ${new_merchant_order_id}=    Convert To String    ${new_merchant_order_id}
    END
    IF    ${last_merchant_order_id_length} > 0
        ${new_merchant_order_id}=    Evaluate    ${last_merchant_order_id[0][0]} +1
    ELSE
        ${new_merchant_order_id}=    Set Variable    ${new_merchant_order_id}
    END
    ${sales_order_id}=    Query    SELECT fk_sales_order from spy_sales_order_item where uuid='${uuid_to_use}';
    ${sales_order_id}=    Set Variable    ${sales_order_id[0][0]}
    Execute Sql String    INSERT INTO spy_merchant_sales_order (id_merchant_sales_order, fk_sales_order, merchant_reference, merchant_sales_order_reference) VALUES (${new_merchant_order_id}, ${sales_order_id}, '${merchant_reference}', 'DE--${sales_order_id}--${merchant_reference}');
    ${last_merchant_order_item_id}=    Query    SELECT id_merchant_sales_order from spy_merchant_sales_order order by id_merchant_sales_order desc limit 1;
    ${last_merchant_order_item_id_length}=    Get Length    ${last_merchant_order_item_id}
    IF    ${last_merchant_order_item_id_length} > 0
        ${new_merchant_order_item_id}=    Evaluate    ${last_merchant_order_item_id[0][0]} +1
    END
    ${sales_order_item_id}=    Query    SELECT id_sales_order_item from spy_sales_order_item where uuid='${uuid_to_use}';
    ${sales_order_item_id}=    Set Variable    ${sales_order_item_id[0][0]}
    ${random_merchant_order_item_reference}=    Generate Random String    10    [NUMBERS]
    Execute Sql String    INSERT INTO spy_merchant_sales_order_item (id_merchant_sales_order_item, fk_merchant_sales_order, fk_sales_order_item, fk_state_machine_item_state, merchant_order_item_reference) VALUES (${new_merchant_order_item_id}, ${new_merchant_order_id}, ${sales_order_item_id}, ${state_id}, '${random_merchant_order_item_reference}');
    Disconnect From Database