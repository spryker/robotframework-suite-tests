*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    debug
Resource    ../../../../../resources/common/common_yves.robot
Resource    ../../../../../resources/steps/pdp_steps.robot
Resource    ../../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/catalog_steps.robot
Resource    ../../../../../resources/steps/products_steps.robot

*** Test Cases ***

Product_PDP
    [Documentation]    Checks that PDP contains required elements
    Yves: go to PDP of the product with sku:    135
    Yves: change variant of the product on PDP on:    Flash
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}   ${addToCartButton}    ${pdp_limited_warranty_option}[${env}]    ${pdp_gift_wrapping_option}[${env}]    ${relatedProducts}
    Yves: PDP contains/doesn't contain:    false    ${pdp_add_to_wishlist_button}
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    135
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}   ${pdp_add_to_cart_disabled_button}[${env}]    ${pdp_limited_warranty_option}[${env}]    ${pdp_gift_wrapping_option}[${env}]     ${pdp_add_to_wishlist_button}    ${relatedProducts}
    Yves: change variant of the product on PDP on:    Flash
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${addToCartButton}    ${pdp_limited_warranty_option}[${env}]    ${pdp_gift_wrapping_option}[${env}]     ${pdp_add_to_wishlist_button}    ${relatedProducts}

Catalog
    [Documentation]    Checks that catalog options and search work
    Yves: perform search by:    canon
    Yves: 'Catalog' page should show products:    29
    Yves: select filter value:    Color    Blue
    Yves: 'Catalog' page should show products:    2
    Yves: go to first navigation item level:    Cameras
    Yves: 'Catalog' page should show products:    63
    Yves: change sorting order on catalog page:    Sort by price ascending
    Yves: 1st product card in catalog (not)contains:     Price    €25.00
    Yves: change sorting order on catalog page:    Sort by price descending
    Yves: 1st product card in catalog (not)contains:      Price    €3,456.99
    Yves: go to catalog page:    2
    Yves: catalog page contains filter:    Price    Ratings     Label     Brand    Color    Merchant
    Yves: select filter value:    Color    Blue
    Yves: 'Catalog' page should show products:    2
    [Teardown]    Yves: check if cart is not empty and clear it

Catalog_Actions
    [Documentation]    Checks quick add to cart and product groups
    [Setup]    Create new dynamic root admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: change concrete product price on:
    ...    || productAbstract | productConcrete | store | mode  | type   | currency | amount ||
    ...    || 003             | 003_26138343    | DE    | gross | default| €        | 65.00  ||
    Trigger p&s
    Yves: check if cart is not empty and clear it
    Yves: perform search by:     150_29554292
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: quick add to cart for first item in catalog
    Yves: perform search by:    115
    Yves: 1st product card in catalog (not)contains:     Add to Cart    false
    Yves: perform search by:    002
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: 1st product card in catalog (not)contains:      Color selector   true
    Yves: mouse over color on product card:    D3D3D3
    Yves: quick add to cart for first item in catalog
    Yves: go to b2c shopping cart
    Yves: shopping cart contains the following products:    150_29554292    003_26138343
    Yves: shopping cart contains product with unit price:    sku=003    productName=Canon IXUS 160    productPrice=65.00
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Delete dynamic root admin user from DB

