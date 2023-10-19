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
    common_api.Connect to Spryker DB
    ${hash_id}=    Query    select id_api_key from spy_api_key WHERE key_hash='${key_hash}';
    ${hash_id_length}=    Get Length    ${hash_id}
    IF    ${hash_id_length} > 0
        Execute Sql String    DELETE FROM spy_api_key WHERE key_hash='${key_hash}';
    END
    ${new_id}=    Get next id from table    spy_api_key    id_api_key
    common_api.Connect to Spryker DB
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
    common_api.Connect to Spryker DB
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
    Wait Until Network Is Idle
    Page Should Not Contain Element    ${zed_error_message}    1s
    Page Should Not Contain Element    ${zed_error_flash_message}    1s

Delete mime_type by id_mime_type in Database:
    [Documentation]    This keyword deletes a mime type by id_mime_type in the DB table spy_mime_type.
        ...    *Example:*
        ...
        ...    ``Delete mime_type by id_mime_type in Database:    21``
        ...
    [Arguments]    ${id_mime_type}
    common_api.Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_mime_type WHERE id_mime_type = '${id_mime_type}';
    Disconnect From Database