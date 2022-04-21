*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Get_budget_cameras_merchant_adress_by_merchant_id    
    When I send a GET request:  /merchants/${merchant_cameras_id}/merchant-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${merchant_cameras_id}
    And Response body parameter should be:    [data][0][type]    merchant-addresses
    And Response body parameter should be:    [data][0][attributes][addresses][0][countryName]    ${merchant_cameras_country}
    And Response body parameter should be:    [data][0][attributes][addresses][0][city]    ${merchant_cameras_city}
    And Response body parameter should be:    [data][0][attributes][addresses][0][address1]    ${merchant_cameras_address1}
    And Response body parameter should be:    [data][0][attributes][addresses][0][address2]    ${merchant_cameras_address2}
    And Response body parameter should be:    [data][0][attributes][addresses][0][address3]    ${merchant_cameras_address3}
    And Response body parameter should be:    [data][0][attributes][addresses][0][zipCode]    ${merchant_cameras_zipcode}
    And Response body parameter should be:    [data][0][attributes][addresses][0][latitude]    ${merchant_cameras_latitude}
    And Response body parameter should be:    [data][0][attributes][addresses][0][longitude]    ${merchant_cameras_longitude}
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    merchant-addresses
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    countryName
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address2
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address3
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    city
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    zipCode
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    latitude
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    longitude
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link

Get_spryker_merchant_adress_by_merchant_id    
    When I send a GET request:  /merchants/${merchant_spryker_id}/merchant-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${merchant_spryker_id}
    And Response body parameter should be:    [data][0][type]    merchant-addresses
    And Response body parameter should be:    [data][0][attributes][addresses][0][countryName]    ${merchant_spryker_country}
    And Response body parameter should be:    [data][0][attributes][addresses][0][city]    ${merchant_spryker_city}
    And Response body parameter should be:    [data][0][attributes][addresses][0][address1]    ${merchant_spryker_address1}
    And Response body parameter should be:    [data][0][attributes][addresses][0][address2]    ${merchant_spryker_address2}
    And Response body parameter should be:    [data][0][attributes][addresses][0][address3]    ${merchant_spryker_address3}
    And Response body parameter should be:    [data][0][attributes][addresses][0][zipCode]    ${merchant_spryker_zipcode}
    And Response body parameter should be:    [data][0][attributes][addresses][0][latitude]    ${merchant_spryker_latitude}    
    And Response body parameter should be:    [data][0][attributes][addresses][0][latitude]    ${merchant_spryker_latitude}
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    merchant-addresses
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    countryName
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address2
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address3
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    city
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    zipCode
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    latitude
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    longitude
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link

 Get_video_king_merchant_adress_by_merchant_id    
    When I send a GET request:  /merchants/${merchant_video_id}/merchant-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${merchant_video_id}
    And Response body parameter should be:    [data][0][type]    merchant-addresses
    And Response body parameter should be:    [data][0][attributes][addresses][0][countryName]    ${merchant_video_country}
    And Response body parameter should be:    [data][0][attributes][addresses][0][city]    ${merchant_video_city}
    And Response body parameter should be:    [data][0][attributes][addresses][0][address1]    ${merchant_video_address1}
    And Response body parameter should be:    [data][0][attributes][addresses][0][address2]    ${merchant_video_address2}
    And Response body parameter should be:    [data][0][attributes][addresses][0][address3]    ${merchant_video_address3}
    And Response body parameter should be:    [data][0][attributes][addresses][0][zipCode]    ${merchant_video_zipcode}
    And Response body parameter should be:    [data][0][attributes][addresses][0][latitude]    ${merchant_video_latitude} 
    And Response body parameter should be:    [data][0][attributes][addresses][0][latitude]    ${merchant_video_latitude}
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    merchant-addresses
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    countryName
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address2
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address3
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    city
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    zipCode
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    latitude
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    longitude
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link

