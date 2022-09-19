*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Test Teardown    TestTeardown
Suite Teardown    SuiteTeardown
Resource    ../../../resources/common/common.robot
Resource    ../../../resources/common/common_yves.robot
Resource    ../../../resources/common/common_zed.robot
Resource    ../../../resources/steps/aop_catalog_steps.robot
Resource    ../../../resources/steps/usercentrics_steps.robot
Resource    ../../../resources/steps/bazaarvoice_steps.robot

*** Test Cases ***
Usercentrics_E2E
    [Documentation]    Checks that usercentrics pbc can be connected in the backoffice and is reflected to the storefront
    [Setup]    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to first navigation item level:    Apps
    Zed: AOP catalog page should contain the following apps:    Usercentrics
    Zed: go to the PBC details page:    Usercentrics
    Zed: PBC details page should contain the following elements:    ${appTitle}    ${appShortDescription}    ${appAuthor}   ${appLogo}
    Zed: click button on the PBC details page:    connect
    Zed: PBC details page should contain the following elements:    ${appPendingStatus}
    Zed: click button on the PBC details page:    configure
    Zed: configure usercentrics pbc:
    ...    || type                        | settingId | isActive ||
    ...    || Enable Smart Data Protector | qp-9Y6Hw9 | true     ||
    Zed: submit pbc configuration form
    Zed: PBC details page should contain the following elements:    ${appConnectedStatus}
    Yves: go to the 'Home' page
    Yves: page should contain script with attribute:    data-settings-id    qp-9Y6Hw9
    Yves: page should/shouldn't contain usercentrics privacy settings form:    true
    Yves: usercentrics accept/deny all:    true
    Yves: usercentrics successfully saved config
    Reload
    Yves: page should/shouldn't contain usercentrics privacy settings form:    false
    LocalStorage clear
    Delete all cookies
    Yves: go to the 'Home' page
    Yves: page should/shouldn't contain usercentrics privacy settings form:    true
    Yves: usercentrics accept/deny all:    false
    Yves: usercentrics successfully saved config
    Reload
    Yves: page should/shouldn't contain usercentrics privacy settings form:    false
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to first navigation item level:    Apps
    ...    AND    Zed: go to the PBC details page:    Usercentrics
    ...    AND    Zed: Disconnect pbc
