*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

Get_list_of_country
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

    ### GET COUNTRY COLLECTION ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   [0]    6
    And Response body parameter should be:    [0][id_country]    1
    And Response body parameter should be:    [0][iso2_code]    AC
    And Response body parameter should be:    [0][iso3_code]    ASC 
    And Response body parameter should be:    [0][name]    Ascension Island
    And Response body parameter should be:    [0][postal_code_mandatory]    False
    And Response body parameter should be:    [0][postal_code_regex]    None
    And Response body parameter should be:    [253][id_country]    254
    And Response body parameter should be:    [253][iso2_code]    ZM
    And Response body parameter should be:    [253][iso3_code]    ZMB
    And Response body parameter should be:    [253][name]    Zambia
    And Response body parameter should be:    [253][postal_code_mandatory]    True
    And Response body parameter should be:    [253][postal_code_regex]    \\\\d{5}
    ### GET COUNTRY COLLECTION WITH FILTER FIRST ITEM ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country?filter[country.iso2_code]=AC
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][id_country]    1
    And Response body parameter should be:    [0][iso2_code]    AC
    And Response body parameter should be:    [0][iso3_code]    ASC 
    And Response body parameter should be:    [0][name]    Ascension Island
    ### GET COUNTRY COLLECTION WITH FILTER ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country?filter[country.iso2_code]=UA
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][id_country]    235
    And Response body parameter should be:    [0][iso2_code]    UA
    And Response body parameter should be:    [0][iso3_code]    UKR 
    And Response body parameter should be:    [0][name]    Ukraine
    And Response body parameter should be:    [0][postal_code_mandatory]    True
    And Response body parameter should be:    [0][postal_code_regex]    \\\\d{5}
    ### GET COUNTRY COLLECTION WITH PAGINATIONS ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country?page[offset]=234&page[limit]=2
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   $    2
    And Response body parameter should be:    [0][id_country]    235
    And Response body parameter should be:    [0][iso2_code]    UA
    And Response body parameter should be:    [0][iso3_code]    UKR 
    And Response body parameter should be:    [0][name]    Ukraine
    And Response body parameter should be:    [0][postal_code_mandatory]    True
    And Response body parameter should be:    [0][postal_code_regex]    \\\\d{5}
    And Response body parameter should be:    [1][id_country]    236
    And Response body parameter should be:    [1][iso2_code]    UG
    And Response body parameter should be:    [1][iso3_code]    UGA 
    And Response body parameter should be:    [1][name]    Uganda
    And Response body parameter should be:    [1][postal_code_mandatory]    False
    And Response body parameter should be:    [1][postal_code_regex]    None
    ### GET COUNTRY COLLECTION WITH PAGINATIONS  OUT OF ITEMS ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country?page[offset]=500&page[limit]=10
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   $    0

    ### GET COLLECTION WITH DECIMAL FIELD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/availability-abstract
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][id_availability_abstract]    1
    And Response body parameter should be:    [0][quantity]    80.0000000000
    And Response body parameter should be:    [0][abstract_sku]    112
    And Response body parameter should be:    [0][fk_store]    1

    ### SETUP DYNAMIC ENTITY CONFIGURATION WITH LESS NUMBER OF FIELDS ###
    Delete dynamic entity configuration in Database:    country
    Create dynamic entity configuration in Database:    country    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true}}]}

    ### GET COUNTRY COLLECTION WITH SHORT CONFIGURATION ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   [0]    3
    And Response body parameter should be:    [0][id_country]    1
    And Response body parameter should be:    [0][iso2_code]    AC
    And Response body parameter should be:    [0][name]    Ascension Island
    And Response body parameter should be:    [253][id_country]    254
    And Response body parameter should be:    [253][iso2_code]    ZM
    And Response body parameter should be:    [253][name]    Zambia

Get_country_by_id
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

    ### GET COUNTRY BY ID ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country/235
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][id_country]    235
    And Response body parameter should be:    [0][iso2_code]    UA
    And Response body parameter should be:    [0][iso3_code]    UKR 
    And Response body parameter should be:    [0][name]    Ukraine
    And Response body parameter should be:    [0][postal_code_mandatory]    True
    And Response body parameter should be:    [0][postal_code_regex]    \\\\d{5}

