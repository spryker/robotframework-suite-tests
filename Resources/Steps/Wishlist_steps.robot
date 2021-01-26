*** Settings ***
Resource    ../Common/Common.robot

*** Keywords ***
Yves: go To 'Wishlist' Page
    Click Element    ${wishlist_icon_header_navigation_widget}
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

    
    