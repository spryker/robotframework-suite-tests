*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Library    String
Library    BuiltIn
Library    Collections
Resource    ../Pages/Yves/Yves_Product_Details_page.robot
Resource    ../Common/Common_Yves.robot

*** Variable ***
${price}    ${pdp_price_element_locator}
${addToCartButton}    ${pdp_add_to_cart_button}
${alternativeProducts}    ${pdp_alternative_products_slider}[${env}]
${measurementUnitSuggestion}    ${pdp_measurement_unit_notification}
${packagingUnitSuggestion}    ${pdp_packaging_unit_notification}
${bundleItemsSmall}    ${pdp_product_bundle_include_small}[${env}]
${bundleItemsLarge}    ${pdp_product_bundle_include_large}
${relatedProducts}    ${pdp_related_products}[${env}]

*** Keywords ***
Yves: PDP contains/doesn't contain: 
    [Arguments]    ${condition}    @{pdp_elements_list}
    ${pdp_elements_list_count}=   get length    ${pdp_elements_list}
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
    ${variants_present_status}=    Run Keyword And Ignore Error    Page should contain element    ${pdp_variant_selector}
    Run Keyword If    'PASS' in ${variants_present_status}    Yves: change variant of the product on PDP on random value
    Wait Until Page Contains Element    ${pdp_add_to_cart_button}
    Scroll and Click Element    ${pdp_add_to_cart_button}
    Wait For Document Ready    
    Yves: remove flash messages

Yves: change quantity on PDP:
    [Arguments]    ${qtyToSet}
    Run Keyword If    '${env}'=='b2b'
    ...    Input text into field    ${pdp_quantity_input_filed}[${env}]    ${qtyToSet}
    ...    ELSE    Add/Edit element attribute with JavaScript:    ${pdp_quantity_input_filed}[${env}]    value    ${qtyToSet}    

Yves: select the following 'Sales Unit' on PDP:
    [Arguments]    ${salesUnit}
    Wait Until Element Is Visible    ${pdp_measurement_sales_unit_selector}
    Select From List By Label    ${pdp_measurement_sales_unit_selector}    ${salesUnit}
    Wait For Document Ready    

Yves: change quantity using '+' or '-' button № times:
    [Arguments]    ${action}    ${clicksCount}
    FOR    ${index}    IN RANGE    0    ${clicksCount}
        Run Keyword If    '${action}' == '+'    Scroll and Click Element    ${pdp_increase_quantity_button}
        ...    ELSE IF    '${action}' == '-'    Scroll and Click Element    ${pdp_decrease_quantity_button} 
    END

Yves: change variant of the product on PDP on:
    [Arguments]    ${variantToChoose}
    Select From List By Label    ${pdp_variant_selector}    ${variantToChoose}
    Wait For Document Ready    

Yves: change amount on PDP:
    [Arguments]    ${amountToSet}
    Input text into field    ${pdp_amount_input_filed}    ${amountToSet}

Yves: product price on the PDP should be:
    [Arguments]    ${expectedProductPrice}
    ${actualProductPrice}=    Get Text    ${pdp_price_element_locator}
    Should Be Equal    ${expectedProductPrice}    ${actualProductPrice}

Yves: add product to the shopping list:
    [Documentation]    If SL name is not provided, default one will be used
    [Arguments]    ${shoppingListName}=${EMPTY}
    ${variants_present_status}=    Run Keyword And Ignore Error    Page should contain element    ${pdp_variant_selector}
    ${shopping_list_dropdown_status}=    Run Keyword And Ignore Error    Page should contain element    ${pdp_shopping_list_selector}
    Run Keyword If    'PASS' in ${variants_present_status}    Yves: change variant of the product on PDP on random value
    Run Keyword If    ('${shoppingListName}' != '${EMPTY}' and 'PASS' in ${shopping_list_dropdown_status})    Select From List By Label    ${pdp_shopping_list_selector}    ${shoppingListName}
    Wait Until Element Is Visible    ${pdp_add_to_shopping_list_button}
    Scroll and Click Element    ${pdp_add_to_shopping_list_button}
    Wait For Document Ready     
    Yves: remove flash messages

