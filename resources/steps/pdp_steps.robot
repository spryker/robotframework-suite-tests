*** Settings ***
Resource    ../common/common.robot
Resource    ../pages/yves/yves_product_details_page.robot
Resource    ../common/common_yves.robot

*** Variable ***
${pdpPriceLocator}    ${pdp_price_element_locator}
${addToCartButton}    ${pdp_add_to_cart_button}
${alternativeProducts}    ${pdp_alternative_products_slider}[${env}]
${measurementUnitSuggestion}    ${pdp_measurement_unit_notification}
${packagingUnitSuggestion}    ${pdp_packaging_unit_notification}
${bundleItemsSmall}    ${pdp_product_bundle_include_small}[${env}]
${bundleItemsLarge}    ${pdp_product_bundle_include_large}
${relatedProducts}    ${pdp_related_products}[${env}]
${bazaarvoiceWriteReview}    ${pdp_bazaarvoice_write_review_button}
${bazaarvoiceQuestions}    ${pdp_bazaarvoice_questions_locator}
${bazaarvoiceInlineRating}    ${pdp_bazaarvoice_intine_rating_locator}

*** Keywords ***
Yves: PDP contains/doesn't contain:
    [Arguments]    ${condition}    @{pdp_elements_list}
    ${pdp_elements_list_count}=   get length    ${pdp_elements_list}
    FOR    ${index}    IN RANGE    0    ${pdp_elements_list_count}
        ${pdp_element_to_check}=    Get From List    ${pdp_elements_list}    ${index}
        IF    '${condition}' == 'true'
            Run Keywords
                Log    ${pdp_element_to_check}    #Left as an example of multiple actions in Condition
                Page Should Contain Element    ${pdp_element_to_check}    message=${pdp_element_to_check} is not displayed
        END
        IF    '${condition}' == 'false'
            Run Keywords
                Log    ${pdp_element_to_check}    #Left as an example of multiple actions in Condition
                Page Should Not Contain Element    ${pdp_element_to_check}    message=${pdp_element_to_check} should not be displayed
        END
    END

Yves: add product to the shopping cart
    ${variants_present_status}=    Run Keyword And Return Status    Page should contain element    ${pdp_variant_selector}    ${EMPTY}    0:00:01
    IF    '${variants_present_status}'=='True'    Yves: change variant of the product on PDP on random value
    Click    ${pdp_add_to_cart_button}
    Yves: remove flash messages

Yves: change quantity on PDP:
    [Arguments]    ${qtyToSet}
    IF    '${env}' in ['b2b','mp_b2b']
        Type Text    ${pdp_quantity_input_filed}[${env}]    ${qtyToSet}
        Click    ${pdp_price_element_locator}
        Click    ${pdp_product_name}  
        Sleep    1s
    ELSE
        Add/Edit element attribute with JavaScript:    ${pdp_quantity_input_filed}[${env}]    value    ${qtyToSet}
        Click    ${pdp_product_name}  
    END

Yves: select the following 'Sales Unit' on PDP:
    [Arguments]    ${salesUnit}
    Wait Until Element Is Visible    ${pdp_measurement_sales_unit_selector}
    Select From List By Label    ${pdp_measurement_sales_unit_selector}    ${salesUnit}


Yves: change quantity using '+' or '-' button № times:
    [Arguments]    ${action}    ${clicksCount}
    FOR    ${index}    IN RANGE    0    ${clicksCount}
        IF    '${action}' == '+'
            Click    ${pdp_increase_quantity_button}[${env}]
        ELSE IF    '${action}' == '-'
            Click    ${pdp_decrease_quantity_button}[${env}]
        END
        Sleep    1s
    END

