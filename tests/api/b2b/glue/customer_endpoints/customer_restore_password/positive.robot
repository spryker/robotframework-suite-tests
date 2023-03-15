*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Restore_password_with_all_required_fields_and_valid_data
    [Setup]    Run Keywords    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_user.first_name}","lastName":"${yves_user.last_name}","gender":"${gender.female}","salutation":"${yves_user.salutation}","email":"${email.name}+${random}${email.domain}","password":"${yves_user.password_new}","confirmPassword":"${yves_user.password_new}","acceptedTerms":True}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    user_reference_id
    ...    AND    Save value to a variable:    [data][attributes][email]    user_email
    ...    AND    Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where customer_reference = '${user_reference_id}'    confirmation_key
    ...    AND    I send a POST request:    /customer-confirmation    {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
    ...    AND    I send a POST request:    /customer-forgotten-password    {"data": {"type": "customer-forgotten-password","attributes": {"email":"${user_email}"}}}
    ...    AND    Save the result of a SELECT DB query to a variable:    select restore_password_key from spy_customer where customer_reference = '${user_reference_id}'    restore_key
    When I send a PATCH request:
    ...    /customer-restore-password/${user_reference_id}
    ...    {"data":{"type":"customer-restore-password","id":"${user_reference_id}","attributes":{"restorePasswordKey":"${restore_key}","password":"${yves_user.password}","confirmPassword":"${yves_user.password}"}}}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I get access token for the customer:    ${user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a DELETE request:    /customers/${user_reference_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
