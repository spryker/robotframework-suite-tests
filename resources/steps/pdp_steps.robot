*** Settings ***
Resource    ../common/common.robot
Resource    ../pages/yves/yves_product_details_page.robot
Resource    ../common/common_yves.robot

*** Variables ***
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
${configureButton}    ${pdp_configure_button}

*** Keywords ***
Yves: PDP contains/doesn't contain:
    [Arguments]    ${condition}    @{pdp_elements_list}
    ${condition}=    Convert To Lower Case    ${condition}
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
    [Arguments]    ${wait_for_p&s}=${False}    ${iterations}=26    ${delay}=3s
    ${variants_present_status}=    Run Keyword And Return Status    Page Should Not Contain Element    ${pdp_variant_selector}    timeout=0:00:01
    IF    '${variants_present_status}'=='False'    Yves: change variant of the product on PDP on random value
    ${wait_for_p&s}=    Convert To String    ${wait_for_p&s}
    ${wait_for_p&s}=    Convert To Lower Case    ${wait_for_p&s}
    IF    '${wait_for_p&s}' == 'true'
        ${wait_for_p&s}=    Set Variable    ${True}
    END
    IF    '${wait_for_p&s}' == 'false'
        ${wait_for_p&s}=    Set Variable    ${False}
    END
    IF    ${wait_for_p&s}
        FOR    ${index}    IN RANGE    1    ${iterations}
        ${result}=    Run Keyword And Ignore Error    Wait Until Element Is Enabled    ${pdp_add_to_cart_button}    timeout=1s
            IF    ${index} == ${iterations}-1
                Take Screenshot    EMBED    fullPage=True
                Fail    'Add to cart' button is not actionable/available on PDP
            END
            IF    'FAIL' in ${result}
                Sleep    ${delay}
                Reload
                Repeat Keyword    3    Wait For Load State
                Wait For Load State    networkidle
                Continue For Loop
            ELSE
                Repeat Keyword    3    Wait For Load State
                Wait For Load State    networkidle
                Click    ${pdp_add_to_cart_button}
                Repeat Keyword    3    Wait For Load State
                Wait For Load State    networkidle
                Exit For Loop
            END
        END
    ELSE
        Click    ${pdp_add_to_cart_button}
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    networkidle
    END
    Repeat Keyword    5    Wait For Load State
    Wait For Load State    networkidle
    Yves: remove flash messages

Yves: change quantity on PDP:
    [Arguments]    ${qtyToSet}
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Type Text    ${pdp_quantity_input_filed}[${env}]    ${qtyToSet}
        Keyboard Key    press    Enter
        Sleep    1s
    ELSE IF    '${env}' in ['ui_suite']
        Select From List By Value    ${pdp_quantity_input_filed}[${env}]    ${qtyToSet}
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
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    networkidle
        IF    '${action}' == '+'
            Click    ${pdp_increase_quantity_button}[${env}]
        ELSE IF    '${action}' == '-'
            Click    ${pdp_decrease_quantity_button}[${env}]
        END
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    networkidle
    END

