*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../resources/common/common_api.robot

*** Test Cases ***

######POST#####
Create_customer_address_with_missing_required_fields
    When I get access token for the customer:    ${yves_user_email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"address3": "${default_address3}","country": "${default_country}","iso2Code": "${default_iso2Code}","company":"${default_company}","phone": "${default_phone}"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    422
    And Array in response should contain property with value:    [errors]    detail    salutation => This field is missing.
    And Array in response should contain property with value:    [errors]     detail    salutation => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    firstName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    lastName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    address1 => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    address2 => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    zipCode => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    city => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    isDefaultShipping => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    isDefaultBilling => This field is missing.

Create_customer_address_with_empty_fields
    When I get access token for the customer:    ${yves_user_email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"customer_reference": "","salutation": "","firstName": "","lastName": "","address1": "","address2": "","address3": "","zipCode": "","city": "","country": "","iso2Code": "","company":"","phone": "","isDefaultShipping": "","isDefaultBilling": ""}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    422
    And Array in response should contain property with value:    [errors]    detail    salutation => This value should not be blank.
    And Array in response should contain property with value:    [errors]     detail    salutation => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    firstName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    lastName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    address1 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    address2 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    zipCode => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    city => This value should not be blank.

Create_customer_address_with_customer_reference_not_matching_token
    When I get access token for the customer:    ${yves_user_email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a POST request:    /customers/DE--1/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","isDefaultShipping": False,"isDefaultBilling": False}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    411
    And Response should return error message:    Unauthorized request.

Create_customer_address_with_non_existing_customer_reference
    When I get access token for the customer:    ${yves_user_email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a POST request:    /customers/DE--10000/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","isDefaultShipping": False,"isDefaultBilling": False}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    411
    And Response should return error message:    Unauthorized request.

Create_customer_address_with_empty_customer_reference
    When I get access token for the customer:    ${yves_user_email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a POST request:    /customers//addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","isDefaultShipping": False,"isDefaultBilling": False}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    411
    And Response should return error message:    Unauthorized request.

Create_customer_address_with_empty_type
    When I get access token for the customer:    ${yves_user_email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "","attributes": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","isDefaultShipping": False,"isDefaultBilling": False}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
