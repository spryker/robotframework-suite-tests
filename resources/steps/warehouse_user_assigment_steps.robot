*** Settings ***
Library    DatabaseLibrary
Library    BuiltIn
Library    ../../resources/libraries/common.py
Resource    ../common/common_api.robot

*** Keywords ***

Create_warehouse_user_assigment:
    [Documentation]    This keyword creates new warehouse user assigment in the DB table `spy_warehouse_user_assignment`. 
        ...    *Example:*
        ...
        ...    ``Create_warehouse_user_assigment:   ${warehouse_uuid}    ${user_uuid}    false``
        ...
    [Arguments]    ${warehouse_uuid}    ${fk_warehouse}    ${user_uuid}    ${isActive}
    ${idWarehouseUserAssignment}=    Get next id from table    spy_warehouse_user_assignment    id_warehouse_user_assignment
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_warehouse_user_assignment (uuid, fk_warehouse, user_uuid, is_active) value ('${warehouse_uuid}',${fk_warehouse}, '${user_uuid}', ${isActive});
    ELSE
        Execute Sql String    INSERT INTO spy_warehouse_user_assignment (id_warehouse_user_assignment, uuid, fk_warehouse, user_uuid, is_active) VALUES (${idWarehouseUserAssignment},'${warehouse_uuid}',${fk_warehouse}, '${user_uuid}', ${isActive});
    END
    Disconnect From Database
    
Get_warehouse_user_assigment_id:
    [Documentation]    This keyword retrive  warehouse user assigment  ${id_warehouse_user_assigment} in the DB table `spy_warehouse_user_assignment` by uuuid and user_uuid. 
        ...    *Example:*
        ...
        ...    ``Get_warehouse_user_assigment_id:   ${warehouse_uuid}    ${user_uuid}`
        ...
    [Arguments]    ${warehouse_uuid}    ${user_uuid}
    Connect to Spryker DB
    ${id_warehouse_user_assigment}=   Query    SELECT id_warehouse_user_assignment FROM spy_warehouse_user_assignment WHERE uuid = '${warehouse_uuid}' AND user_uuid='${user_uuid}';
    Disconnect From Database
    Set Test Variable    ${id_warehouse_user_assigment}    ${id_warehouse_user_assigment[0][0]}
    [Return]    ${id_warehouse_user_assigment}

Remove_warehous_user_assigment:
    [Documentation]    This keyword deletes the entry from the DB table `spy_warehouse_user_assignment`.
        ...    *Example:*
        ...
        ...    ``Remove_warehous_user_assigment:    ${warehouse_uuid}    ${user_uuid}``
        ...
    [Arguments]    ${warehouse_uuid}    ${user_uuid}
    ${id_warehouse_user_assigment}=    Get_warehouse_user_assigment_id:   ${warehouse_uuid}    ${user_uuid} 
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_warehouse_user_assignment WHERE id_warehouse_user_assignment = ${id_warehouse_user_assigment};
    Disconnect From Database

Make user a warehouse user/ not a warehouse user:
    [Documentation]    This keyword update user with warehouse assigment in the DB table `spy_user`. 
        ...    *Example:*
        ...
        ...    ``Make user a warehouse user/ not a warehouse user:   ${user_uuid}    0``
        ...
    [Arguments]    ${user_uuid}    ${isActive}
    common_api.Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    UPDATE spy_user SET is_warehouse_user = '${isActive}' WHERE uuid = '${user_uuid}';
    ELSE
        Execute Sql String    UPDATE spy_user SET is_warehouse_user = '${isActive}' WHERE uuid = '${user_uuid}';
    END
    Disconnect From Database        