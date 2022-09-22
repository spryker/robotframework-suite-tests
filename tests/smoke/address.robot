*** Settings ***
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Resource    ../../resources/common/common.robot
Resource    ../../resources/pages/yves/Yves_b2c_variable.robot
Resource    ../../resources/steps/Yves_b2c_logic.robot
Resource    ../../resources/pages/zed/zed_login_page.robot
Resource    ../../resources/steps/zed_b2c.robot
Resource    ../../resources/steps/shopping_lists_steps.robot

*** Test Cases ***
Add_new_address_in_Customer's_profile  
    Yves:login:    ${yves_second_user_email}    ${yves_second_user_password}
    Yves:Address registration through customer profile
    ...    || street               | house_no        |    post_code        |    city    |    phone    ||
    ...    || ${random}          | ${random}   |    ${random}    |    Berlin${random}   |    ${random}        ||
     Yves:message should be shown:    success    Address was successfully added
    [Teardown]    Run Keywords     Yves: delete address
     ...    AND         Yves: logout
Add_new_address_in_Checkout_and_save_it    
    Yves:login:    ${yves_second_user_email}    ${yves_second_user_password}
    Yves: Checkout
    Yves:Address registration through checkout process
     ...    || shipping_first_name               |     shipping_last_name                    |    shipping_street        |    shipping_house_no      |    shipping_city          |    shipping_post_code    |    shipping_phone        ||
    ...     || ${yves_second_user_first_name}    |     ${yves_second_user_last_name}         |    ${random}              |    ${random}              |    Berlin${random}        |   ${random}              |    ${random}       ||
     Yves: navigate to address section
     [Teardown]    Run Keywords     Yves: delete address
     ...    AND     Yves: logout
Change_address_in_yves
    Yves:login:    ${yves_second_user_email}    ${yves_second_user_password}
    Yves:Address registration through customer profile
    ...    || street               | house_no        |    post_code        |    city    |    phone    ||
    ...    || ${random}            | ${random}   |    ${random}    |    India${random}   |    ${random}        ||
    Yves:click edit
    Yves:clear text in address
    Yves:change address:
    ...    || street               | house_no        |    post_code        |    city                 |    phone            ||
    ...    || ab${random}          | ${random}       |    ${random}        |    Frankfurt${random}   |    ${random}        ||
    Yves:message should be shown:    success    Address was successfully updated
    [Teardown]    Run Keywords     Yves: delete address
     ...    AND       Yves: logout
Delete_address_in_Yves
    Yves:login:    ${yves_second_user_email}    ${yves_second_user_password}
    Yves:Address registration through customer profile
    ...    || street               | house_no        |    post_code        |    city    |    phone    ||
    ...    || ${random}            | ${random}   |    ${random}    |    India${random}   |    ${random}        ||
   Yves: delete address
    Yves:message should be shown:    success    Address deleted successfully   
Add_new_address_view_mode
    Zed:login:    ${zed_admin_email}    ${zed_admin_password}
    Zed:customer address navigation
    Zed:New address registraton:
    ...    ||     customer_first_name              | customer_last_name              |    address line 1        |    address line 2        |    customer_zipcode    |    customer_phone    |    customer_city    ||
    ...    || himanshu      | ${yves_second_user_last_name}   |   abc${random}           |   street${random}        |    ${random}          |   123${random}        |        India      ||   
    [Teardown]    Run Keywords    Delete All Cookies
    ...    AND    Reload
    ...    AND    Yves:login:    ${yves_second_user_email}    ${yves_second_user_password}
    ...    AND    Yves: address navigation
    ...    AND    Yves: delete address
    ...    AND     Delete All Cookies
     ...    AND    Reload
Change_address_in_Zed
    Zed:login:    ${zed_admin_email}    ${zed_admin_password}
    Zed:Edit customer address:
    Zed:message should be shown:    success    Customer was updated successfully.
     [Teardown]    Run Keywords    Delete All Cookies
    ...    AND       Reload
