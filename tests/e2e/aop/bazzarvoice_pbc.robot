*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Test Teardown     TestTeardown
Suite Teardown    SuiteTeardown
Resource    ../../../resources/common/common.robot
Resource    ../../../resources/common/common_yves.robot
Resource    ../../../resources/common/common_zed.robot
Resource    ../../../resources/steps/aop_catalog_steps.robot

*** Test Cases ***
Bazzarvoice_E2E
    [Documentation]    Checks that bazzarvoice pbc can be connected in the backoffice and is reflected to the storefront
    [Setup]    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to first navigation item level:    Apps
    Zed: AOP catalog page should contain the following:    Payone    BazaarVoice
    Zed: go to the PBC details page:    BazaarVoice
    # Zed: PBC details page should contain the following elements:    ${appTitle}    ${appShortDescription}    ${appAuthor}   ${appLogo}
    # Zed: click button on the PBC details page:    connect
    # Zed: PBC details page should contain the following elements:    ${appPendingStatus}
    Zed: click button on the PBC details page:    configure
    




    # App is moved to ‘Configuration pending’ status
    # ‘Connect’ button was replaced with ‘Configure’
    # Burger menu contains ‘disconnect’ link
    # Appropriate tooltip message is displayed
    # When  Click ‘Connect’ and Click “Configure
    # Then Required fields are displayed and could be fulfilled
    # When Enter valid creds , Select checkboxes to enable ratingsReviews, questionsAnswers, inlineRatings features
    # And Save configuration
    # Then Configuration is saved , and App is displayed as connected
    # When I Go to yves
    # Then I  make sure that  BV script is added to the page
    # and
    # BV ratings & Reviews is displayed
    # BV questions & Answers is displayed (could be checked in elements)
    # BV inline Ratings is displayed 