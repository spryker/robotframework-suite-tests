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
${glue_url}                    http://glue.de.spryker.local
${bapi_url}                    http://backend-api.de.spryker.local
${api_timeout}                 60
${default_password}            change123
${default_allow_redirects}     true
${default_auth}                ${NONE}

*** Keywords ***
# SuiteSetup
#     fsdf
# SuiteTeardown
#     fsdf
# TestSetup
#     sdf
# TestTeardown
#     dsf

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
    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}
    ${data}=    Evaluate    ${json}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    POST    ${glue_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    
    ...    ELSE    POST    ${glue_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a POST request with data:
    [Arguments]   ${path}    ${data}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}
    ${data}=    Evaluate    ${data}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    POST    ${glue_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    
    ...    ELSE    POST    ${glue_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a PUT request:
    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}
    ${data}=    Evaluate    ${json}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    PUT    ${glue_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    
    ...    ELSE    PUT    ${glue_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a PUT request with data:
    [Arguments]   ${path}    ${data}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}
    ${data}=    Evaluate    ${data}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    PUT    ${glue_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    
    ...    ELSE    PUT    ${glue_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a PATCH request:
    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}
    ${data}=    Evaluate    ${json}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    PATCH    ${glue_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    
    ...    ELSE    PATCH    ${glue_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a PATCH request with data
    [Arguments]   ${path}    ${data}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}
    ${data}=    Evaluate    ${data}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    PATCH    ${glue_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    
    ...    ELSE    PATCH    ${glue_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a GET request:
    [Arguments]   ${path}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    GET    ${glue_url}${path}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}
    ...    ELSE    GET    ${glue_url}${path}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}
    ${response_body}=    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I send a DELETE request:
    [Arguments]   ${path}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    Run Keyword if    ${hasValue}    DELETE    ${glue_url}${path}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}
    ...    ELSE    DELETE    ${glue_url}${path}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}
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
    ${json_path}=    Replace String    ${json_path}    [    ['
    ${json_path}=    Replace String    ${json_path}    ]    ']
    Should Be Equal    ${response_body${json_path}}    ${expected_value}

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
    ${actual_self_link}=    Get Value From Json    ${response_body}    $..links.self    #Exampleof path: $..address.streetAddress
    ${actual_self_link}=    Convert To String    ${actual_self_link}
    ${actual_self_link}=    Fetch From Left    ${actual_self_link}    ,
    ${actual_self_link}=    Replace String    ${actual_self_link}    [    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    ]    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    '    ${EMPTY}
    Should Be Equal    ${actual_self_link}    ${expected_self_link}
    