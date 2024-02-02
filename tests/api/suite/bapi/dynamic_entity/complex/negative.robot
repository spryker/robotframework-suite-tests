*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    API_test_setup

Get_product_abstract_collection_with_invalid_query_parameter:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Delete dynamic entity configuration relation in Database:    robotTestsCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    Delete dynamic entity configuration in Database:    robot-tests-products
    Delete dynamic entity configuration in Database:    robot-tests-product-categories
    Delete dynamic entity configuration in Database:    robot-tests-categories
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"discount","fieldVisibleName":"discount","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"warehouses","fieldVisibleName":"warehouses","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-categories    spy_product_category     1    {"identifier":"id_product_category","fields":[{"fieldName":"id_product_category","fieldVisibleName":"id_product_category","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_category","fieldVisibleName":"fk_category","isCreatable":true,"isEditable":true,"validation":{"isRequired":true},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"product_order","fieldVisibleName":"product_order","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-categories    spy_category     1    {"identifier":"id_category","fields":[{"fieldName":"id_category","fieldVisibleName":"id_category","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_category_template","fieldVisibleName":"fk_category_template","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"category_key","fieldVisibleName":"category_key","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_clickable","fieldVisibleName":"is_clickable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_in_menu","fieldVisibleName":"is_in_menu","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_searchable","fieldVisibleName":"is_searchable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-products    robot-tests-product-categories    robotTestsProductCategories    fk_product_abstract    id_product
    Create dynamic entity configuration relation in Database:    robot-tests-product-categories    robot-tests-categories    robotTestsCategories    id_category    fk_category

    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET PRODUCT ABSTRACT COLLECTION WITH CHILDS ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts?include=test
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1313

Create_product_abstract_collection_with_invalid_child:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Delete dynamic entity configuration relation in Database:    robotTestsCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    Delete dynamic entity configuration in Database:    robot-tests-products
    Delete dynamic entity configuration in Database:    robot-tests-product-categories
    Delete dynamic entity configuration in Database:    robot-tests-categories
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"discount","fieldVisibleName":"discount","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"warehouses","fieldVisibleName":"warehouses","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH INVALID CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProductsInvalid": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1313
    And Response body parameter should be:    [0][message]    Relation `robotTestsProductAbstractProductsInvalid` not found. Please check the requested relation name and try again.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products

Create_product_abstract_collection_with_child_contained_invalid_field:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"discount","fieldVisibleName":"discount","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"warehouses","fieldVisibleName":"warehouses","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD CONTAINED INVALID FIELD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR", "invalid_field": "invalid"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1311
    And Response body parameter should be:    [0][message]    The provided `invalid_field` is incorrect or invalid.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products

Update_product_abstract_collection_with_invalid_child:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"discount","fieldVisibleName":"discount","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"warehouses","fieldVisibleName":"warehouses","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH INVALID CHILD###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PATCH request:   /dynamic-entity/robot-tests-product-abstracts  {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProductsInvalid": [{"id_product": ${id_product}, "attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1313
    And Response body parameter should be:    [0][message]    Relation `robotTestsProductAbstractProductsInvalid` not found. Please check the requested relation name and try again.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}

Update_product_abstract_collection_with_child_contained_invalid_field:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"discount","fieldVisibleName":"discount","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"warehouses","fieldVisibleName":"warehouses","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH INVALID CHILD CONTAINED INVALID FIELD ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PATCH request:   /dynamic-entity/robot-tests-product-abstracts  {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"id_product": ${id_product}, "attributes": "FOOBAR", "sku": "FOOBAR", "invalid_field": "invalid"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1311
    And Response body parameter should be:    [0][message]    The provided `invalid_field` is incorrect or invalid.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}

Update_product_abstract_collection_with_missing_required_field:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"discount","fieldVisibleName":"discount","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"warehouses","fieldVisibleName":"warehouses","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH INVALID CHILD CONTAINED INVALID FIELD ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PATCH request:   /dynamic-entity/robot-tests-product-abstracts  {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"fk_product_abstract": ${id_product_abstract}, "attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1310
    And Response body parameter should be:    [0][message]    Incomplete Request - missing identifier
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}

Upsert_product_abstract_collection_with_invalid_child:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"discount","fieldVisibleName":"discount","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"warehouses","fieldVisibleName":"warehouses","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH INVALID CHILD###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PUT request:   /dynamic-entity/robot-tests-product-abstracts  {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProductsInvalid": [{"id_product": ${id_product}, "attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1313
    And Response body parameter should be:    [0][message]    Relation `robotTestsProductAbstractProductsInvalid` not found. Please check the requested relation name and try again.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}

Upsert_product_abstract_collection_with_child_contained_invalid_field:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"discount","fieldVisibleName":"discount","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"warehouses","fieldVisibleName":"warehouses","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH INVALID CHILD CONTAINED INVALID FIELD ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PUT request:   /dynamic-entity/robot-tests-product-abstracts  {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"id_product": ${id_product}, "attributes": "FOOBAR", "sku": "FOOBAR", "invalid_field": "invalid"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1311
    And Response body parameter should be:    [0][message]    The provided `invalid_field` is incorrect or invalid.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}

Upsert_product_abstract_collection_with_missing_required_field:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"discount","fieldVisibleName":"discount","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"warehouses","fieldVisibleName":"warehouses","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH INVALID CHILD CONTAINED INVALID FIELD ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a PUT request:   /dynamic-entity/robot-tests-product-abstracts  {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"fk_product_abstract": ${id_product_abstract}, "attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1309
    And Response body parameter should be:    [0][message]    Failed to persist the data. Please verify the provided data and try again. Entry is duplicated.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}
