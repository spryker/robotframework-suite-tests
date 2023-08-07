@@ -0,0 +1,209 @@
*** Settings ***
Library    DatabaseLibrary
Library    BuiltIn
Library    ../../resources/libraries/common.py
Resource    ../common/common_api.robot

*** Keywords ***

Get shipment type id in DB by key:
    [Documentation]    This keyword get the entry from the DB table `spy_shipment_type`. 
        ...    *Example:*
        ...
        ...    ``Get shipment type id in DB by key:    some-shipment-type-61152``
        ...
    [Arguments]    ${key}
    Connect to Spryker DB
    ${id_shipment_type_store}    Query    SELECT id_shipment_type FROM spy_shipment_type WHERE key = '${key}' ORDER BY id_shipment_type DESC LIMIT 1;

    Disconnect From Database
    [Return]    ${id_shipment_type_store[0][0]}

Delete shipment type in DB:
    [Documentation]    This keyword deletes the entry from the DB table `spy_shipment_type`. If `withRelations=true`, deletes with relations.
        ...    *Example:*
        ...
        ...    ``Delete shipment type in DB:    some-shipment-type-61152    withRelations=true``
        ...
    [Arguments]    ${key}    ${withRelations}=${True}
    IF    ${withRelations}
        ${id_shipment_type_store}=    Get shipment type id in DB by key:    ${key} 
        Connect to Spryker DB
        Execute Sql String    DELETE FROM spy_shipment_type_store WHERE fk_shipment_type = ${id_shipment_type_store};
        Execute Sql String    DELETE FROM spy_shipment_type WHERE key = '${key}';
        Disconnect From Database
    END
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_shipment_type WHERE key = '${key}';
    Disconnect From Database