*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***

ENABLER
    TestSetup
# need receive the confirmation key from email
# Customer_confirmation
#     [Setup]    Run Keywords    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user_first_name}","lastName":"${yves_third_user_last_name}","gender":"${gender_male}","salutation":"${yves_third_user_salutation}","email":"${email_name}${random}${email_domain}","password":"${yves_third_user_password}","confirmPassword":"${yves_third_user_password}","acceptedTerms":True}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    userId
#     And I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
#     Response status code should be:    204
#     And Response reason should be:    No Content
#     [Teardown]    Run Keywords    I get access token for the customer:    ${email_name}${random}${email_domain}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
#     ...    AND    I send a DELETE request:    /customers/${userId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content