*** Settings ***
Library    BuiltIn
Library    String

*** Variables ***
${shopping_cart_main_content_locator}    xpath=//*[@data-qa='component cart-sidebar']
${shopping_cart_checkout_button}    xpath=//a[@data-qa='cart-go-to-checkout']
${shopping_cart_request_quote_button}    xpath=//a[contains(@href,'/quote-request/create')]
${shopping_cart_upp-sell_products_section}    xpath=//main[contains(@class,'page-layout-main--cart-page')]//slick-carousel[@data-qa='component slick-carousel']
${shopping_cart_locked_cart_form}    xpath=//form[@class='cart-locking__form']
${shopping_cart_cart_title}    xpath=//*[contains(@class,'cart-title__text')]
${request_a_quote_button}    xpath=//a[contains(@class,'button')][contains(text(),'Request a Quote')]

*** Keywords ***
Expand shopping cart accordion: 
     [Arguments]    ${accordionTitle}
     ${accordionState}=    Get Element Attribute    xpath=//div[@data-qa='component cart-sidebar']//*[contains(@class,'cart-sidebar-item__title')][contains(.,'${accordionTitle}')]    class
     ${accordionState}=    Replace String    ${accordionState}    ${SPACE}    ${EMPTY}
     ${accordionState}=    Replace String    ${accordionState}    _    ${SPACE}
     ${accordionState}=    Replace String    ${accordionState}    -    ${SPACE}
     ${accordionState}=    Replace String    ${accordionState}    \r    ${EMPTY}
     ${accordionState}=    Replace String    ${accordionState}    \n    ${EMPTY}
     Log    ${accordionState}
     Run Keyword Unless    'active' in '${accordionState}'    Run Keywords
     ...    Scroll and Click Element    xpath=//div[@data-qa='component cart-sidebar']//*[contains(@class,'cart-sidebar-item__title')][contains(.,'${accordionTitle}')]
     ...    AND    Wait Until Element Is Visible    xpath=//div[@data-qa='component cart-sidebar']//*[contains(@class,'cart-sidebar-item__title')][contains(.,'${accordionTitle}')]/../div[contains(@class,'cart-sidebar-item__content')]
