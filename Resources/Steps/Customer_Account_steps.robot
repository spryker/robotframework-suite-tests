*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Resource    ../Steps/Quick_Order_steps.robot

*** Keywords ***
Yves: go to user menu item in the left bar:
    [Documentation]    Case sensitive, accepts: Overview, Profile, Addresses, Order History, Newsletter, Shopping lists, Shopping carts, Quote Requests
    [Arguments]    ${left_navigation_node}
    Wait Until Element Is Visible    xpath=//ul[@class='navigation-sidebar__list']//*[contains(.,'${left_navigation_node}')]/a
    Click Element    xpath=//ul[@class='navigation-sidebar__list']//*[contains(.,'${left_navigation_node}')]/a