Yves: change variant of the product on PDP on:
    [Arguments]    ${variantToChoose}
    Wait Until Page Contains Element    ${pdp_variant_selector}
    TRY    
        Set Browser Timeout    10s
        Click    ${pdp_variant_custom_selector}    force=True
        Wait Until Element Is Visible    ${pdp_variant_custom_selector_results}
        Click    xpath=//ul[contains(@id,'select2-attribute')][contains(@id,'results')]/li[contains(@id,'select2-attribute')][contains(.,'${variantToChoose}')]
    EXCEPT
        Run Keyword And Ignore Error    Select From List By Value    ${pdp_variant_selector}    ${variantToChoose}
    END
    Set Browser Timeout    ${browser_timeout}
    Wait For Elements State    ${pdp_reset_selected_variant_locator}    attached

Yves: change amount on PDP:
    [Arguments]    ${amountToSet}
    Type Text    ${pdp_amount_input_filed}    ${amountToSet}

Yves: product price on the PDP should be:
    [Arguments]    ${expectedProductPrice}
    ${actualProductPrice}=    Get Text    ${pdp_price_element_locator}
    Should Be Equal    ${expectedProductPrice}    ${actualProductPrice}

Yves: add product to the shopping list:
    [Documentation]    If SL name is not provided, default one will be used
    [Arguments]    ${shoppingListName}=${EMPTY}
    ${variants_present_status}=    Run Keyword And Ignore Error    Page should contain element    ${pdp_variant_selector}
    ${shopping_list_dropdown_status}=    Run Keyword And Ignore Error    Page should contain element    ${pdp_shopping_list_selector}
    IF    'PASS' in ${variants_present_status}    Yves: change variant of the product on PDP on random value
    IF    ('${shoppingListName}' != '${EMPTY}' and 'PASS' in ${shopping_list_dropdown_status})    Select From List By Label    ${pdp_shopping_list_selector}    ${shoppingListName}
    Wait Until Element Is Visible    ${pdp_add_to_shopping_list_button}
    Click    ${pdp_add_to_shopping_list_button}

    Yves: remove flash messages

Yves: change variant of the product on PDP on random value
    Wait Until Element Is Visible    ${pdp_variant_selector}
    Run Keyword And Ignore Error    Select Random Option From List    ${pdp_variant_selector}    xpath=//*[@data-qa='component variant']//select//option[@value]
    Sleep    3s

Yves: get sku of the concrete product on PDP
    Wait Until Element Is Visible    ${pdp_product_sku}[${env}]
    ${got_concrete_product_sku}=    Get Text    ${pdp_product_sku}[${env}]
    ${got_concrete_product_sku}=    Replace String    ${got_concrete_product_sku}    SKU:     ${EMPTY}
    ${got_concrete_product_sku}=    Replace String    ${got_concrete_product_sku}    ${SPACE}    ${EMPTY}
    Set Global Variable    ${got_concrete_product_sku}
    [Return]    ${got_concrete_product_sku}

Yves: get name of the product on PDP
    Wait Until Element Is Visible    ${pdp_main_container_locator}[${env}]
    ${got_product_name}=    Get Text    ${pdp_product_name}
    ${got_product_name}=    Remove leading and trailing whitespace from a string:    ${got_product_name}
    Set Global Variable    ${got_product_name}
    [Return]    ${got_product_name}

Yves: get sku of the abstract product on PDP
    Wait Until Element Is Visible    ${pdp_main_container_locator}[${env}]
    ${currentURL}=    Get Url
    Log    current url: ${currentURL}
    ${got_abstract_product_sku}=    Get Regexp Matches    ${currentURL}    ([^-]+$)
    ${got_abstract_product_sku}=    Convert To String    ${got_abstract_product_sku}
    ${got_abstract_product_sku}=    Replace String    ${got_abstract_product_sku}    '    ${EMPTY}
    ${got_abstract_product_sku}=    Replace String    ${got_abstract_product_sku}    [    ${EMPTY}
    ${got_abstract_product_sku}=    Replace String    ${got_abstract_product_sku}    ]    ${EMPTY}
    ${sku_length}=    Get Length    ${got_abstract_product_sku}
    ${got_abstract_product_sku}=    Set Variable If    '${env}'!='b2b' and '${sku_length}'=='2'    0${got_abstract_product_sku}    ${got_abstract_product_sku}
    ${got_abstract_product_sku}=    Set Variable If    '${env}'!='b2b' and '${sku_length}'=='1'    00${got_abstract_product_sku}    ${got_abstract_product_sku}
    Set Global Variable    ${got_abstract_product_sku}
    [Return]    ${got_abstract_product_sku}

