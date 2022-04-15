*** Settings ***
Resource    ../pages/yves/yves_catalog_page.robot
Resource    ../common/common_yves.robot
Resource    ../common/common.robot

*** Keywords ***
Yves: 'Catalog' page should show products:
    [Arguments]    ${productsCount}
    Wait Until Element Is Visible    ${catalog_products_counter_locator}[${env}]
    Element Should Contain    ${catalog_products_counter_locator}[${env}]    ${productsCount}

Yves: product with name in the catalog should have price:
    [Arguments]    ${productName}    ${expectedProductPrice}
    ${actualProductPrice}=    Get Text    xpath=//product-item[@data-qa='component product-item']//*[contains(@class,'product-item__name')][contains(text(),'${productName}')]/ancestor::product-item//*[@data-qa='component money-price']/*[contains(@class,'money-price__amount')][contains(@class,'default')]
    ${actualProductPrice}=    Remove String    ${actualProductPrice}    ${SPACE}
    Log    ${expectedProductPrice}
    Log    ${actualProductPrice}
    Should Be Equal    ${actualProductPrice}    ${expectedProductPrice}

Yves: page contains CMS element:
    [Documentation]    Arguments are ${type}    ${title}, ${type} can be: CMS Block, Banner, Product Slider, Homepage Banners, Homepage Inspirational Block, Homepage Banner Video, Footer section, CMS Page Title, CMS Page Content
    [Arguments]    ${type}    ${text}=
    Run Keyword If    '${type}'=='banner'    Element Should Be Visible    xpath=//*[contains(@class,'headline--category') and contains(text(),'${text}')]
    ...    ELSE    Run Keyword If    '${type}'=='Product slider'    Element Should Be Visible    xpath=//*[contains(@class,'catalog-cms-block')]//*[contains(@class,'title') and contains(text(),'${text}')]
    ...    ELSE    Run Keyword If    '${type}'=='Homepage Banners'    Element Should Be Visible    xpath=//div[contains(@class,'slick-carousel__container js-slick-carousel__container slick-initialized slick-slider slick-dotted')]
    ...    ELSE    Run Keyword If    '${type}'=='Homepage Inspirational Block'    Element Should Be Visible    xpath=//*[contains(@class,'multi-inspirational-block__title')]
    ...    ELSE    Run Keyword If    '${type}'=='Homepage Banner Video'    Element Should Be Visible    xpath=//*[contains(@class,'image-banner__video')]
    ...    ELSE    Run Keyword If    '${type}'=='Footer section'    Element Should Be Visible    xpath=//*[@class='footer']
    ...    ELSE    Run Keyword If    '${type}'=='CMS Page Title'    Element Should Be Visible    xpath=//*[contains(@class,'cms-page')][contains(@class,'title')]//*[contains(text(),'${text}')]
    ...    ELSE    Run Keyword If    '${type}'=='CMS Page Content' and '${env}'=='b2c'    Element Should Be Visible    xpath=//*[contains(@class,'cms-page__content')]//*[contains(text(),'${text}')]
    ...    ELSE    Run Keyword If    '${type}'=='CMS Page Content' and '${env}'=='b2b'    Element Should Be Visible    xpath=//main[contains(@class,'cms-page')]//*[contains(text(),'${text}')]
    ...    ELSE    Run Keyword If    '${type}'=='CMS Block'    Element Should Be Visible    xpath=//div[contains(@class,'catalog-cms-block')]//*[.="${text}"]

Yves: change sorting order on catalog page:
    [Arguments]    ${sortingOption}
    Click    xpath=//span[contains(@id,'select2-sort')]
    Wait Until Element Is Visible    xpath=//ul[contains(@role,'listbox')]//li[contains(@id,'select2-sort') and contains(text(),'${sortingOption}')]
    Click    xpath=//ul[contains(@role,'listbox')]//li[contains(@id,'select2-sort') and contains(text(),'${sortingOption}')]

