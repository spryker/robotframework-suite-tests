*** Settings ***
Resource  ../common/common_zed.robot
Resource  ../common/common.robot
Resource  ../../resources/common/common_yves.robot
Resource  ../../resources/pages/zed/zed_shipment_page.robot
Resource  ../../resources/pages/zed/zed_order_shipment_page.robot
Resource  ../../resources/pages/zed/zed_order_details_page.robot
*** Keywords ***
Zed: Edit order shipment  Hover    ${view_order_last_placed}
  Zed: click Action Button(without search) in a table for row that contains:    ${lastPlacedOrder}    View 
  Select From List By Label    ${delivery_address_shipment_page}    New address
   Zed: Enter shipment details for order:
   ...    ||  fname                             |  lname                   |  email                        |  address1            |  address2            |  city    |  zipcode      |  salutation  |  country  |  shipmentmethod  ||
    ...    ||  ${yves_user_first_name}${random}  |  ${yves_user_last_name}  |  ${yves_user_email}${random}  |  address1+${random}  |  address2+${random}  |  Berlin  |  11${random}  |  Mr          |  Germany  |  DHL - Express   ||      
  Select From List By Text    ${shipment_method_dropdown}    DHL - Express
  Wait Until Element Is Visible    ${save_button_shipment_page}
  Click    ${save_button_shipment_page}
Zed: Create a new shipment for order
   Zed: click Action Button(without search) in a table for row that contains:    ${lastPlacedOrder}    View 
  Click    ${create_shipment_button}
  Zed: Enter shipment details for order:         
  ...    ||  fname                             |  lname                   |  email                        |  address1            |  address2            |  city    |  zipcode      |  salutation  |  country  |  shipmentmethod  ||
  ...    ||  ${yves_user_first_name}${random}  |  ${yves_user_last_name}  |  ${yves_user_email}${random}  |  address1+${random}  |  address2+${random}  |  Berlin  |  11${random}  |  Mr          |  Germany  |  DHL - Express   ||  
  Wait Until Element Is Visible    ${save_button_shipment_page}
  Click    ${save_button_shipment_page}
Zed: Enter shipment details for order: 
  [Arguments]    @{args}          
  ${registrationData}=    Set Up Keyword Arguments    @{args}
  FOR    ${key}    ${value}    IN    &{registrationData}
      Log    Key is '${key}' and value is '${value}'.
      IF    '${key}'=='fname'    Type Text    ${shipment_address_first_name}    ${value}
      IF    '${key}'=='lname'    Type Text    ${shipment_address_last_name}    ${value}
      IF    '${key}'=='email'    Type Text    ${shipment_address_email}    ${value}
      IF    '${key}'=='Address1'    Type Text    ${shipment_address_address1}     ${value}
      IF    '${key}'=='address2'    Type Text    ${shipment_address_address2}     ${value}
      IF    '${key}'=='city'    Type Text    ${shipment_address_city}     ${value}
      IF    '${key}'=='zipcode'    Type Text    ${shipment_address_zipcode}     ${value}
      IF    '${key}'=='salutation'    Select From List By Value    ${salutation_shipment_page}    ${value}
      IF    '${key}'== 'country'        Select From List By Value    ${country_create_new_shipment_page}    ${value}  
      IF    '${key}'== 'shipmentmethod'        Select From List By Index    ${shipment_method_dropdown_new_shipment_page}    ${value}  
      END
 

