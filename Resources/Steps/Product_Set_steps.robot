*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Resource    ../Pages/Yves/Yves_Product_Sets_page.robot
Resource    ../Common/Common_Yves.robot

*** Keywords ***
Yves: 'Product Sets' page contains the following sets:
    [Arguments]    @{product_set_list}
    ${product_set_list_count}=   get length  ${product_set_list}
    FOR    ${index}    IN RANGE    0    ${product_set_list_count}
        ${product_set_to_check}=    Get From List    ${product_set_list}    ${index}
        Run Keyword If    '${env}'=='b2b'    Page Should Contain Element    xpath=//*[contains(@class,'product-set-card__name')][text()='${product_set_to_check}']/ancestor::article
        ...    ELSE    Page Should Contain Element    xpath=//*[contains(@class,'title')][text()='${product_set_to_check}']/ancestor::article
    END

Yves: view the following Product Set:
    [Arguments]    ${productSetName}
    Run Keyword If    '${env}'=='b2b'    Scroll and Click Element    xpath=//*[contains(@class,'product-set-card__name')][text()='${productSetName}']/ancestor::article
    ...    ELSE    Scroll and Click Element    xpath=//*[contains(@class,'title')][text()='${productSetName}']/ancestor::article

Yves: 'Product Set' page contains the following products:
    [Arguments]    @{product_name_list}    ${productName1}=${EMPTY}     ${productName2}=${EMPTY}     ${productName3}=${EMPTY}     ${productName4}=${EMPTY}     ${productName5}=${EMPTY}     ${productName6}=${EMPTY}     ${productName7}=${EMPTY}     ${productName8}=${EMPTY}     ${productName9}=${EMPTY}     ${productName10}=${EMPTY}     ${productName11}=${EMPTY}     ${productName12}=${EMPTY}     ${productName13}=${EMPTY}     ${productName14}=${EMPTY}     ${productName15}=${EMPTY}
    ${product_name_list_count}=   get length  ${product_name_list}
    FOR    ${index}    IN RANGE    0    ${product_name_list_count}
        ${product_name_to_check}=    Get From List    ${product_name_list}    ${index}
        Page Should Contain Element    xpath=//*[contains(@class,'custom-element product-set-details')]//a[contains(.,'${product_name_to_check}')]
    END

Yves: change variant of the product on CMS page on:
    [Arguments]    ${productName}    ${variantToSet}
    Mouse Over    xpath=//*[contains(@class,'custom-element product-set-details')]//a[contains(.,'${productName}')]
    Run Keyword If    '${env}'=='b2b'    Select From List By Label   //*[contains(@class,'custom-element product-set-details')]//div[@class='product-item__variant']/descendant::select    ${variantToSet}
    ...    ELSE    Select From List By Label    //*[contains(@class,'custom-element custom-select custom-select--expand')]//descendant::select    ${variantToSet}
    Wait For Document Ready    

Yves: add all products to the shopping cart from Product Set
    Scroll and Click Element    ${add_all_product_to_the_shopping_cart}
    Yves: remove flash messages