Yves: set quantity on PDP:
    [Arguments]    ${qty}
    Type Text    xpath=(//formatted-number-input//input)[1]    ${qty}

Yves: change variant of the product on PDP on:
    [Arguments]    ${variantToChoose}
    Repeat Keyword    3    Wait For Load State
    Wait Until Page Contains Element    ${pdp_variant_selector}
    TRY
        ${timeout}=    Set Variable    1s
        Set Browser Timeout    ${timeout}
        Click    ${pdp_variant_custom_selector}
        Repeat Keyword    3    Wait For Load State
        Wait Until Element Is Visible    ${pdp_variant_custom_selector_results}    timeout=${timeout}
        TRY
            Set Browser Timeout    ${browser_timeout}
            Click    xpath=//ul[contains(@id,'select2-attribute')][contains(@id,'results')]/li[contains(@id,'select2-attribute')][contains(.,'${variantToChoose}')]
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Set Browser Timeout    ${browser_timeout}
            Reload
            Sleep    ${timeout}
            Click    xpath=//ul[contains(@id,'select2-attribute')][contains(@id,'results')]/li[contains(@id,'select2-attribute')][contains(.,'${variantToChoose}')]
            Set Browser Timeout    ${browser_timeout}
            Repeat Keyword    3    Wait For Load State
        END
    EXCEPT
        Set Browser Timeout    ${timeout}
        Run Keyword And Ignore Error    Select From List By Value    ${pdp_variant_selector}    ${variantToChoose}
        Set Browser Timeout    ${browser_timeout}
        Repeat Keyword    3    Wait For Load State
    END
    Set Browser Timeout    ${browser_timeout}
    ${variant_selected}=    Run Keyword And Return Status    Wait For Elements State    ${pdp_reset_selected_variant_locator}    attached    timeout=3s
    IF    '${variant_selected}'=='False'
        TRY
            Set Browser Timeout    1s
            Click    ${pdp_variant_custom_selector}
            Wait Until Element Is Visible    ${pdp_variant_custom_selector_results}
            TRY
                Click    xpath=//ul[contains(@id,'select2-attribute')][contains(@id,'results')]/li[contains(@id,'select2-attribute')][contains(.,'${variantToChoose}')]
                Set Browser Timeout    ${browser_timeout}
                Repeat Keyword    3    Wait For Load State
            EXCEPT
                Set Browser Timeout    ${browser_timeout}
                Reload
                Click    xpath=//ul[contains(@id,'select2-attribute')][contains(@id,'results')]/li[contains(@id,'select2-attribute')][contains(.,'${variantToChoose}')]
                Set Browser Timeout    ${browser_timeout}
                Repeat Keyword    3    Wait For Load State
            END
        EXCEPT
            ${final_try}=    Run Keyword And Ignore Error    Select From List By Value    ${pdp_variant_selector}    ${variantToChoose}
            Repeat Keyword    3    Wait For Load State
            IF    'FAIL' in ${final_try}
                Take Screenshot    EMBED    fullPage=True
                FAIL    '${variantToChoose}' variant was not selected on PDP. Check if variant exists
            END
        END
    END
    Set Browser Timeout    ${browser_timeout}

Yves: reset selected variant of the product on PDP
    Wait Until Page Contains Element    ${pdp_reset_selected_variant_locator}
    Click    ${pdp_reset_selected_variant_locator}

Yves: change amount on PDP:
    [Arguments]    ${amountToSet}
    Type Text    ${pdp_amount_input_filed}    ${amountToSet}

Yves: product price on the PDP should be:
    [Arguments]    ${expectedProductPrice}    ${wait_for_p&s}=${False}    ${iterations}=26    ${delay}=5s
    ### *** promise for P&S *** ####
    ${wait_for_p&s}=    Convert To String    ${wait_for_p&s}
    ${wait_for_p&s}=    Convert To Lower Case    ${wait_for_p&s}
    IF    '${wait_for_p&s}' == 'true'
        ${wait_for_p&s}=    Set Variable    ${True}
    END
    IF    '${wait_for_p&s}' == 'false'
        ${wait_for_p&s}=    Set Variable    ${False}
    END
    Set Browser Timeout    3s
    IF    ${wait_for_p&s}
        FOR    ${index}    IN RANGE    1    ${iterations}
            ${price_displayed}=    Run Keyword And Ignore Error    Page Should Contain Element    ${pdp_price_element_locator}    timeout=1s
            IF    'PASS' in ${price_displayed}
                ${actualProductPrice}=    Get Text    ${pdp_price_element_locator}
            END
            ${result}=    Run Keyword And Ignore Error    Should Be Equal    ${expectedProductPrice}    ${actualProductPrice}
            IF    ${index} == ${iterations}-1
                Take Screenshot    EMBED    fullPage=True
                Fail    Actual product price is ${actualProductPrice}, expected ${expectedProductPrice}
            END
            IF    'FAIL' in ${result} or 'FAIL' in ${price_displayed}
                Sleep    ${delay}
                Reload
                Continue For Loop
            ELSE
                Set Browser Timeout    ${browser_timeout}
                Exit For Loop
            END
        END
    ELSE
        Set Browser Timeout    3s
        TRY
            ${actualProductPrice}=    Get Text    ${pdp_price_element_locator}
            Should Be Equal    ${expectedProductPrice}    ${actualProductPrice}    message=Actual product price is ${actualProductPrice}, expected ${expectedProductPrice}
        EXCEPT
            Sleep    ${browser_timeout}
            Set Browser Timeout    ${browser_timeout}
            Reload
            Take Screenshot    EMBED    fullPage=True
            ${actualProductPrice}=    Get Text    ${pdp_price_element_locator}
            Should Be Equal    ${expectedProductPrice}    ${actualProductPrice}    message= Actual product price is ${actualProductPrice}, expected ${expectedProductPrice}
        END
        Set Browser Timeout    ${browser_timeout}
    END

Yves: product original price on the PDP should be:
    [Arguments]    ${expectedProductPrice}
    ${actualProductPrice}=    Get Text    ${pdp_original_price_element_locator}
    Should Be Equal    ${expectedProductPrice}    ${actualProductPrice}

Yves: add product to the shopping list:
    [Documentation]    If SL name is not provided, default one will be used
    [Arguments]    ${shoppingListName}=${EMPTY}
    Repeat Keyword    3    Wait For Load State
    ${variants_present_status}=    Run Keyword And Ignore Error    Page Should Not Contain Element    ${pdp_variant_selector}    timeout=1s
    ${shopping_list_dropdown_status}=    Run Keyword And Ignore Error    Page should contain element    ${pdp_shopping_list_selector}    timeout=5s
    IF    'FAIL' in ${variants_present_status}    Yves: change variant of the product on PDP on random value
    IF    ('${shoppingListName}' != '${EMPTY}' and 'PASS' in ${shopping_list_dropdown_status})
        TRY
            Set Browser Timeout    3s
            Wait Until Element Is Enabled    ${pdp_shopping_list_selector}
            Select From List By Label    ${pdp_shopping_list_selector}    ${shoppingListName}
            Wait Until Element Is Visible    ${pdp_add_to_shopping_list_button}
            Click With Options    ${pdp_add_to_shopping_list_button}   noWaitAfter=true
            Set Browser Timeout    ${browser_timeout}
            Wait For Response
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Set Browser Timeout    ${browser_timeout}
            Click    xpath=//span[@class='select2-selection select2-selection--single']//span[contains(@id,'select2-idShoppingList')]
            Wait Until Element Is Visible    xpath=//li[contains(@id,'select2-idShoppingList')][contains(@id,'result')][contains(.,'${shoppingListName}')]
            Click    xpath=//li[contains(@id,'select2-idShoppingList')][contains(@id,'result')][contains(.,'${shoppingListName}')]
            Wait Until Element Is Visible    ${pdp_add_to_shopping_list_button}
            Click    ${pdp_add_to_shopping_list_button}
            Set Browser Timeout    ${browser_timeout}
            Wait For Response
            Repeat Keyword    3    Wait For Load State
        FINALLY
            Set Browser Timeout    ${browser_timeout}
        END
    ELSE
        Click    ${pdp_add_to_shopping_list_button}
        Wait For Response
    END
    Set Browser Timeout    ${browser_timeout}
    Yves: remove flash messages

Yves: change variant of the product on PDP on random value
    Wait Until Element Is Visible    ${pdp_variant_selector}
    TRY
        Set Browser Timeout    10s
        Click With Options    ${pdp_variant_custom_selector}    force=True
        Wait Until Element Is Visible    ${pdp_variant_custom_selector_results}
        Click    xpath=//ul[contains(@id,'select2-attribute')][contains(@id,'results')]/li[contains(@id,'select2-attribute')][1]
    EXCEPT
        Run Keyword And Ignore Error    Select From List By Value    ${pdp_variant_selector}    ${variantToChoose}
    END
    Set Browser Timeout    ${browser_timeout}
    Repeat Keyword    3    Wait For Load State

Yves: get sku of the concrete product on PDP
    Wait Until Element Is Visible    ${pdp_product_sku}[${env}]
    ${got_concrete_product_sku}=    Get Text    ${pdp_product_sku}[${env}]
    ${got_concrete_product_sku}=    Replace String    ${got_concrete_product_sku}    SKU:     ${EMPTY}
    ${got_concrete_product_sku}=    Replace String    ${got_concrete_product_sku}    ${SPACE}    ${EMPTY}
    Set Global Variable    ${got_concrete_product_sku}
    RETURN    ${got_concrete_product_sku}

Yves: get name of the product on PDP
    Wait Until Element Is Visible    ${pdp_main_container_locator}[${env}]
    ${got_product_name}=    Get Text    ${pdp_product_name}
    ${got_product_name}=    Remove leading and trailing whitespace from a string:    ${got_product_name}
    Set Global Variable    ${got_product_name}
    RETURN    ${got_product_name}

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
    ${got_abstract_product_sku}=    Set Variable If    '${env}'!='ui_b2b' and '${sku_length}'=='2'    0${got_abstract_product_sku}    ${got_abstract_product_sku}
    ${got_abstract_product_sku}=    Set Variable If    '${env}'!='ui_b2b' and '${sku_length}'=='1'    00${got_abstract_product_sku}    ${got_abstract_product_sku}
    Set Global Variable    ${got_abstract_product_sku}
    RETURN    ${got_abstract_product_sku}

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
    Set Browser Timeout    3s
    TRY
        Yves: flash message should be shown:    success    Items added successfully
        Yves: remove flash messages
    EXCEPT
        Set Browser Timeout    ${browser_timeout}
        Log    flash message was not shown
    END
    Set Browser Timeout    ${browser_timeout}

Yves: check if product is available on PDP:
    [Arguments]    ${abstractSku}    ${isAvailable}
    ${isAvailable}=    Convert To Lower Case    ${isAvailable}
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
    Repeat Keyword    3    Wait For Load State
    TRY
        Click    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'offer-item')]//span[contains(@class,'radio__box')]
        Repeat Keyword    3    Wait For Load State
        Wait For Elements State    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'offer-item')]//span[contains(@class,'radio__box')]/../input    state=checked    timeout=3s
    EXCEPT
        Reload
        Repeat Keyword    3    Wait For Load State
        Click    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'offer-item')]//span[contains(@class,'radio__box')]
        Wait For Elements State    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'offer-item')]//span[contains(@class,'radio__box')]/../input    state=checked    timeout=3s
    END
    Wait Until Element Contains    ${referrer_url}    offer    message=Offer selector radio button does not work on PDP but should
    Repeat Keyword    3    Wait For Load State
    Wait For Load State    networkidle

