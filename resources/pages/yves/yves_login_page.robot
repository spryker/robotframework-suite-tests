*** Variables ***
${email_field}    id=loginForm_email
${password_field}    id=loginForm_password
${form_login_button}    xpath=//form[@name='loginForm']//*[contains(@class,'button')][@type='submit']
${forgot_password_link}    xpath=//a[@class='link link--darkest link--login-forgot-password']