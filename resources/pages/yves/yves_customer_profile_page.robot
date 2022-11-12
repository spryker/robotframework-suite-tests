*** Variables ***
${customer_profile_first_name}    id=profileForm_first_name
${customer_profile_last_name}    id=profileForm_last_name 
${customer_profile_email_field}    id=profileForm_email
${customer_profile_submit_button}    xpath=//form[@name='profileForm']//button[@type='submit']
${customer_profile_old_password_field}    id=passwordForm_password
${customer_profile_new_password_field}    id=passwordForm_new_password_password
${customer_profile_confirm_password_field}    id=passwordForm_new_password_confirm
${customer_profile_password_reset_submit_button}    xpath=//form[@name='passwordForm']//button[@type='submit']
${customer_profile_delete_button}    xpath=//a[contains(@href,'/customer/delete')]
${customer_profile_confirm_delete_button}    xpath=//button[@class='button button--alert float-right']
