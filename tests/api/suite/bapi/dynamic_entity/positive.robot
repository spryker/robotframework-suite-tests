*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/dynamic_entity_steps.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    API_test_setup

Get_country_collection
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-tests-countries
    Create dynamic entity configuration in Database:    robot-tests-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    # ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET COUNTRY COLLECTION ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-countries
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   [data][0]    6
    And Response body parameter should be:    [data][0][id_country]    1
    And Response body parameter should be:    [data][0][iso2_code]    AC
    And Response body parameter should be:    [data][0][iso3_code]    ASC
    And Response body parameter should be:    [data][0][name]    Ascension Island
    And Response body parameter should be:    [data][0][postal_code_mandatory]    False
    And Response body parameter should be:    [data][0][postal_code_regex]    None
    And Response body parameter should be:    [data][253][id_country]    254
    And Response body parameter should be:    [data][253][iso2_code]    ZM
    And Response body parameter should be:    [data][253][iso3_code]    ZMB
    And Response body parameter should be:    [data][253][name]    Zambia
    And Response body parameter should be:    [data][253][postal_code_mandatory]    True
    And Response body parameter should be:    [data][253][postal_code_regex]    \\\\d{5}
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-tests-countries

Get_country_Collection_with_filter_first_item
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-tests-countries
    Create dynamic entity configuration in Database:    robot-tests-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    # ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET COUNTRY COLLECTION WITH FILTER FIRST ITEM ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-countries?filter[country.iso2_code]=AC
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][0][id_country]    1
    And Response body parameter should be:    [data][0][iso2_code]    AC
    And Response body parameter should be:    [data][0][iso3_code]    ASC
    And Response body parameter should be:    [data][0][name]    Ascension Island
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-tests-countries

Get_country_collection_with_filter
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-tests-countries
    Create dynamic entity configuration in Database:    robot-tests-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    # ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET COUNTRY COLLECTION WITH FILTER ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-countries?filter[country.iso2_code]=UA
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][0][id_country]    235
    And Response body parameter should be:    [data][0][iso2_code]    UA
    And Response body parameter should be:    [data][0][iso3_code]    UKR
    And Response body parameter should be:    [data][0][name]    Ukraine
    And Response body parameter should be:    [data][0][postal_code_mandatory]    True
    And Response body parameter should be:    [data][0][postal_code_regex]    \\\\d{5}
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-tests-countries

Get_country_collection_with_paginations
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-tests-countries
    Create dynamic entity configuration in Database:    robot-tests-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    # ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET COUNTRY COLLECTION WITH PAGINATIONS ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-countries?page[offset]=234&page[limit]=2
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   $    1
    And Response should contain the array of a certain size:   [data]    2
    And Response body parameter should be:    [data][0][id_country]    235
    And Response body parameter should be:    [data][0][iso2_code]    UA
    And Response body parameter should be:    [data][0][iso3_code]    UKR
    And Response body parameter should be:    [data][0][name]    Ukraine
    And Response body parameter should be:    [data][0][postal_code_mandatory]    True
    And Response body parameter should be:    [data][0][postal_code_regex]    \\\\d{5}
    And Response body parameter should be:    [data][1][id_country]    236
    And Response body parameter should be:    [data][1][iso2_code]    UG
    And Response body parameter should be:    [data][1][iso3_code]    UGA
    And Response body parameter should be:    [data][1][name]    Uganda
    And Response body parameter should be:    [data][1][postal_code_mandatory]    False
    And Response body parameter should be:    [data][1][postal_code_regex]    None
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-tests-countries

Get_country_collection_with_paginations_out_of_items
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-tests-countries
    Create dynamic entity configuration in Database:    robot-tests-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    # ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET COUNTRY COLLECTION WITH PAGINATIONS  OUT OF ITEMS ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-countries?page[offset]=500&page[limit]=10
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   $    1
    And Response should contain the array of a certain size:   [data]    0
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-tests-countries


