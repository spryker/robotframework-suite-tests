*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../resources/common/common_api.robot
Test Tags    glue    dms

*** Test Cases ***
ENABLER
    API_test_setup

# Example_test
#     When I send a GET request:    /concrete-products/${product_with_alternative.concrete_sku}/abstract-alternative-products
#     Then Response status code should be:    200

# Abstract_product_with_abstract_includes_for_labels
#     [Setup]    Log    Hello
#     When I send a GET request:    /abstract-products/${abstract_product.product_with_label.sku}?include=product-labels