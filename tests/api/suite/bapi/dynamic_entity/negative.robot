*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

Get_list_of_country_with_invalid_token
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    country
    Create dynamic entity configuration in Database:    country    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    
    ### GET TOKEN ###
    When I set Headers:    Content-Type=application/x-www-form-urlencoded
    And I send a POST request with data:    /token    'grantType=password&username=admin@spryker.com&password=change123'
    Then Response status code should be:    200
    And Response body parameter should be:    [token_type]    Bearer
    And Response body parameter should be greater than:   [expires_in]    0
    And Response body parameter should be less than:   [expires_in]    30000
    And Response body parameter should not be EMPTY:   [token_type]
    And Response body parameter should not be EMPTY:   [access_token]
    And Response body parameter should not be EMPTY:   [refresh_token]
    When Save value to a variable:    [access_token]    token
    
    ### GET WITH INVALID TOKEN ###
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /dynamic-entity/country
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
    ### GET WITH INVALID PREFIX ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity-invalid/country
    Then Response status code should be:    404
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][message]    Not found
    And Response body parameter should be:    [0][status]    404
    And Response body parameter should be:    [0][code]    007
    ### GET WITH INVALID PREFIX ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/invalid-resource
    Then Response status code should be:    404
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][message]    Not found
    And Response body parameter should be:    [0][status]    404
    And Response body parameter should be:    [0][code]    007
    ### GET COUNTRY WITH INVALID ID ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country/9999999
    Then Response status code should be:    404
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][message]    The entity could not be found in the database.
    And Response body parameter should be:    [0][status]    404
    And Response body parameter should be:    [0][code]    504

Create_country_with_invalid_body
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    country
    Delete dynamic entity configuration in Database:    availability-abstract
    Create dynamic entity configuration in Database:    country    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    Create dynamic entity configuration in Database:    availability-abstract    spy_availability_abstract     1    {"identifier":"id_availability_abstract","fields":[{"fieldName":"id_availability_abstract","fieldVisibleName":"id_availability_abstract","isEditable":false,"isCreatable":false,"type":"integer"},{"fieldName":"fk_store","fieldVisibleName":"fk_store","isEditable":true,"isCreatable":true,"type":"integer","validation":{"isRequired":true,"min":1,"max":2}},{"fieldName":"abstract_sku","fieldVisibleName":"abstract_sku","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"minLength":0,"maxLength":255}},{"fieldName":"quantity","fieldVisibleName":"quantity","type":"decimal","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"precision":20,"scale":10}}]}

    ### GET TOKEN ###
    When I set Headers:    Content-Type=application/x-www-form-urlencoded
    And I send a POST request with data:    /token    'grantType=password&username=admin@spryker.com&password=change123'
    Then Response status code should be:    200
    And Response body parameter should be:    [token_type]    Bearer
    And Response body parameter should be greater than:   [expires_in]    0
    And Response body parameter should be less than:   [expires_in]    30000
    And Response body parameter should not be EMPTY:   [token_type]
    And Response body parameter should not be EMPTY:   [access_token]
    And Response body parameter should not be EMPTY:   [refresh_token]
    When Save value to a variable:    [access_token]    token
    
    ### POST WITH EMPTY BODY ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/country   ''
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    Invalid or missing data format. Please ensure that the data is provided in the correct format
    And Response body parameter should be:    [0][code]    501
    ### POST WITH EMPTY JSON ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/country   {}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    Invalid or missing data format. Please ensure that the data is provided in the correct format
    And Response body parameter should be:    [0][code]    501    
    ### POST WITH EMPTY DATA ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/country   {"data": []}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    Invalid or missing data format. Please ensure that the data is provided in the correct format
    And Response body parameter should be:    [0][code]    501
    ### POST WITH INVALID DATA ###
    Delete country by iso2_code in Database:   XX
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/country   {"data":[{"iso2_code":"XX","name":"XXX"}]}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    The required field must not be empty. Field: iso3_code
    And Response body parameter should be:    [0][code]    509
    And Response body parameter should contain:    [0][status]   400
    ### POST WITH INVALID RESOURCE NAME ###
    Delete country by iso2_code in Database:   XX
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/cnt   {"data":[{"iso2_code":"XX","name":"XXX"}]}
    Then Response status code should be:    404
    And Response body parameter should contain:    [0][message]    Not found
    And Response body parameter should be:    [0][code]    007
    And Response body parameter should contain:    [0][status]   404
    ### POST WITH INVALID FIELD VALUE ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/country   {"data":[{"iso2_code":"X","iso3_code":"XXXX","name":""}]}
    Then Response status code should be:    400
    And Response should contain the array of a certain size:   $    3
    And Response body parameter should contain:    [0][message]    Invalid data value for field. Field rules: max_length: 2, min_length: 2, is_required: 1
    And Response body parameter should be:    [0][code]    508
    And Response body parameter should contain:    [0][status]   400
    And Response body parameter should contain:    [1][message]    Invalid data value for field. Field rules: max_length: 3, min_length: 3, is_required: 1
    And Response body parameter should be:    [1][code]    508
    And Response body parameter should contain:    [1][status]   400
    And Response body parameter should contain:    [2][message]    Invalid data value for field. Field rules: max_length: 255, min_length: 1, is_required: 1
    And Response body parameter should be:    [2][code]    508
    And Response body parameter should contain:    [2][status]   400
    ### POST WITH INVALID DATA DECIAMAL AND INTEGER ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/availability-abstract   {"data":[{"fk_store":100,"abstract_sku":"999","quantity":"1000000000.00005000000001"}]}
    Then Response status code should be:    400
    And Response should contain the array of a certain size:   $    2
    And Response body parameter should contain:    [0][message]    Invalid data value for field. Field rules: min: 1, max: 2, is_required: 1
    And Response body parameter should be:    [0][code]    508
    And Response body parameter should contain:    [0][status]   400
    And Response body parameter should contain:    [1][message]    Invalid data value for field. Field rules: precision: 20, scale: 10, is_required: 1
    And Response body parameter should be:    [1][code]    508
    And Response body parameter should contain:    [1][status]   400

