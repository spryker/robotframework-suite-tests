*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    API_test_setup

 Get_product_abstract_collection_with_childs:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Delete dynamic entity configuration relation in Database:    robotTestsCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    Delete dynamic entity configuration in Database:    robotests-products
    Delete dynamic entity configuration in Database:    robotests-product-categories
    Delete dynamic entity configuration in Database:    robotests-categories
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robotests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"discount","fieldVisibleName":"discount","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"warehouses","fieldVisibleName":"warehouses","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robotests-product-categories    spy_product_category     1    {"identifier":"id_product_category","fields":[{"fieldName":"id_product_category","fieldVisibleName":"id_product_category","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_category","fieldVisibleName":"fk_category","isCreatable":true,"isEditable":true,"validation":{"isRequired":true},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"product_order","fieldVisibleName":"product_order","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robotests-categories    spy_category     1    {"identifier":"id_category","fields":[{"fieldName":"id_category","fieldVisibleName":"id_category","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_category_template","fieldVisibleName":"fk_category_template","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"category_key","fieldVisibleName":"category_key","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_clickable","fieldVisibleName":"is_clickable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_in_menu","fieldVisibleName":"is_in_menu","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_searchable","fieldVisibleName":"is_searchable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robotests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robotests-products    robotests-product-categories    robotTestsProductCategories    fk_product_abstract    id_product
    Create dynamic entity configuration relation in Database:    robotests-product-categories    robotests-categories    robotTestsCategories    id_category    fk_category
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET PRODUCT ABSTRACT COLLECTION WITH CHILDS ONE LVEL ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts?include=robotTestsProductAbstractProducts
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   [data]    422
    And Response should contain the array of a certain size:   [data][0]    8
    And Response should contain the array of a certain size:   [data][0][robotTestsProductAbstractProducts]    1
    And Each array element of array in response should contain property:    [data]    id_product_abstract
    And Each array element of array in response should contain property:    [data]    sku
    And Each array element of array in response should contain nested property:    [data]    [robotTestsProductAbstractProducts]    id_product
    And Each array element of array in response should contain nested property:    [data]    [robotTestsProductAbstractProducts]    fk_product_abstract
    ### GET PRODUCT ABSTRACT COLLECTION WITH CHILDS AS TREE ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts?include=robotTestsProductAbstractProducts.robotTestsProductCategories.robotTestsCategories
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   [data]    422
    And Response should contain the array of a certain size:   [data][0]    8
    And Response should contain the array of a certain size:   [data][0][robotTestsProductAbstractProducts]    1
    And Response should contain the array of a certain size:   [data][0][robotTestsProductAbstractProducts][0][robotTestsProductCategories]    1
    And Response should contain the array of a certain size:   [data][0][robotTestsProductAbstractProducts][0][robotTestsProductCategories][0][robotTestsCategories]    1

 Get_product_abstract_with_childs_by_id:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Delete dynamic entity configuration relation in Database:    robotTestsCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    Delete dynamic entity configuration in Database:    robotests-products
    Delete dynamic entity configuration in Database:    robotests-product-categories
    Delete dynamic entity configuration in Database:    robotests-categories
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robotests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"discount","fieldVisibleName":"discount","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"warehouses","fieldVisibleName":"warehouses","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robotests-product-categories    spy_product_category     1    {"identifier":"id_product_category","fields":[{"fieldName":"id_product_category","fieldVisibleName":"id_product_category","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_category","fieldVisibleName":"fk_category","isCreatable":true,"isEditable":true,"validation":{"isRequired":true},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"product_order","fieldVisibleName":"product_order","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robotests-categories    spy_category     1    {"identifier":"id_category","fields":[{"fieldName":"id_category","fieldVisibleName":"id_category","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_category_template","fieldVisibleName":"fk_category_template","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"category_key","fieldVisibleName":"category_key","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_clickable","fieldVisibleName":"is_clickable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_in_menu","fieldVisibleName":"is_in_menu","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_searchable","fieldVisibleName":"is_searchable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robotests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robotests-products    robotests-product-categories    robotTestsProductCategories    fk_product_abstract    id_product
    Create dynamic entity configuration relation in Database:    robotests-product-categories    robotests-categories    robotTestsCategories    id_category    fk_category

    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET PRODUCT ABSTRACT COLLECTION WITH CHILDS ONE LVEL ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts/130?include=robotTestsProductAbstractProducts
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   [data]    8
    And Response should contain the array of a certain size:   [data][robotTestsProductAbstractProducts]    1
    And Response body parameter should be:    [data][id_product_abstract]    130
    And Response body parameter should be:    [data][sku]    M21704
    And Response body parameter should be:    [data][robotTestsProductAbstractProducts][0][fk_product_abstract]    130

    ### GET PRODUCT ABSTRACT COLLECTION WITH CHILDS AS TREE ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts/130?include=robotTestsProductAbstractProducts.robotTestsProductCategories.robotTestsCategories
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   [data]    8
    And Response should contain the array of a certain size:   [data][robotTestsProductAbstractProducts]    1
    And Response should contain the array of a certain size:   [data][robotTestsProductAbstractProducts][0][robotTestsProductCategories]    1
    And Response should contain the array of a certain size:   [data][robotTestsProductAbstractProducts][0][robotTestsProductCategories][0][robotTestsCategories]    1
