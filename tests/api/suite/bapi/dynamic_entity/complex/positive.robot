*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

Get_product_abstract_collection_with_childs: 
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    test-product-abstracts
    Create dynamic entity configuration in Database:    test-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}