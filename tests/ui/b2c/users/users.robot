*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one
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

*** Test Cases ***
Agent_Assist
    [Documentation]    Checks that agent can be used.
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new Zed user with the following data:    agent+${random}@spryker.com    ${default_secure_password}    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent+${random}@spryker.com    ${default_secure_password}
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    ${yves_second_user_first_name}
    Yves: agent widget contains:    ${yves_second_user_email}
    Yves: as an agent login under the customer:    ${yves_second_user_email}
    Yves: end customer assistance
    Yves: perform search by customer:    ${yves_second_user_last_name}
    Yves: agent widget contains:    ${yves_second_user_email}
    Yves: as an agent login under the customer:    ${yves_second_user_email}
    Yves: end customer assistance
    Yves: perform search by customer:    ${yves_second_user_email}
    Yves: agent widget contains:    ${yves_second_user_email}
    Yves: as an agent login under the customer:    ${yves_second_user_email}
    Yves: perform search by:    020
    Yves: product with name in the catalog should have price:    Sony Cyber-shot DSC-W830    €105.80
    Yves: go to PDP of the product with sku:    020
    Yves: product price on the PDP should be:    €105.80
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: fill in the following new shipping address:
    ...    || firstName                         |     lastName                          |    street          |    houseNumber      |    city                |    postCode     |    phone         ||
    ...    || ${yves_second_user_first_name}    |     ${yves_second_user_last_name}     |    ${random}       |    ${random}        |    Berlin${random}     |   ${random}     |    ${random}     ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:     Standard: €4.90
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: get the last placed order ID by current customer
    Yves: end customer assistance
    Yves: logout as an agent
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to 'Order History' page
    Yves: 'Order History' page contains the following order with a status:    ${lastPlacedOrder}    ${order_state}
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    agent+${random}@spryker.com

User_Control
    [Documentation]    Create a user with limited access
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new role with name:    controlRole${random}
    Zed: apply access permissions for user role:    ${full_access}    ${full_access}    ${full_access}   ${permission_allow}
    Zed: apply access permissions for user role:    ${bundle_access}    ${controller_access}    ${action_access}    ${permission_deny}
    Zed: create new group with role assigned:   controlGroup${random}    controlRole${random}
    Zed: create new Zed user with the following data:    sonia+control${random}@spryker.com   ${default_secure_password}    First Control    Last Control    ControlGroup${random}    This user is an agent    en_US
    Zed: login on Zed with provided credentials:   sonia+control${random}@spryker.com    ${default_secure_password}
    Zed: go to second navigation item level:    Catalog    Attributes
    Zed: click button in Header:    Create Product Attribute
    Zed: validate the message when permission is restricted:    Access denied
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: deactivate the created user:    sonia+control${random}@spryker.com
    Zed: login with deactivated user/invalid data:    sonia+control${random}@spryker.com    ${default_secure_password}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Users    User Roles
    ...    AND    Zed: click Action Button in a table for row that contains:    controlRole${random}    Delete
