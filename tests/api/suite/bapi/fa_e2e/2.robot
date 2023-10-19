*** Settings ***
Library    BuiltIn
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Test Tags    robot:recursive-stop-on-failure
Resource    ../../../../../resources/common/common.robot
Resource    ../../../../../resources/steps/header_steps.robot
Resource    ../../../../../resources/common/common_yves.robot
Resource    ../../../../../resources/common/common_zed.robot
Resource    ../../../../../resources/steps/pdp_steps.robot
Resource    ../../../../../resources/steps/shopping_lists_steps.robot
Resource    ../../../../../resources/steps/checkout_steps.robot
Resource    ../../../../../resources/steps/customer_registration_steps.robot
Resource    ../../../../../resources/steps/order_history_steps.robot
Resource    ../../../../../resources/steps/product_set_steps.robot
Resource    ../../../../../resources/steps/catalog_steps.robot
Resource    ../../../../../resources/steps/agent_assist_steps.robot
Resource    ../../../../../resources/steps/company_steps.robot
Resource    ../../../../../resources/steps/customer_account_steps.robot
Resource    ../../../../../resources/steps/configurable_bundle_steps.robot
Resource    ../../../../../resources/steps/zed_users_steps.robot
Resource    ../../../../../resources/steps/products_steps.robot
Resource    ../../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../../resources/steps/wishlist_steps.robot
Resource    ../../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../../resources/steps/zed_discount_steps.robot
Resource    ../../../../../resources/steps/zed_cms_page_steps.robot
Resource    ../../../../../resources/steps/zed_customer_steps.robot
Resource    ../../../../../resources/steps/zed_root_menus_steps.robot
Resource    ../../../../../resources/steps/minimum_order_value_steps.robot
Resource    ../../../../../resources/steps/availability_steps.robot
Resource    ../../../../../resources/steps/glossary_steps.robot
Resource    ../../../../../resources/steps/zed_payment_methods_steps.robot
Resource    ../../../../../resources/steps/zed_dashboard_steps.robot
Resource    ../../../../../resources/steps/configurable_product_steps.robot


*** Test Cases ***

Make_user_a_warehouse_user
    Zed: login on Zed with provided credentials:    ${zed_admin_email_de}
    Zed: update Zed user:
    ...    || oldEmail                       | password      | user_is_warehouse_user ||
    ...    || admin_de@spryker.com           | Change123!321 | true                   ||