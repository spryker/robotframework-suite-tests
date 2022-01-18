*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../resources/common/common_api.robot

*** Test Cases ***
#####POST#####
Create_customer_address_with_all_fields
        [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Cleanup existing customer addresses:    ${yves_user_reference}
    When I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"customer_reference": "${yves_user_reference}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","country": "${default_country}","iso2Code": "${default_iso2Code}","company":"${default_company}","phone": "${default_phone}","isDefaultShipping": False,"isDefaultBilling": False}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    address_uid_1
    And Response body parameter should be:    [data][type]    addresses
    And Response body parameter should be:    [data][attributes][salutation]    ${yves_user_salutation}
    And Response body parameter should be:    [data][attributes][firstName]    ${yves_user_first_name}
    And Response body parameter should be:    [data][attributes][lastName]    ${yves_user_last_name}
    And Response body parameter should be:    [data][attributes][address1]    ${default_address1}
    And Response body parameter should be:    [data][attributes][address2]    ${default_address2}
    And Response body parameter should be:    [data][attributes][address3]    ${default_address3}
    And Response body parameter should be:    [data][attributes][zipCode]    ${default_zipCode}
    And Response body parameter should be:    [data][attributes][city]    ${default_city}
    And Response body parameter should be:    [data][attributes][country]    ${default_country}
    And Response body parameter should be:    [data][attributes][iso2Code]    ${default_iso2Code}
    And Response body parameter should be:    [data][attributes][company]    ${default_company}
    And Response body parameter should be:    [data][attributes][phone]    ${default_phone}
    And Response body parameter should be:    [data][attributes][isDefaultShipping]    True
    And Response body parameter should be:    [data][attributes][isDefaultBilling]    True
    And Response body has correct self link for created entity:    ${address_uid_1}
    [Teardown]    Run Keywords    I send a DELETE request:     /customers/${yves_user_reference}/addresses/${address_uid_1}
    ...    AND    Response status code should be:    204

Create_customer_address_only_required_fields
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Cleanup existing customer addresses:    ${yves_user_reference}
    And I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","isDefaultShipping": False,"isDefaultBilling": False}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    address_uid_1
    And Response body parameter should be:    [data][type]    addresses
    And Response body parameter should be:    [data][attributes][salutation]    ${yves_user_salutation}
    And Response body parameter should be:    [data][attributes][firstName]    ${yves_user_first_name}
    And Response body parameter should be:    [data][attributes][lastName]    ${yves_user_last_name}
    And Response body parameter should be:    [data][attributes][address1]    ${default_address1}
    And Response body parameter should be:    [data][attributes][address2]    ${default_address2}
    And Response body parameter should be:    [data][attributes][address3]    None
    And Response body parameter should be:    [data][attributes][zipCode]    ${default_zipCode}
    And Response body parameter should be:    [data][attributes][city]    ${default_city}
    And Response body parameter should be:    [data][attributes][country]    ${default_country}
    And Response body parameter should be:    [data][attributes][iso2Code]    ${default_iso2Code}
    And Response body parameter should be:    [data][attributes][company]    None
    And Response body parameter should be:    [data][attributes][phone]    None
    And Response body parameter should be:    [data][attributes][isDefaultShipping]    True
    And Response body parameter should be:    [data][attributes][isDefaultBilling]    True
    And Response body has correct self link for created entity:    ${address_uid_1}
    [Teardown]    Run Keywords    I send a DELETE request:     /customers/${yves_user_reference}/addresses/${address_uid_1}
    ...    AND    Response status code should be:    204
    


Create_customer_address_as_shipping_default
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Cleanup existing customer addresses:    ${yves_user_reference}
    And I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","isDefaultShipping": False,"isDefaultBilling": False}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    first_address_uid
    And Response body parameter should be:    [data][attributes][isDefaultShipping]    True
    And Response body parameter should be:    [data][attributes][isDefaultBilling]    True
    When I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","isDefaultShipping": True,"isDefaultBilling": False}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    shipping_address_uid
    And Response body parameter should be:    [data][attributes][isDefaultShipping]    True
    And Response body parameter should be:    [data][attributes][isDefaultBilling]    False
    When I send a GET request:    /customers/${yves_user_reference}/addresses/${first_address_uid}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][attributes][isDefaultShipping]    False
    And Response body parameter should be:    [data][attributes][isDefaultBilling]    True
    [Teardown]    Run Keywords    I send a DELETE request:     /customers/${yves_user_reference}/addresses/${first_address_uid}
    ...    AND    Response status code should be:    204    
    ...    AND    I send a DELETE request:     /customers/${yves_user_reference}/addresses/${shipping_address_uid}
    ...    AND    Response status code should be:    204

