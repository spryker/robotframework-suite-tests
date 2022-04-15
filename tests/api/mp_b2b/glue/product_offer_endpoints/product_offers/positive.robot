*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Get_concrete_product_without_offers
    When I send a GET request:    /concrete-products/${bundle_product_concrete_sku}/product-offers
    Then Response status code should be:    200
    And Response reason should be:    OK

Get_all_concrete_product_offer_info_with_product_offer_prices_included
    When I send a GET request:    /concrete-products/${concrete_product_with_volume_prices}/product-offers?include=product-offer-prices,product-offer-availabilities,merchants
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${second_offer_with_vp}
    And Response body parameter should be:    [data][0][type]    product-offers
    And Response body parameter should be in:    [data][0][attributes][isDefault]    True    False
    And Response body parameter should be:    [data][0][attributes][merchantReference]    ${second_merchant_reference}
    And Response body parameter should not be EMPTY:    [data][0][links][self]
    And Response body parameter should contain:    [data][0][attributes]    merchantSku
    And Response should contain the array of a certain size:    [data][0][relationships][merchants][data]    1
    And Response body parameter should be:    [data][0][relationships][merchants][data][0][id]    ${second_merchant_reference}
    And Response body parameter should be:    [data][0][relationships][merchants][data][0][type]    merchants   
    And Response should contain the array of a certain size:    [data][0][relationships][product-offer-prices][data]    1
    And Response body parameter should be:    [data][0][relationships][product-offer-prices][data][0][id]    ${second_offer_with_vp}
    And Response body parameter should be:    [data][0][relationships][product-offer-prices][data][0][type]    product-offer-prices
    And Response body parameter should be in:    [data][1][attributes][isDefault]    True    False
    And Response body parameter should be:    [data][1][attributes][merchantReference]    ${merchant_reference}
    And Response body parameter should not be EMPTY:    [data][1][links][self]
    And Response body parameter should contain:    [data][1][attributes]    merchantSku
    And Response should contain the array of a certain size:    [data][1][relationships][merchants][data]    1
    And Response body parameter should be:    [data][1][relationships][merchants][data][0][id]    ${merchant_reference}
    And Response body parameter should be:    [data][1][relationships][merchants][data][0][type]    merchants   
    And Response should contain the array of a certain size:    [data][0][relationships][product-offer-prices][data]    1
    And Response body parameter should be:    [data][1][relationships][product-offer-prices][data][0][id]    ${offer_with_vp}
    And Response body parameter should be:    [data][1][relationships][product-offer-prices][data][0][type]    product-offer-prices
    And Response should contain the array of a certain size:    [included]    4
    And Response include should contain certain entity type:    product-offer-prices
    And Response include should contain certain entity type:    merchants
    And Response body parameter should be:    [included][0][id]    ${second_merchant_reference}
    And Response body parameter should be:    [included][0][type]    merchants
    And Response body parameter should be:    [included][0][attributes][merchantName]   ${second_merchant_name}
    And Response body parameter should be:    [included][0][attributes][merchantUrl]   ${second_merchant_url}
    And Response body parameter should be:    [included][0][attributes][contactPersonRole]   ${second_merchant_contact_person_role}
    And Response body parameter should be:    [included][0][attributes][contactPersonTitle]   ${second_merchant_contact_person_title}
    And Response body parameter should be:    [included][0][attributes][contactPersonFirstName]   ${second_merchant_contact_person_first_name}
    And Response body parameter should be:    [included][0][attributes][contactPersonLastName]   ${second_merchant_contact_person_last_name}
    And Response body parameter should be:    [included][0][attributes][contactPersonPhone]   ${second_merchant_contact_person_phone}
    And Response body parameter should be:    [included][0][attributes][logoUrl]   ${second_merchant_logo_url}
    And Response body parameter should be:    [included][0][attributes][publicEmail]   ${second_merchant_public_email}
    And Response body parameter should be:    [included][0][attributes][publicPhone]   ${second_merchant_public_phone}
    And Response body parameter should be:    [included][0][attributes][description]   ${second_merchant_description}
    And Response body parameter should be:    [included][0][attributes][bannerUrl]   ${second_merchant_banner_url}
    And Response body parameter should be:    [included][0][attributes][deliveryTime]   ${second_merchant_delivery_time}
    And Response body parameter should be:    [included][0][attributes][faxNumber]   ${second_merchant_fax_number}
    And Response should contain the array of a certain size:    [included][0][attributes][legalInformation]    4
    And Response body parameter should not be EMPTY:    [included][0][attributes][legalInformation][terms]
    And Response body parameter should not be EMPTY:    [included][0][attributes][legalInformation][cancellationPolicy]
    And Response body parameter should be:    [included][0][attributes][legalInformation][imprint]   ${second_merchant_imprint}
    And Response body parameter should be:    [included][0][attributes][legalInformation][dataPrivacy]   ${second_merchant_data_privacy}
    And Response should contain the array of a certain size:    [included][0][attributes][categories]    0
    And Response body parameter should be:    [included][1][id]    ${second_offer_with_vp}
    And Response body parameter should be:    [included][1][type]    product-offer-prices
    And Response body parameter should be greater than:    [included][1][attributes][price]    0
    And Response body parameter should be in:    [included][1][attributes][prices][0][priceTypeName]    DEFAULT    ORIGINAL
    And Response body parameter should be greater than:    [included][1][attributes][prices][0][netAmount]    1
    And Response body parameter should be greater than:    [included][1][attributes][prices][0][grossAmount]    0
    And Response should contain the array of a certain size:    [included][1][attributes][prices][0][currency]    3
    And Response body parameter should not be EMPTY:    [included][1][attributes][prices][0][currency][code]
    And Response body parameter should not be EMPTY:    [included][1][attributes][prices][0][currency][name]
    And Response body parameter should not be EMPTY:    [included][1][attributes][prices][0][currency][symbol]
    And Response should contain the array of a certain size:    [included][1][attributes][prices][0][volumePrices]    0
    And Response body parameter should be:    [included][2][id]    ${merchant_reference}
    And Response body parameter should be:    [included][2][type]    merchants
    And Response body parameter should be:    [included][2][attributes][merchantName]   ${merchant_name}
    And Response body parameter should be:    [included][2][attributes][merchantUrl]   ${merchant_url}
    And Response body parameter should be:    [included][2][attributes][contactPersonRole]   ${merchant_contact_person_role}
    And Response body parameter should be:    [included][2][attributes][contactPersonTitle]   ${merchant_contact_person_title}
    And Response body parameter should be:    [included][2][attributes][contactPersonFirstName]   ${merchant_contact_person_first_name}
    And Response body parameter should be:    [included][2][attributes][contactPersonLastName]   ${merchant_contact_person_last_name}
    And Response body parameter should be:    [included][2][attributes][contactPersonPhone]   ${merchant_contact_person_phone}
    And Response body parameter should be:    [included][2][attributes][logoUrl]   ${merchant_logo_url}
    And Response body parameter should be:    [included][2][attributes][publicEmail]   ${merchant_public_email}
    And Response body parameter should be:    [included][2][attributes][publicPhone]   ${merchant_public_phone}
    And Response body parameter should be:    [included][2][attributes][description]   ${merchant_description}
    And Response body parameter should be:    [included][2][attributes][bannerUrl]   ${merchant_banner_url}
    And Response body parameter should be:    [included][2][attributes][deliveryTime]   ${merchant_delivery_time}
    And Response body parameter should be:    [included][2][attributes][faxNumber]   ${merchant_fax_number}
    And Response should contain the array of a certain size:    [included][2][attributes][legalInformation]    4
    And Response body parameter should not be EMPTY:    [included][2][attributes][legalInformation][terms]
    And Response body parameter should not be EMPTY:    [included][2][attributes][legalInformation][cancellationPolicy]
    And Response body parameter should be:    [included][2][attributes][legalInformation][imprint]   ${merchant_imprint}
    And Response body parameter should be:    [included][2][attributes][legalInformation][dataPrivacy]   ${merchant_data_privacy}
    And Response should contain the array of a certain size:    [included][2][attributes][categories]    0
    And Response body parameter should be:    [included][3][id]    ${offer_with_vp}
    And Response body parameter should be:    [included][3][type]    product-offer-prices
    And Response body parameter should be greater than:    [included][3][attributes][price]    0
    And Response body parameter should be in:    [included][3][attributes][prices][0][priceTypeName]    DEFAULT    ORIGINAL
    And Response body parameter should be greater than:    [included][3][attributes][prices][0][netAmount]    1
    And Response body parameter should be greater than:    [included][3][attributes][prices][0][grossAmount]    0
    And Response should contain the array of a certain size:    [included][3][attributes][prices][0][currency]    3
    And Response body parameter should not be EMPTY:    [included][3][attributes][prices][0][currency][code]
    And Response body parameter should not be EMPTY:    [included][3][attributes][prices][0][currency][name]
    And Response body parameter should not be EMPTY:    [included][3][attributes][prices][0][currency][symbol]
    And Response should contain the array of a certain size:    [included][3][attributes][prices][0][volumePrices]    3
    And Response body parameter should be greater than:    [included][3][attributes][prices][0][volumePrices][0][grossAmount]    0
    And Response body parameter should be greater than:    [included][3][attributes][prices][0][volumePrices][0][netAmount]    0
    And Response body parameter should be greater than:    [included][3][attributes][prices][0][volumePrices][0][quantity]    0
    And Response body parameter should be greater than:    [included][3][attributes][prices][0][volumePrices][1][grossAmount]    0
    And Response body parameter should be greater than:    [included][3][attributes][prices][0][volumePrices][1][netAmount]    0
    And Response body parameter should be greater than:    [included][3][attributes][prices][0][volumePrices][1][quantity]    0
    And Response body parameter should be greater than:    [included][3][attributes][prices][0][volumePrices][2][grossAmount]    0
    And Response body parameter should be greater than:    [included][3][attributes][prices][0][volumePrices][2][netAmount]    0
    And Response body parameter should be greater than:    [included][3][attributes][prices][0][volumePrices][2][quantity]    0
    And Response body has correct self link