Yves: select xxx merchant's offer with price:
    [Arguments]    ${merchantName}    ${price}    ${wait_for_p&s}=${False}    ${iterations}=26    ${delay}=3s
    Wait Until Element Is Visible    ${pdp_product_sku}[${env}]
    Repeat Keyword    2    Wait For Load State
    ### *** promise for P&S *** ####
    ${wait_for_p&s}=    Convert To String    ${wait_for_p&s}
    ${wait_for_p&s}=    Convert To Lower Case    ${wait_for_p&s}
    IF    '${wait_for_p&s}' == 'true'
        ${wait_for_p&s}=    Set Variable    ${True}
    END
    IF    '${wait_for_p&s}' == 'false'
        ${wait_for_p&s}=    Set Variable    ${False}
    END
    IF    ${wait_for_p&s}
        FOR    ${index}    IN RANGE    1    ${iterations}
        ${result}=    Run Keyword And Ignore Error    Page Should Contain Element    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'item')]//span[@itemprop='price'][contains(.,'${price}')]/ancestor::div[contains(@class,'offer-item')]//span[contains(@class,'radio__box')]    timeout=1s
            IF    ${index} == ${iterations}-1
                Take Screenshot    EMBED    fullPage=True
                Fail    Expected '${merchantName}' merchant offer with '${price}' is not present on PDP
            END
            IF    'FAIL' in ${result}
                Sleep    ${delay}
                Reload
                Continue For Loop
            ELSE
                Click    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'item')]//span[@itemprop='price'][contains(.,'${price}')]/ancestor::div[contains(@class,'offer-item')]//span[contains(@class,'radio__box')]
                Repeat Keyword    2    Wait For Load State
                Wait For Elements State    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'item')]//span[@itemprop='price'][contains(.,'${price}')]/ancestor::div[contains(@class,'offer-item')]//span[contains(@class,'radio__box')]/../input    state=checked    timeout=3s
                Exit For Loop
            END
        END
    ELSE
        TRY
            Click    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'item')]//span[@itemprop='price'][contains(.,'${price}')]/ancestor::div[contains(@class,'offer-item')]//span[contains(@class,'radio__box')]
            Repeat Keyword    2    Wait For Load State
            Wait For Elements State    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'item')]//span[@itemprop='price'][contains(.,'${price}')]/ancestor::div[contains(@class,'offer-item')]//span[contains(@class,'radio__box')]/../input    state=checked    timeout=3s
        EXCEPT
            Reload
            Repeat Keyword    2    Wait For Load State
            Click    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'item')]//span[@itemprop='price'][contains(.,'${price}')]/ancestor::div[contains(@class,'offer-item')]//span[contains(@class,'radio__box')]
            Wait For Elements State    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'item')]//span[@itemprop='price'][contains(.,'${price}')]/ancestor::div[contains(@class,'offer-item')]//span[contains(@class,'radio__box')]/../input    state=checked    timeout=3s
        END
    END
    Wait Until Element Contains    ${referrer_url}    offer    message=Offer selector radio button does not work on PDP but should
    Repeat Keyword    3    Wait For Load State
    Wait For Load State    networkidle

