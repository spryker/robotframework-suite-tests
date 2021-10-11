*** Settings ***
Resource    ../Pages/Yves/Yves_Catalog_page.robot
Resource    ../Common/Common_Yves.robot
Resource    ../Common/Common.robot

*** Keywords ***
Yves: 'Catalog' page should show products:
    [Arguments]    ${productsCount}
    Wait Until Element Is Visible    ${catalog_products_counter_locator}[${env}]
    Element Should Contain    ${catalog_products_counter_locator}[${env}]    ${productsCount}

Yves: product with name in the catalog should have price:
    [Arguments]    ${productName}    ${expectedProductPrice}
    ${actualProductPrice}=    Get Text    xpath=//product-item[@data-qa='component product-item']//*[contains(@class,'product-item__name')][contains(text(),'${productName}')]/ancestor::*//*[@data-qa='component money-price']/*[contains(@class,'money-price__amount')][contains(@class,'default')]
    Should Be Equal    ${actualProductPrice}    ${expectedProductPrice}

Yves: page contains CMS element:
    [Documentation]    Arguments are ${type}    ${title}, ${type} can be: Banner, Product Slider, Homepage Banners, Homepage Inspirational Block, Homepage Banner Video, Footer section, CMS Page Title, CMS Page Content
    [Arguments]    ${type}    ${text}=
    Run Keyword If    '${type}'=='banner'    Element Should Be Visible    xpath=//*[contains(@class,'headline--category') and contains(text(),'${text}')]
    ...    ELSE    Run Keyword If    '${type}'=='Product slider'    Element Should Be Visible    xpath=//*[contains(@class,'catalog-cms-block')]//*[contains(@class,'title') and contains(text(),'${text}')]
    ...    ELSE    Run Keyword If    '${type}'=='Homepage Banners'    Element Should Be Visible    xpath=//div[contains(@class,'slick-carousel__container js-slick-carousel__container slick-initialized slick-slider slick-dotted')]
    ...    ELSE    Run Keyword If    '${type}'=='Homepage Inspirational Block'    Element Should Be Visible    xpath=//*[contains(@class,'multi-inspirational-block__title')]
    ...    ELSE    Run Keyword If    '${type}'=='Homepage Banner Video'    Element Should Be Visible    xpath=//*[contains(@class,'image-banner__video')]
    ...    ELSE    Run Keyword If    '${type}'=='Footer section'    Element Should Be Visible    xpath=//*[contains(@class,'footer')]
    ...    ELSE    Run Keyword If    '${type}'=='CMS Page Title'    Element Should Be Visible    xpath=//*[contains(@class,'cms-page__title') and contains(text(),'${text}')]
    ...    ELSE    Run Keyword If    '${type}'=='CMS Page Content'    Element Should Be Visible    xpath=//*[contains(@class,'cms-page__content') and contains(text(),'${text}')]


Yves: change sorting order on catalog page:
    [Arguments]    ${sortingOption}
    Click    xpath=//span[contains(@id,'select2-sort')]
    Wait Until Element Is Visible    xpath=//ul[contains(@role,'listbox')]//li[contains(@id,'select2-sort') and contains(text(),'${sortingOption}')]
    Click    xpath=//ul[contains(@role,'listbox')]//li[contains(@id,'select2-sort') and contains(text(),'${sortingOption}')]
        

Yves: 1st product card in catalog (not)contains:
    [Documentation]    ${elementName} can be: Price, Name
    [Arguments]    ${elementName}    ${value}
    Run Keyword If    '${elementName}'=='Price'    Element Should Be Visible    xpath=//span[contains(@class,'default-price') and contains(.,'${value}')][1]
    ...    ELSE    Run Keyword If    '${elementName}'=='Name'    Element Should Be Visible    xpath=//span[contains(@class,'item__name') and contains(.,'${value}')][1]

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
    ${initialCartCounter}=    Yves: get current cart item counter value
    Click    xpath=(//button[contains(@title,'Add to Cart')])[1]
    Yves: flash message should be shown:    success    Items added successfully
    Yves: remove flash messages
    ${currentCartCounter}=    Yves: get current cart item counter value
    Should Be True    ${initialCartCounter}+1==${currentCartCounter}

Yves: get current cart item counter value
    [Documentation]    returns the cart item count number as an integer
    ${currentCartCounterText}=    Execute Javascript    document.evaluate("//*[@data-qa='component navigation-top']//span[contains(@class,'cart-counter__quantity js-cart-counter__quantity')]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.textContent
    ${currentCartCounter}=    Convert To Integer    ${currentCartCounterText}
    [return]    ${currentCartCounter}


Yves: select product color:
    [Documentation]    the color should start with capital letter, e.g. Black, Red, White
    [Arguments]    ${colour}
    Scroll Element Into View    xpath=//*[@class='product-item__name js-product-item__name']
    Mouse Over    xpath=//a[@class='product-item__overlay js-product-item__link-detail-page']/ancestor::div[@class='product-item__image-wrap']
    Wait Until Element Is Visible    xpath=//*[contains(text(),'${colour}')]/ancestor::button[contains(@class,'product-item-color-selector__item')]
    Mouse Over    xpath=//*[contains(text(),'${colour}')]/ancestor::button[contains(@class,'product-item-color-selector__item')]
