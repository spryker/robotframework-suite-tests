*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_aop_pbc_details_page.robot
Resource    ../pages/zed/zed_aop_bazaarvoice_details_page.robot
Resource    ../pages/yves/yves_product_details_page.robot
Resource    ../pages/yves/yves_bazaarvoice_review_popup_form.robot

*** Keywords ***
Zed: configure bazaarvoice pbc:
    [Documentation]    Possible argument names: clientName, siteId, environment, services, stores
    [Arguments]    @{args}
    ${bazaarvoiceCondifurationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{bazaarvoiceCondifurationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='clientName' and '${value}' != '${EMPTY}'    Type Text    ${pbc_bazzarvoice_client_name_input}    ${value}
        IF    '${key}'=='siteId' and '${value}' != '${EMPTY}'    Type Text    ${pbc_bazzarvoice_side_id_input}    ${value}
        IF    '${key}'=='environment' and '${value}' != '${EMPTY}'    Click    //spy-radio-group[@id='settings_environment']//label//span[contains(text(),'${value}')]/ancestor::label
        IF    '${key}'=='services' and '${value}' != '${EMPTY}'
            Run Keywords
                Convert string to List by separator:    ${value}
                Log    ${covertedList}
                Check bazaarvoice configuration checkbox:    ${covertedList}
        END
        IF    '${key}'=='stores' and '${value}' != '${EMPTY}'
            Run Keywords
                Convert string to List by separator:    ${value}
                Log    ${covertedList}
                Check bazaarvoice configuration checkbox:    ${covertedList}
        END
    END

Check bazaarvoice configuration checkbox:
    [Arguments]    ${bazaarvoice_checkboxes}
    ${bazaarvoice_checkbox_count}=   get length  ${bazaarvoice_checkboxes}
    FOR    ${index}    IN RANGE    0    ${bazaarvoice_checkbox_count}
        ${checkbox_to_check}=    Get From List    ${bazaarvoice_checkboxes}    ${index}
        Run Keywords
        ...    Log    ${checkbox_to_check}
        ...    AND    Click    xpath=//spy-checkbox/label//span[contains(text(),'${checkbox_to_check}')]/ancestor::label
    END

Yves: post bazaarvoice review:
    [Documentation]    Possible argument names: overallRating, reviewTitle, review, recommendProduct, nickname, location, email, age, gender, qualityRating, valueRating
    [Arguments]    @{args}
    Click    ${pdp_bazaarvoice_write_review_button}
    Wait Until Element Is Visible    ${bv_submit_button}
    ${bazaarvoiceReviewData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{bazaarvoiceReviewData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='overallRating' and '${value}' != '${EMPTY}'    Click    xpath=//span[@id='bv-radio-rating-${value}']
        IF    '${key}'=='reviewTitle' and '${value}' != '${EMPTY}'    Type Text    ${bv_review_title_input}    ${value}
        IF    '${key}'=='review' and '${value}' != '${EMPTY}'    Type Text    ${bv_review_text_area}    ${value}
        IF    '${key}'=='recommendProduct' and '${value}' == 'yes'    Click    ${bv_recommend_product_true_label}
        IF    '${key}'=='recommendProduct' and '${value}' == 'no'    Click    ${bv_recommend_product_false_label}
        IF    '${key}'=='nickname' and '${value}' != '${EMPTY}'    Type Text    ${bv_nickname_input}    ${value}
        IF    '${key}'=='location' and '${value}' != '${EMPTY}'    Type Text    ${bv_location_input}    ${value}
        IF    '${key}'=='email' and '${value}' != '${EMPTY}'    Type Text    ${bv_email_input}    ${value}
        IF    '${key}'=='age' and '${value}' != '${EMPTY}'    Select From List By Label    ${bv_select_age_dropdown}    ${value}
        IF    '${key}'=='gender' and '${value}' != '${EMPTY}'    Select From List By Label    ${bv_select_gender_dropdown}    ${value}
        IF    '${key}'=='qualityRating' and '${value}' != '${EMPTY}'    Click    xpath=//span[@id='bv-radio-rating_Quality-${value}']
        IF    '${key}'=='valueRating' and '${value}' != '${EMPTY}'    Click    xpath=//span[@id='bv-radio-rating_Value-${value}']
    END
    Check Checkbox    ${bv_terms_and_conditions_checkbox}
    Click    ${bv_submit_button}

Yves: first product card in the catalog should contain bazaarvoice inline rating
    Page Should Contain Element    xpath=//div[contains(@class,'grid grid')]/div[1]/product-item//*[@data-bv-show='inline_rating']

Yves: bazaarvoice successfully sent an event:
    [Arguments]    ${eventName}    ${timeout}=30s
    ${response}=    Wait for response    matcher=bazaarvoice\\.com\\/\\w+\\.gif\\?.*type=${eventName}    timeout=${timeout}
    Should be true    ${response}[ok]
