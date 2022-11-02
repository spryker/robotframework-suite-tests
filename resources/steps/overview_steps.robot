*** Settings ***
Resource    ../common/common.robot
Resource    ../pages/yves/yves_overview_page.robot

*** Keywords ***
Yves: validate the page title:
    [Arguments]    ${title}
    Element Should Contain    ${overview_page_title_locator}    ${title}