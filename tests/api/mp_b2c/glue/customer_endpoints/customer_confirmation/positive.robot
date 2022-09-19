*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
Customer_confirmation
   [Setup]    Run Keywords    I send a POST request:    /customers    {"data":{"type":"customers","attributes":{"firstName":"${yves_user.first_name}","lastName":"${yves_user.last_name}","gender":"${gender.female}","salutation":"${yves_user.salutation}","email":"${yves_user.first_name}+${random}@spryker.com","password":"${yves_user.password}","confirmPassword":"${yves_user.password}","acceptedTerms":True}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    user_reference_id
    ...    AND    Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where customer_reference = '${user_reference_id}'    confirmation_key
    When I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_user.first_name}+${random}@spryker.com
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a DELETE request:    /customers/${user_reference_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
