*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree    spryker-core-back-office    spryker-core    product    product-sets    product-relations    configurable-bundle    product-labels
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/product_set_steps.robot
Resource    ../../../../resources/steps/configurable_bundle_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot

*** Test Cases ***
Product_labels
    [Tags]    smoke    product-labels    search    catalog
    [Documentation]    Checks that products have labels on PLP and PDP
    Trigger product labels update
    Yves: go to first navigation item level:    Sale
    Yves: 1st product card in catalog (not)contains:     Sale label    true
    Yves: go to the PDP of the first product on open catalog page
    Yves: PDP contains/doesn't contain:    true    ${pdp_sales_label}[${env}]
    Yves: go to first navigation item level:    New
    Yves: 1st product card in catalog (not)contains:     New label    true
    Yves: go to the PDP of the first product on open catalog page
    Yves: PDP contains/doesn't contain:    true    ${pdp_new_label}[${env}]
    [Teardown]    Yves: check if cart is not empty and clear it

Product_Sets
    [Tags]    product-sets    cart
    [Documentation]    Check the usage of product sets
    [Setup]    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to URL:    en/product-sets
    Yves: 'Product Sets' page contains the following sets:    HP Product Set    Sony Product Set    TomTom Runner Product Set
    Yves: view the following Product Set:    TomTom Runner Product Set
    Yves: 'Product Set' page contains the following products:    TomTom Golf    Samsung Galaxy S6 edge
    Yves: change variant of the product on CMS page on:    Samsung Galaxy S6 edge    128 GB
    Yves: add all products to the shopping cart from Product Set
    Yves: go to shopping cart page
    Yves: shopping cart contains the following products:     052_30614390    096_30856274
    Yves: delete product from the shopping cart with sku:    052_30614390
    Yves: delete product from the shopping cart with sku:    096_30856274

CRUD_Product_Set
    [Tags]    smoke    product-sets    product
    [Documentation]    CRUD operations for product sets
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create new product set:
    ...    || name en            | name de            | url en             | url de             | set key       | active | product | product 2 | product 3 ||
    ...    || test set ${random} | test set ${random} | test-set-${random} | test-set-${random} | test${random} | true   | 005     | 007       | 010       ||
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to newly created page by URL:    en/test-set-${random}
    Yves: 'Product Set' page contains the following products:    Canon IXUS 175
    Yves: 'Product Set' page contains the following products:    Canon IXUS 285
    Yves: 'Product Set' page contains the following products:    Canon IXUS 180
    Yves: add all products to the shopping cart from Product Set
    Yves: shopping cart contains the following products:    005_30663301
    Yves: shopping cart contains the following products:    007_30691822
    Yves: shopping cart contains the following products:    010_30692994
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: delete product set:    test set ${random}
    Trigger multistore p&s
    Yves: go to URL and refresh until 404 occurs:    ${yves_url}en/test-set-${random}
    [Teardown]    Delete dynamic admin user from DB

Product_Relations
    [Tags]    smoke    product-relations    cart
    [Documentation]    Checks related product on PDP and upsell products in cart
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: PDP contains/doesn't contain:    true    ${relatedProducts}
    Yves: go to PDP of the product with sku:    ${product_with_relations_upselling_sku}
    Yves: PDP contains/doesn't contain:    false    ${relatedProducts}
    Yves: add product to the shopping cart
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${upSellProducts}
