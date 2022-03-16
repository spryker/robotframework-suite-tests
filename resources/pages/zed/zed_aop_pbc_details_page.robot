*** Variables ***
${pbc_details_main_content_locator}    xpath=//app-common-details
${pbc_datails_app_logo_locator}    xpath=//img[@class='app-common-details__logo']
${pbc_datails_short_description_locator}    xpath=//app-common-details//*[contains(@class,'description')]
${pbc_datails_author_link_locator}    xpath=//app-common-details//a[contains(@class,'author-link')]
${pbc_datails_title_locator}    xpath=//app-common-details//*[contains(@class,'title-text')]
${pbc_details_configure_button_locator}    xpath=//app-common-details//spy-button[contains(@class,'configure')]
${pbc_details_connect_button_locator}    xpath=//app-common-details//spy-button[contains(@class,'connect')]
${pbc_configuration_form_main_content_locator}    xpath=//app-configuration//following-sibling::div[contains(@class,'content')]
${pbc_details_pending_status_locator}    xpath=//app-common-details//app-status-badge//*[text()='Connection pending']
