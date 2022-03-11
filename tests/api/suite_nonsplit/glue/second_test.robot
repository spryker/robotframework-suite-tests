*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
My_first_POST_request
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    Log    ${token}
    I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"customer_reference": "${yves_user_reference}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","isDefaultShipping": ${default_shipping_status},"isDefaultBilling": ${default_billing_status}}}}
    Response status code should be:    201
    [Teardown]    Cleanup existing customer addresses:    ${yves_user_reference}