Volume_Prices
    [Documentation]    Checks that volume prices are applied in cart
    [Setup]    Run keywords    Create new dynamic root admin user in DB
    ...    AND    Create new approved dynamic customer in DB
    ...    AND    Zed: check and restore product availability in Zed:    ${volume_prices_product_abstract_sku}    Available    ${volume_prices_product_concrete_sku}    ${dynamic_admin_user}
    ...    AND    Trigger p&s
    ...    AND    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    VolumePriceCart+${random}
    Yves: go to PDP of the product with sku:    ${volume_prices_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    5
    Yves: product price on the PDP should be:    €16.50
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    VolumePriceCart+${random}
    Yves: shopping cart contains product with unit price:    sku=${volume_prices_product_concrete_sku}    productName=${volume_prices_product_name}    productPrice=16.50
    [Teardown]    Run Keywords    Delete dynamic root admin user from DB
    ...    AND    Delete dynamic customer via API


Measurement_Units
    [Documentation]    Checks checkout with Measurement Unit product
    [Setup]    Run keywords    Create new approved dynamic customer in DB
    ...    AND    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    ...    AND    Yves: create new default customer address in profile
    ...    AND    Yves: create new 'Shopping Cart' with name:    measurementUnitsCart+${random}
    Yves: go to PDP of the product with sku:    215
    Yves: change variant of the product on PDP on:    Ring (500m)
    Yves: select the following 'Sales Unit' on PDP:    Meter
    Yves: set quantity on PDP:    3
    Yves: PDP contains/doesn't contain:    true    ${measurementUnitSuggestion}
    Yves: set quantity on PDP:    10
    Yves: add product to the shopping cart
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    215_124
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Delete dynamic customer via API

Packaging_Units
    [Documentation]    Checks checkout with Packaging Unit product
    [Setup]    Run keywords    Create new approved dynamic customer in DB
    ...    AND    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    ...    AND    Yves: create new default customer address in profile
    ...    AND    Yves: create new 'Shopping Cart' with name:    packagingUnitsCart+${random}
    Yves: go to PDP of the product with sku:    218
    Yves: change variant of the product on PDP on:    Giftbox
    Yves: change amount on PDP:    51
    Yves: PDP contains/doesn't contain:    true    ${packagingUnitSuggestion}
    Yves: change amount on PDP:    1000
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    packagingUnitsCart+${random}
    Yves: shopping cart contains the following products:    218_1234
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Delete dynamic customer via API

Product_Bundles
    [Documentation]    Checks checkout with Bundle product
    [Setup]    Run keywords    Create new dynamic root admin user in DB
    ...    AND    Create new approved dynamic customer in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: create new default customer address in profile
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: shopping cart contains the following products:    ${bundle_product_concrete_sku}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Run Keywords    Delete dynamic root admin user from DB
    ...    AND    Delete dynamic customer via API

Back_in_Stock_Notification
    [Setup]    Run Keywords    Create new dynamic root admin user in DB
    ...    AND    Create new approved dynamic customer in DB
    [Documentation]    Back in stock notification is sent and availability check
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    true
    Zed: change product stock:    ${stock_product_abstract_sku}    ${stock_product_concrete_sku}    false    0
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    false
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:  ${stock_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    Yves: check if product is available on PDP:    ${stock_product_abstract_sku}    false
    Yves: submit back in stock notification request for email:    ${dynamic_customer}
    Yves: unsubscribe from availability notifications
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: change product stock:    ${stock_product_abstract_sku}    ${stock_product_concrete_sku}    true    0
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    true
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:  ${stock_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: check if product is available on PDP:    ${stock_product_abstract_sku}    true
    [Teardown]    Run Keywords    Zed: check and restore product availability in Zed:    ${stock_product_abstract_sku}    Available    ${stock_product_concrete_sku}    ${dynamic_admin_user}
    ...    AND    Delete dynamic root admin user from DB
    ...    AND    Delete dynamic customer via API

Manage_Product
    [Setup]    Run Keywords    Create new dynamic root admin user in DB
    ...    AND    Create new approved dynamic customer in DB
    [Documentation]    checks that BO user can manage abstract and concrete products + create new
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: start new abstract product creation:
    ...    || sku                   | store | name en                | name de                  | new from   | new to     ||
    ...    || zedManageSKU${random} | DE    | manageProduct${random} | DEmanageProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 | attribute 2 | attribute value 2 ||
    ...    || color       | grey              | color       | blue              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set           ||
    ...    || DE    | gross | default | €        | 100.00 | Smart Electronics ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract       | productConcrete                  | active | searchable en | searchable de ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-grey | true   | true          | true          ||
    Zed: change concrete product data:
    ...    || productAbstract       | productConcrete                  | active | searchable en | searchable de ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-blue | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract       | productConcrete                  | store | mode  | type    | currency | amount ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-blue | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract       | productConcrete                  | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-grey | Warehouse1   | 100              | true                            ||
    Zed: change concrete product stock:
    ...    || productAbstract       | productConcrete                  | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-blue | Warehouse1   | 100              | false                           ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract       | name de                        ||
    ...    || zedManageSKU${random} | DEmanageProduct${random} force ||
    Trigger multistore p&s
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     zedManageSKU${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    zedManageSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change variant of the product on PDP on:    grey
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    blue
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: add new concrete product to abstract:
    ...    || productAbstract       | sku                               | autogenerate sku | attribute 1 | name en                  | name de                  | use prices from abstract ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-black | false            | black       | ENaddedConcrete${random} | DEaddedConcrete${random} | true                     ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract       | productConcrete                   | active | searchable en | searchable de ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-black | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract       | productConcrete                   | store | mode  | type    | currency | amount ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-black | DE    | gross | default | €        | 25.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract       | productConcrete                   | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-black | Warehouse1   | 5                | false                           ||
    Zed: update abstract product price on:
    ...    || productAbstract       | store | mode  | type    | currency | amount | tax set           ||
    ...    || zedManageSKU${random} | DE    | gross | default | €        | 150.00 | Smart Electronics ||
    Zed: save abstract product:    zedManageSKU${random}
    Trigger multistore p&s
    Zed: update abstract product price on:
    ...    || productAbstract       | store | mode  | type    | currency | amount | tax set           ||
    ...    || zedManageSKU${random} | DE    | gross | default | €        | 150.00 | Smart Electronics ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract       | name en                         | name de                         ||
    ...    || zedManageSKU${random} | ENUpdatedmanageProduct${random} | DEUpdatedmanageProduct${random} ||
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    zedManageSKU${random}    wait_for_p&s=true
    Yves: product name on PDP should be:    ENUpdatedmanageProduct${random}
    Yves: product price on the PDP should be:    €150.00    wait_for_p&s=true
    Yves: change variant of the product on PDP on:    grey
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    blue
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    black
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product name on PDP should be:    ENaddedConcrete${random}
    Yves: product price on the PDP should be:    €25.00    wait_for_p&s=true
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item zedManageSKU${random}-color-black only has availability of 5.
    Yves: go to PDP of the product with sku:    zedManageSKU${random}
    Yves: change variant of the product on PDP on:    black
    Yves: change quantity on PDP:    3
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    zedManageSKU${random}-color-black    ENaddedConcrete${random}    25.00
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     manageProduct${random}     View
    Zed: view product page is displayed
    Zed: view abstract product page contains:
    ...    || store | sku                   | name                          | variants count ||
    ...    || DE AT | zedManageSKU${random} | UpdatedmanageProduct${random} | 3              ||
    [Teardown]    Run Keywords    Delete dynamic root admin user from DB
    ...    AND    Delete dynamic customer via API