Yves: merchant's offer/product price should be:
    [Arguments]    ${merchantName}    ${expectedProductPrice}
    Wait Until Element Is Visible    ${pdpPriceLocator}
    Try reloading page until element does/not contain text:    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]/ancestor::div[contains(@class,'item')]//span[@itemprop='price']    ${expectedProductPrice}    true    21    5s

Yves: merchant is (not) displaying in Sold By section of PDP:
    [Arguments]    ${merchantName}    ${condition}
    Wait Until Element Is Visible    ${pdp_product_sku}[${env}]
    Try reloading page until element is/not appear:    xpath=//section[@data-qa='component product-configurator']//*[contains(text(),'${merchantName}')]     ${condition}    20    10s

Yves: select random varian if variant selector is available
    ${variants_present_status}=    Run Keyword And Return Status    Page should contain element    ${pdp_variant_selector}    ${EMPTY}    0:00:01
    IF    '${variants_present_status}'=='True'    Yves: change variant of the product on PDP on random value

Yves: try add product to the cart from PDP and expect error:
    [Arguments]    ${expectedError}
    Repeat Keyword    3    Wait For Load State
    Wait For Load State    networkidle
    Click    ${pdp_add_to_cart_button}
    Repeat Keyword    3    Wait For Load State
    Wait For Load State    networkidle
    Yves: flash message should be shown:    error    ${expectedError}

Yves: product name on PDP should be:
    [Arguments]    ${expected_product_name}
    Yves: try reloading page if element is/not appear:    xpath=//h1[contains(@class,'title')][contains(.,'${expected_product_name}')]    True    15    3s

Yves: try to add product to wishlist as guest user
    Wait Until Element Is Visible    ${pdp_add_to_wishlist_button}
    Sleep    1s
    Click    ${pdp_add_to_wishlist_button}
    Sleep    1s
    Wait Until Element Is Visible    ${email_field}

Yves: try to add product to wishlist as a guest user via glue
    ${add_to_wishlist_url}=    Get Element Attribute    xpath=//form[contains(@action,'wishlist/add')]    action
    &{res}=    Http    url=${yves_url}${add_to_wishlist_url}    method=POST
    Should Be Equal     ${res.status}    ${200}
    Reload
    Should Contain     ${res.body}    Create account    msg=Guest customer is able to access wishlist page