Get_all_product_offer_info_with_product_offer_prices_included
    When I send a GET request:    /product-offers/${offer}?include=product-offer-prices,product-offer-availabilities,merchants
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response body parameter should be:    [data][attributes][merchantReference]    ${merchant_reference}
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response body parameter should be greater than:    [data][attributes][merchantSku]    1
    And Response should contain the array of a certain size:    [data][relationships][merchants][data]    1
    And Response body parameter should be:    [data][relationships][merchants][data][0][id]    ${merchant_reference}
    And Response body parameter should be:    [data][relationships][merchants][data][0][type]    merchants   
    And Response should contain the array of a certain size:    [data][relationships][product-offer-prices][data]    1
    And Response body parameter should be:    [data][relationships][product-offer-prices][data][0][id]    ${offer}
    And Response body parameter should be:    [data][relationships][product-offer-prices][data][0][type]    product-offer-prices
    And Response should contain the array of a certain size:    [included]    2
    And Response include should contain certain entity type:    product-offer-prices
    And Response include should contain certain entity type:    merchants
    And Response body parameter should be:    [included][0][id]    ${merchant_reference}
    And Response body parameter should be:    [included][0][type]    merchants
    And Response body parameter should be:    [included][0][attributes][merchantName]   ${merchant_name}
    And Response body parameter should be:    [included][0][attributes][merchantUrl]   ${merchant_url}
    And Response body parameter should be:    [included][0][attributes][contactPersonRole]   ${merchant_contact_person_role}
    And Response body parameter should be:    [included][0][attributes][contactPersonTitle]   ${merchant_contact_person_title}
    And Response body parameter should be:    [included][0][attributes][contactPersonFirstName]   ${merchant_contact_person_first_name}
    And Response body parameter should be:    [included][0][attributes][contactPersonLastName]   ${merchant_contact_person_last_name}
    And Response body parameter should be:    [included][0][attributes][contactPersonPhone]   ${merchant_contact_person_phone}
    And Response body parameter should be:    [included][0][attributes][logoUrl]   ${merchant_logo_url}
    And Response body parameter should be:    [included][0][attributes][publicEmail]   ${merchant_public_email}
    And Response body parameter should be:    [included][0][attributes][publicPhone]   ${merchant_public_phone}
    And Response body parameter should be:    [included][0][attributes][description]   ${merchant_description}
    And Response body parameter should be:    [included][0][attributes][bannerUrl]   ${merchant_banner_url}
    And Response body parameter should be:    [included][0][attributes][deliveryTime]   ${merchant_delivery_time}
    And Response body parameter should be:    [included][0][attributes][faxNumber]   ${merchant_fax_number}
    And Response should contain the array of a certain size:    [included][0][attributes][legalInformation]    4
    And Response body parameter should not be EMPTY:    [included][0][attributes][legalInformation][terms]
    And Response body parameter should not be EMPTY:    [included][0][attributes][legalInformation][cancellationPolicy]
    And Response body parameter should be:    [included][0][attributes][legalInformation][imprint]   ${merchant_imprint}
    And Response body parameter should be:    [included][0][attributes][legalInformation][dataPrivacy]   ${merchant_data_privacy}
    And Response should contain the array of a certain size:    [included][0][attributes][categories]    0
    And Response body parameter should be:    [included][1][id]    ${offer}
    And Response body parameter should be:    [included][1][type]    product-offer-prices
    And Response body parameter should be greater than:    [included][1][attributes][price]    0
    And Response body parameter should be in:    [included][1][attributes][prices][0][priceTypeName]    DEFAULT    ORIGINAL
    And Response body parameter should be greater than:    [included][1][attributes][prices][0][netAmount]    1
    And Response body parameter should be greater than:    [included][1][attributes][prices][0][grossAmount]    0
    And Response should contain the array of a certain size:    [included][1][attributes][prices][0][currency]    3
    And Response body parameter should not be EMPTY:    [included][1][attributes][prices][0][currency][code]
    And Response body parameter should not be EMPTY:    [included][1][attributes][prices][0][currency][name]
    And Response body parameter should not be EMPTY:    [included][1][attributes][prices][0][currency][symbol]
    And Response should contain the array of a certain size:    [included][1][attributes][prices][0][volumePrices]    0
    And Response body parameter should be in:    [included][1][attributes][prices][1][priceTypeName]    DEFAULT    ORIGINAL
    And Response body parameter should be greater than:    [included][1][attributes][prices][1][netAmount]    1
    And Response body parameter should be greater than:    [included][1][attributes][prices][1][grossAmount]    0
    And Response should contain the array of a certain size:    [included][1][attributes][prices][1][currency]    3
    And Response body parameter should not be EMPTY:    [included][1][attributes][prices][1][currency][code]
    And Response body parameter should not be EMPTY:    [included][1][attributes][prices][1][currency][name]
    And Response body parameter should not be EMPTY:    [included][1][attributes][prices][1][currency][symbol]
    And Response should contain the array of a certain size:    [included][1][attributes][prices][1][volumePrices]    0

