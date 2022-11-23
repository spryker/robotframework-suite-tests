*** Settings ***
Resource    ../common/common.robot
Resource    ../pages/yves/yves_overview_page.robot
Resource    ../../resources/common/common_yves.robot

*** Keywords ***
Yves: validate the page title:
    [Arguments]    ${title}
    Yves: try reloading page if element is/not appear:    ${overview_page_title_locator}     True
    Element Should Contain    ${overview_page_title_locator}    ${title}