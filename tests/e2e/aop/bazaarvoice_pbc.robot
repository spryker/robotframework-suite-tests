*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Test Teardown     TestTeardown
Suite Teardown    SuiteTeardown
Resource    ../../../resources/common/common.robot
Resource    ../../../resources/common/common_yves.robot
Resource    ../../../resources/common/common_zed.robot
Resource    ../../../resources/steps/aop_catalog_steps.robot
Resource    ../../../resources/steps/bazaarvoice_steps.robot
Resource    ../../../resources/steps/bazaarvoice_steps.robot
Resource    ../../../resources/steps/pdp_steps.robot
Resource    ../../../resources/steps/shopping_carts_steps.robot
Resource    ../../../resources/steps/checkout_steps.robot


*** Test Cases ***
Bazaarvoice_E2E
    [Documentation]    Checks that bazzarvoice pbc can be connected in the backoffice and is reflected to the storefront
    [Setup]    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to first navigation item level:    Apps
    Zed: AOP catalog page should contain apps:    Payone    BazaarVoice
    Zed: go to the PBC details page:    BazaarVoice
    Zed: PBC details page should contain elements:    ${appTitle}    ${appShortDescription}    ${appAuthor}   ${appLogo}
    Zed: click button on the PBC details page:    connect
    Zed: PBC details page should contain elements:    ${appPendingStatus}
    Zed: click button on the PBC details page:    configure
    Zed: configure bazaarvoice pbc with data:
    ...    || clientName      | siteId    | environment | services                                                                              | stores ||
    ...    || partner-spryker | main_site | Staging     | Ratings & Reviews,Questions & Answers,Inline Ratings,Bazaarvoice Pixel,Container Page | EN,DE  ||
    Zed: submit pbc configuration form
    Zed: PBC details page should contain elements:    ${appConnectedStatus}
    Yves: go to the 'Home' page
    Yves: page should contain script:    bazaar-voice
    Yves: perform search by:    150
    Yves: page should contain script:    bazaar-voice
    Yves: 1st product card in the catalog should contains bv inline rating
    Yves: go to PDP of the product with sku:    150
    Yves: page should contain script:    bazaar-voice
    Yves: PDP contains/doesn't contain:    true    ${bazaarvoiceWriteReview}    ${bazaarvoiceQuestions}    ${bazaarvoiceInlineRating}
    Yves: post bazaarvoice review with data:
    ...    || overallRating | reviewTitle            | review                                               | recommendProduct | nickname        | location | email                       | age      | gender | qualityRating | valueRating ||
    ...    || 5             | Robot Review ${random} | I bought this a month ago and am so happy that I did | yes              | Robot ${random} | New York | sonia+${random}@spryker.com | 25 to 34 | Female | 5             | 1           ||
    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    Yves: create new 'Shopping Cart' with name:    bazaarvoice+${random}
    Yves: go to PDP of the product with sku:    136
    Yves: add product to the shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName | lastName    | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | Robot     | bazaarvoice | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select shipping method on checkout and go next:    Air Sonic
    Yves: select payment method on checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    #TODO: create an assertion for bv pixer request on the checkout
    Yves: 'Thank you' page is displayed
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to first navigation item level:    Apps
    ...    AND    Zed: go to the PBC details page:    BazaarVoice
    ...    AND    Zed: Disconnect pbc