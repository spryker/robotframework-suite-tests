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

*** Test Cases ***
Connect_pbc_payone
    [Documentation]    Checks that bazzarvoice pbc can be connected in the backoffice and is reflected to the storefront
    [Setup]    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to first navigation item level:    Apps
    Zed: AOP catalog page should contain the following apps:    Payone    BazaarVoice
    Zed: go to the PBC details page:    Payone
    Zed: PBC details page should contain the following elements:    ${appTitle}    ${appShortDescription}    ${appAuthor}   ${appLogo}
    Zed: click button on the PBC details page:    connect
    Zed: PBC details page should contain the following elements:    ${appPendingStatus}
    Zed: click button on the PBC details page:    configure
    Zed:Payone provide configuration pbc payone:    