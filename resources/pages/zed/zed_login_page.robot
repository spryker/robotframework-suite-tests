*** Variables ***
${host_zed}    http://backoffice.de.spryker.local/
${login_url}    security-gui/login
${zed_user_name_field}    id=auth_username
${zed_password_field}    id=auth_password
${zed_login_button}    xpath=//button[@type='submit']
${customer_first_name}    xpath=//input[@id='customer_address_first_name']
${customer_last_name}    xpath=//input[@id='customer_address_last_name']
${address line 1}    xpath=//input[@id='customer_address_address1']
${address line 2}    xpath=//input[@id='customer_address_address2']
${customer_city}    xpath=//input[@id='customer_address_city']
${customer_zipcode}    xpath=//input[@id='customer_address_city']
${customer_phone}    xpath=//input[@id='customer_address_city']
${save}    xpath=//input[@value='Save']
${salutation}    xpath=(//select[@id='customer_address_salutation'])
${country}    xpath=//select[@id='customer_address_fk_country']
${billing address}    xpath=//select[@id='customer_default_billing_address'] 