Yves: 1st product card in catalog (not)contains:
    [Documentation]    ${elementName} can be: Price, Name, Add to Cart, Color selector, Sale label, New label
    [Arguments]    ${elementName}    ${value}
    Run Keyword If    '${elementName}'=='Price' and '${value}'=='true'    Element Should Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//span[contains(@class,'default-price') and contains(.,'${value}')]
    ...    ELSE    Run Keyword If    '${elementName}'=='Price' and '${value}'=='false'    Element Should Not Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//span[contains(@class,'default-price') and contains(.,'${value}')]
    ...    ELSE    Run Keyword If    '${elementName}'=='Name' and '${value}'=='true'    Element Should Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//*[contains(@class,'item__name') and contains(.,'${value}')]
    ...    ELSE    Run Keyword If    '${elementName}'=='Name' and '${value}'=='false'    Element Should Not Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//*[contains(@class,'item__name') and contains(.,'${value}')]
    ...    ELSE    Run Keyword If    '${env}'=='b2b' and '${elementName}'=='Add to Cart' and '${value}'=='true'    Element Should Not Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//*[@class='product-item__actions']//ajax-add-to-cart//button[@disabled='']
    ...    ELSE    Run Keyword If    '${env}'=='b2b' and '${elementName}'=='Add to Cart' and '${value}'=='false'    Element Should Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//*[@class='product-item__actions']//ajax-add-to-cart//button[@disabled='']
    ...    ELSE    Run Keyword If    '${env}'=='b2c' and '${elementName}'=='Add to Cart' and '${value}'=='true'    Element Should Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//ajax-add-to-cart//button
    ...    ELSE    Run Keyword If    '${env}'=='b2c' and '${elementName}'=='Add to Cart' and '${value}'=='false'    Element Should Not Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//ajax-add-to-cart//button
    ...    ELSE    Run Keyword If    '${elementName}'=='Color selector' and '${value}'=='true'    Page Should Contain Element   xpath=//product-item[@data-qa='component product-item'][1]//product-item-color-selector
    ...    ELSE    Run Keyword If    '${elementName}'=='Color selector' and '${value}'=='false'    Page Should Not Contain Element   xpath=//product-item[@data-qa='component product-item'][1]//product-item-color-selector
    ...    ELSE    Run Keyword If    '${elementName}'=='Sale label' and '${value}'=='true'    Page Should Contain Element   xpath=//product-item[@data-qa='component product-item'][1]//label-group//span[contains(text(),'SALE')]
    ...    ELSE    Run Keyword If    '${elementName}'=='Sale label' and '${value}'=='false'    Page Should Not Contain Element   xpath=//product-item[@data-qa='component product-item'][1]//label-group//span[contains(text(),'SALE')]
    ...    ELSE    Run Keyword If    '${elementName}'=='New label' and '${value}'=='true'    Page Should Contain Element   xpath=//product-item[@data-qa='component product-item'][1]//label-group//span[contains(text(),'New')]
    ...    ELSE    Run Keyword If    '${elementName}'=='New label' and '${value}'=='false'    Page Should Not Contain Element   xpath=//product-item[@data-qa='component product-item'][1]//label-group//span[contains(text(),'New')]

Yves: go to catalog page:
    [Arguments]    ${pageNumber}
    Click    xpath=//a[contains(@class,'pagination__step') and contains(text(),'${pageNumber}')]

Yves: catalog page contains filter:
    [Arguments]    @{listOfFilters}
    FOR    ${filter}    IN    @{listOfFilters}
        Log    Looking for filter: ${filter}
        Element Should Be Visible    xpath=//*[contains(@class,'filter') and contains(text(),'${filter}')]
    END

Yves: select filter value:
    [Arguments]    ${filter}    ${filterValue}
    Click    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(text(),'${filter}')]
    Wait Until Element Is Visible    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(text(),'${filter}')]/following-sibling::*//span[contains(@value,'${filterValue}')]
    Click    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(text(),'${filter}')]/following-sibling::*//span[contains(@value,'${filterValue}')]
    Click    ${catalog_filter_apply_button}

Yves: quick add to cart for first item in catalog
    Run Keyword If    '${env}'=='b2b'    Click    xpath=//product-item[@data-qa='component product-item'][1]//*[@class='product-item__actions']//ajax-add-to-cart//button
    ...    ELSE    Run Keyword If    '${env}'=='b2c'    Click    xpath=//product-item[@data-qa='component product-item'][1]//ajax-add-to-cart//button

Yves: get current cart item counter value
    [Documentation]    returns the cart item count number as an integer
    ${currentCartCounterText}=    Execute Javascript    document.evaluate("//*[@data-qa='component navigation-top']//span[contains(@class,'cart-counter__quantity js-cart-counter__quantity')]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.textContent
    ${currentCartCounter}=    Convert To Integer    ${currentCartCounterText}
    [return]    ${currentCartCounter}

Yves: select product color:
    [Documentation]    the color should start with capital letter, e.g. Black, Red, White
    [Arguments]    ${colour}
    Mouse Over    xpath=//product-item[@data-qa='component product-item'][1]//*[contains(@class,'item__name')]
    Wait Until Element Is Visible    xpath=//product-item[@data-qa='component product-item'][1]//product-item-color-selector
    Mouse Over    xpath=//product-item[@data-qa='component product-item'][1]//product-item-color-selector//span[contains(@class,'tooltip')][contains(text(),'${colour}')]/ancestor::button
