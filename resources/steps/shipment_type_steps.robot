*** Settings ***
Library    DatabaseLibrary
Library    BuiltIn
Library    ../../resources/libraries/common.py
Resource    ../common/common_api.robot

*** Keywords ***
Deactivate shipment types
    [Documentation]    This keyword deactivates shipment types. If `uuid` is provided, deactivates shipment type by uuid.
        ...    *Example:*
        ...
        ...    ``Deactivate shipment types in DB    uuid=e086c160-b5de-474c-a19b-1f42c85ae996``
        ...
    [Arguments]    ${uuid}=${None}
    ${query}    Set Variable    UPDATE spy_shipment_type SET is_active = false
    IF    '${uuid}' != '${None}'
         ${query}    Set Variable    ${query} WHERE uuid = '${uuid}'
    END
    Log   ${query}
    Connect to Spryker DB
    Execute Sql String    ${query};
    Disconnect From Database
    Trigger publish trigger-events    shipment_type    ${console_path}    timeout=1s

Active shipment types
    [Documentation]    This keyword activates shipment types. If `uuid` is provided, activates shipment type by uuid.
        ...    *Example:*
        ...
        ...    ``Activate shipment types in DB    uuid=e086c160-b5de-474c-a19b-1f42c85ae996``
        ...
    [Arguments]    ${uuid}=${None}
    ${query}    Set Variable    UPDATE spy_shipment_type SET is_active = true
    IF    '${uuid}' != '${None}'
         ${query}    Set Variable    ${query} WHERE uuid = '${uuid}'
    END
    Log   ${query}
    Connect to Spryker DB
    Execute Sql String    ${query};
    Disconnect From Database
    Trigger publish trigger-events    shipment_type    ${console_path}    timeout=1s

Create shipment type in DB
    [Documentation]    This keyword creates a new entry in the DB table `spy_shipment_type`. If `storeName` is provided, creates store relation.
            ...    *Example:*
            ...
            ...    ``Create shipment type in DB    uuid=e086c160-b5de-474c-a19b-1f42c85ae996    name=Free pick up    key=fp    isActive=true    storeName=DE``
            ...
        [Arguments]    ${uuid}=${None}    ${name}=${None}    ${key}=${None}    ${isActive}=${True}    ${storeName}=DE
        IF    '${uuid}' == '${None}'
            ${uuid}=    Evaluate    uuid.uuid4()
        END
        IF    '${name}' == '${None}'
            ${name}=    Generate Random String    5    [LETTERS]
        END
        IF    '${key}' == '${None}'
            ${key}=    Generate Random String    5    [LETTERS]
        END
        ${idShipmentType}=    Get next id from table    spy_shipment_type    id_shipment_type
        Connect to Spryker DB
        IF    '${db_engine}' == 'pymysql'
            Execute Sql String    insert ignore into spy_shipment_type (`key`, name, uuid, is_active) value ('${key}', '${name}', '${uuid}', ${isActive});
        ELSE
            Execute Sql String    INSERT INTO spy_shipment_type (id_shipment_type, key, name, uuid, is_active) VALUES (${idShipmentType}, '${key}', '${name}', '${uuid}', ${isActive});
        END
        Disconnect From Database
        IF    '${storeName}' != '${None}'
            Create shipment type store relation in DB    ${uuid}    ${storeName}
        END

Create shipment type store relation in DB
    [Documentation]    This keyword creates a new entry in the DB table `spy_shipment_type_store`.
        ...    *Example:*
        ...
        ...    ``Create shipment type store relation in DB    shipmentTypeUuid=e086c160-b5de-474c-a19b-1f42c85ae996    storeName=DE``
        ...
    [Arguments]    ${shipmentTypeUuid}    ${storeName}
    ${idShipmentType}=    Get id shipment type by uuid    ${shipmentTypeUuid}
    ${idShipmentTypeStore}=    Get next id from table    spy_shipment_type_store    id_shipment_type_store
    Connect to Spryker DB
    ${storeIds}=    Query    SELECT id_store FROM spy_store WHERE name = '${storeName}' ORDER BY id_store DESC LIMIT 1;
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_shipment_type_store (fk_shipment_type, fk_store) value (${idShipmentType}, ${storeIds[0][0]});
    ELSE
        Execute Sql String    INSERT INTO spy_shipment_type_store (id_shipment_tyoe_store, fk_shipment_type, fk_store) VALUES (${idShipmentTypeStore}, ${idShipmentType}, ${storeIds[0][0]});
    END
    Disconnect From Database

Get id shipment type by uuid
    [Documentation]    This keyword returns Shipment Type ID by Shipment Type UUID.
        ...    *Example:*
        ...
        ...    ``Get id shipment type by uuid    uuid=e086c160-b5de-474c-a19b-1f42c85ae996``
        ...
    [Arguments]    ${uuid}
    Connect to Spryker DB
    ${shipmentTypeIds}    Query    SELECT id_shipment_type FROM spy_shipment_type WHERE uuid = '${uuid}' ORDER BY id_shipment_type DESC LIMIT 1;
    Disconnect From Database
    [Return]    ${shipmentTypeIds[0][0]}

Delete shipment type in DB
    [Documentation]    This keyword deletes the entry from the DB table `spy_shipment_type`. If `withRelations=true`, deletes with relations.
        ...    *Example:*
        ...
        ...    ``Delete shipment type in DB    uuid=e086c160-b5de-474c-a19b-1f42c85ae996    withRelations=true``
        ...
    [Arguments]    ${uuid}    ${withRelations}=${True}
    Deactivate shipment types    ${uuid}
    IF    ${withRelations}
        ${idShipmentType}=    Get id shipment type by uuid    ${uuid}
        Connect to Spryker DB
        Execute Sql String    DELETE FROM spy_shipment_type_store WHERE fk_shipment_type = ${idShipmentType};
        Disconnect From Database
    END
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_shipment_type WHERE uuid = '${uuid}';
    Disconnect From Database
