*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common_yves.robot
Resource    ../pages/yves/yves_wishlist_page.robot

*** Keywords ***
Yves: go To 'Wishlist' Page
    Yves: go to URL:    en/wishlist

Yves: go to wishlist with name:
    [Arguments]    ${wishlistName}
    Yves: go To 'Wishlist' Page
    Click    xpath=//table[@class='table table--expand']//a[contains(text(),'${wishlistName}')]
    Element Should Be Visible    xpath=//div[contains(@class,'title')]//*[contains(text(),'${wishlistName}')]

Yves: product with sku is marked as discountinued in wishlist:
    [Arguments]    ${productSku}
    FOR    ${index}    IN RANGE    0    21
        ${discontinue_applied}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//li[contains(text(),'${productSku}')]/ancestor::td/following-sibling::td/span[contains(text(),'Discontinued')]
        IF    '${discontinue_applied}'=='False'
            Run Keywords
                Sleep    1s
                Reload
        ELSE
            Exit For Loop
        END
    END
    Element Should Be Visible    xpath=//li[contains(text(),'${productSku}')]/ancestor::td/following-sibling::td/span[contains(text(),'Discontinued')]

Yves: product with sku is marked as alternative in wishlist:
    [Arguments]    ${productSku}
    FOR    ${index}    IN RANGE    0    21
        ${alternative_applied}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//li[contains(text(),'${productSku}')]/ancestor::tr/preceding-sibling::tr//*[contains(text(),'Alternative for')]
        IF    '${alternative_applied}'=='False'
            Run Keywords
                Sleep    1s
                Reload
        ELSE
            Exit For Loop
       END
    END
    Element Should Be Visible    xpath=//li[contains(text(),'${productSku}')]/ancestor::tr/preceding-sibling::tr//*[contains(text(),'Alternative for')]

Yves: create wishlist with name:
    [Arguments]    ${wishlistName}
    Type Text    ${wishlist_name_input_field}    ${wishlistName}
    Click    ${wishlist_add_new_button}
    Yves: flash message should be shown:    success    Wishlist created successfully.
    Yves: remove flash messages

Yves: wishlist contains product with sku:
    [Arguments]    ${productSku}
    Element Should Be Visible    //ul[@class='menu menu--inline menu--middle']//li[contains(text(),'${productSku}')]    message=Product with such sku is not found in wishlist

Yves: delete all wishlists
    Yves: go To 'Wishlist' Page
    ${wishlists_list_count}=   Get Element Count    ${wishlist_delete_button}
    FOR    ${index}    IN RANGE    0    ${wishlists_list_count}
        Click    ${wishlist_delete_button}\[1\]
        Yves: flash message should be shown:    success    Wishlist deleted successfully
        Yves: remove flash messages
    END

Yves: assert merchant of product in wishlist:
    [Documentation]    Method for MP which asserts value in 'Sold by' label of item in wishlist. Requires concrete SKU
    [Arguments]    ${sku}    ${merchant_name_expected}
    Page Should Contain Element    xpath=//ul[@class='menu menu--inline menu--middle']//li[contains(text(),'${sku}')]/../li/p[@data-qa='component sold-by-merchant']//a[text()='${merchant_name_expected}']

Yves: add all available products from wishlist to cart
    Wait Until Element Is Visible    ${wishlist_add_all_to_cart_button}
    Click    ${wishlist_add_all_to_cart_button}

Yves: create new 'Whistist' with name:
    [Arguments]    ${wishlistName}
    ${currentURL}=    Get Location
    IF    '/wishlist' not in '${currentURL}'    
            IF    '.at.' in '${currentURL}'
                Go To    ${yves_at_url}wishlist
            ELSE
                Go To    ${yves_url}wishlist
            END    
    END
    Type Text    ${wishlist_name_input_field}    ${wishlistName}
    Click    ${wishlist_add_new_button}
    Yves: remove flash messages



