*** Settings ***
Library    DatabaseLibrary
Library    BuiltIn
Library    ../../resources/libraries/common.py
Resource    ../common/common_api.robot

*** Keywords ***

Get shipment type id from DB by key:
    [Documentation]    This keyword gets the entry from the DB table `spy_shipment_type`. 
        ...    *Example:*
        ...
        ...    ``Get shipment type id from DB by key:   some-shipment-type-61152``
        ...
    [Arguments]    ${key}
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql' 
    ${id_shipment_type_store}    Query    SELECT id_shipment_type FROM spy_shipment_type WHERE `key` = '${key}' ORDER BY id_shipment_type DESC LIMIT 1;
    Disconnect From Database
    ELSE
    ${id_shipment_type_store}    Query    SELECT id_shipment_type FROM spy_shipment_type WHERE "key" = '${key}' ORDER BY id_shipment_type DESC LIMIT 1;
    END
    [Return]    ${id_shipment_type_store[0][0]}

Delete shipment type in DB:
    [Documentation]    This keyword deletes the entry from the DB table `spy_shipment_type`. If `withRelations=true`, deletes with relations.
        ...    *Example:*
        ...
        ...    ``Delete shipment type in DB:    some-shipment-type-61152    withRelations=true``
        ...
    [Arguments]    ${key}    ${withRelations}=${True}
    IF    ${withRelations}
        ${id_shipment_type_store}=    Get shipment type id from DB by key:    ${key} 
        Connect to Spryker DB
        IF    '${db_engine}' == 'pymysql' 
        Execute Sql String    DELETE FROM spy_shipment_type_store WHERE fk_shipment_type = ${id_shipment_type_store};
        Execute Sql String    DELETE FROM spy_shipment_type WHERE `key` = '${key}';
        ELSE
        Execute Sql String    DELETE FROM spy_shipment_type_store WHERE fk_shipment_type = ${id_shipment_type_store};
        Execute Sql String    DELETE FROM spy_shipment_type WHERE "key" = '${key}';
        END
        Disconnect From Database
    END
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql' 
        Execute Sql String    DELETE FROM spy_shipment_type WHERE `key` = '${key}';
    ELSE
        Execute Sql String    DELETE FROM spy_shipment_type WHERE "key" = '${key}';
    END
    Disconnect From Database
    

Create_warehouse_user_assigment
    [Documentation]    This is a helper keyword which helps get access token for future use in the headers of the following requests.
    ...
    ...    It gets the token for the specified user ``${email}`` and saves it into the test variable ``${token}``, which can then be used within the scope of the test where this keyword was called.
    ...    After the test ends the ``${token}`` variable is cleared. This keyword needs to be called separately for each test where you expect to need a customer token.
    ...
    ...    The password in this case is not passed to the keyword and the default password stored in ``${default_password}`` will be used when getting token.
    ...
    ...    *Example:*
    ...
    ...    ``I get access token by user credentials:    ${zed_admin.email}``   
    When I get access token by user credentials:    ${zed_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token} 
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    And Save value to a variable:    [data][id]   warehouse_assigment_id

Remove_warehous_user_assigment
    [Documentation]    This is a helper keyword which helps get access token for future use in the headers of the following requests.
    ...
    ...    It gets the token for the specified user ``${email}`` and saves it into the test variable ``${token}``, which can then be used within the scope of the test where this keyword was called.
    ...    After the test ends the ``${token}`` variable is cleared. This keyword needs to be called separately for each test where you expect to need a customer token.
    ...
    ...    The password in this case is not passed to the keyword and the default password stored in ``${default_password}`` will be used when getting token.
    ...
    ...    *Example:*
    ...
    ...    ``I get access token by user credentials:    ${zed_admin.email}``   
    When I get access token by user credentials:    ${zed_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token} 
    When I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}
    And Response status code should be:    204   