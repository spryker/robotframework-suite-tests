*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_aop_pbc_details_page.robot
Resource    ../pages/zed/zed_aop_bazaarvoice_details_page.robot
Resource    ../pages/yves/yves_product_details_page.robot
Resource    ../pages/yves/yves_bazaarvoice_review_popup_form.robot


*** Keywords ***
Zed: configure bazaarvoice pbc with the following data:
    [Documentation]    Possible argument names: clientName, siteId, environment, services, stores
    [Arguments]    @{args}
    ${bazaarvoiceCondifurationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{bazaarvoiceCondifurationData}
        Log    Key is '${key}' and value is '${value}'.
        Run keyword if    '${key}'=='clientName' and '${value}' != '${EMPTY}'    Type Text    ${pbc_bazzarvoice_client_name_input}    ${value}
        Run keyword if    '${key}'=='siteId' and '${value}' != '${EMPTY}'    Type Text    ${pbc_bazzarvoice_side_id_input}    ${value}
        Run keyword if    '${key}'=='environment' and '${value}' != '${EMPTY}'    Click    //spy-radio-group[@id='settings_environment']//label//span[contains(text(),'${value}')]/ancestor::label
        Run keyword if    '${key}'=='services' and '${value}' != '${EMPTY}'    Run Keywords    
        ...    Conver string to List by separator:    ${value}
        ...    AND    Log    ${covertedList}
        ...    AND    Check bazaarvoice configuration checkbox:    ${covertedList}
        Run keyword if    '${key}'=='stores' and '${value}' != '${EMPTY}'    Run Keywords    
        ...    Conver string to List by separator:    ${value}
        ...    AND    Log    ${covertedList}
        ...    AND    Check bazaarvoice configuration checkbox:    ${covertedList}
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

Yves: post bazaarvoice review with the following data:
    [Documentation]    Possible argument names: overallRating, reviewTitle, review, recommendProduct, nickname, location, email, age, gender, qualityRating, valueRating
    [Arguments]    @{args}
    Click    ${pdp_bazaarvoice_write_review_button}
    Wait Until Element Is Visible    ${bv_submit_button}
    ${bazaarvoiceReviewData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{bazaarvoiceReviewData}
        Log    Key is '${key}' and value is '${value}'.
        Run keyword if    '${key}'=='overallRating' and '${value}' != '${EMPTY}'    Click    xpath=//span[@id='bv-radio-rating-${value}']
        Run keyword if    '${key}'=='reviewTitle' and '${value}' != '${EMPTY}'    Type Text    ${bv_review_title_input}    ${value}
        Run keyword if    '${key}'=='review' and '${value}' != '${EMPTY}'    Type Text    ${bv_review_text_area}    ${value}
        Run keyword if    '${key}'=='recommendProduct' and '${value}' == 'yes'    Click    ${bv_recommend_product_true_label}
        Run keyword if    '${key}'=='recommendProduct' and '${value}' == 'no'    Click    ${bv_recommend_product_false_label}
        Run keyword if    '${key}'=='nickname' and '${value}' != '${EMPTY}'    Type Text    ${bv_nickname_input}    ${value}
        Run keyword if    '${key}'=='location' and '${value}' != '${EMPTY}'    Type Text    ${bv_location_input}    ${value}
        Run keyword if    '${key}'=='email' and '${value}' != '${EMPTY}'    Type Text    ${bv_email_input}    ${value}
        Run keyword if    '${key}'=='age' and '${value}' != '${EMPTY}'    Select From List By Label    ${bv_select_age_dropdown}    ${value}
        Run keyword if    '${key}'=='gender' and '${value}' != '${EMPTY}'    Select From List By Label    ${bv_select_gender_dropdown}    ${value}
        Run keyword if    '${key}'=='qualityRating' and '${value}' != '${EMPTY}'    Click    xpath=//span[@id='bv-radio-rating_Quality-${value}']
        Run keyword if    '${key}'=='valueRating' and '${value}' != '${EMPTY}'    Click    xpath=//span[@id='bv-radio-rating_Value-${value}']
    END
    Check Checkbox    ${bv_terms_and_conditions_checkbox}
    Click    ${bv_submit_button}
Yves: page should contain the following script:
    [Arguments]    ${scriptId}
    Try reloading page until element is/not appear:    xpath=//head//script[@id='${scriptId}']    true
    # FOR    ${index}    IN RANGE    0    21
    #     ${script_applied}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//head//script[@id='${scriptId}']
    #     Run Keyword If    '${script_applied}'=='False'    Run Keywords    Sleep    1s    AND    Reload
    #     ...    ELSE    Exit For Loop
    # END 
    Page Should Contain Element    xpath=//head//script[@id='${scriptId}']