Create_customer_address_as_billing_default
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Cleanup existing customer addresses:    ${yves_user_reference}
    And I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"customer_reference": "${yves_user_reference}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","country": "${default_country}","iso2Code": "${default_iso2Code}","company":"${default_company}","phone": "${default_phone}","isDefaultShipping": False,"isDefaultBilling": False}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    first_address_uid
    And Response body parameter should be:    [data][attributes][isDefaultShipping]    True
    And Response body parameter should be:    [data][attributes][isDefaultBilling]    True
    When I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","isDefaultShipping": False,"isDefaultBilling": True}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    shipping_address_uid
    And Response body parameter should be:    [data][attributes][isDefaultShipping]    False
    And Response body parameter should be:    [data][attributes][isDefaultBilling]    True
    When I send a GET request:    /customers/${yves_user_reference}/addresses/${first_address_uid}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][attributes][isDefaultShipping]    True
    And Response body parameter should be:    [data][attributes][isDefaultBilling]    False
    [Teardown]    Run Keywords    I send a DELETE request:     /customers/${yves_user_reference}/addresses/${first_address_uid}
    ...    AND    Response status code should be:    204    
    ...    AND    I send a DELETE request:     /customers/${yves_user_reference}/addresses/${shipping_address_uid}
    ...    AND    Response status code should be:    204

#GET
Get_empty_list_of_customer_addresses
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Cleanup existing customer addresses:    ${yves_user_reference}
    And I send a GET request:    /customers/${yves_user_reference}/addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    Response should contain the array of a certain size:    [data]    0

Get_list_of_customer_addresses_with_1_address
    [Setup]    Run keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Cleanup existing customer addresses:    ${yves_user_reference}
    ...    AND    I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"customer_reference": "${yves_user_reference}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","country": "${default_country}","iso2Code": "${default_iso2Code}","company":"${default_company}","phone": "${default_phone}","isDefaultShipping": False,"isDefaultBilling": False}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /customers/${yves_user_reference}/addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    1
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Save value to a variable:    [data][0][id]    address_uid
    And Response body parameter should be:    [data][0][type]    addresses
    And Response body parameter should be:    [data][0][attributes][salutation]    ${yves_user_salutation}
    And Response body parameter should be:    [data][0][attributes][firstName]    ${yves_user_first_name}
    And Response body parameter should be:    [data][0][attributes][lastName]    ${yves_user_last_name}
    And Response body parameter should be:    [data][0][attributes][address1]    ${default_address1}
    And Response body parameter should be:    [data][0][attributes][address2]    ${default_address2}
    And Response body parameter should be:    [data][0][attributes][address3]    ${default_address3}
    And Response body parameter should be:    [data][0][attributes][zipCode]    ${default_zipCode}
    And Response body parameter should be:    [data][0][attributes][city]    ${default_city}
    And Response body parameter should be:    [data][0][attributes][country]    ${default_country}
    And Response body parameter should be:    [data][0][attributes][iso2Code]    ${default_iso2Code}
    And Response body parameter should be:    [data][0][attributes][company]    ${default_company}
    And Response body parameter should be:    [data][0][attributes][phone]    ${default_phone}
    And Response body parameter should be:    [data][0][attributes][isDefaultShipping]    True
    And Response body parameter should be:    [data][0][attributes][isDefaultBilling]    True
    And Response body has correct self link
    [Teardown]    Run Keywords    I send a DELETE request:     /customers/${yves_user_reference}/addresses/${address_uid}
    ...    AND    Response status code should be:    204

