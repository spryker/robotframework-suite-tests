*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common_yves.robot

*** Keywords ***
Yves: login with invalid password for consecutive 10 times:
    [Arguments]    ${email}    ${password}=${random}       
    ${counter}=    Set Variable    1
    WHILE  True
        Log    ${counter}
    Yves: login on Yves with provided credentials:    ${email}    ${password}
    ${counter}=    Evaluate    ${counter} + 1
     IF    ${counter} == 11 
            BREAK
        END
    END

Yves: login with invalid agent password for consecutive 9 times:
    [Arguments]    ${email}    ${password}=${random}
    ${counter}=    Set Variable    1
    WHILE  True
        Log    ${counter}
    Yves: go to URL:    /agent/login
    Type Text    ${email_field}   ${email}
    Type Text    ${password_field}    ${password}
    Click    ${form_login_button}
    ${counter}=    Evaluate    ${counter} + 1
     IF    ${counter} == 10
            BREAK
        END
    END

Yves: login on Yves with valid agent credentials:
    [Arguments]    ${email}    ${password}
    Yves: go to URL:    /agent/login
    Type Text    ${email_field}   ${email}
    Type Text    ${password_field}   ${password}
    Click    ${form_login_button}

Yves: redirected url for user after login with valid credentials should contain:
    [Arguments]    ${expected_url}
    ${url}    Get Url
    Should Contain    ${url}    ${expected_url}

Yves: redirected url for agent after login with valid credentials should contain:
    [Arguments]    ${expected_url}
    ${url}    Get Url   
    Should Contain   ${url}    ${expected_url}

Yves: error message should be shown after multiple login attempts failed:
    [Arguments]    ${text}
    Element Text Should Be    ${blocked_login_error_message_header}     ${text}