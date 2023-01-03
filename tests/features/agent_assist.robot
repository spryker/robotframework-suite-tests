*** Settings ***
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Resource    ../../resources/steps/agent_assist_steps.robot
Resource    ../../resources/common/common.robot
Resource    ../../resources/steps/header_steps.robot
Resource    ../../resources/common/common_yves.robot
Resource    ../../resources/common/common_zed.robot
Resource    ../../resources/steps/pdp_steps.robot
Resource    ../../resources/steps/shopping_lists_steps.robot
Resource    ../../resources/steps/checkout_steps.robot
Resource    ../../resources/steps/order_history_steps.robot
Resource    ../../resources/steps/product_set_steps.robot
Resource    ../../resources/steps/catalog_steps.robot
Resource    ../../resources/steps/company_steps.robot
Resource    ../../resources/steps/customer_account_steps.robot
Resource    ../../resources/steps/configurable_bundle_steps.robot
Resource    ../../resources/pages/yves/yves_shopping_cart_page.robot
Resource    ../../resources/pages/yves/yves_agent_assist_page.robot
Resource    ../../resources/steps/zed_users_steps.robot


*** Test Cases ***
Agent_Assist_Impersonate_As_Customer
    [Documentation]    This test case checks the overall possibility to create an agent user in Zed, login with his credentials in Yves and impersonate as a customer.
    [Tags]    suite-nonsplit    b2c    b2b    all
    Zed: login on Zed with provided credentials:    ${zed_admin_email}    ${zed_admin_password}    
    Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change123    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent+${random}@spryker.com
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    ${yves_user_first_name}
    Yves: agent widget contains:    ${yves_user_email}
    Yves: as an agent login under the customer:    ${yves_user_email}
    Yves: header contains/doesn't contain:    false    ${customerSearchWidget}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: delete Zed user with the following email:    agent+${random}@spryker.com

# Agent_Assist_Impersonate_As_Customer_Merchant_Prices
#     [Documentation]    This test case checks the overall possibility to create an agent user in Zed, login with his credentials in Yves and impersonate as a customer.
#     [Tags]    b2b
#     Zed: login on Zed with provided credentials:    ${zedAdminEmail}    ${zedAdminPassword}    
#     Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change123    Agent    Assist    Root group    This user is an agent    en_US
#     Yves: go to the 'Home' page
#     Yves: go to URL:    agent/login
#     Yves: login on Yves with provided credentials:    agent+${random}@spryker.com
#     Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
#     Yves: perform search by customer:    ${yvesUserFirstName}
#     Yves: agent widget contains:    ${yvesUserEmail}
#     Yves: as an agent login under the customer:    ${yvesUserEmail}
#     Yves: perform search by:    EUROKRAFT trolley - with open shovel
#     Yves: product with name in the catalog should have price:    EUROKRAFT trolley - with open shovel    €188.34
#     Yves: go to PDP of the product with sku:    M70208
#     Yves: product price on the PDP should be:    €188.34

# Agent_Assist_Overview_B2B
#     [Documentation]    This test case checks that an agent in a B2B shop has a menu for request for quote
#     [Tags]    b2b    suite_nonsplit 
#     Zed: login on Zed with provided credentials:    admin@spryker.com
#     Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change123    Agent    Assist    Root group    This user is an agent    en_US
#     Yves: go to the 'Home' page
#     Yves: go to URL:    agent/login
#     Yves: login on Yves with provided credentials:    agent+${random}@spryker.com
#     Yves: header contains/doesn't contain:    true    ${quote_request_agent_widget}
#     Click    ${agent_assist_overview_link}
#     
#     Page Should Contain Element    ${agent_assist_menu_overview}
#     Page Should Contain Element    ${agent_assist_menu_quote_request}

# Agent_Assist_Overview_B2C
#     [Documentation]    This test case checks that an agent in a B2C shop has no menu for request for quote
#     [Tags]    b2c
#     Zed: login on Zed with provided credentials:    admin@spryker.com
#     Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change123    Agent    Assist    Root group    This user is an agent    en_US
#     Yves: go to the 'Home' page
#     Yves: go to URL:    agent/login
#     Yves: login on Yves with provided credentials:    agent+${random}@spryker.com
#     Yves: header contains/doesn't contain:    false    ${quote_request_agent_widget}
#     Click    ${agent_assist_overview_link}
#     
#     Page Should Contain Element    ${agent_assist_menu_overview}
#     Page Should Not Contain Element    ${agent_assist_menu_quote_request}

# Agent_Request_For_Quote
#     [Documentation]    In this test is checked, that an agent can process a request for quote.
#     [Tags]    b2b    suite_nonsplit 
#     Yves: login on Yves with provided credentials:    sonia@spryker.com
#     Yves: create new 'Shopping Cart' with name:    QuoteRequest+${random}
#     Yves: go to PDP of the product with sku:    M70208
#     Yves: add product to the shopping cart
#     Yves: go to the shopping cart through the header with name:    QuoteRequest+${random}
#     Yves: convert a cart to a quote request
#     Zed: login on Zed with provided credentials:    admin@spryker.com
#     Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change123    Agent    Assist    Root group    This user is an agent    en_US
#     Yves: go to the 'Home' page
#     Yves: go to URL:    agent/login
#     Yves: login on Yves with provided credentials:    agent+${random}@spryker.com
#     Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
#     Yves: perform search by customer:    Karl
#     Yves: agent widget contains:    karl@spryker.com
#     Yves: as an agent login under the customer:    karl@spryker.com
#     Yves: perform search by:    EUROKRAFT trolley - with open shovel
#     Yves: product with name in the catalog should have price:    EUROKRAFT trolley - with open shovel    €188.34
#     Yves: go to PDP of the product with sku:    M70208
#     Yves: product price on the PDP should be:    €188.34



