*** Variables ***
${zed_customer_edit_page_title}                xpath=//h5[contains(text(),'Edit Customer')]
${zed_customer_delete_button}                  xpath=//a[contains(@href,'/customer/delete')]
${zed_customer_delete_confirm_button}          xpath=//button[contains(@class,'btn btn-danger safe-submit')]
${zed_Add_new_address_button}                  xpath=//a[contains(@href,'/customer/address/add')]
${zed_customer_edit_button}                    xpath=//a[contains(@href,'/customer/edit')]
${zed_customer_salutation}                     id=customer_address_salutation
${zed_customer_first_name}                     id=customer_address_first_name
${zed_customer_last_name}                      id=customer_address_last_name
${zed_customer_address_line_1}                 id=customer_address_address1
${zed_customer_address_line_2}                 id=customer_address_address2
${zed_customer_city}                           id=customer_address_city
${zed_customer_zipcode}                        id=customer_address_zip_code
${zed_customer_phone}                          id=customer_address_phone
${zed_customer_save_button}                    xpath=//input[@value='Save']
${zed_customer_salutation}                    id=customer_address_salutation
${zed_customer_country}                       id=customer_address_fk_country
${zed_customer_billing_address}               xpath=//select[@id='customer_default_billing_address']
${zed_customer_view_button}                    xpath=(//a[contains(@href,'/customer/view')])[1]