Yves: add product to wishlist:
    [Arguments]    ${wishlistName}    ${selectWishlist}=
    Wait Until Element Is Visible    ${pdp_add_to_wishlist_button}
    Wait Until Element Is Enabled    ${pdp_add_to_wishlist_button}
    ${wishlistSelectorExists}=    Run Keyword And Return Status    Element Should Be Visible    ${pdp_wishlist_dropdown}
    IF    '${selectWishlist}'=='select'
        Run keywords
            Wait Until Element Is Visible    xpath=//select[contains(@name,'wishlist-name')]
            Wait Until Element Is Enabled    xpath=//select[contains(@name,'wishlist-name')]
            Select From List By Value    xpath=//select[contains(@name,'wishlist-name')]    ${wishlistName}
    END
    Click    ${pdp_add_to_wishlist_button}
    Yves: flash message should be shown:    success    Items added successfully
    Yves: remove flash messages

Yves: check if product is available on PDP:
    [Arguments]    ${abstractSku}    ${isAvailable}
    Reload
    IF    '${isAvailable}'=='false'
        Run keywords
            Element Should Be Visible    ${pdp_product_not_available_text}
            Element Should Be Visible    ${pdp_add_to_cart_disabled_button}[${env}]
            Element Should Be Visible    ${pdp_availability_notification_email_field}
    ELSE
        Run keywords
            Element Should Not Be Visible    ${pdp_product_not_available_text}
            Element Should Not Be Visible    ${pdp_add_to_cart_disabled_button}[${env}]
            Element Should Not Be Visible    ${pdp_availability_notification_email_field}
            Element Should Be Visible    ${pdp_add_to_cart_button}
    END

Yves: submit back in stock notification request for email:
    [Arguments]    ${email}
    Type Text    ${pdp_availability_notification_email_field}    ${email}
    Click    ${pdp_back_in_stock_subscribe_button}
    Yves: flash message should be shown:    success    Successfully subscribed
    Yves: remove flash messages
    Element Should Be Visible    xpath=//button[contains(text(),'Do not notify me when back in stock')]

Yves: unsubscribe from availability notifications
    Click    ${pdp_back_in_stock_unsubscribe_button}
    Yves: flash message should be shown:    success    Successfully unsubscribed
    Yves: remove flash messages

Yves: select xxx merchant's offer:
    [Arguments]    ${merchantName}
    Wait Until Element Is Visible    ${pdp_product_sku}[${env}]
    Click    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'offer-item')]//span[contains(@class,'radio__box')]
    Sleep    3s
    Wait Until Element Contains    ${referrer_url}    offer

Yves: merchant's offer/product price should be:
    [Arguments]    ${merchantName}    ${expectedProductPrice}
    Wait Until Element Is Visible    ${pdpPriceLocator}  
    Try reloading page until element does/not contain text:    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'item')]//span[@itemprop='price']    ${expectedProductPrice}    true    20    3s

Yves: merchant is (not) displaying in Sold By section of PDP:
    [Arguments]    ${merchantName}    ${condition}
    Wait Until Element Is Visible    ${pdp_product_sku}[${env}]
    Try reloading page until element is/not appear:    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]     ${condition}    26    3s  
   
Yves: select random varian if variant selector is available
    ${variants_present_status}=    Run Keyword And Return Status    Page should contain element    ${pdp_variant_selector}    ${EMPTY}    0:00:01
    IF    '${variants_present_status}'=='True'    Yves: change variant of the product on PDP on random value