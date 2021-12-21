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
${glue_url}                    http://glue.de.spryker.local
${bapi_url}                    http://backend-api.de.spryker.local
${api_timeout}                 60
${default_password}            change123
${default_allow_redirects}     true
${default_auth}                ${NONE}

*** Keywords ***
SuiteSetup
    [Documentation]    Basic steps before each suite
    Remove Files    ${OUTPUTDIR}/selenium-screenshot-*.png
    Remove Files    resources/libraries/__pycache__/*
    Load Variables    ${env}
    ${random}=    Generate Random String    5    [NUMBERS]
    Set Global Variable    ${random}
    ${today}=    Get Current Date    result_format=%Y-%m-%d
    Set Global Variable    ${today}
    [Teardown]
    [Return]    ${random}

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

I set Headers:
    [Arguments]    &{headers}
    Set Test Variable    &{headers}
    [Return]    &{headers}

I get access token for the customer:    
    [Arguments]    ${email}    ${password}=${default_password}
    ${data}=    Evaluate    {"data":{"type":"access-tokens","attributes":{"username":"${email}","password":"${password}"}}}
    ${response}=    POST    ${glue_url}/access-tokens    json=${data}
    ${token}=    Set Variable    Bearer ${response.json()['data']['attributes']['accessToken']}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${token}    ${token}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${expected_self_link}    ${glue_url}/access-tokens
    Log    ${token}
    [Return]    ${token}

I send a POST request:
    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${json}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    POST    ${glue_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    POST    ${glue_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=ANY
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a POST request with data:
    [Arguments]   ${path}    ${data}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${data}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    POST    ${glue_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    POST    ${glue_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a PUT request:
    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${json}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    PUT    ${glue_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    PUT    ${glue_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a PUT request with data:
    [Arguments]   ${path}    ${data}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${data}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    PUT    ${glue_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    PUT    ${glue_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a PATCH request:
    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${json}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    PATCH    ${glue_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    PATCH    ${glue_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a PATCH request with data
    [Arguments]   ${path}    ${data}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${data}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    PATCH    ${glue_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    PATCH    ${glue_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a GET request:
    [Arguments]   ${path}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    GET    ${glue_url}${path}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    GET    ${glue_url}${path}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a DELETE request:
    [Arguments]   ${path}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    DELETE    ${glue_url}${path}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    DELETE    ${glue_url}${path}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

Response reason should be:
    [Arguments]    ${reason}
    Should Be Equal As Strings    ${reason}    ${response.reason}

Response status code should be:
    [Arguments]    ${status_code}
    Should Be Equal As Strings    ${response.status_code}    ${status_code}

Response body should contain:
    [Arguments]    ${value}
    ${response_body}=    Convert To String    ${response_body}
    ${response_body}=    Replace String    ${response_body}    '    "
    Should Contain    ${response_body}    ${value}

Response body parameter should be:
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Be Equal    ${data}    ${expected_value}

Response body parameter should NOT be:
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Not Be Equal    ${data}    ${expected_value}

Response body parameter should have datatype:
    [Documentation]    str, int, ...
    [Arguments]    ${parameter}    ${expected_data_type}
    ${actual_data_type}=    Evaluate datatype of a variable:    ${parameter}
    Should Be Equal    ${actual_data_type}    ${expected_data_type}

Evaluate datatype of a variable:
    [Arguments]    ${variable}
    ${data_type}=    Evaluate     type($variable).__name__
    [Return]    ${data_type}
    #Example of assertions:
    # ${is int}=      Evaluate     isinstance($variable, int)    # will be True
    # ${is string}=   Evaluate     isinstance($variable, str)    # will be False

Response header parameter should be:
    [Arguments]    ${header_parameter}    ${header_value}
    ${actual_header_value}=    Get From Dictionary    ${response_headers}    ${header_parameter}
    Should Be Equal    ${actual_header_value}    ${header_value}

Response body has correct self link
    ${actual_self_link}=    Get Value From Json    ${response_body}    $.links.self    #Exampleof path: $..address.streetAddress
    ${actual_self_link}=    Convert To String    ${actual_self_link}
    ${actual_self_link}=    Replace String    ${actual_self_link}    [    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    ]    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    '    ${EMPTY}
    Should Be Equal    ${actual_self_link}    ${expected_self_link}

Response body has correct self link internal
    ${actual_self_link}=    Get Value From Json    ${response_body}    [data][links][self]    #Exampleof path: $..address.streetAddress
    ${actual_self_link}=    Convert To String    ${actual_self_link}
    ${actual_self_link}=    Replace String    ${actual_self_link}    [    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    ]    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    '    ${EMPTY}
    Log    ${response_body}  
    Should Be Equal    ${actual_self_link}    ${expected_self_link}


Response body parameter should not be EMPTY:
    [Arguments]    ${json_path}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Should Not Be Equal    ${data}    None    ${data} is not empty but shoud be

Response body parameter should be greater than:
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
    [Arguments]    ${json_path}    ${expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    Log    @{data}
    ${list_length}=    Get Length    @{data}
    ${list_length}=    Convert To String    ${list_length}
    #${log_list}=    Log List    @{data}
    Should Be Equal    ${list_length}    ${expected_size}    actual size ${list_length} doesn't equal expected ${expected_size}

Response should contain the array larger than a certain size:
    [Arguments]    ${json_path}    ${expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    Log    @{data}
    ${list_length}=    Get Length    @{data}
    ${list_length}=    Convert To Integer    ${list_length}
    ${result}=    Evaluate   ${list_length} > ${expected_size}
    ${result}=    Convert To String    ${result}
    Should Be Equal    ${result}    True    Actual array length is ${list_length} and it is not greater than expected ${expected_size}
    
Each array element of array in response should contain property:
    [Arguments]    ${json_path}    ${expected_property}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        List Should Contain Value    ${list_element}    ${expected_property}
    END

Each array element of array in response should contain value:
    [Arguments]    ${json_path}    ${expected_property}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${sub_list_element}=    Create List    ${list_element}
        ${sub_list_element}=    Convert To String    ${sub_list_element}
        Should Contain    : ${sub_list_element}    ${expected_property}
    END

Each array element of array in response should contain property with value:
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        Dictionary Should Contain Item    ${list_element}    ${expected_property}    ${expected_value}
    END

Response should return error message:
    [Arguments]    ${error_message}
    ${data}=    Get Value From Json    ${response_body}    [errors][0][detail]
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Be Equal    ${data}    ${error_message}    Actual ${data} doens't equal expected ${error_message}

Response should return error code:
    [Arguments]    ${error_message}
    ${data}=    Get Value From Json    ${response_body}    [errors][0][code]
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Be Equal    ${data}    ${error_message}    Actual ${data} doens't equal expected ${error_message}

Response should contain certain number of values:
    [Arguments]    ${json_path}    ${expected_value}    ${expected_count}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${log_list}=    Log List    @{data}
    ${list_as_string}=    Convert To String    @{data}
    ${count}=    Get Count    : ${list_as_string}    ${expected_value}
    ${count}=    Convert To String    ${count}
    Should Be Equal    ${count}    ${expected_count}    Actual ${count} doesn't equal expected ${expected_count}

Response include should contain certain entity type:
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
    [Arguments]    ${json_path}    ${name}
    ${var_value}=    Get Value From Json    ${response_body}    ${json_path}
    ${var_value}=    Convert To String    ${var_value}
    ${var_value}=    Replace String    ${var_value}    '   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    [   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    ]   ${EMPTY}
    Set Test Variable    ${${name}}    ${var_value}  
    [Return]    ${name}

Response body parameter should contain:
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Log    ${data}
    Should Contain   ${data}    ${expected_value}  