Get_country_collection_with_short_configuration
    ### SETUP DYNAMIC ENTITY CONFIGURATION WITH LESS NUMBER OF FIELDS ###
    Delete dynamic entity configuration in Database:    robot-tests-countries
    Create dynamic entity configuration in Database:    robot-tests-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true}}]}
    # ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET COUNTRY COLLECTION WITH SHORT CONFIGURATION ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-countries
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   [data][0]    3
    And Response body parameter should be:    [data][0][id_country]    1
    And Response body parameter should be:    [data][0][iso2_code]    AC
    And Response body parameter should be:    [data][0][name]    Ascension Island
    And Response body parameter should be:    [data][253][id_country]    254
    And Response body parameter should be:    [data][253][iso2_code]    ZM
    And Response body parameter should be:    [data][253][name]    Zambia
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-tests-countries

Get_country_by_id
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-tests-countries
    Create dynamic entity configuration in Database:    robot-tests-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
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
    And I send a GET request:    /dynamic-entity/robot-tests-countries/235
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][id_country]    235
    And Response body parameter should be:    [data][iso2_code]    UA
    And Response body parameter should be:    [data][iso3_code]    UKR
    And Response body parameter should be:    [data][name]    Ukraine
    And Response body parameter should be:    [data][postal_code_mandatory]    True
    And Response body parameter should be:    [data][postal_code_regex]    \\\\d{5}
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-tests-countries

Create_and_update_country:
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-tests-countries
    Create dynamic entity configuration in Database:    robot-tests-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE TEST COUNTRY AND CLEANUP TEST DATA IF EXIST###
    Delete country by iso2_code in Database:   XM
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-countries   {"data":[{"iso2_code":"XM","iso3_code":"XXM","name":"POST XM"}]}
    Then Response status code should be:    201
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][0][iso2_code]    XM
    And Response body parameter should be:    [data][0][iso3_code]    XXM
    And Response body parameter should be:    [data][0][name]    POST XM
    Response body parameter should be greater than :    [data][0][id_country]    200
    When Save value to a variable:    [data][0][id_country]    xxa_country_id
    ### UPDATE COUNTRY ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/robot-tests-countries/${xxa_country_id}    {"data":{"iso2_code":"XX","iso3_code":"XXX","name":"Country XX"}}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][iso2_code]    XX
    And Response body parameter should be:    [data][iso3_code]    XXX
    And Response body parameter should be:    [data][name]    Country XX
    And Response body parameter should be:    [data][id_country]    ${xxa_country_id}
    ### GET COUNTRY AND VALIDATE DATA ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-countries/${xxa_country_id}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][iso2_code]    XX
    And Response body parameter should be:    [data][iso3_code]    XXX
    And Response body parameter should be:    [data][name]    Country XX
    ### UPDATE ONE FIELD OF COUNTRY ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/robot-tests-countries/${xxa_country_id}    {"data":{"name":"Test Country"}}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][name]    Test Country
    And Response body parameter should be:    [data][id_country]    ${xxa_country_id}
    ### GET COUNTRY AND VALIDATE DATA ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-countries/${xxa_country_id}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:   [data][iso2_code]    XX
    And Response body parameter should be:   [data][iso3_code]    XXX
    And Response body parameter should be:   [data][name]    Test Country
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-tests-countries
    ...   AND    Delete country by iso2_code in Database:   XX
    ...   AND    Delete country by iso2_code in Database:   XM

