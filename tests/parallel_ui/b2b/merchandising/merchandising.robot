*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_two    spryker-core-back-office    spryker-core    product    product-sets    product-relations    product-labels
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/product_set_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot

*** Test Cases ***
Product_Sets
    [Documentation]    Checks that product set can be added into cart.
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to URL:    en/product-sets
    Yves: 'Product Sets' page contains the following sets:    The Presenter's Set    Basic office supplies    The ultimate data disposal set
    Yves: view the following Product Set:    Basic office supplies
    Yves: 'Product Set' page contains the following products:    Clairefontaine Collegeblock 8272C DIN A5, 90 sheets
    Yves: change variant of the product on CMS page on:    Clairefontaine Collegeblock 8272C DIN A5, 90 sheets    lined
    Yves: add all products to the shopping cart from Product Set
    Yves: shopping cart contains the following products:    421344    420687    421511    423452

Product_Relations
    [Documentation]    Checks related product on PDP and upsell products in cart
    [Setup]    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: PDP contains/doesn't contain:    true    ${relatedProducts}
    Yves: go to PDP of the product with sku:    ${product_with_relations_upselling_sku}
    Yves: PDP contains/doesn't contain:    false    ${relatedProducts}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${upSellProducts}

Product_labels
    [Documentation]    Checks that products have labels on PLP and PDP
    Trigger product labels update
    Yves: go to first navigation item level:    Sale %
    Yves: 1st product card in catalog (not)contains:     Sale label    true
    Yves: go to the PDP of the first product on open catalog page
    Yves: PDP contains/doesn't contain:    true    ${pdp_sales_label}[${env}]
    Yves: go to first navigation item level:    New
    Yves: 1st product card in catalog (not)contains:     New label    true
    Yves: go to the PDP of the first product on open catalog page
    Yves: PDP contains/doesn't contain:    true    ${pdp_new_label}[${env}]

CRUD_Product_Set
    [Documentation]    CRUD operations for product sets. DMS-ON: https://spryker.atlassian.net/browse/FRW-7393
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create new product set:
    ...    || name en            | name de            | url en             | url de             | set key       | active | product                             | product 2                           | product 3                                      ||
    ...    || test set ${random} | test set ${random} | test-set-${random} | test-set-${random} | test${random} | true   | ${one_variant_product_abstract_sku} | ${multi_color_product_abstract_sku} | ${product_with_relations_related_products_sku} ||
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to newly created page by URL:    en/test-set-${random}
    Yves: 'Product Set' page contains the following products:    QUIPO universal steel cabinet with swing doors - HxWxD 1950 x 950 x 420 mm - light gray, from 3 pieces
    Yves: 'Product Set' page contains the following products:    Safescan automatic banknote counter - with 6-fold Counterfeit recognition, EUR value counting, SAFESCAN 2665-S
    Yves: 'Product Set' page contains the following products:    EUROKRAFT hand truck - with open shovel - load capacity 400 kg
    Yves: add all products to the shopping cart from Product Set
    Yves: shopping cart contains the following products:    107254    419904    403125
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: delete product set:    test set ${random}
    Trigger multistore p&s
    Yves: go to URL and refresh until 404 occurs:    ${yves_url}en/test-set-${random}
    [Teardown]    Delete dynamic admin user from DB