Get_budget_cameras_merchant_with_merchant_adress_by_merchant_id    
    When I send a GET request:  /merchants/${merchant_cameras_id}?include=merchant-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    merchants
    And Response body parameter should be:    [data][id]    ${merchant_cameras_id}
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should have datatype:    [data][relationships]    dict
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][merchant-addresses]
    And Each array element of array in response should contain property:    [data][relationships][merchant-addresses][data]    type
    And Each array element of array in response should contain property:    [data][relationships][merchant-addresses][data]    id
    And Response body parameter should not be EMPTY:    [included]
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain property with value:    [included]    type    merchant-addresses
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    countryName
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address3
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    city
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    zipCode
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    latitude
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    longitude
    And Response body parameter should be:    [included][0][attributes][addresses][0][countryName]    ${merchant_cameras_country}
    And Response body parameter should be:    [included][0][attributes][addresses][0][city]    ${merchant_cameras_city}
    And Response body parameter should be:    [included][0][attributes][addresses][0][address1]    ${merchant_cameras_address1}
    And Response body parameter should be:    [included][0][attributes][addresses][0][address2]    ${merchant_cameras_address2}
    And Response body parameter should be:    [included][0][attributes][addresses][0][address3]    ${merchant_cameras_address3}
    And Response body parameter should be:    [included][0][attributes][addresses][0][latitude]    ${merchant_cameras_latitude}
    And Response body parameter should be:    [included][0][attributes][addresses][0][longitude]    ${merchant_cameras_longitude}
    And Response body parameter should be:    [included][0][attributes][addresses][0][zipCode]    ${merchant_cameras_zipcode}

Get_spryker_merchant_with_merchant_adress_by_merchant_id  
    When I send a GET request:  /merchants/${merchant_spryker_id}?include=merchant-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    merchants
    And Response body parameter should be:    [data][id]    ${merchant_spryker_id}
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should have datatype:    [data][relationships]    dict
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][merchant-addresses]
    And Each array element of array in response should contain property:    [data][relationships][merchant-addresses][data]    type
    And Each array element of array in response should contain property:    [data][relationships][merchant-addresses][data]    id
    And Response body parameter should not be EMPTY:    [included]
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain property with value:    [included]    type    merchant-addresses
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    countryName
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address3
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    city
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    zipCode
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    latitude
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    longitude
    And Response body parameter should be:    [included][0][attributes][addresses][0][countryName]    ${merchant_spryker_country}
    And Response body parameter should be:    [included][0][attributes][addresses][0][city]    ${merchant_spryker_city}
    And Response body parameter should be:    [included][0][attributes][addresses][0][address1]    ${merchant_spryker_address1}
    And Response body parameter should be:    [included][0][attributes][addresses][0][address2]    ${merchant_spryker_address2}
    And Response body parameter should be:    [included][0][attributes][addresses][0][address3]    ${merchant_spryker_address3}
    And Response body parameter should be:    [included][0][attributes][addresses][0][latitude]    ${merchant_spryker_latitude}
    And Response body parameter should be:    [included][0][attributes][addresses][0][longitude]    ${merchant_spryker_longitude}
    And Response body parameter should be:    [included][0][attributes][addresses][0][zipCode]    ${merchant_spryker_zipcode}

 Get_video_king_merchant_with_merchant_adress_by_merchant_id    
    When I send a GET request:  /merchants/${merchant_video_id}?include=merchant-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    merchants
    And Response body parameter should be:    [data][id]    ${merchant_video_id}
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should have datatype:    [data][relationships]    dict
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][merchant-addresses]
    And Each array element of array in response should contain property:    [data][relationships][merchant-addresses][data]    type
    And Each array element of array in response should contain property:    [data][relationships][merchant-addresses][data]    id
    And Response body parameter should not be EMPTY:    [included]
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain property with value:    [included]    type    merchant-addresses
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    countryName
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address3
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    city
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    zipCode
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    latitude
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    longitude
    And Response body parameter should be:    [included][0][attributes][addresses][0][countryName]    ${merchant_video_country}
    And Response body parameter should be:    [included][0][attributes][addresses][0][city]    ${merchant_video_city}
    And Response body parameter should be:    [included][0][attributes][addresses][0][address1]    ${merchant_video_address1}
    And Response body parameter should be:    [included][0][attributes][addresses][0][address2]    ${merchant_video_address2}
    And Response body parameter should be:    [included][0][attributes][addresses][0][address3]    ${merchant_video_address3}
    And Response body parameter should be:    [included][0][attributes][addresses][0][latitude]    ${merchant_video_latitude}
    And Response body parameter should be:    [included][0][attributes][addresses][0][longitude]    ${merchant_video_longitude}
    And Response body parameter should be:    [included][0][attributes][addresses][0][zipCode]    ${merchant_video_zipcode}