Yves: change variant of the product on PDP on random value
    Wait Until Element Is Visible    ${pdp_variant_selector}
    Select Random Option From List    ${pdp_variant_selector}    xpath=//*[@data-qa='component variant']//select//option[@value]
    Wait For Document Ready

Yves: get sku of the concrete product on PDP
    Wait Until Element Is Visible    ${pdp_product_sku}[${env}]
    ${got_concrete_product_sku}=    Get Text    ${pdp_product_sku}[${env}]
    ${got_concrete_product_sku}=    Replace String    ${got_concrete_product_sku}    SKU:     ${EMPTY}
    ${got_concrete_product_sku}=    Replace String    ${got_concrete_product_sku}    ${SPACE}    ${EMPTY}
    Set Global Variable    ${got_concrete_product_sku}
    [Return]    ${got_concrete_product_sku}

Yves: get sku of the abstract product on PDP
    Wait For Document Ready    
    ${currentURL}=    Get Location        
    ${got_abstract_product_sku}=    Get Regexp Matches    ${currentURL}    ([^-]+$)
    ${got_abstract_product_sku}=    Convert To String    ${got_abstract_product_sku}
    ${got_abstract_product_sku}=    Replace String    ${got_abstract_product_sku}    '    ${EMPTY}
    ${got_abstract_product_sku}=    Replace String    ${got_abstract_product_sku}    [    ${EMPTY}
    ${got_abstract_product_sku}=    Replace String    ${got_abstract_product_sku}    ]    ${EMPTY}
    Set Global Variable    ${got_abstract_product_sku}
    [Return]    ${got_abstract_product_sku}

Yves: add product to wishlist:
    [Arguments]    ${wishlistName}
    Wait Until Element Is Visible    ${pdp_add_to_wishlist_button}    timeout=20 seconds    error=Add to wishlist button didn't appear
    Wait Until Element Is Enabled    ${pdp_add_to_wishlist_button}
    ${wishlistSelectorExists}=    Run Keyword And Return Status    Element Should Be Visible    ${pdp_wishlist_dropdown}
    Run Keyword If    '${wishlistSelectorExists}'=='True'
    ...    Select From List By Value    xpath=//select[contains(@name,'wishlist-name')]    ${wishlistName}       
    Scroll and Click Element    ${pdp_add_to_wishlist_button}
    Yves: flash message should be shown:    success    Items added successfully
    Yves: remove flash messages

Yves: check if product is available on PDP:
    [Arguments]    ${abstractSku}    ${isAvailable}
    Reload Page    
    Run Keyword If    '${isAvailable}'=='false'    Run keywords    Element Should Be Visible    ${pdp_product_not_available_text}
    ...    AND    Element Should Be Visible    ${pdp_add_to_cart_disabled_button}
    ...    AND    Element Should Be Visible    ${pdp_availability_notification_email_field}
    ...    ELSE    Run keywords    Element Should Not Be Visible    ${pdp_product_not_available_text}
    ...    AND    Element Should Not Be Visible    ${pdp_add_to_cart_disabled_button}
    ...    AND    Element Should Not Be Visible    ${pdp_availability_notification_email_field}
    ...    AND    Element Should Be Visible    ${pdp_add_to_cart_button}      

Yves: submit back in stock notification request for email:
    [Arguments]    ${email}
    Input text into field    ${pdp_availability_notification_email_field}    ${email}
    Scroll and Click Element    xpath=//button[@data-qa='submit-button']
    Yves: flash message should be shown:    success    Successfully subscribed
    Yves: remove flash messages
    Element Should Be Visible    xpath=//button[contains(text(),'Do not notify me when back in stock')]
    
Yves: unsubscribe from availability notifications
    Scroll and Click Element    xpath=//button[contains(text(),'Do not notify me when back in stock')]
    Yves: flash message should be shown:    success    Successfully unsubscribed
    Yves: remove flash messages
