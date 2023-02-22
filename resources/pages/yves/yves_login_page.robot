*** Variables ***
${login_main_content_locator}    xpath=//div[contains(@data-qa,'component form')]//h2[contains(text(),'Login')]
${email_field}    id=loginForm_email
${password_field}    id=loginForm_password
${form_login_button}    xpath=//form[@name='loginForm']//*[contains(@class,'button')][@type='submit']