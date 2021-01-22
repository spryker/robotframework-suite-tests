*** Settings ***
Resource    ../Common/Common.robot

*** Keywords ***
Yves: go To 'Wishlist' Page
    Click Element    ${wishlist_icon_header_navigation_widget}
    Wait For Document Ready 