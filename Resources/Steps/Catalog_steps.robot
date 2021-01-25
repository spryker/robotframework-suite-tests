*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Resource    ../Pages/Yves/Yves_Catalog_page.robot

*** Keywords ***
Yves: 'Catalog' page should show products:
    [Arguments]    ${productsCount}
    Wait Until Element Is Visible    ${catalog_products_counter_locator}[${env}]
    Element Should Contain    ${catalog_products_counter_locator}[${env}]    ${productsCount}

Yves: product with name in the catalog should have price:
    [Arguments]    ${productName}    ${expectedProductPrice}
    ${actualProductPrice}=    Get Text    xpath=//product-item[@data-qa='component product-item']//a[contains(@class,'product-item__name')][contains(text(),'${productName}')]/..//*[@data-qa='component money-price']/*[contains(@class,'money-price__amount')]
    Should Be Equal    ${actualProductPrice}    ${expectedProductPrice}

Yves: page contains CMS element:
    [Documentation]    ${type} can be: Banner, Product Slider
    [Arguments]    ${type}    ${title}
    Run Keyword If    '${type}'=='banner'    Element Should Be Visible    xpath=//*[contains(@class,'headline--category') and contains(text(),'${title}')]
    ...    ELSE    Run Keyword If    '${type}'=='Product slider'    Element Should Be Visible    xpath=//*[contains(@class,'catalog-cms-block')]//*[contains(@class,'title') and contains(text(),'${title}')]

Yves: change sorting order on catalog page:
    [Arguments]    ${sortingOption}
    Click Element    xpath=//span[contains(@id,'select2-sort')]
    Wait Until Element Is Visible    xpath=//ul[contains(@role,'listbox')]//li[contains(@id,'select2-sort') and contains(text(),'${sortingOption}')]
    Click Element    xpath=//ul[contains(@role,'listbox')]//li[contains(@id,'select2-sort') and contains(text(),'${sortingOption}')]
    Wait For Document Ready    

Yves: 1st product card in catalog (not)contains:
    [Documentation]    ${elementName} can be: Price, Name
    [Arguments]    ${elementName}    ${value}
    Run Keyword If    '${elementName}'=='Price'    Element Should Be Visible    xpath=//span[contains(@class,'default-price') and contains(text(),'${value}')][1]
    ...    ELSE    Run Keyword If    '${elementName}'=='Name'    Element Should Be Visible    xpath=//span[contains(@class,'item__name') and contains(text(),'${value}')][1]

Yves: go to catalog page:
    [Arguments]    ${pageNumber}
    Click Element    xpath=//a[contains(@class,'pagination__step') and contains(text(),'${pageNumber}')]

Yves: catalog page contains filter:
    [Arguments]    @{listOfFilters}
    FOR    ${filter}    IN    @{listOfFilters}
        Log    Looking for filter: ${filter}
        Element Should Be Visible    xpath=//*[contains(@class,'filter') and contains(text(),'${filter}')]
    END

Yves: select filter value:
    [Arguments]    ${filter}    ${filterValue}
    Click Element    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(text(),'${filter}')]
    Wait Until Element Is Visible    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(text(),'${filter}')]/following-sibling::*//*[contains(@value,'${filterValue}')]
    Click Element    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(text(),'${filter}')]/following-sibling::*//*[contains(@value,'${filterValue}')]
    Click Element    ${catalog_filter_apply_button}
    Wait For Document Ready    

Yves: quick add to cart for first item in catalog
    ${initialCartCounter}=    Yves: get current cart item counter value
    Scroll and Click Element    xpath=//button[contains(@title,'Add to Cart')][1]
    Yves: flash message should be shown:    success    Items added successfully
    Yves: remove flash messages
    ${currentCartCounter}=    Yves: get current cart item counter value
    Should Be True    ${initialCartCounter}+1==${currentCartCounter}

Yves: get current cart item counter value
    [Documentation]    returns the cart item count number as an integer
    ${currentCartCounterText}=    Execute Javascript    return document.evaluate("//*[@data-qa='component navigation-top']//span[contains(@class,'cart-counter__quantity js-cart-counter__quantity')]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.textContent
    ${currentCartCounter}=    Convert To Integer    ${currentCartCounterText}
    [return]    ${currentCartCounter}


Yves: select product color:
    [Arguments]    ${colour}
    Scroll Element Into View    xpath=//*[@class='product-item__name js-product-item__name']
    Mouse Over    xpath=//a[@class='product-item__overlay js-product-item__link-detail-page']/ancestor::div[@class='product-item__image-wrap']
    Wait Until Element Is Visible    xpath=//*[contains(text(),'${colour}')]/ancestor::button[contains(@class,'product-item-color-selector__item')]
    Mouse Over    xpath=//*[contains(text(),'${colour}')]/ancestor::button[contains(@class,'product-item-color-selector__item')]
