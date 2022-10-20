*** Variables ***
${zed_user_email_field}    id=user_username
${zed_user_password_filed}    id=user_password_first
${zed_user_repeat_password_field}    id=user_password_second
${zed_user_first_name_field}    id=user_first_name
${zed_user_last_name_field}    id=user_last_name
${zed_user_interface_language}    id=user_fk_locale
${zed_user_role_name}    id=role_name
${zed_user_group_title}     id=group_title
${zed_user_group_assigned_role_textbox}    xpath=//input[@role='searchbox']
${zed_user_edit_button}    xpath=(//a[contains(@class,'btn-edit')])[2]
${zed_user_deactivate_button}    xpath=//form[contains(@name,'deactivate_user_form')]