Create_country_collection:
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-tests-countries
    Create dynamic entity configuration in Database:    robot-tests-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE THREE TEST COUNTRIES ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-countries   {"data":[{"iso2_code":"XA","iso3_code":"XXA","name":"Country XA"},{"iso2_code":"XB","iso3_code":"XXB","name":"Country XB"},{"iso2_code":"XC","iso3_code":"XXC","name":"Country XC","postal_code_regex":"\\d{5}"}]}
    Then Response status code should be:    201
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][0][iso2_code]    XA
    And Response body parameter should be:    [data][0][iso3_code]    XXA
    And Response body parameter should be:    [data][0][name]    Country XA
    Response body parameter should be greater than :    [data][0][id_country]    200
    And Response body parameter should be:    [data][1][iso2_code]    XB
    And Response body parameter should be:    [data][1][iso3_code]    XXB
    And Response body parameter should be:    [data][1][name]    Country XB
    Response body parameter should be greater than :    [data][1][id_country]    200
    And Response body parameter should be:    [data][2][iso2_code]    XC
    And Response body parameter should be:    [data][2][iso3_code]    XXC
    And Response body parameter should be:    [data][2][name]    Country XC
    And Response body parameter should be:    [data][2][postal_code_regex]    \\\\d{5}
    Response body parameter should be greater than :    [data][2][id_country]    200
    When Save value to a variable:    [data][0][id_country]    xxa_country_id
    When Save value to a variable:    [data][1][id_country]    xxb_country_id
    When Save value to a variable:    [data][2][id_country]    xxc_country_id
    #### UPDATE COUNTRY COLLECTION ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/robot-tests-countries    {"data":[{"id_country":${xxa_country_id},"iso2_code":"XA","iso3_code":"XAA","name":"XAA"},{"id_country":${xxb_country_id},"iso2_code":"XB","iso3_code":"XBB","name":"XBB"},{"id_country":${xxc_country_id},"iso2_code":"XC","iso3_code":"XCC","name":"XCC"}]}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][0][iso2_code]    XA
    And Response body parameter should be:    [data][0][iso3_code]    XAA
    And Response body parameter should be:    [data][0][name]    XAA
    And Response body parameter should be:    [data][0][id_country]    ${xxa_country_id}
    And Response body parameter should be:    [data][1][iso2_code]    XB
    And Response body parameter should be:    [data][1][iso3_code]    XBB
    And Response body parameter should be:    [data][1][name]    XBB
    And Response body parameter should be:    [data][1][id_country]    ${xxb_country_id}
    And Response body parameter should be:    [data][2][iso2_code]    XC
    And Response body parameter should be:    [data][2][iso3_code]    XCC
    And Response body parameter should be:    [data][2][name]    XCC
    And Response body parameter should be:    [data][2][id_country]    ${xxc_country_id}
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-tests-countries
    ...   AND    Delete country by iso2_code in Database:   XA
    ...   AND    Delete country by iso2_code in Database:   XB
    ...   AND    Delete country by iso2_code in Database:   XC

