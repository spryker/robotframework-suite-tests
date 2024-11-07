*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    debug
Resource    ../../../../../resources/common/common.robot
Resource    ../../../../../resources/common/common_zed.robot
Resource    ../../../../../resources/steps/zed_root_menus_steps.robot
Resource    ../../../../../resources/steps/glossary_steps.robot
Resource    ../../../../../resources/common/common_yves.robot
Resource    ../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/merchants_steps.robot
Resource    ../../../../../resources/steps/catalog_steps.robot
Resource    ../../../../../resources/steps/pdp_steps.robot

*** Test Cases ***
Zed_navigation_ordering_and_naming
    [Documentation]    Verifies each left navigation node can be opened.
    [Setup]    Create new dynamic root admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: verify first navigation root menus
    Zed: verify root menu icons
    Zed: verify second navigation root menus
    [Teardown]    Delete dynamic root admin user from DB

Glossary
    [Documentation]    Create + edit glossary translation in BO
    [Setup]    Run Keywords    Create new approved dynamic customer in DB
    ...    AND    Create new dynamic root admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Administration    Glossary  
    Zed: click button in Header:    Create Translation
    Zed: fill glossary form:
    ...    || Name                     | EN_US                        | DE_DE                             ||
    ...    || cart.price.test${random} | This is a sample translation | Dies ist eine Beispielübersetzung ||
    Zed: submit the form
    Zed: table should contain:    cart.price.test${random}
    Zed: go to second navigation item level:    Administration    Glossary 
    Zed: click Action Button in a table for row that contains:    ${glossary_name}    Edit
    Zed: fill glossary form:
    ...    || DE_DE                    | EN_US                              ||
    ...    || ${original_DE_text}-Test | ${original_EN_text}-Test-${random} ||
    Zed: submit the form
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: validate the page title:    ${original_EN_text}-Test-${random}
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: undo the changes in glossary translation:    ${glossary_name}     ${original_DE_text}    ${original_EN_text}
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: validate the page title:    ${original_EN_text}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: undo the changes in glossary translation:    ${glossary_name}     ${original_DE_text}    ${original_EN_text}
    ...    AND    Trigger p&s
    ...    AND    Delete dynamic root admin user from DB
    ...    AND    Delete dynamic customer via API

Product_Restrictions
    [Documentation]    Checks White and Black lists
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create product list with the following assigned category:    list_name=White${random}    list_type=white    category=Smartwatches
    Zed: create product list with the following assigned category:    list_name=Black${random}    list_type=black    category=Smartphones
    Zed: unassign all product lists from merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London
    Zed: assign product list to merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London    product_list=White${random}
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_test_company_user_email}
    Yves: at least one product is/not displayed on the search results page:    search_query=TomTom    expected_visibility=true    wait_for_p&s=true
    Yves: at least one product is/not displayed on the search results page:    search_query=Canon    expected_visibility=false
    Yves: at least one product is/not displayed on the search results page:    search_query=Lenovo    expected_visibility=false
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: unassign all product lists from merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London
    Zed: assign product list to merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London    product_list=Black${random}
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_test_company_user_email}
    Yves: at least one product is/not displayed on the search results page:    search_query=060    expected_visibility=false    wait_for_p&s=true
    Yves: at least one product is/not displayed on the search results page:    search_query=052    expected_visibility=false
    Yves: at least one product is/not displayed on the search results page:    search_query=Canon    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=Lenovo    expected_visibility=true
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: at least one product is/not displayed on the search results page:    search_query=060    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=052    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=Canon    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=Lenovo    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=TomTom    expected_visibility=true
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: unassign all product lists from merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London
    ...    AND    Zed: remove product list with title:    White${random}
    ...    AND    Zed: remove product list with title:    Black${random}
    ...    AND    Trigger multistore p&s

Customer_Specific_Prices
    [Documentation]    Checks that product price can be different for different customers
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: perform search by:    ${product_with_merchant_price_abstract_sku}
    Yves: product with name in the catalog should have price:    ${product_with_merchant_price_product_name}    ${product_with_merchant_price_default_price}
    Yves: go to PDP of the product with sku:    ${product_with_merchant_price_abstract_sku}
    Yves: product price on the PDP should be:    ${product_with_merchant_price_default_price}
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_test_company_user_email}
    Yves: create new 'Shopping Cart' with name:    customerPrices+${random}
    Yves: perform search by:    ${product_with_merchant_price_abstract_sku}
    Yves: product with name in the catalog should have price:    ${product_with_merchant_price_product_name}    ${product_with_merchant_price_merchant_price}
    Yves: go to PDP of the product with sku:    ${product_with_merchant_price_abstract_sku}
    Yves: product price on the PDP should be:    ${product_with_merchant_price_merchant_price}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    customerPrices+${random}
    Yves: shopping cart contains product with unit price:    sku=${product_with_merchant_price_concrete_sku}    productName=${product_with_merchant_price_product_name}    productPrice=${product_with_merchant_price_merchant_price}
    [Teardown]    Yves: delete 'Shopping Cart' with name:    customerPrices+${random}