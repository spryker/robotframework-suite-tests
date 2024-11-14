*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    
Resource    ../../../../../resources/common/common_yves.robot
Resource    ../../../../../resources/steps/pdp_steps.robot
Resource    ../../../../../resources/steps/products_steps.robot
Resource    ../../../../../resources/steps/catalog_steps.robot
Resource    ../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/common/common_mp.robot
Resource    ../../../../../resources/steps/mp_products_steps.robot
Resource    ../../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../../resources/steps/availability_steps.robot
Resource    ../../../../../resources/steps/configurable_product_steps.robot
Resource    ../../../../../resources/steps/agent_assist_steps.robot
Resource    ../../../../../resources/steps/zed_discount_steps.robot
Resource    ../../../../../resources/steps/zed_users_steps.robot

*** Test Cases ***
Discontinued_Alternative_Products
    [Documentation]    Checks discontinued and alternative products
    Yves: go to PDP of the product with sku:    ${product_with_relations_alternative_products_sku}
    Yves: change variant of the product on PDP on:    2.3 GHz
    Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: delete all wishlists
    Yves: go to PDP of the product with sku:    ${discontinued_product_concrete_sku}
    Yves: add product to wishlist:    My wishlist
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: discontinue the following product:    ${discontinued_product_abstract_sku}    ${discontinued_product_concrete_sku}
    Zed: product is successfully discontinued
    Zed: check if at least one price exists for concrete and add if doesn't:    100
    Zed: add following alternative products to the concrete:    012
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to 'Wishlist' page
    Yves: go to wishlist with name:    My wishlist
    Yves: product with sku is marked as discountinued in wishlist:    ${discontinued_product_concrete_sku}
    Yves: product with sku is marked as alternative in wishlist:    012
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}    
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: undo discontinue the following product:    ${discontinued_product_abstract_sku}    ${discontinued_product_concrete_sku}
    ...    AND    Trigger p&s

