*** Settings ***
Library    String
Library    Dialogs
Library    OperatingSystem
Library    Process
Library    Collections
Library    BuiltIn
Library    DateTime
Library    RequestsLibrary
Library    DatabaseLibrary
Library    ../../resources/libraries/common.py
Library    Telnet

*** Variables ***
# *** DB VARIABLES ***
${db_engine}
${db_port}
${default_db_host}    127.0.0.1
${default_db_name}    eu-docker
${default_db_password}    secret
${default_db_port}    3306
${default_db_port_postgres}    5432
${default_db_user}    spryker
${default_db_engine}    pymysql
# ${default_db_engine}       psycopg2

# *** DOCKER VARIABLES ***
${docker}
${default_docker}     ${False}
${docker_db_host}     database
${docker_cli_url}     http://cli:9000
${cli_path}    ..

# *** CLI VARIABLES ***
${project_location}
${ignore_console}
${default_ignore_console}    ${True}

# *** COMMON VARIABLES ***
${verify_ssl}          false

*** Keywords ***
Common_suite_setup
    [documentation]  Basic steps before each suite
    Remove Files    ${OUTPUTDIR}/selenium-screenshot-*.png
    Remove Files    resources/libraries/__pycache__/*
    Remove Files    ${OUTPUTDIR}/*.png
    Remove Files    ${OUTPUTDIR}/*.yml
    Load Variables    ${env}
    Overwrite env variables
    ${random}=    Generate Random String    5    [NUMBERS]
    Set Global Variable    ${random}
    ${today}=    Get Current Date    result_format=%Y-%m-%d
    Set Global Variable    ${today}
    IF    ${docker}
        Set Global Variable    ${db_host}    ${docker_db_host}
    END
    [Return]    ${random}

Load Variables
    [Documentation]    Keyword is used to load variable values from the environment file passed during execution. This Keyword is used during suite setup.
    ...    It accepts the name of the environment as specified at the beginning of an environment file e.g. ``"environment": "api_suite"``.
    ...
    ...    These variables are loaded and usable throughtout all tests of the test suite, if this keyword is called during suite setup.
    ...
    ...    *Example:*
    ...
    ...    ``Load Variables    ${env}``
    ...
    ...    ``Load Variables    api_suite``
    [Arguments]    ${env}
    &{vars}=   Define Environment Variables From Json File    ${env}
    FOR    ${key}    ${value}    IN    &{vars}
        Log    Key is '${key}' and value is '${value}'.
        ${var_value}=   Get Variable Value  ${${key}}   ${value}
        Set Global Variable    ${${key}}    ${var_value}
    END

Overwrite env variables
    IF    '${project_location}' == '${EMPTY}'
            Set Suite Variable    ${cli_path}    ${cli_path}
    ELSE
            Set Suite Variable    ${cli_path}    ${project_location}
    END
    IF    '${ignore_console}' == '${EMPTY}'
            Set Suite Variable    ${ignore_console}    ${default_ignore_console}
    ELSE
            Set Suite Variable    ${ignore_console}    ${ignore_console}
    END
    IF    '${docker}' == '${EMPTY}'
            Set Suite Variable    ${docker}    ${default_docker}
    ELSE
            Set Suite Variable    ${docker}    ${docker}
    END
    IF    '${ignore_console}' == 'true'    Set Suite Variable    ${ignore_console}    ${True}
    IF    '${ignore_console}' == 'false'    Set Suite Variable    ${ignore_console}    ${False}
    IF    '${docker}' == 'true'    Set Suite Variable    ${docker}    ${True}
    IF    '${docker}' == 'false'    Set Suite Variable    ${docker}    ${False}
    ${verify_ssl}=    Convert To String    ${verify_ssl}
    ${verify_ssl}=    Convert To Lower Case    ${verify_ssl}
    IF    '${verify_ssl}' == 'true'
        Set Global Variable    ${verify_ssl}    ${True}
    ELSE
        Set Global Variable    ${verify_ssl}    ${False}
    END

Set Up Keyword Arguments
    [Arguments]    @{args}
    &{arguments}=    Fill Variables From Text String    @{args}
    FOR    ${key}    ${value}    IN    &{arguments}
        Log    Key is '${key}' and value is '${value}'.
        ${var_value}=   Set Variable    ${value}
        Set Test Variable    ${${key}}    ${var_value}
    END
    [Return]    &{arguments}

Variable datatype should be:
    [Arguments]    ${variable}    ${expected_data_type}
    ${actual_data_type}=    Evaluate datatype of a variable:    ${variable}
    Should Be Equal    ${actual_data_type}    ${expected_data_type}

Evaluate datatype of a variable:
    [Arguments]    ${variable}
    ${data_type}=    Evaluate     type($variable).__name__
    [Return]    ${data_type}
    #Example of assertions:
    # ${is int}=      Evaluate     isinstance($variable, int)    # will be True
    # ${is string}=   Evaluate     isinstance($variable, str)    # will be False

Conver string to List by separator:
    [Arguments]    ${string}    ${separator}=,
    ${convertedList}=    Split String    ${string}    ${separator}
    ${convertedList}=    Set Test Variable    ${convertedList}
    [Return]    ${convertedList}

Remove leading and trailing whitespace from a string:
    [Arguments]    ${string}
    ${string}=    Replace String Using Regexp    ${string}    (^[ ]+|[ ]+$)    ${EMPTY}
    Set Global Variable    ${string}
    [Return]    ${string}

Connect to Spryker DB
    [Documentation]    This keyword allows to connect to Spryker DB.
    ...        Supports both MariaDB and PostgeSQL.
    ...
    ...        To specify the expected DB engine, use ``db_engine`` variabl. Default one -> *MariaDB*
    ...
    ...    *Example:*
    ...    ``robot -v env:api_suite -v db_engine:psycopg2``
    ...
    ...    with the example above you'll use PostgreSQL DB engine
    ${db_name}=    Set Variable If    '${db_name}' == '${EMPTY}'    ${default_db_name}    ${db_name}
    ${db_user}=    Set Variable If    '${db_user}' == '${EMPTY}'    ${default_db_user}    ${db_user}
    ${db_password}=    Set Variable If    '${db_password}' == '${EMPTY}'    ${default_db_password}    ${db_password}
    ${db_host}=    Set Variable If    '${db_host}' == '${EMPTY}'    ${default_db_host}    ${db_host}
    ${db_engine}=    Set Variable If    '${db_engine}' == '${EMPTY}'    ${default_db_engine}    ${db_engine}
    ${db_engine}=    Convert To Lower Case    ${db_engine}
    IF    '${db_engine}' == 'mysql'
        ${db_engine}=    Set Variable    pymysql
    ELSE IF    '${db_engine}' == 'postgresql'
        ${db_engine}=    Set Variable    psycopg2
    ELSE IF    '${db_engine}' == 'postgres'
        ${db_engine}=    Set Variable    psycopg2
    END
    IF    '${db_engine}' == 'psycopg2'
        ${db_port}=    Set Variable If    '${db_port}' == '${EMPTY}'    ${db_port_postgres_env}    ${db_port}
        IF    '${db_port_postgres_env}' == '${EMPTY}'
        ${db_port}=    Set Variable If    '${db_port_postgres_env}' == '${EMPTY}'    ${default_db_port_postgres}    ${db_port_postgres_env}
        END
    ELSE
    ${db_port}=    Set Variable If    '${db_port}' == '${EMPTY}'    ${db_port_env}    ${db_port}
        IF    '${db_port_env}' == '${EMPTY}'
        ${db_port}=    Set Variable If    '${db_port_env}' == '${EMPTY}'    ${default_db_port}    ${db_port_env}
        END
    END
    Set Test Variable    ${db_engine}
    Connect To Database    ${db_engine}    ${db_name}    ${db_user}    ${db_password}    ${db_host}    ${db_port}

Save the result of a SELECT DB query to a variable:
    [Documentation]    This keyword saves any value which you receive from DB using SQL query ``${sql_query}`` to a test variable called ``${variable_name}``.
    ...
    ...    It can be used to save a value returned by any query into a custom test variable.
    ...    This variable, once created, can be used during the specific test where this keyword is used and can be re-used by the keywords that follow this keyword in the test.
    ...    It will not be visible to other tests.
    ...    NOTE: Make sure that you expect only 1 value from DB, you can also check your query via external SQL tool.
    ...
    ...    *Examples:*
    ...
    ...    ``Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where customer_reference = '${user_reference_id}'    confirmation_key``
    [Arguments]    ${sql_query}    ${variable_name}
    Connect to Spryker DB
    ${var_value} =    Query    ${sql_query}
    Disconnect From Database
    ${var_value}=    Convert To String    ${var_value}
    ${var_value}=    Replace String    ${var_value}    '   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    ,   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    (   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    )   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    [   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    ]   ${EMPTY}
    Set Test Variable    ${${variable_name}}    ${var_value}
    [Return]    ${variable_name}

Send GET request and return status code:
    [Arguments]    ${url}    ${timeout}=5
    ${response}=    GET    ${url}    timeout=${timeout}    allow_redirects=true    expected_status=ANY
    Set Test Variable    ${response.status_code}    ${response.status_code}
    [Return]    ${response.status_code}

Run console command
    [Documentation]    This keyword executes console command using provided command and parameters. If docker is enabled, it will execute the command using docker.
        ...    *Example:*
        ...
        ...    ``Run console command    command=publish:trigger-events parameters=-r service_point    storeName=DE``
        ...
    [Arguments]    ${command}    ${storeName}=DE
    ${consoleCommand}=    Set Variable    cd ${cli_path} && APPLICATION_STORE=${storeName} docker/sdk ${command}
    IF    ${docker}
        ${consoleCommand}=    Set Variable    curl --request POST -LsS --data "APPLICATION_STORE='${storeName}' COMMAND='${command}' cli.sh" --max-time 1000 --url "${docker_cli_url}/console"
        ${rc}    ${output}=    Run And Return RC And Output    ${consoleCommand}
        Log   ${output}
        Should Be Equal As Integers    ${rc}    0    message=CLI command can't be executed. Check '{docker}', '{ignore_console}' variables value and cli execution path: '{cli_path}'
    END
    IF    ${ignore_console} != True
        ${rc}    ${output}=    Run And Return RC And Output    ${consoleCommand}
        Log   ${output}
        Should Be Equal As Integers    ${rc}    0    message=CLI command can't be executed. Check '{docker}', '{ignore_console}' variables value and cli execution path: '{cli_path}'
    END

Trigger p&s
    [Arguments]    ${timeout}=5s    ${storeName}=DE
    Run console command    console queue:worker:start --stop-when-empty    ${storeName}
    IF    ${docker} or ${ignore_console} != True    Sleep    ${timeout}

Trigger API specification update
    [Arguments]    ${timeout}=5s    ${storeName}=DE
    Run console command    cli glue api:generate:documentation --invalidated-after-interval 90sec    ${storeName}
    IF    ${docker} or ${ignore_console} != True    Sleep    ${timeout}

Trigger multistore p&s
    [Arguments]    ${timeout}=5s
    Trigger p&s    ${timeout}    DE
    Trigger p&s    ${timeout}    AT

Trigger oms
    [Arguments]    ${timeout}=5s
    Run console command    console order:invoice:send    DE
    Run console command    console order:invoice:send    AT
    Run console command    console oms:check-timeout    DE
    Run console command    console oms:check-timeout    AT
    Run console command    console oms:check-condition    DE
    Run console command    console oms:check-condition    AT
    IF    ${docker} or ${ignore_console} != True    Sleep    ${timeout}

Trigger publish trigger-events
    [Documentation]    This keyword triggers publish:trigger-events console command using provided resource, path and store.
        ...    *Example:*
        ...
        ...    ``Trigger publish trigger-events    resource=service_point    storeName=DE    timeout=5s``
        ...
    [Arguments]    ${resource}    ${storeName}=DE    ${timeout}=5s
    Run console command    console publish:trigger-events -r ${resource}    ${storeName}
    Trigger p&s    ${timeout}    ${storeName}

Get next id from table
    [Documentation]    This keyword returns next ID from the given table.
        ...    *Example:*
        ...
        ...    ``Get next id from table    tableName=product    idColumnName=id_product``
        ...
    [Arguments]    ${tableName}    ${idColumnName}
    Connect to Spryker DB
    ${lastId}=    Query    SELECT ${idColumnName} FROM ${tableName} ORDER BY ${idColumnName} DESC LIMIT 1;
    ${newId}=    Set Variable    ${EMPTY}
    ${lastIdLength}=    Get Length    ${lastId}
    IF    ${lastIdLength} > 0
        ${newId}=    Evaluate    ${lastId[0][0]} + 1
    ELSE
        ${newId}=    Evaluate    1
    END
    Disconnect From Database
    Log    ${newId}
    [Return]    ${newId}

Get concrete product sku by id from DB:
    [Documentation]    This keyword returns product concrete sku from DB found by id_product. Returns '${concrete_sku}' variable
    ...    *Example:*
    ...
    ...    ``Get concrete product sku by id from DB:    ${id_product}``
    ...
    [Arguments]    ${id_product}
    Connect to Spryker DB
    ${concrete_sku}=    Query    select sku from spy_product WHERE id_product='${id_product}';
    ${concrete_sku}=    Get From List    ${concrete_sku}    0
    ${concrete_sku}=    Convert To String    ${concrete_sku[0]}
    Set Test Variable    ${concrete_sku}    ${concrete_sku}
    Disconnect From Database

Create giftcode in Database:
    [Documentation]    This keyword creates a new entry in the DB table spy_gift_card with the name, value and gift-card code.
        ...    *Example:*
        ...
        ...    ``Create giftcode in Database:    checkout_${random}    ${gift_card.amount}``
        ...
    [Arguments]    ${spy_gift_card_code}    ${spy_gift_card_value}
    ${amount}=   Evaluate    ${spy_gift_card_value} / 100
    ${amount}=    Evaluate    "%.f" % ${amount}
    ${new_id}=    Get next id from table    spy_gift_card    id_gift_card
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_gift_card (code,name,currency_iso_code,value) value ('${spy_gift_card_code}','Gift_card_${amount}','EUR','${spy_gift_card_value}')
    ELSE
        Execute Sql String    INSERT INTO spy_gift_card (id_gift_card, code, name, currency_iso_code, value) VALUES (${new_id}, '${spy_gift_card_code}', 'Gift_card_${amount}', 'EUR', '${spy_gift_card_value}');
    END
    Disconnect From Database

Update order status in Database:
    [Documentation]    This keyword updates order status in database to any required status. This allows to skip going through the order workflow manually
    ...    but just switch to the status you need to create a test.
    ...    There is no separate endpoint to update order status and this keyword allows to do this via database value update.
    ...    *Example:*
    ...
    ...    ``Update order status in Database:    7    shipped``
    [Arguments]    ${order_item_status_name}    ${uuid_to_use}
    Connect to Spryker DB
    ${new_id}=    Set Variable    ${EMPTY}
    ${state_id}=    Set Variable    ${EMPTY}
    ${last_id}=    Query    SELECT id_oms_order_item_state FROM spy_oms_order_item_state ORDER BY id_oms_order_item_state DESC LIMIT 1;
    ${expected_state_id}=    Query    SELECT id_oms_order_item_state FROM spy_oms_order_item_state WHERE name='${order_item_status_name}';
    ${last_id_length}=    Get Length    ${last_id}
    ${expected_state_id_length}=    Get Length    ${expected_state_id}
    IF    ${expected_state_id_length} > 0
        ${state_id}=    Set Variable    ${expected_state_id[0][0]}
    ELSE
        ${new_id}=    Evaluate    ${last_id[0][0]} + 1
        Execute Sql String    INSERT INTO spy_oms_order_item_state (id_oms_order_item_state, name) VALUES (${new_id}, '${order_item_status_name}');
        ${state_id}=    Set Variable    ${new_id}
    END
    Execute Sql String    update spy_sales_order_item set fk_oms_order_item_state = '${state_id}' where uuid= '${uuid_to_use}'
    Disconnect From Database

Create merchant order for the item in DB and change status:
    [Documentation]    This keyword creates new merchant order in the DB and sets the desired status . This allows to skip going through the order workflow manually
    ...    but just switch to the status you need to create a test.
    ...    There is no separate endpoint to update order status and this keyword allows to do this via database value update.
    ...    *Example:*
    ...
    ...    ``Create merchant order for the item in DB and change status:    shipped    ${uuid}    ${merchants.sony_experts.merchant_reference}``
    [Arguments]    ${order_item_status_name}    ${uuid_to_use}    ${merchant_reference}
    Connect to Spryker DB
    ${new_id}=    Set Variable    ${EMPTY}
    ${state_id}=    Set Variable    ${EMPTY}
    ${last_id}=    Query    SELECT id_state_machine_item_state FROM spy_state_machine_item_state ORDER BY id_state_machine_item_state DESC LIMIT 1;
    ${expected_state_id}=    Query    SELECT id_state_machine_item_state FROM spy_state_machine_item_state WHERE name='${order_item_status_name}';
    ${last_id_length}=    Get Length    ${last_id}
    IF    ${last_id_length} == 0
        ${state_id}=    Set Variable    1
        ${state_id}=    Convert To String    ${state_id}
    END
    ${expected_state_id_length}=    Get Length    ${expected_state_id}
    IF    ${expected_state_id_length} > 0
        ${state_id}=    Set Variable    ${expected_state_id[0][0]}
    ELSE
        ${state_id}=    Set Variable    ${state_id}
        Execute Sql String    INSERT INTO spy_state_machine_item_state (id_state_machine_item_state, fk_state_machine_process, name) VALUES (${state_id}, 2, '${order_item_status_name}');
    END
    ${last_order_item_id}=    Query    SELECT id_merchant_sales_order_item from spy_merchant_sales_order_item order by id_merchant_sales_order_item desc limit 1;
    ${last_order_item_id_length}=    Get Length    ${last_order_item_id}
    IF    ${last_order_item_id_length} == 0
        ${new_order_item_id}=    Set variable    1
        ${new_order_item_id}=    Convert To String    ${new_order_item_id}
    END
    IF    ${last_order_item_id_length} > 0
        ${new_order_item_id}=    Evaluate    ${last_order_item_id[0][0]} +1
    ELSE
        ${new_order_item_id}=    Set Variable    ${new_order_item_id}
    END
    ${last_merchant_order_id}=    Query    SELECT id_merchant_sales_order from spy_merchant_sales_order order by id_merchant_sales_order desc limit 1;
    ${last_merchant_order_id_length}=    Get Length    ${last_merchant_order_id}
    IF    ${last_merchant_order_id_length} == 0
        ${new_merchant_order_id}=    Set Variable    1
        ${new_merchant_order_id}=    Convert To String    ${new_merchant_order_id}
    END
    IF    ${last_merchant_order_id_length} > 0
        ${new_merchant_order_id}=    Evaluate    ${last_merchant_order_id[0][0]} +1
    ELSE
        ${new_merchant_order_id}=    Set Variable    ${new_merchant_order_id}
    END
    ${sales_order_id}=    Query    SELECT fk_sales_order from spy_sales_order_item where uuid='${uuid_to_use}';
    ${sales_order_id}=    Set Variable    ${sales_order_id[0][0]}
    Execute Sql String    INSERT INTO spy_merchant_sales_order (id_merchant_sales_order, fk_sales_order, merchant_reference, merchant_sales_order_reference) VALUES (${new_merchant_order_id}, ${sales_order_id}, '${merchant_reference}', 'DE--${sales_order_id}--${merchant_reference}');
    ${last_merchant_order_item_id}=    Query    SELECT id_merchant_sales_order from spy_merchant_sales_order order by id_merchant_sales_order desc limit 1;
    ${last_merchant_order_item_id_length}=    Get Length    ${last_merchant_order_item_id}
    IF    ${last_merchant_order_item_id_length} > 0
        ${new_merchant_order_item_id}=    Evaluate    ${last_merchant_order_item_id[0][0]} +1
    END
    ${sales_order_item_id}=    Query    SELECT id_sales_order_item from spy_sales_order_item where uuid='${uuid_to_use}';
    ${sales_order_item_id}=    Set Variable    ${sales_order_item_id[0][0]}
    ${random_merchant_order_item_reference}=    Generate Random String    10    [NUMBERS]
    Execute Sql String    INSERT INTO spy_merchant_sales_order_item (id_merchant_sales_order_item, fk_merchant_sales_order, fk_sales_order_item, fk_state_machine_item_state, merchant_order_item_reference) VALUES (${new_merchant_order_item_id}, ${new_merchant_order_id}, ${sales_order_item_id}, ${state_id}, '${random_merchant_order_item_reference}');
    Disconnect From Database

Delete country by iso2_code in Database:
    [Documentation]    This keyword deletes a country by iso2_code in the DB table spy_country.
        ...    *Example:*
        ...
        ...    ``Delete country by iso2_code in Database:    DE``
        ...
    [Arguments]    ${iso2_code}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_country WHERE iso2_code = '${iso2_code}';
    Disconnect From Database

Create dynamic entity configuration in Database:
     [Documentation]    This keyword create dynamic entity configuration in the DB table spy_dynamic_entity_configuration.
        ...    *Example:*
        ...
        ...    ``Create dynamic entity configuration in Database:    country    spy_country     1   {"identifier":"id_country","fields":[...]}``
        ...
    [Arguments]    ${table_alias}   ${table_name}    ${is_active}    ${definition}
    ${new_id}=    Get next id from table    spy_dynamic_entity_configuration    id_dynamic_entity_configuration
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String  insert ignore into spy_dynamic_entity_configuration (table_alias, table_name, is_active, definition) value ('${table_alias}', '${table_name}', '${is_active}', '${definition}');
    ELSE
        Execute Sql String  insert into spy_dynamic_entity_configuration (id_dynamic_entity_configuration, table_alias, table_name, is_active, definition) values (${new_id}, '${table_alias}', '${table_name}', '${is_active}', '${definition}')
    END
    Disconnect From Database

Delete dynamic entity configuration in Database:
     [Documentation]    This keyword delete dynamic entity configuration in the DB table spy_dynamic_entity_configuration.
        ...    *Example:*
        ...
        ...    ``Delete dynamic entity configuration in Database:    country```
        ...
    [Arguments]    ${table_alias}
    Connect to Spryker DB
    Execute Sql String  DELETE FROM spy_dynamic_entity_configuration WHERE table_alias = '${table_alias}';
    Disconnect From Database

I add 'admin' role to company user and get company_user_uuid:
    [Documentation]    This is a helper keyword which sets the 'Admin' role to the company user if it is not already set and returns the uuid of this company user. Requires: company user email, company key and business unit key
    ...    *Example:*
    ...
    ...    ``Add 'admin' role to company user and return company_user_uuid:    anne.boleyn@spryker.com    BoB-Hotel-Jim    business-unit-jim-1``
    [Arguments]    ${email}    ${company_key}    ${business_unit_key}
    Connect to Spryker DB
    ${id_customer}=    Query    select id_customer from spy_customer WHERE email='${email}'
    ${id_customer}=    Evaluate    ${id_customer[0][0]}+0
    IF    '${db_engine}' == 'pymysql'
        ${id_business_unit}=    Query    select id_company_business_unit from spy_company_business_unit where `key`='${business_unit_key}'
    ELSE
        ${id_business_unit}=    Query    select id_company_business_unit from spy_company_business_unit where "key"='${business_unit_key}'
    END
    ${id_business_unit}=    Evaluate    ${id_business_unit[0][0]}+0
    IF    '${db_engine}' == 'pymysql'
        ${id_company}=    Query    select id_company from spy_company WHERE `key`='${company_key}'
    ELSE
        ${id_company}=    Query    select id_company from spy_company WHERE "key"='${company_key}'
    END
    ${id_company}=    Evaluate    ${id_company[0][0]}+0
    ${id_company_user}=    Query    select id_company_user from spy_company_user WHERE fk_customer=${id_customer} and fk_company_business_unit=${id_business_unit} and fk_company=${id_company}
    ${id_company_user}=    Evaluate    ${id_company_user[0][0]}+0
    ${id_company_role_admin}=    Query    select id_company_role from spy_company_role WHERE name='Admin' and fk_company='${id_company}'
    ${id_company_role_admin}=    Evaluate    ${id_company_role_admin[0][0]}+0
    ${is_role_set}=    Query    SELECT id_company_role_to_company_user FROM spy_company_role_to_company_user WHERE fk_company_role = ${id_company_role_admin} and fk_company_user = ${id_company_user}
    ${is_role_set_length}=    Get Length    ${is_role_set}
    IF    ${is_role_set_length} == 0
        ${last_id}=    Query    SELECT id_company_role_to_company_user FROM spy_company_role_to_company_user ORDER BY id_company_role_to_company_user DESC LIMIT 1;
        ${new_id}=    Evaluate    ${last_id[0][0]}+1
        Execute Sql String    INSERT INTO spy_company_role_to_company_user (id_company_role_to_company_user, fk_company_role, fk_company_user) VALUES (${new_id}, ${id_company_role_admin}, ${id_company_user});
    END
    ${company_user_uuid}=    Query    select uuid from spy_company_user where id_company_user=${id_company_user}
    ${company_user_uuid}=    Convert To String    ${company_user_uuid}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    '   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    ,   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    (   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    )   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    [   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    ]   ${EMPTY}
    Set Test Variable    ${company_user_uuid}    ${company_user_uuid}
    [Return]    ${company_user_uuid}

Get voucher code by discountId from Database:
    [Documentation]    This keyword allows to get voucher code according to the discount ID. Discount_id can be found in Backoffice > Merchandising > Discount page
    ...        and set this id as an argument of a keyword.
    ...
    ...    *Example:*
    ...    ``Get voucher code by discountId from Database:    3``
    [Arguments]    ${discount_id}
    Save the result of a SELECT DB query to a variable:    select fk_discount_voucher_pool from spy_discount where id_discount = ${discount_id}    discount_voucher_pool_id
    IF    '${db_engine}' == 'pymysql'
        Save the result of a SELECT DB query to a variable:    select code from spy_discount_voucher where fk_discount_voucher_pool = ${discount_voucher_pool_id} and is_active = 1 limit 1    discount_voucher_code
    ELSE
        Save the result of a SELECT DB query to a variable:    select code from spy_discount_voucher where fk_discount_voucher_pool = ${discount_voucher_pool_id} and is_active = true limit 1    discount_voucher_code
    END

Create dynamic entity configuration relation in Database:
     [Documentation]    This keyword create dynamic entity configuration in the DB tables spy_dynamic_entity_configuration_relation and spy_dynamic_entity_configuration_relation_mapping.
        ...    *Example:*
        ...
        ...   TODO Finish this keyword
        ...    ``Create dynamic entity configuration relation in Database:    country    spy_country     1   {"identifier":"id_country","fields":[...]}``
        ...
    [Arguments]    ${parent_dynamic_entity_configuration_alias}   ${child_dynamic_entity_configuration_alias}    ${name}    ${child_field_name}   ${parent_field_name}

    Connect to Spryker DB

    ${parent_dynamic_entity_configuration_alias_id}=    Query    SELECT id_dynamic_entity_configuration from spy_dynamic_entity_configuration where table_alias='${parent_dynamic_entity_configuration_alias}';
    ${parent_dynamic_entity_configuration_alias_id}=    Set Variable    ${parent_dynamic_entity_configuration_alias_id[0][0]}
    Log  ${parent_dynamic_entity_configuration_alias_id}
    ${child_dynamic_entity_configuration_alias_id}=    Query    SELECT id_dynamic_entity_configuration from spy_dynamic_entity_configuration where table_alias='${child_dynamic_entity_configuration_alias}';
    ${child_dynamic_entity_configuration_alias_id}=    Set Variable    ${child_dynamic_entity_configuration_alias_id[0][0]}
    Log  ${child_dynamic_entity_configuration_alias_id}

    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    INSERT INTO spy_dynamic_entity_configuration_relation (fk_parent_dynamic_entity_configuration,fk_child_dynamic_entity_configuration,name,is_editable) VALUES (${parent_dynamic_entity_configuration_alias_id},${child_dynamic_entity_configuration_alias_id},'${name}',1);
    ELSE
        ${new_relation_id}=    Get next id from table    spy_dynamic_entity_configuration_relation    id_dynamic_entity_configuration_relation
        Log  ${new_relation_id}

        Execute Sql String    INSERT INTO spy_dynamic_entity_configuration_relation (id_dynamic_entity_configuration_relation, fk_parent_dynamic_entity_configuration, fk_child_dynamic_entity_configuration,name,is_editable) values (${new_relation_id}, ${parent_dynamic_entity_configuration_alias_id},${child_dynamic_entity_configuration_alias_id},'${name}',1);
    END

    ${dynamic_entity_configuration_relation_id}=    Query    SELECT id_dynamic_entity_configuration_relation from spy_dynamic_entity_configuration_relation where name='${name}';
    ${dynamic_entity_configuration_relation_id}=    Set Variable    ${dynamic_entity_configuration_relation_id[0][0]}

    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_dynamic_entity_configuration_relation_field_mapping (fk_dynamic_entity_configuration_relation, parent_field_name, child_field_name) value (${dynamic_entity_configuration_relation_id}, '${parent_field_name}', '${child_field_name}');
    ELSE
        ${new_mapping_id}=    Get next id from table    spy_dynamic_entity_configuration_relation_field_mapping    id_dynamic_entity_configuration_relation_field_mapping
        Execute Sql String  insert into spy_dynamic_entity_configuration_relation_mapping (id_dynamic_entity_configuration_relation_field_mapping, fk_dynamic_entity_configuration_relation, parent_field_name, child_field_name) values (${new_mapping_id},'${dynamic_entity_configuration_relation_id}','${parent_field_name}','${child_field_name}')
    END
    Disconnect From Database

Delete dynamic entity configuration relation in Database:
     [Documentation]    This keyword delete dynamic entity configuration in the DB table spy_dynamic_entity_configuration_relation.
        ...    *Example:*
        ...
        ...    ``Delete dynamic entity configuration relation in Database:    name```
        ...
    [Arguments]    ${relation_name}
    Connect to Spryker DB
    ${dynamic_entity_configuration_relation_id}=    Query    SELECT id_dynamic_entity_configuration_relation from spy_dynamic_entity_configuration_relation where name='${relation_name}';
    Log    ${dynamic_entity_configuration_relation_id}
    ${dynamic_entity_configuration_relation_id_length}=    Get Length    ${dynamic_entity_configuration_relation_id}
    ${dynamic_entity_configuration_relation_id_length}=    Set Variable    ${dynamic_entity_configuration_relation_id_length}
    Log    ${dynamic_entity_configuration_relation_id_length}
    IF   ${dynamic_entity_configuration_relation_id_length} > 0
        ${dynamic_entity_configuration_relation_id}=    Set Variable    ${dynamic_entity_configuration_relation_id[0][0]}
        Log   ${dynamic_entity_configuration_relation_id}

        Execute Sql String  DELETE FROM spy_dynamic_entity_configuration_relation_field_mapping WHERE fk_dynamic_entity_configuration_relation = ${dynamic_entity_configuration_relation_id};
        Execute Sql String  DELETE FROM spy_dynamic_entity_configuration_relation WHERE id_dynamic_entity_configuration_relation = ${dynamic_entity_configuration_relation_id};
    END

    Disconnect From Database
