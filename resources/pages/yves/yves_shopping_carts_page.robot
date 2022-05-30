*** Settings ***
Resource    ../../common/common.robot
*** Variables ***
${shopping_carts_main_content_locator}    xpath=//*[@data-qa='component quote-table']
${create_shopping_cart_button}    xpath=//main//a[contains(@href,'multi-cart/create')]
${shopping_cart_name_input_field}    id=quoteForm_name
${create_new_cart_submit_button}    xpath=//form[@name='quoteForm']//button[@data-qa='submit-button']
${share_shopping_cart_confirm_button}    xpath=//form[@name='shareCartForm']//button[@type='submit']
${delete_first_shopping_cart_button}    xpath=//*[@data-qa='component quote-table']//table/tbody/tr[1]//ul//a[contains(.,'Delete')]


*** Keywords ***
Edit shopping cart with name:
    [Arguments]    ${shoppingCartName}
    Click    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${shoppingCartName}')]/..//ul//a[contains(.,'Edit')]

Duplicate shopping cart with name:
    [Arguments]    ${shoppingCartName}
    Click    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${shoppingCartName}')]/..//ul//a[contains(.,'Duplicate')]

Add to list shopping cart with name:
    [Arguments]    ${shoppingCartName}
    Click    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${shoppingCartName}')]/..//ul//a[contains(.,'Add to list')]

Dismiss shopping cart with name:
    [Arguments]    ${shoppingCartName}
    Click    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${shoppingCartName}')]/..//ul//a[contains(.,'Dismiss')]

Delete shopping cart with name:
    [Arguments]    ${shoppingCartName}
    Click    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${shoppingCartName}')]/..//ul//a[contains(.,'Delete')]

Share shopping cart with name:
    [Arguments]    ${shoppingCartName}
    Click    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${shoppingCartName}')]/..//ul//a[contains(.,'Share')]

Select access level to share shopping cart with:
    [Arguments]    ${customerToShareWith}    ${accessLevel}
    Select From List By Label    xpath=//div[@data-qa="share-cart-table"]//*[text()='Users']/../../div[@data-qa='component user-share-list']//li[contains(.,'${customerToShareWith}')]//select    ${accessLevel}

Delete first available shopping cart
        ${can_be_deleted}=    Run Keyword And Return Status    Page Should Contain Element    ${delete_first_shopping_cart_button}
        IF    '${can_be_deleted}'=='True'    Click    ${delete_first_shopping_cart_button}