Upsert_country_collection:
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-tests-countries
    Create dynamic entity configuration in Database:    robot-tests-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### POST GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}

    ### CREATE TEST COUNTRY AND CLEANUP TEST DATA IF EXIST###
    Delete country by iso2_code in Database:   XA
    Delete country by iso2_code in Database:   XB
    Delete country by iso2_code in Database:   XL
    Delete country by iso2_code in Database:   XS
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-countries   {"data":[{"iso2_code":"XA","iso3_code":"XAA","name":"PUT XAA"},{"iso2_code":"XB","iso3_code":"XBB","name":"PUT XBB"}]}
    Then Response status code should be:    201
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][0][iso2_code]    XA
    And Response body parameter should be:    [data][0][iso3_code]    XAA
    And Response body parameter should be:    [data][0][name]    PUT XAA
    Response body parameter should be greater than :    [data][0][id_country]    200
    And Response body parameter should be:    [data][1][iso2_code]    XB
    And Response body parameter should be:    [data][1][iso3_code]    XBB
    And Response body parameter should be:    [data][1][name]    PUT XBB
    Response body parameter should be greater than :    [data][1][id_country]    200
    When Save value to a variable:    [data][0][id_country]    xaa_country_id
    When Save value to a variable:    [data][1][id_country]    xbb_country_id

    ## UPSERT ONE COUNTRY ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PUT request:    /dynamic-entity/robot-tests-countries/${xaa_country_id}    {"data":{"iso2_code":"XX","iso3_code":"XXX","name":"Country XXX"}}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][iso2_code]    XX
    And Response body parameter should be:    [data][iso3_code]    XXX
    And Response body parameter should be:    [data][name]    Country XXX
    And Response body parameter should be:    [data][id_country]    ${xaa_country_id}
    ### GET COUNTRY AND VALIDATE DATA ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-countries/${xaa_country_id}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][iso2_code]    XX
    And Response body parameter should be:    [data][iso3_code]    XXX
    And Response body parameter should be:    [data][name]    Country XXX
    ### PARTIAL UPDATE ONE COUNTRY ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PUT request:    /dynamic-entity/robot-tests-countries/${xaa_country_id}    {"data":{"name":"Country XXL"}}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][name]    Country XXL
    And Response body parameter should be:    [data][id_country]    ${xaa_country_id}
    ### GET COUNTRY AND VALIDATE DATA ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-countries/${xaa_country_id}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][iso2_code]    XX
    And Response body parameter should be:    [data][iso3_code]    XXX
    And Response body parameter should be:    [data][name]    Country XXL
    ### UPSERT COUNTRY COLLECTION ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PUT request:    /dynamic-entity/robot-tests-countries    {"data":[{"id_country":${xaa_country_id},"iso2_code":"XL","iso3_code":"XXL","name":"XXL"},{"id_country":${xbb_country_id},"iso2_code":"XS","iso3_code":"XXS","name":"XXS"}]}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][0][iso2_code]    XL
    And Response body parameter should be:    [data][0][iso3_code]    XXL
    And Response body parameter should be:    [data][0][name]    XXL
    And Response body parameter should be:    [data][0][id_country]    ${xaa_country_id}
    And Response body parameter should be:    [data][1][iso2_code]    XS
    And Response body parameter should be:    [data][1][iso3_code]    XXS
    And Response body parameter should be:    [data][1][name]    XXS
    And Response body parameter should be:    [data][1][id_country]    ${xbb_country_id}
    ### GET COUNTRIES AND VALIDATE DATA ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-countries/${xaa_country_id}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][iso2_code]    XL
    And Response body parameter should be:    [data][iso3_code]    XXL
    And Response body parameter should be:    [data][name]    XXL
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-countries/${xbb_country_id}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][iso2_code]    XS
    And Response body parameter should be:    [data][iso3_code]    XXS
    And Response body parameter should be:    [data][name]    XXS
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-tests-countries
    ...   AND    Delete country by iso2_code in Database:   XA
    ...   AND    Delete country by iso2_code in Database:   XB
    ...   AND    Delete country by iso2_code in Database:   XC
    ...   AND    Delete country by iso2_code in Database:   XX
    ...   AND    Delete country by iso2_code in Database:   XL
    ...   AND    Delete country by iso2_code in Database:   XS

Authorization_by_x_api_key
    [Documentation]    data excahnge api should support 2 autorization options: by x-api-key and by backoffice user token.
    [Setup]    Create api key in db
    When I set Headers:    x-api-key=${dummy_api_key}
    And I send a GET request:    /dynamic-entity/categories
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    [Teardown]    Delete api key from db

Availability_recalculation_after_stock_update
    [Documentation]    checks that product availability is recalculated after stock update via data exchange api
    [Setup]    Find first available product via data exchange api
    Remove Tags    *
    Set Tags    bapi
    API_test_setup
    When I get access token by user credentials:   ${zed_admin.email}
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/stock-products/${index}    {"data":{"is_never_out_of_stock":${false},"quantity":0}}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][is_never_out_of_stock]    False
    And Response body parameter should be:    [data][quantity]    0
    Trigger p&s
    And Product availability status should be changed on:    is_available=False
    [Teardown]    Run Keywords    Remove Tags    *
    ...    AND    Set Tags    bapi
    ...    AND    Restore product initial stock via data exchange api:
