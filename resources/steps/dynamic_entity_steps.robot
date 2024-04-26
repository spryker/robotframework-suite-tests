*** Settings ***
Resource    ../common/common_api.robot
Resource    ../common/common_zed.robot
Resource    ../../resources/pages/zed/zed_data_exchange_api_configurator_page.robot


*** Keywords ***
Create api key in db
    [Documentation]    This keyword creates api key hash for data exchange api in the DB table spy_api_key. Key hash is static and matches env varaible `dummy_api_key`.
    ...
    ...    Each combination of `dummy_api_key` and `dummy_key_hash` is unique
    ...
    ### works for MariaDB and PostgreSQL ###
    [Arguments]    ${key_hash}=${dummy_key_hash}    ${created_by}=1
    Connect to Spryker DB
    ${hash_id}=    Query    select id_api_key from spy_api_key WHERE key_hash='${key_hash}';
    ${hash_id_length}=    Get Length    ${hash_id}
    IF    ${hash_id_length} > 0
        Execute Sql String    DELETE FROM spy_api_key WHERE key_hash='${key_hash}';
    END
    ${new_id}=    Get next id from table    spy_api_key    id_api_key
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String  insert into spy_api_key (id_api_key, name, key_hash, created_by) value ('${new_id}', 'autotest${random}', '${key_hash}', '${created_by}');
    ELSE
        Execute Sql String  insert into spy_api_key (id_api_key, name, key_hash, created_by) values ('${new_id}', 'autotest${random}', '${key_hash}', '${created_by}');
    END
    Disconnect From Database

Delete api key from db
    [Documentation]    This keyword deletes api key hash for data exchange api in the DB table spy_api_key.
    ...
    ### works for MariaDB and PostgreSQL ###
    [Arguments]    ${key_hash}=${dummy_key_hash}
    Connect to Spryker DB
    ${hash_id}=    Query    select id_api_key from spy_api_key WHERE key_hash='${key_hash}';
    ${hash_id_length}=    Get Length    ${hash_id}
    IF    ${hash_id_length} > 0
        Execute Sql String    DELETE FROM spy_api_key WHERE key_hash='${key_hash}';
    END
    Disconnect From Database

Zed: start creation of new data exchange api configuration for db table:
    [Arguments]    ${table_name}
    Zed: go to first navigation item level:    Data Exchange API Configuration
    Zed: perform search by:    ${table_name}
    ${is_table_empty}=    Run Keyword And Ignore Error    Page Should Contain Element    xpath=//table//td[contains(@class,'empty')]    timeout=1s
    IF    'PASS' in ${is_table_empty}
        Zed: click button in Header:    Data Exchange API Configuration
        Select From List By Value    ${data_exchange_table_select_locator}    ${table_name}
        Click    ${data_exchange_create_configuration_button}
        Wait Until Page Contains Element    ${data_exchange_resource_name_field}
    ELSE
        Log    ${table_name} already exists in the configuration. Edit instead of create
        Zed: click Action Button in a table for row that contains:    ${table_name}    Edit
        Wait Until Page Contains Element    ${data_exchange_resource_name_field}
    END

Zed: edit data exchange api configuration:
    [Arguments]    @{args}
    ${configurationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{configurationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='table_name' and '${value}' != '${EMPTY}'
            ${currentURL}=    Get Location
            IF    '/configuration-list' not in '${currentURL}'    Zed: go to first navigation item level:    Data Exchange API Configuration
            Zed: click Action Button in a table for row that contains:    ${value}    Edit
            Wait Until Page Contains Element    ${data_exchange_resource_name_field}
        END
        IF    '${key}'=='is_enabled' and '${value}' == 'true'   Zed: Check checkbox by Label:    Is enabled
        IF    '${key}'=='is_enabled' and '${value}' == 'false'   Zed: Uncheck Checkbox by Label:    Is enabled
        IF    '${key}'=='field_name' and '${value}' != '${EMPTY}'
            ${field_name}=    Set Variable    ${value}
        END
        IF    '${key}'=='enabled' and '${value}' == 'true'   Check Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'is_enabled')]
        IF    '${key}'=='enabled' and '${value}' == 'false'   Uncheck Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'is_enabled')]
        IF    '${key}'=='visible_name' and '${value}' != '${EMPTY}'   Type Text    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'visible_name')]    ${value}
        IF    '${key}'=='type' and '${value}' != '${EMPTY}'   Select From List By Value    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//select[contains(@name,'type')]    ${value}
        IF    '${key}'=='creatable' and '${value}' == 'true'   Check Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'creatable')]
        IF    '${key}'=='creatable' and '${value}' == 'false'   Uncheck Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'creatable')]
        IF    '${key}'=='editable' and '${value}' == 'true'   Check Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'editable')]
        IF    '${key}'=='editable' and '${value}' == 'false'   Uncheck Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'editable')]
        IF    '${key}'=='required' and '${value}' == 'true'   Check Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'required')]
        IF    '${key}'=='required' and '${value}' == 'false'   Uncheck Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'required')]
    END

Zed: save data exchange api configuration
    Click    ${data_exchange_create_configuration_button}
    Wait For Load State
    Page Should Not Contain Element    ${zed_error_message}    1s
    Page Should Not Contain Element    ${zed_error_flash_message}    1s

Delete mime_type by id_mime_type in Database:
    [Documentation]    This keyword deletes a mime type by id_mime_type in the DB table spy_mime_type.
        ...    *Example:*
        ...
        ...    ``Delete mime_type by id_mime_type in Database:    21``
        ...
    [Arguments]    ${id_mime_type}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_mime_type WHERE id_mime_type = '${id_mime_type}';
    Disconnect From Database

