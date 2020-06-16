*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Library    String
Library    BuiltIn
Library    Collections
Resource    ../Pages/Yves/Yves_Product_Details_Page.robot

*** Variable ***
${price}    ${pdp_price_element_locator}
${addToCartButton}    ${pdp_add_to_cart_button}

*** Keywords ***
Yves: PDP contains/doesn't contain: 
    [Arguments]    ${condition}    @{pdp_elements_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${pdp_elements_list_count}=   get length  ${pdp_elements_list}
    FOR    ${index}    IN RANGE    0    ${pdp_elements_list_count}
        ${pdp_element_to_check}=    Get From List    ${pdp_elements_list}    ${index}
        Run Keyword If    '${condition}' == 'true'    
        ...    Run Keywords
        ...    Log    ${pdp_element_to_check}    #Left as an example of multiple actions in Condition
        ...    AND    Page Should Contain Element    ${pdp_element_to_check}    message=${pdp_element_to_check} is not displayed
        Run Keyword If    '${condition}' == 'false'    
        ...    Run Keywords
        ...    Log    ${pdp_element_to_check}    #Left as an example of multiple actions in Condition
        ...    AND    Page Should Not Contain Element    ${pdp_element_to_check}    message=${pdp_element_to_check} should not be displayed
    END

Yves: add product to the shopping cart
    Wait Until Page Contains Element    ${pdp_add_to_cart_button}
    Click Element    ${pdp_add_to_cart_button}
    Wait For Document Ready    