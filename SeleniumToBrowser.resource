*** Settings ***
Library     Browser

*** Keywords ***
Add Location Strategy
    No Operation

# Click Element
#     [Arguments]    ${locator}
#     Click    ${locator}

# Wait Until Page Contains
#     [Arguments]    ${text}    ${timeout}=None    ${error}=None
#     sleep    1s
#     Wait Until Network Is Idle
#     Browser.get text    css=html    contains    ${text}

# Wait Until Element Is Visible
#     [Arguments]    ${locator}    ${timeout}=None    ${error}=None
#     Wait For Elements State    ${locator}    visible    ${timeout}    ${error}

# Click Button
#     [Arguments]    ${locator}
#     Click    text=${locator}

# Wait Until Page Contains Element
#     [Arguments]    ${locator}    ${timeout}=0:00:20    ${error}=None    ${limit}=None
#     Wait For Elements State    ${locator}    attached    ${timeout}    ${error}

# Element Should Be Visible
#     [Arguments]    ${locator}    ${message}=None
#     Wait For Elements State    ${locator}    visible

# Page Should Contain
#     [Arguments]    ${text}
#     Browser.Get Text    //main    contains    ${text}

# Set Selenium Speed
#     No Operation

# Capture Page Screenshot
#     [Arguments]    ${filename}=None
#     Take Screenshot    ${filename}

# Wait Until Element Is Not Visible
#     [Arguments]    ${locator}    ${timeout}=None    ${error}=None
#     Wait For Elements State    ${locator}    hidden    ${timeout}    ${error}

# Get Location
#     Get URL

# Close All Browsers
    # Close Context    ALL

# Click Link
#     [Arguments]    ${locator}
#     Click    ${locator}

# Page Should Contain Element
#     [Arguments]    ${locator}    ${message}=None
#     Wait For Elements State    ${locator}

# Get Selenium Speed
#     No Operation

# Page Should Contain Link
#     [Arguments]    ${url}    ${message}=None
#     ${hrefs}=    Execute JavaScript    Array.from(document.querySelectorAll('a')).map(e => e.getAttribute('href'))
#     Should Contain    ${hrefs}    ${url}

# Scroll Element Into View
#     [Arguments]    ${locator}
#     Hover    ${locator}

# Input Text
#     [Arguments]    ${locator}    ${text}
#     Type Text    ${locator}    ${text}    0ms

# Element Should Contain
#     [Arguments]    ${locator}    ${expected}    ${Message}=None    ${Ignore_case}=None
#     Browser.Get Text    ${locator}    contains    ${expected}

# Wait Until Element Contains
#     [Arguments]    ${locator}    ${text}    ${timeout}=None    ${error}=None
#     Browser.Get Text    ${locator}    contains    ${text}

# Page Should Not Contain Element
#     [Arguments]    ${locator}    ${message}=None
#     Wait For Elements State    ${locator}    hidden

# Page Should Not Contain
#     [Arguments]    ${text}
#     Browser.Get Text    //main    validate    "${text}" not in value

# Page Should Not Contain Link
#     [Arguments]    ${locator}    ${message}=None
#     Wait For Elements State    ${locator}    hidden

# Select Frame
#     [Arguments]    ${locator}
#     FAIL    Gebruik de cascading locators en herschrijf test. bijv    css=iframe >>> xpath

# Element Should Not Contain
#     [Arguments]    ${locator}    ${text}
#     Browser.Get Text    ${locator}    validate    "${text}" not in value

# Checkbox Should Be Selected
#     [Arguments]    ${locator}
#     Get Checkbox State    ${locator}    ==    CHECKED

# Checkbox Should Not Be Selected
#     [Arguments]    ${locator}
#     Get Checkbox State    ${locator}    ==    UNCHECKED

# Page Should Contain Checkbox
#     [Arguments]    ${locator}
#     Get element state    ${locator}

# Unselect Checkbox
#     [Arguments]    ${locator}
#     Uncheck Checkbox    ${locator}

# Select Checkbox
#     [Arguments]    ${locator}
#     Check Checkbox    ${locator}

# Unselect Frame
#     No Operation

# Element Attribute Value Should Be
#     [Arguments]    ${locator}    ${attribute}    ${expected}
#     Get Attribute    ${locator}    ${attribute}    ==    ${expected}

# Page Should Contain Button
#     [Arguments]    ${locator}
#     Get element state    ${locator}

# Click Element At Coordinates
#     [Arguments]    ${locator}    ${x}    ${y}
#     Click    selector=${locator}    position_x=${x}    position_y=${y}

# Mouse Over
#     [Arguments]    ${locator}
#     Hover    ${locator}

# Element Should Not Be Visible
#     [Arguments]    ${locator}    ${timeout}=None    ${error}=None
#     Wait For Elements State    ${locator}    hidden    ${timeout}    ${error}