Update_country_with_invalid_data
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    country
    Create dynamic entity configuration in Database:    country    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    
    ### GET TOKEN ###
    When I set Headers:    Content-Type=application/x-www-form-urlencoded
    And I send a POST request with data:    /token    'grantType=password&username=admin@spryker.com&password=change123'
    Then Response status code should be:    200
    And Response body parameter should be:    [token_type]    Bearer
    And Response body parameter should be greater than:   [expires_in]    0
    And Response body parameter should be less than:   [expires_in]    30000
    And Response body parameter should not be EMPTY:   [token_type]
    And Response body parameter should not be EMPTY:   [access_token]
    And Response body parameter should not be EMPTY:   [refresh_token]
    When Save value to a variable:    [access_token]    token
    
    ### CREATE TEST COUNTRIES ###
    Delete country by iso2_code in Database:   XA
    Delete country by iso2_code in Database:   XB
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/country   {"data":[{"iso2_code":"XA","iso3_code":"XXA","name":"XXA"},{"iso2_code":"XB","iso3_code":"XXB","name":"XXB"}]}
    Then Response status code should be:    201
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XA
    And Response body parameter should be:    [0][iso3_code]    XXA
    And Response body parameter should be:    [0][name]   XXA
    And Response body parameter should be:    [1][iso2_code]    XB
    And Response body parameter should be:    [1][iso3_code]    XXB
    And Response body parameter should be:    [1][name]   XXB
    Response body parameter should be greater than :    [0][id_country]    200
    When Save value to a variable:    [0][id_country]    xxa_country_id
    When Save value to a variable:    [1][id_country]    xxb_country_id

    ### UPDATE COUNTRY WITH INVALID DATA ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/country/${xxa_country_id}    {"data":{"iso2_code":"XXXX"}}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    Invalid data value for field. Field rules: max_length: 2, min_length: 2, is_required: 1
    And Response body parameter should be:    [0][code]    508
    And Response body parameter should be:    [0][status]    400
    ### UPDATE COUNTRY COLLECTION WITH INVALID DATA ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/country    {"data":[{"id_country":${xxa_country_id},"iso2_code":"XXXX"},{"id_country":${xxb_country_id},"iso3_code":"XXXXX"}]}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    Invalid data value for field. Field rules: max_length: 2, min_length: 2, is_required: 1
    And Response body parameter should be:    [0][code]    508
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should contain:    [1][message]    Invalid data value for field. Field rules: max_length: 3, min_length: 3, is_required: 1
    And Response body parameter should be:    [1][code]    508
    And Response body parameter should be:    [1][status]    400
    ### UPDATE COUNTRY WITH INVALID FILELD TYPE ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/country/${xxa_country_id}    {"data":{"iso2_code":1234}}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    Invalid data type for field: iso2_code
    And Response body parameter should be:    [0][code]    507
    And Response body parameter should be:    [0][status]    400

Upsert_with_invalid_id
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    country
    Create dynamic entity configuration in Database:    country    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    
    ### CLEANUP DATA ### 
    Delete country by iso2_code in Database:   XX
    
    ### POST GET TOKEN ###
    When I set Headers:    Content-Type=application/x-www-form-urlencoded
    And I send a POST request with data:    /token    'grantType=password&username=admin@spryker.com&password=change123'
    Then Response status code should be:    200
    And Response body parameter should be:    [token_type]    Bearer
    And Response body parameter should be greater than:   [expires_in]    0
    And Response body parameter should be less than:   [expires_in]    30000
    And Response body parameter should not be EMPTY:   [token_type]
    And Response body parameter should not be EMPTY:   [access_token]
    And Response body parameter should not be EMPTY:   [refresh_token]
    When Save value to a variable:    [access_token]    token

    ### UDATE WITH INVALID ID ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PUT request:    /dynamic-entity/country/500    {"data":{"iso2_code":"XX","iso3_code":"XXX","name":"Country XXX"}}
    Then Response status code should be:    500
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][message]    Failed to persist the data. Please verify the provided data and try again.
    And Response body parameter should be:    [0][code]    502
    And Response body parameter should be:    [0][status]    500

Invalid_dynamic_entity_configuration
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    invalidtest
    Create dynamic entity configuration in Database:    invalidtest    spy_invalidtest     1    {"identifier":"id_country","fields":[]}
    
    ### GET TOKEN ###
    When I set Headers:    Content-Type=application/x-www-form-urlencoded
    And I send a POST request with data:    /token    'grantType=password&username=admin@spryker.com&password=change123'
    Then Response status code should be:    200
    And Response body parameter should be:    [token_type]    Bearer
    And Response body parameter should be greater than:   [expires_in]    0
    And Response body parameter should be less than:   [expires_in]    30000
    And Response body parameter should not be EMPTY:   [token_type]
    And Response body parameter should not be EMPTY:   [access_token]
    And Response body parameter should not be EMPTY:   [refresh_token]
    When Save value to a variable:    [access_token]    token
    
    ### GET RESOURCE WITH INVALID TABLE ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/invalidtest
    Then Response status code should be:    404
    And Response body parameter should be:    [0][message]   The model does not exist. Check if the requested table alias is correct or run `console propel:model:build`.
    And Response body parameter should be:    [0][code]    503
    And Response body parameter should be:    [0][status]    404
