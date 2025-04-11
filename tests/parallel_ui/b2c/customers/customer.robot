*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_two
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/steps/header_steps.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/common/common_zed.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/shopping_lists_steps.robot
Resource    ../../../../resources/steps/checkout_steps.robot
Resource    ../../../../resources/steps/order_history_steps.robot
Resource    ../../../../resources/steps/product_set_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/agent_assist_steps.robot
Resource    ../../../../resources/steps/company_steps.robot
Resource    ../../../../resources/steps/customer_account_steps.robot
Resource    ../../../../resources/steps/zed_users_steps.robot
Resource    ../../../../resources/steps/products_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/steps/zed_customer_steps.robot
Resource    ../../../../resources/steps/zed_discount_steps.robot
Resource    ../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../resources/steps/zed_cms_page_steps.robot
Resource    ../../../../resources/steps/merchant_profile_steps.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/steps/mp_profile_steps.robot
Resource    ../../../../resources/steps/mp_orders_steps.robot
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/mp_products_steps.robot
Resource    ../../../../resources/steps/mp_account_steps.robot
Resource    ../../../../resources/steps/mp_dashboard_steps.robot
Resource    ../../../../resources/steps/zed_root_menus_steps.robot
Resource    ../../../../resources/steps/minimum_order_value_steps.robot
Resource    ../../../../resources/steps/availability_steps.robot
Resource    ../../../../resources/steps/glossary_steps.robot
Resource    ../../../../resources/steps/order_comments_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot
Resource    ../../../../resources/steps/dynamic_entity_steps.robot
Resource    ../../../../resources/steps/customer_registration_steps.robot

*** Test Cases ***
New_Customer_Registration
    [Documentation]    Check that a new user can be registered in the system
    Create dynamic admin user in DB
    Register a new customer with data:
    ...    || salutation | first name | last name | e-mail                            | password                   ||
    ...    || Mr.        | New        | User      | sonia+ui+new${random}@spryker.com | ${default_secure_password} ||
    Yves: flash message should be shown:    success    Almost there! We send you an email to validate your email address. Please confirm it to be able to log in.
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: delete customer:    sonia+ui+new${random}@spryker.com
    ...    AND    Delete dynamic admin user from DB

Guest_User_Access_Restrictions
    [Documentation]    Checks that guest users see products info and cart but not profile
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: header contains/doesn't contain:    true    ${currencySwitcher}[${env}]   ${wishlistIcon}    ${accountIcon}    ${shoppingCartIcon}
    Yves: go to PDP of the product with sku:    002
    Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}    ${addToCartButton}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:   002    Canon IXUS 160    37.50
    Yves: go to user menu:    Overview
    Yves: 'Login' page is displayed
    Yves: go to 'Wishlist' page
    Yves: 'Login' page is displayed

Authorized_User_Access
    [Documentation]    Checks that authorized users see products info, cart and profile
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: header contains/doesn't contain:    true    ${currencySwitcher}[${env}]    ${accountIcon}     ${wishlistIcon}    ${shoppingCartIcon}
    Yves: go to PDP of the product with sku:    002
    Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}     ${addToCartButton}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    002    Canon IXUS 160    37.50
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: go to 'Wishlist' page
    Yves: 'Wishlist' page is displayed

User_Account
    [Documentation]    Checks user account pages work + address management
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: go to user menu:    My Profile
    Yves: 'Profile' page is displayed
    Yves: go to 'Wishlist' page
    Yves: 'Wishlist' page is displayed
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: go to user menu item in the left bar:    Newsletter
    Yves: 'Newsletter' page is displayed
    Yves: go to user menu item in the left bar:    Returns
    Yves: 'Returns' page is displayed
    Yves: create a new customer address in profile:     Mr    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    true    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Yves: delete user address:    Kirncher Str. ${random}
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    false    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create a new customer address in profile:
    ...    || email               | salutation | first name                              | last name                              | address 1          | address 2           | address 3           | city            | zip code  | country | phone     | company          ||
    ...    || ${dynamic_customer} | Mr         | ${yves_second_user_first_name}${random} | ${yves_second_user_last_name}${random} | address 1${random} | address 2 ${random} | address 3 ${random} | Berlin${random} | ${random} | Austria | 123456789 | Spryker${random} ||
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Overview
    Yves: go to user menu item in the left bar:    Addresses
    Yves: check that user has address exists/doesn't exist:    true    ${yves_second_user_first_name}${random}    ${yves_second_user_last_name}${random}    address 1${random}    address 2 ${random}    ${random}    Berlin${random}    Austria
    [Teardown]    Delete dynamic admin user from DB

Add_to_Wishlist
    [Documentation]    Check creation of wishlist and adding to different wishlists
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:  003
    Yves: add product to wishlist:    My wishlist
    Yves: go to 'Wishlist' page
    Yves: create wishlist with name:    Second wishlist
    Yves: go to PDP of the product with sku:  004
    Yves: add product to wishlist:    Second wishlist    select
    Yves: go to 'Wishlist' page
    Yves: go to wishlist with name:    My wishlist
    Yves: wishlist contains product with sku:    003_26138343
    Yves: go to wishlist with name:    Second wishlist
    Yves: wishlist contains product with sku:    004_30663302
    Yves: go to PDP of the product with sku:    ${bundled_product_3_concrete_sku}
    Delete All Cookies
    Yves: try to add product to wishlist as guest user

Reorder
    [Documentation]    Checks that merchant relation is saved with reorder
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains the following products:    Canon IXUS 285
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | Guest     | User     | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:    Reorder    ${lastPlacedOrder}
    Yves: shopping cart contains the following products:    Canon IXUS 285

Update_Customer_Data
    [Documentation]    Checks customer data can be updated from Yves and Zed
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    My Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name | last name | email               ||
    ...    || Ms.        | Dynamic    | Customer  | ${dynamic_customer} ||
    Yves: update customer profile data:
    ...    || salutation | first name                            | last name                            ||
    ...    || Dr.        | updated${yves_second_user_first_name} | updated${yves_second_user_last_name} ||
    Yves: assert customer profile data:
    ...    || salutation | first name                            | last name                            ||
    ...    || Dr.        | updated${yves_second_user_first_name} | updated${yves_second_user_last_name} ||
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: assert customer profile data:
    ...    || email               | salutation | first name                            | last name                            ||
    ...    || ${dynamic_customer} | Dr         | updated${yves_second_user_first_name} | updated${yves_second_user_last_name} ||
    Zed: update customer profile data:
    ...    || email               | salutation | first name                     | last name                     ||
    ...    || ${dynamic_customer} | Mr         | ${yves_second_user_first_name} | ${yves_second_user_last_name} ||
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    My Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name                     | last name                     | email               ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | ${dynamic_customer} ||
    [Teardown]    Delete dynamic admin user from DB

Email_Confirmation
    [Documentation]    Check that a new user cannot login if the email is not verified
    Register a new customer with data:
    ...    || salutation | first name | last name | e-mail                                | password                   ||
    ...    || Mr.        | New        | User      | sonia+ui+fails+${random}@spryker.com  | ${default_secure_password} ||
    Yves: flash message should be shown:    success    Almost there! We send you an email to validate your email address. Please confirm it to be able to log in.
    Yves: login on Yves with provided credentials and expect error:     sonia+ui+fails+${random}@spryker.com     ${default_secure_password}
    [Teardown]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: delete customer:    sonia+ui+fails+${random}@spryker.com
    ...    AND    Delete dynamic admin user from DB