Zed: download data exchange api specification should be active:
    [Arguments]    ${expected_condition}
    ${currentURL}=    Get Location
    IF    '/configuration-list' not in '${currentURL}'    Zed: go to first navigation item level:    Data Exchange API Configuration
    ${expected_condition}=    Convert To Lower Case    ${expected_condition}
    IF    '${expected_condition}' == 'true'
        Wait Until Element Is Enabled    ${data_exchange_download_spec_button}    timeout=3s    message=Data Exchange API spec is NOT downloadable
    ELSE
        ${download_button_state}=    Get Element Attribute  ${data_exchange_download_spec_button}    class
        Should Contain    ${download_button_state}    disabled    message=Data Exchange API spec is downloadable BUT should NOT
    END

Zed: download data exchange api specification
    [Documentation]    Downloads BAPI spec file and returns file location (path) in '${specification_file_path}' variable
    ${dl_promise}    Promise To Wait For Download    saveAs=${OUTPUTDIR}/tmp.file
    Click    ${data_exchange_download_spec_button}
    ${file_object}=    Wait For  ${dl_promise}
    File Should Exist    ${file_object}[saveAs]
    Move File    ${file_object}[saveAs]    ${OUTPUTDIR}/${file_object.suggestedFilename}
    Should Be Equal    ${file_object.suggestedFilename}    schema.yml
    Set Test Variable    ${specification_file_path}    ${OUTPUTDIR}/${file_object.suggestedFilename}

Zed: check that downloaded api specification contains:
    [Arguments]    ${expected_content}
    ${file_content}=   Get File  ${specification_file_path}
    Should Contain    ${file_content}    ${expected_content}

Zed: check that downloaded api specification does not contain:
    [Arguments]    ${expected_content}
    ${file_content}=   Get File  ${specification_file_path}
    Should Not Contain    ${file_content}    ${expected_content}

Zed: delete dowloaded api specification
    Remove File    ${specification_file_path}

Zed: wait until info box is not displayed
    [Arguments]    ${iterations}=20    ${delays}=10s
    Try reloading page until element is/not appear:    ${zed_info_flash_message}    false    tries=${iterations}    timeout=${delays}

Find first available product via data exchange api
    [Arguments]    ${start_from_index}=0    ${end_index}=100
    Remove Tags    *
    Set Tags    bapi
    API_test_setup
    I get access token by user credentials:   ${zed_admin.email}
    I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    FOR    ${index}    IN RANGE    ${start_from_index}    ${end_index}
        I send a GET request:    /dynamic-entity/stock-products/${index}
        ${is_200}=    Run Keyword And Ignore Error    Response status code should be:    200
        IF    'FAIL' in ${is_200}    Continue For Loop
        Save value to a variable:    [data][is_never_out_of_stock]    initial_is_never_out_of_stock
        Save value to a variable:    [data][quantity]    initial_quantity
        IF    '${initial_is_never_out_of_stock}' == 'False'
                IF    ${initial_quantity} > 0
                    Save value to a variable:    [data][fk_product]    fk_product
                    Set Test Variable    ${index}    ${index}
                    Exit For Loop
                ELSE
                    Continue For Loop
                END
        ELSE
            Save value to a variable:    [data][fk_product]    fk_product
            Set Test Variable    ${index}    ${index}
            Exit For Loop
        END
    END
    Get concrete product sku by id from DB:    ${fk_product}
    Make sure that concrete product is available:    ${concrete_sku}
    RETURN    ${concrete_sku}

Make sure that concrete product is available:
    [Arguments]    ${sku}=${concrete_sku}
    Remove Tags    *
    Set Tags    glue
    API_test_setup
    I set Headers:    Content-Type==application/json
    I send a GET request:    /concrete-products/${concrete_sku}/concrete-product-availabilities
    ${is_avaialbe}=    Run Keyword And Ignore Error    Response body parameter should be:    [data][0][attributes][availability]   True
    IF    'FAIL' in ${is_avaialbe}
        ${index}=    Evaluate    ${index}+1
        Find first available product via data exchange api    ${index}
    END

Product availability status should be changed on:
    [Arguments]    ${is_available}    ${sku}=${concrete_sku}    ${sleep_time}=5s    ${iterations}=26
    ${is_available}=    Convert To Title Case    ${is_available}
    Remove Tags    *
    Set Tags    glue
    API_test_setup
    I set Headers:    Content-Type==application/json
    FOR    ${index}    IN RANGE    1    ${iterations}
        I send a GET request:    /concrete-products/${concrete_sku}/concrete-product-availabilities
        Response status code should be:    200
        ${actual_availability}=    Run Keyword And Ignore Error    Response body parameter should be:    [data][0][attributes][availability]   ${is_available}
        IF    ${index} == ${iterations}-1
            Fail    Expected product availability is not reached. Check P&S
        END
        IF    'PASS' in ${actual_availability}
            Exit For Loop
        END
        IF    'FAIL' in ${actual_availability}
            Sleep    ${sleep_time}
            Continue For Loop
        END

    END


Restore product initial stock via data exchange api:
    [Arguments]    ${id_stock_product}=${index}
    Remove Tags    *
    Set Tags    bapi
    API_test_setup
    I get access token by user credentials:   ${zed_admin.email}
    I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    I send a PATCH request:    /dynamic-entity/stock-products/${id_stock_product}    {"data":{"is_never_out_of_stock":${initial_is_never_out_of_stock},"quantity":${initial_quantity}}}