Get_list_of_customer_addresses_with_2_addresses
    [Setup]    Run keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Cleanup existing customer addresses:    ${yves_user_reference}
    ...    AND    I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"customer_reference": "${yves_user_reference}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","country": "${default_country}","iso2Code": "${default_iso2Code}","company":"${default_company}","phone": "${default_phone}","isDefaultShipping": False,"isDefaultBilling": False}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"customer_reference": "${yves_user_reference}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","country": "${default_country}","iso2Code": "${default_iso2Code}","company":"${default_company}","phone": "${default_phone}","isDefaultShipping": False,"isDefaultBilling": False}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /customers/${yves_user_reference}/addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    2
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Save value to a variable:    [data][0][id]    first_address_uid
    And Response body parameter should not be EMPTY:    [data][1][id]
    And Save value to a variable:    [data][1][id]    second_address_uid
    And Response body has correct self link
    [Teardown]    Run Keywords    I send a DELETE request:     /customers/${yves_user_reference}/addresses/${first_address_uid}    
    ...    AND    Response status code should be:    204
    ...    AND    I send a DELETE request:     /customers/${yves_user_reference}/addresses/${second_address_uid}
    ...    AND    Response status code should be:    204

#DELETE
Delete_customer_address
    [Setup]    Run keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Cleanup existing customer addresses:    ${yves_user_reference}
    ...    AND    I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"customer_reference": "${yves_user_reference}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","country": "${default_country}","iso2Code": "${default_iso2Code}","company":"${default_company}","phone": "${default_phone}","isDefaultShipping": False,"isDefaultBilling": False}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a GET request:    /customers/${yves_user_reference}/addresses
    ...    AND    Response status code should be:    200
    ...    AND    Response should contain the array of a certain size:    [data]    1
    ...    AND    Save value to a variable:    [data][0][id]    address_uid
    When I send a DELETE request:     /customers/${yves_user_reference}/addresses/${address_uid}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    When I send a GET request:    /customers/${yves_user_reference}/addresses
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    0


#PATCH
Update_customer_address_several_fields
    [Setup]    Run keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Cleanup existing customer addresses:    ${yves_user_reference}
    ...    AND    I send a POST request:    /customers/${yves_user_reference}/addresses    {"data": {"type": "addresses","attributes": {"customer_reference": "${yves_user_reference}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","country": "${default_country}","iso2Code": "${default_iso2Code}","company":"${default_company}","phone": "${default_phone}","isDefaultShipping": False,"isDefaultBilling": False}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    address_uid
    ...    AND    Response body parameter should be:    [data][attributes][isDefaultBilling]    True
    When I send a PATCH request:    /customers/${yves_user_reference}/addresses/${address_uid}    {"data": {"type": "addresses","attributes": {"address1": "${changed_address1}","address2": "${changed_address2}","address3": "${changed_address3}","phone": "${changed_phone}"}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${address_uid}
    And Response body parameter should be:    [data][type]    addresses  
    And Response body parameter should be:    [data][attributes][salutation]    ${yves_user_salutation}
    And Response body parameter should be:    [data][attributes][firstName]    ${yves_user_first_name}
    And Response body parameter should be:    [data][attributes][lastName]    ${yves_user_last_name}
    And Response body parameter should be:    [data][attributes][address1]    ${changed_address1}
    And Response body parameter should be:    [data][attributes][address2]    ${changed_address2}
    And Response body parameter should be:    [data][attributes][address3]    ${changed_address3}
    And Response body parameter should be:    [data][attributes][zipCode]    ${default_zipCode}
    And Response body parameter should be:    [data][attributes][city]    ${default_city}
    And Response body parameter should be:    [data][attributes][country]    ${default_country}
    And Response body parameter should be:    [data][attributes][iso2Code]    ${default_iso2Code}
    And Response body parameter should be:    [data][attributes][company]    ${default_company}
    And Response body parameter should be:    [data][attributes][phone]    ${changed_phone}
    And Response body parameter should be:    [data][attributes][isDefaultShipping]    True
    And Response body parameter should be:    [data][attributes][isDefaultBilling]    True
    [Teardown]    Run Keywords    I send a DELETE request:     /customers/${yves_user_reference}/addresses/${address_uid}
    ...    AND    Response status code should be:    204