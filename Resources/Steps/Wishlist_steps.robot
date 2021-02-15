*** Settings ***
Resource    ../Common/Common.robot
Resource    ../../Resources/Common/Common_Yves.robot
Resource    ../Pages/Yves/Yves_Wishlist_page.robot

*** Keywords ***
Yves: go To 'Wishlist' Page
    Yves: go to URL:    en/wishlist
    Wait For Document Ready 

Yves: go to wishlist with name:
    [Arguments]    ${wishlistName}
    Yves: go To 'Wishlist' Page
    Scroll and Click Element    xpath=//table[@class='table table--expand']//a[contains(text(),'${wishlistName}')]
    Wait For Document Ready    
    Element Should Be Visible    xpath=//div[contains(@class,'title')]//*[contains(text(),'${wishlistName}')]

Yves: product with sku is marked as discountinued in wishlist:
    [Arguments]    ${productSku}
    Element Should Be Visible    xpath=//li[contains(text(),'${productSku}')]/ancestor::td/following-sibling::td/span[contains(text(),'Discontinued')]

Yves: product with sku is marked as alternative in wishlist:
    [Arguments]    ${productSku}
    Element Should Be Visible    xpath=//li[contains(text(),'${productSku}')]/ancestor::tr/preceding-sibling::tr//*[contains(text(),'Alternative for')]

Yves: create wishlist with name:
    [Arguments]    ${wishlistName}
    Input text into field    ${wishlist_name_input_field}    ${wishlistName}
    Scroll and Click Element    ${wishlist_add_new_button}
    Yves: flash message should be shown:    success    Wishlist created successfully.
    Yves: remove flash messages

Yves: wishlist contains product with sku:
    [Arguments]    ${productSku}
    Element Should Be Visible    //ul[@class='menu menu--inline menu--middle']//li[contains(text(),'${productSku}')]    message=Product with such sku is not found in wishlist

Yves: delete all wishlists
    Yves: go To 'Wishlist' Page
    Wait For Document Ready    
    ${wishlists_list_count}=   Get Element Count    ${wishlist_delete_button}
    FOR    ${index}    IN RANGE    0    ${wishlists_list_count}
        Scroll and Click Element    ${wishlist_delete_button}\[1\]
        Yves: flash message should be shown:    success    Wishlist deleted successfully
        Yves: remove flash messages
    END




    
    