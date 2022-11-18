*** Variables ***
${email_field}    id=loginForm_email
${password_field}    id=loginForm_password
${form_login_button}    xpath=//form[@name='loginForm']//*[contains(@class,'button')][@type='submit']
${blocked_login_error_message_header}    xpath=//div[@class='box']//h1