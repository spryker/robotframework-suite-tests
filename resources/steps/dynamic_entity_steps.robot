*** Settings ***
Resource    ../common/common_api.robot
Resource    ../common/common_zed.robot


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