Create_and_update_country_collection: 
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

    ### CREATE TEST COUNTRY AND CLEANUP TEST DATA IF EXIST###
    Delete country by iso2_code in Database:   XM
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/country   {"data":[{"iso2_code":"XM","iso3_code":"XXM","name":"POST XM"}]}
    Then Response status code should be:    201
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XM
    And Response body parameter should be:    [0][iso3_code]    XXM
    And Response body parameter should be:    [0][name]    POST XM
    Response body parameter should be greater than :    [0][id_country]    200
    Delete country by iso2_code in Database:   XM
    Delete country by iso2_code in Database:   XA
    Delete country by iso2_code in Database:   XB
    Delete country by iso2_code in Database:   XC
    Delete country by iso2_code in Database:   XX


    ### CREATE THREE TEST COUNTRIES ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/country   {"data":[{"iso2_code":"XA","iso3_code":"XXA","name":"Country XA"},{"iso2_code":"XB","iso3_code":"XXB","name":"Country XB"},{"iso2_code":"XC","iso3_code":"XXC","name":"Country XC","postal_code_regex":"\\d{5}"}]}
    Then Response status code should be:    201
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XA
    And Response body parameter should be:    [0][iso3_code]    XXA
    And Response body parameter should be:    [0][name]    Country XA
    Response body parameter should be greater than :    [0][id_country]    200
    And Response body parameter should be:    [1][iso2_code]    XB
    And Response body parameter should be:    [1][iso3_code]    XXB
    And Response body parameter should be:    [1][name]    Country XB
    Response body parameter should be greater than :    [1][id_country]    200
    And Response body parameter should be:    [2][iso2_code]    XC
    And Response body parameter should be:    [2][iso3_code]    XXC
    And Response body parameter should be:    [2][name]    Country XC
    And Response body parameter should be:    [2][postal_code_regex]    \\\\d{5}
    Response body parameter should be greater than :    [2][id_country]    200
    When Save value to a variable:    [0][id_country]    xxa_country_id
    When Save value to a variable:    [1][id_country]    xxb_country_id
    When Save value to a variable:    [2][id_country]    xxc_country_id

    ### UPDATE ONE COUNTRY ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/country/${xxa_country_id}    {"data":{"iso2_code":"XX","iso3_code":"XXX","name":"Country XX"}}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XX
    And Response body parameter should be:    [0][iso3_code]    XXX
    And Response body parameter should be:    [0][name]    Country XX
    And Response body parameter should be:    [0][id_country]    ${xxa_country_id}
    ### GET COUNTRY AND VALIDATE DATA ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country/${xxa_country_id}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XX
    And Response body parameter should be:    [0][iso3_code]    XXX
    And Response body parameter should be:    [0][name]    Country XX
    ### UPDATE ONE FIELD OF COUNTRY ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/country/${xxa_country_id}    {"data":{"name":"Test Country"}}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][name]    Test Country
    And Response body parameter should be:    [0][id_country]    ${xxa_country_id}
    ### GET COUNTRY AND VALIDATE DATA ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country/${xxa_country_id}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XX
    And Response body parameter should be:    [0][iso3_code]    XXX
    And Response body parameter should be:    [0][name]    Test Country
    #### UPDATE COUNTRY COLLECTION ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/country    {"data":[{"id_country":${xxa_country_id},"iso2_code":"XA","iso3_code":"XAA","name":"XAA"},{"id_country":${xxb_country_id},"iso2_code":"XB","iso3_code":"XBB","name":"XBB"},{"id_country":${xxc_country_id},"iso2_code":"XC","iso3_code":"XCC","name":"XCC"}]}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XA
    And Response body parameter should be:    [0][iso3_code]    XAA
    And Response body parameter should be:    [0][name]    XAA
    And Response body parameter should be:    [0][id_country]    ${xxa_country_id}
    And Response body parameter should be:    [1][iso2_code]    XB
    And Response body parameter should be:    [1][iso3_code]    XBB
    And Response body parameter should be:    [1][name]    XBB
    And Response body parameter should be:    [1][id_country]    ${xxb_country_id}
    And Response body parameter should be:    [2][iso2_code]    XC
    And Response body parameter should be:    [2][iso3_code]    XCC
    And Response body parameter should be:    [2][name]    XCC
    And Response body parameter should be:    [2][id_country]    ${xxc_country_id}

