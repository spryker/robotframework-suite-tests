*** Settings ***
Resource    ../Common/Common.robot
Resource    ../Yves/Yves_Header_Section.robot

*** Keywords ***
Yves: go To 'Wishlist' Page
    Click Element    ${wishlist_icon_header_navigation_widget}
    Wait For Document Ready 