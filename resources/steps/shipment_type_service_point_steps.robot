*** Settings ***
Library    DatabaseLibrary
Library    BuiltIn
Library    ../../resources/libraries/common.py
Resource    ../common/common_api.robot
Resource    service_point_steps.robot
Resource    shipment_type_steps.robot

*** Keywords ***
Create shipment type service type relation in DB
    [Documentation]    This keyword creates a new entry in the DB table `spy_shipmetn_type_service_type`.
        ...    *Example:*
        ...
        ...    ``Create shipemnt type service type relation in DB    idShipmentType=1    idServiceType=1``
        ...
    [Arguments]    ${shipmentTypeUuid}    ${serviceTypeUuid}
    ${idShipmentType}=               Get id shipment type by uuid  ${shipmentTypeUuid}
    ${idServiceType}=                Get id service type by uuid  ${serviceTypeUuid}
    ${idShipmentTypeServiceType}=    Get next id from table    spy_shipment_type_service_type    id_shipment_type_service_type
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    INSERT IGNORE INTO spy_shipment_type_service_type (fk_shipment_type, fk_service_type) VALUE (${idShipmentType}, ${idServiceType});
    ELSE
        Execute Sql String    INSERT INTO spy_shipment_type_service_type (id_shipment_type_service_type, fk_shipment_type, fk_service_type) VALUES (${idShipmentTypeServiceType}, ${idShipmentType}, ${idServiceType});
    END
    Disconnect From Database

Delete shipment type service type in DB
    [Documentation]    This keyword deletes the entry from the DB table `spy_shipment_type_service_type`.
        ...    *Example:*
        ...
        ...    ``Delete service type in DB    uuid=33a7-5c55-9b04``
        ...
    [Arguments]    ${shipmentTypeUuid}
    ${idShipmentType}=    Get id shipment type by uuid  ${shipmentTypeUuid}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_shipment_type_service_type WHERE fk_shipment_type = ${idShipmentType};
    Disconnect From Database
