*** Variables ***
${create_return_main_content_locator}    css=*[name=return_create_form]
&{create_return_button}    b2b=xpath=//form[@name='return_create_form']//button[contains(@class,'return-create')]    b2c=xpath=//button[contains(@class,'return')]    suite-nonsplit=xpath=//div[@data-qa='component return-create-form']//button
