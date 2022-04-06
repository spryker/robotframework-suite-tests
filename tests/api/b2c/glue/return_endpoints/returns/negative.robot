*** Settings ***
Suite Setup       SuiteSetup
Default Tags      glue
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***

 ####POST####
Create_a_return_with_Invalid_access_token
     [Setup]    I set Headers:    Authorization=3485h7
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${random}","reason":"${return_resaon}"}]}}}
    Then Response status code should be:     401
    And Response reason should be:     Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001

Create_a_return_with_without_access_token
     [Setup]    I set Headers:    Authorization=
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${random}","reason":"${return_resaon}"}]}}}
    Then Response status code should be:     403
    And Response reason should be:     Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Create_return_for_order_item_that_cannot_be_returned
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"GROSS_MODE","currency":"EUR","store":"DE"}}}
    ...    AND    I send a GET request:    /customers/${yves_second_user_reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_with_stock_and_never_out_of_stock}","quantity":"1"}}}
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default_address1}","address2": "${default_address2}","address3": "${default_address3}","zipCode": "${default_zipCode}","city": "${default_city}","iso2Code": "${default_iso2Code}","company": "${default_company}","phone": "${default_phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_product_sku}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    Uuid
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_resaon}"}]}}}
    Then Response status code should be:     422
    And Response reason should be:     Unprocessable Entity
    And Response should return error message:    "Return cant be created."    
    And Response should return error code:    3601

Create_return_with_invalid_returnItems_uuid
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${random}","reason":"${return_resaon}"}]}}}
    Then Response status code should be:     422
    And Response reason should be:     Unprocessable Entity
    And Response should return error message:    "Return cant be created."    
    And Response should return error code:    3601

Create_return_without_returnItems_uuid
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"","reason":"${return_resaon}"}]}}}
    Then Response status code should be:     422
    And Response reason should be:     Unprocessable Entity
    And Response should return error message:    "Return cant be created."    
    And Response should return error code:    3601

Create_return_without_returnItems_reason
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"DE","returnItems":[{"salesOrderItemUuid":"${random}","reason":""}]}}}
    Then Response status code should be:     422
    And Response reason should be:     Unprocessable Entity
    And Response should return error message:    "Return cant be created."    
    And Response should return error code:    3601


####GET####
Get_lists_of_returns_with_Invalid_access_token
     [Setup]    I set Headers:    Authorization=3485h7
    When I send a GET request:     /returns
    Then Response status code should be:     401
    And Response reason should be:     Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001


Get_lists_of_returns_without_access_token
     [Setup]    I set Headers:    Authorization=
    When I send a GET request:     /returns
    Then Response status code should be:     403
    And Response reason should be:     Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002


####GET####
Get_return_by_Id_with_Invalid_access_token
     [Setup]    I set Headers:    Authorization=3485h7
    When I send a GET request:     /returns/${random}
    Then Response status code should be:     401
    And Response reason should be:     Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001


Get_return_by_Id_without_access_token
     [Setup]    I set Headers:    Authorization=
    When I send a GET request:     /returns/${random}
    Then Response status code should be:     403
    And Response reason should be:     Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002


Get_return_by_Id_with_Invalid_return_reference
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:     /returns/${random}
    Then Response status code should be:     404
    And Response reason should be:     Not Found
    And Response should return error message:    "Cant find return by the given return reference."
    And Response should return error code:    3602

