*** Variables ***
${offer_active_checkbox}    xpath=//web-spy-checkbox[@spy-id='productOffer_isActive']//span[@class='ant-checkbox-inner']
${offer_merchant_sku}    id=productOffer_merchantSku
${stores_list_selector}    xpath=//web-spy-select[@spy-id='productOffer_stores']//nz-select
${offer_stock_input}    xpath=//web-spy-input[@spy-id='productOffer_productOfferStocks_quantity']//input
${offer_saved_popup}    xpath=//span[contains(@class,'ant-alert')]//span[contains(text(),'The Offer is saved')]
${offer_always_in_stock_checkbox}    xpath=//web-spy-checkbox[contains(@name,'Stock')]/label/span[contains(@class,'checkbox')]