Product_Original_Price
    [Setup]    Run Keywords    Create new dynamic root admin user in DB
    ...    AND    Create new approved dynamic customer in DB
    [Documentation]    checks that Orignal price is displayed on the PDP and in Catalog
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: start new abstract product creation:
    ...    || sku                     | store | name en                  | name de                    | new from   | new to     ||
    ...    || zedOriginalSKU${random} | DE    | originalProduct${random} | DEoriginalProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 | attribute 2 | attribute value 2 ||
    ...    || color       | grey              | color       | blue              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set           ||
    ...    || DE    | gross | default | €        | 100.00 | Smart Electronics ||
    Zed: update abstract product price on:
    ...    || store | mode  | type     | currency | amount | tax set           ||
    ...    || DE    | gross | original | €        | 200.00 | Smart Electronics ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract         | productConcrete                    | active | searchable en | searchable de ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-grey | true   | true          | true          ||
    Zed: change concrete product data:
    ...    || productAbstract         | productConcrete                    | active | searchable en | searchable de ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-blue | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract         | productConcrete                    | store | mode  | type    | currency | amount ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-blue | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract         | productConcrete                    | store | mode  | type     | currency | amount ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-blue | DE    | gross | original | €        | 50.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract         | productConcrete                    | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-grey | Warehouse1   | 100              | true                            ||
    Zed: change concrete product stock:
    ...    || productAbstract         | productConcrete                    | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-blue | Warehouse1   | 100              | false                           ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract         | name de                        ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random} forced ||
    Trigger multistore p&s
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     zedOriginalSKU${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to URL:    en/search?q=zedOriginalSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: 1st product card in catalog (not)contains:     Original Price    €200.00
    Yves: go to PDP of the product with sku:    zedOriginalSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €200.00
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change variant of the product on PDP on:    blue
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €50.00
    [Teardown]    Run Keywords    Delete dynamic root admin user from DB
    ...    AND    Delete dynamic customer via API

Offer_Availability_Calculation
    [Documentation]    check offer availability
    [Setup]    Repeat Keyword    3    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku      | product name          | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || offAvKU${random} | offAvProduct${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    offAvProduct${random}
    MP: click on a table row that contains:     offAvProduct${random}
    MP: fill abstract product required fields:
    ...    || product name          | store | store 2 | tax set        ||
    ...    || offAvProduct${random} | DE    | AT      | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 90             ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 2           | AT    | EUR      | 200           | 90             ||
    MP: save abstract product 
    MP: click on a table row that contains:    offAvProduct${random}
    MP: open concrete drawer by SKU:    offAvKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 5              | true              | en_US         ||
    MP: open concrete drawer by SKU:    offAvKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 2          | AT    | EUR      | 50            || 
    MP: save concrete product
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     offAvProduct${random}     Approve
    Trigger p&s
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    offAvKU${random}-1
    MP: click on a table row that contains:    offAvKU${random}-1
    MP: fill offer fields:
    ...    || is active | merchant sku      | store | stock quantity ||
    ...    || true      | offAvMKU${random} | DE    | 5              ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | CHF      | 100           ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 2          | DE    | EUR      | 200           | 1        ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 3          | AT    | EUR      | 10            | 1        ||
    MP: save offer
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: delete all user addresses
    Yves: create new 'Shopping Cart' with name:    offAvailability${random}
    Yves: go to PDP of the product with sku:     offAvKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: merchant's offer/product price should be:    Spryker    €200.00
    Yves: select xxx merchant's offer:    Spryker
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 5.
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity on PDP:    3
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    offAvailability${random}
    Yves: assert merchant of product in cart or list:    offAvKU${random}-1    Spryker
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Standard
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 2.
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Cancel
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: create new 'Shopping Cart' with name:    offUpdatedAvailability${random}
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 5.
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity on PDP:    3
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    offUpdatedAvailability${random}
    Yves: assert merchant of product in cart or list:    offAvKU${random}-1    Spryker
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: delete all user addresses
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:      offAvProduct${random}     Deny
    ...    AND    Trigger multistore p&s

Product_Availability_Calculation
    [Documentation]    Check product availability + multistore
    [Setup]    Run Keywords    Repeat Keyword    3    Trigger multistore p&s
    ...    AND    Create new dynamic root admin user in DB
    ...    AND    Create new approved dynamic customer in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: update warehouse:    
    ...    || warehouse  | store || 
    ...    || Warehouse1 | AT    ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: start new abstract product creation:
    ...    || sku                      | store | store 2 | name en                      | name de                        | new from   | new to     ||
    ...    || availabilitySKU${random} | DE    | AT      | availabilityProduct${random} | DEavailabilityProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 ||
    ...    || color       | grey              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set           ||
    ...    || DE    | gross | default | €        | 100.00 | Smart Electronics ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set           ||
    ...    || AT    | gross | default | €        | 200.00 | Smart Electronics ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract          | productConcrete                     | active | searchable en | searchable de ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-color-grey | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract          | productConcrete                     | store | mode  | type    | currency | amount ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-color-grey | DE    | gross | default | €        | 50.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract          | productConcrete                     | store | mode  | type    | currency | amount ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-color-grey | AT    | gross | default | €        | 75.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract          | productConcrete                     | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-color-grey | Warehouse1   | 5                | false                           ||
    Trigger multistore p&s
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     availabilitySKU${random}     Approve
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: create new default customer address in profile
    Yves: go to PDP of the product with sku:    availabilitySKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-color-grey only has availability of 5.
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: change quantity on PDP:    3
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed    
    Trigger oms
    Yves: get the last placed order ID by current customer
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-color-grey only has availability of 2.
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Cancel
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-color-grey only has availability of 5.
    Yves: go to AT store 'Home' page if other store not specified:
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: update warehouse:    
    ...    || warehouse  | unselect store || 
    ...    || Warehouse1 | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to AT store 'Home' page if other store not specified:
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: update warehouse:    
    ...    || warehouse  | unselect store || 
    ...    || Warehouse1 | AT             ||
    ...    AND    Repeat Keyword    3    Trigger multistore p&s
    ...    AND    Delete dynamic root admin user from DB
    ...    AND    Delete dynamic customer via API

Configurable_Product_PDP_Wishlist_Availability
    [Documentation]    Configure product from PDP and Wishlist + availability case.
    [Setup]    Run keywords   Create new dynamic root admin user in DB
    ...    AND    Create new approved dynamic customer in DB
    ...    AND    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    ...    AND    Yves: create new 'Whistist' with name:    configProduct${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product price on the PDP should be:    ${configurable_product_price_without_configurations}
    Yves: product configuration status should be equal:      Configuration is not complete.
    Yves: check and go back that configuration page contains:
    ...    || store | locale | price_mode | currency | sku                                  ||
    ...    || DE    | en_US  | GROSS_MODE | EUR      | ${configurable_product_concrete_sku} ||
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 517        | 275        ||
    Yves: product configuration price should be:    ${configurable_product_price_without_configurations}
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 2 | Option Two: Option Two title 4 ||
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 389.50     | 210        ||
    Yves: product configuration price should be:    932.99
    Yves: product configuration notification is:    No item available for your configuration
    Yves: back to PDP and not save configuration
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 607        | 249        ||
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: product price on the PDP should be:    ${configurable_product_price_without_configurations}
    Yves: add product to wishlist:    configProduct${random}    select
    Yves: go to wishlist with name:    configProduct${random}
    Yves: wishlist contains product with sku:    ${configurable_product_concrete_sku}
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 3 | Option Two: Option Two title 3 ||
    Yves: change the product options in configurator to:
    ...    || option one    | option two ||
    ...    || 389.50        | 275        ||
    Yves: product configuration price should be:    ${configurable_product_price_with_options} 
    Yves: save product configuration
    Yves: add all available products from wishlist to cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_sku}    productName=${configurable_product_name}    productPrice=${configurable_product_price_with_options}
    [Teardown]    Run Keywords    Delete dynamic root admin user from DB
    ...    AND    Delete dynamic customer via API

Configurable_Product_PDP_Shopping_List
    [Documentation]    Configure products from both the PDP and the Shopping List. Verify the availability of five items. Ensure that products that have not been configured cannot be purchased.
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    configProduct+${random}
    ...    AND    Yves: create new 'Shopping List' with name:    configProduct+${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: add product to the shopping cart
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: checkout is blocked with the following message:    This cart can't be processed. Please configure items inside the cart.
    Yves: delete product from the shopping cart with sku:    ${configurable_product_concrete_sku}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: check and go back that configuration page contains:
    ...    || store | locale | price_mode | currency | customer_id                          | sku                                  ||
    ...    || DE    | en_US  | GROSS_MODE | EUR      | ${yves_company_user_buyer_reference} | ${configurable_product_concrete_sku} ||
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 607        | 275        ||
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 517        | 167        ||
    Yves: product configuration notification is:     Only 5 items available 
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 2 | Option Two: Option Two title 1 ||
    Yves: product configuration status should be equal:      Configuration complete! 
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item ${configurable_product_concrete_sku} only has availability of 5.
    Yves: go to PDP of the product with sku:   ${configurable_product_abstract_sku}
    Yves: change quantity on PDP:    5
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    configProduct+${random}
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 517        | 249        ||
    Yves: save product configuration
    ### bug: https://spryker.atlassian.net/browse/CC-33647
    Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_sku}    ${configurable_product_name}    €249.00
    Yves: delete product from the shopping cart with name:    ${configurable_product_name}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: add product to the shopping list:    configProduct+${random}
    Yves: go to 'Shopping Lists' page
    Yves: view shopping list with name:    configProduct+${random}
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 607        | 275        ||
    Yves: save product configuration
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 3 | Option Two: Option Two title 4 ||
    Yves: add all available products from list to cart
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 3 | Option Two: Option Two title 4 ||
    Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_sku}    ${configurable_product_name}    €882.00
    [Teardown]    Run Keywords    Yves: delete 'Shopping List' with name:    configProduct+${random}
    ...    AND    Yves: delete 'Shopping Cart' with name:    configProduct+${random}

Configurable_Product_RfQ_OMS
    [Documentation]    Conf Product in RfQ, OMS, Merchant OMS and reorder. 
    [Setup]    Run keywords    Create new dynamic root admin user in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: deactivate all discounts from Overview page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: delete all user addresses
    Yves: create new 'Shopping Cart' with name:    confProductCart+${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 607        | 275        ||
    Yves: save product configuration    
    Yves: add product to the shopping cart
    Yves: submit new request for quote
    Yves: click 'Send to Agent' button on the 'Quote Request Details' page   
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    ${dynamic_admin_user}
    Yves: go to 'Agent Quote Requests' page through the header
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Waiting
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: 'Quote Request Details' page is displayed
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: click 'Edit Items' button on the 'Quote Request Details' page
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 517        | 249        ||
    Yves: save product configuration    
    Yves: click 'Save and Back to Edit' button on the 'Quote Request Details' page
    Yves: click 'Send to Customer' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu:    Quote Requests
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Ready
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: click 'Convert to Cart' button on the 'Quote Request Details' page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €771.90
    Zed: go to order page:    ${lastPlacedOrder} 
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to order page:    ${lastPlacedOrder} 
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: trigger all matching states inside this order:    skip picking
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of xxx order item inside xxx shipment:    Ship    1
    Zed: trigger matching state of xxx order item inside xxx shipment:    Deliver    1
    Zed: trigger matching state of xxx order item inside xxx shipment:    Refund    1
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu:    Order History
    Yves: 'View Order/Reorder/Return' on the order history page:     View Order
    Yves: 'Order Details' page is displayed
    ### Reorder ###
    Yves: reorder all items from 'Order Details' page
    Yves: go to the shopping cart through the header with name:    Cart from order ${lastPlacedOrder}
    Yves: 'Shopping Cart' page is displayed
    # ### bug: https://spryker.atlassian.net/browse/CC-33647
    # Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_sku}    ${configurable_product_name}    €766.00
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 2 | Option Two: Option Two title 3 ||
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: activate following discounts from Overview page:    	Free mobile phone    20% off cameras products    Free Acer M2610 product    Free delivery    10% off Intel products    5% off white products    Tuesday & Wednesday $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Delete dynamic root admin user from DB