Get_product_offer_without_volume_prices
    When I send a GET request:    /product-offers/${offer_without_vp}?include=product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_without_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][volumePrices]    0

Get_product_offer_with_gross_eur_volume_prices
    When I send a GET request:    /product-offers/${offer_with_vp}?include=product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response body parameter should be:    [included][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][grossAmount]    0
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][volumePrices]    3
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][grossAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][netAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][quantity]    int
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency_code_eur}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency_name_eur}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency_symbol_eur}

Get_product_offer_with_net_eur_volume_prices
    When I send a GET request:    /product-offers/${offer_with_vp}?include=product-offer-prices&priceMode=${net_mode}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response body parameter should be:    [included][0][attributes][prices][0][grossAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][netAmount]    1
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][volumePrices]    3
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][grossAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][netAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][quantity]    int
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency_code_eur}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency_name_eur}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency_symbol_eur}

Get_product_offer_with_gross_chf_volume_prices
    When I send a GET request:    /product-offers/${offer_with_vp}?include=product-offer-prices&currency=${currency_code_chf}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response body parameter should be:    [included][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][grossAmount]    1
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency_code_chf}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency_name_chf}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency_symbol_chf}

Get_product_offer_with_net_chf_volume_prices
    When I send a GET request:    /product-offers/${offer_with_vp}?include=product-offer-prices&priceMode=${net_mode}&currency=${currency_code_chf}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response body parameter should be:    [included][0][attributes][prices][0][grossAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][netAmount]    1
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency_code_chf}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency_name_chf}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency_symbol_chf}