Upsert_country_collection:
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    country
    Create dynamic entity configuration in Database:    country    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    
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
    
    ### CREATE TEST COUNTRY AND CLEANUP TEST DATA IF EXIST###
    Delete country by iso2_code in Database:   XA
    Delete country by iso2_code in Database:   XB
    Delete country by iso2_code in Database:   XL
    Delete country by iso2_code in Database:   XS
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/country   {"data":[{"iso2_code":"XA","iso3_code":"XAA","name":"PUT XAA"},{"iso2_code":"XB","iso3_code":"XBB","name":"PUT XBB"}]}
    Then Response status code should be:    201
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XA
    And Response body parameter should be:    [0][iso3_code]    XAA
    And Response body parameter should be:    [0][name]    PUT XAA
    Response body parameter should be greater than :    [0][id_country]    200
    And Response body parameter should be:    [1][iso2_code]    XB
    And Response body parameter should be:    [1][iso3_code]    XBB
    And Response body parameter should be:    [1][name]    PUT XBB
    Response body parameter should be greater than :    [1][id_country]    200
    When Save value to a variable:    [0][id_country]    xaa_country_id
    When Save value to a variable:    [1][id_country]    xbb_country_id

    ## UPSERT ONE COUNTRY ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PUT request:    /dynamic-entity/country/${xaa_country_id}    {"data":{"iso2_code":"XX","iso3_code":"XXX","name":"Country XXX"}}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XX
    And Response body parameter should be:    [0][iso3_code]    XXX
    And Response body parameter should be:    [0][name]    Country XXX
    And Response body parameter should be:    [0][id_country]    ${xaa_country_id}
    ### GET COUNTRY AND VALIDATE DATA ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country/${xaa_country_id}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XX
    And Response body parameter should be:    [0][iso3_code]    XXX
    And Response body parameter should be:    [0][name]    Country XXX   
    ### PARTIAL UPDATE ONE COUNTRY ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PUT request:    /dynamic-entity/country/${xaa_country_id}    {"data":{"name":"Country XXL"}}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][name]    Country XXL
    And Response body parameter should be:    [0][id_country]    ${xaa_country_id}
    ### GET COUNTRY AND VALIDATE DATA ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country/${xaa_country_id}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XX
    And Response body parameter should be:    [0][iso3_code]    XXX
    And Response body parameter should be:    [0][name]    Country XXL  
    ### UPSERT COUNTRY COLLECTION ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PUT request:    /dynamic-entity/country    {"data":[{"id_country":${xaa_country_id},"iso2_code":"XL","iso3_code":"XXL","name":"XXL"},{"id_country":${xbb_country_id},"iso2_code":"XS","iso3_code":"XXS","name":"XXS"}]}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XL
    And Response body parameter should be:    [0][iso3_code]    XXL
    And Response body parameter should be:    [0][name]    XXL
    And Response body parameter should be:    [0][id_country]    ${xaa_country_id}
    And Response body parameter should be:    [1][iso2_code]    XS
    And Response body parameter should be:    [1][iso3_code]    XXS
    And Response body parameter should be:    [1][name]    XXS
    And Response body parameter should be:    [1][id_country]    ${xbb_country_id}
    ### GET COUNTRIES AND VALIDATE DATA ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country/${xaa_country_id}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XL
    And Response body parameter should be:    [0][iso3_code]    XXL
    And Response body parameter should be:    [0][name]    XXL  
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/country/${xbb_country_id}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][iso2_code]    XS
    And Response body parameter should be:    [0][iso3_code]    XXS
    And Response body parameter should be:    [0][name]    XXS
