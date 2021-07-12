*** Settings ***
Library    BuiltIn
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Teardown     TestTeardown
Resource    ../../Resources/Common/Common.robot
Resource    ../../Resources/Common/Common_Yves.robot
Resource    ../../Resources/Steps/PDP_steps.robot
Resource    ../../Resources/Steps/Header_steps.robot

*** Test Cases ***
b2c_test_new_function
    Set Up Keyword Arguments    
    ...    || usrname | sku | price   | name           || 
    ...    || test    | 005 | €70.00  | Canon IXUS 175 ||
    Yves: go to PDP of the product with sku:    ${sku}
    Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}    ${addToCartButton} 
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:   ${sku}    ${name}    ${price}