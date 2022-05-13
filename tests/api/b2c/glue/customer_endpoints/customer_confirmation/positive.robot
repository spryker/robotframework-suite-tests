*** Settings ***
Suite Setup    SuiteSetup
Test Setup     TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Customer_confirmation
    [Setup]    Run Keywords    I send a POST request:    /customers    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user_first_name}","lastName":"${yves_third_user_last_name}","gender":"${yves_third_user_gender_male}","salutation":"${yves_third_user_salutation}","email":"${yves_third_user_first_name}.${yves_third_user_last_name}${random}@spryker.com","password":"${yves_third_user_password}","confirmPassword":"${yves_third_user_password}","acceptedTerms":True}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    user_reference_id
    ...    AND    Connect To Database    pymysql    ${db_name}    ${db_user}    ${db_password}    ${db_host}    ${db_port}
    ...    AND    Save value from DB to a variable:    select registration_key from spy_customer where customer_reference = '${user_reference_id}'    confirmation_key
    When I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_third_user_first_name}.${yves_third_user_last_name}${random}@spryker.com
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a DELETE request:    /customers/${user_reference_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
    ...    AND    Disconnect From Database