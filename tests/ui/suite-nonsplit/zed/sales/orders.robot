Orders_List_Page
    [Documentation]    Checks that order details are displayed correctly on orders page
    Setup: placed order exists with known customer, state, total, items
    Login to Zed
    Open Sales/Orders screen
    Check that customer name value is expected
    Check that customer email value is expected
    Check that state value is expected
    Check that total value is expected
    Check that #of items value is expected
    Check that View and Claim buttons are active


Order_View_Page
    [Documentation]    Checks that order details are displayed correctly on view order page
    Setup: placed order exists and has state 'Payment Pending' (1 product with quantity 2, 1 with quantity 1), paid by Dummy Payment
    Login to Zed
    Open Sales/Orders screen
    Click View button
    Order overview section: check date if possible
    Check Unique Product Quantity
    Assert numbers in Totals section: product price 
    Assert numbers in Totals section: shipment price 
    Assert numbers in Totals section: discount
    Assert numbers in Totals section: tax 
    Assert numbers in Totals section: grand total
    Check if Trigger States contains Pay and Cancel buttons
    Assert values in Customer section: Name
    Assert values in Customer section: Email
    Assert values in Customer section: Billing adddress
    Assert values in Order Items section: Delivery Address
    Assert values in Order Items section: Delivery Method
    Assert values in Order Items section: Shipping Method
    Assert values in Order Items section: Shipping Costs
    Assert values in Order Items section: Request delivery date
    Assert values of 1st product: Name
    Assert values of 1st product: Quantity
    Assert values of 1st product: Unit price
    Assert values of 1st product: Total
    Assert value of 2nd product: Total
    Check that each product has 'Payment Pending' state
    Check that trigger event column contains Pay and Cancel buttons for each product
    Check values in payments section: Payment provider
    Check values in payments section: Payment method 
    Check values in payments section: Amount


Order_OMS_Actions
    [Documentation]    Checks that order could be processed through OMS from backoffice (by items and whole order)
    Setup: placed order exists and has state 'Payment Pending' (any 2 different products), paid by Dummy Payment
    Login to Zed
    Open Sales/Orders screen
    Click View button
    On Order Items section click Pay in 1 product row
    Check that state for this row becaume Confirmed
    Check that state for second row remains Payment Pending
    Check that new trigger buttons appeared: skip timeout and invoice-generate
    On Order Overview section (top of page) click Pay button
    Check that state of all products is now Confirmed
    Check that skip timeout and invoice-generate buttons are now displaying for each product row and in top section
    Click Skip timeout for 1st product
    Check that top list of trigger buttons now contains Ship
    Click Skip timeout for 2nd product
    Check that top list of trigger buttons now contains only Ship
    Click Ship for whole order
    Check that state updated to Shipped for each product
    Click Stock update
    Check that state is now Delivered
    Click Close for whole order
    Check that state is now closed
    Check that no trigger buttons are now displayed


Order_Cancellation
    [Documentation]    Checks that orders in suitable states could be cancelled from backoffice
    Setup: 3 placed orders exist with states 'Payment Pending', 'Confirmed', 'Shipped', paid by Dummy Payment
    Login to Zed
    Open Sales/Orders screen
    Click View button on order in 'Payment Pending' state
    Click Cancel button in 'trigger states' section
    Check that order state updated to Cancelled
    Check that there are no trigger buttons now
    Return to orders list page
    Check that state is Cancelled for updated order
    Click View button on order in 'Confirmed' state
    Click Cancel button in 'trigger states' section
    Check that order state updated to Cancelled
    Check that there are no trigger buttons now
    Return to orders list page
    Check that state is Cancelled for updated order
    Click View button on order in 'Shipped' state
    Check that there are no Cancel button


Order_with_Bundled_Items
    [Documentation]    Checks that bundled items info is displaying correctly and such order could be processed from backoffice
    Setup: placed order contains bundle product and has state 'Payment Pending' (different products, example on nonsplit is HP Bundle)
    Login to Zed
    Open Sales/Orders screen
    Click View button on order row
    In Totals section check that bundle name is displayed
    In Order items section check that bundle row is displaying with total
    In Order items section check that bundle row has no state
    In Order items section check that separete row is displaying for each bundled product
    Assert Unit Price for each bundled product
    Assert State for each bundled product
    Click Pay on first bundled product
    Go back to orders list and check that state now contains 'confirmed' and 'Payment pending'
    Return to order view page
    Click Pay for whole product
    Assert State for each bundled product, it should be 'confirmed' for all now


Order_Custom_Reference_and_Comments
    [Documentation]    Checks that backoffice user can operate order's custom reference and comments
    Setup: any placed order exists
    Login to Zed
    Open Sales/Orders screen
    Click View button on order row
    On Custom Order Reference section click Edit Reference
    Fill some text
    Click Save
    Check that reference text is now displayed
    Click Edit Reference again
    Update text to new
    Click Save
    Check that updated text is displaying
    On comments section type some text in message box
    Click Send Message
    Check that message text is now displaying in comments section with admin user name
    Check that message box cleared


Order_Reclamation
    [Documentation]    Checks that order reclamation could be created and moved through available states
    Setup: placed order exists and has state 'Exported' (any 2 different products)
    Login to Zed
    Open Sales/Orders screen
    Click Claim in order row
    Select 1st product
    Click Create Reclamation
    Check that View reclamation page was opened and contains only selected product
    Assert product name, price, state
    Check that Ship button is available
    Click Ship
    Check that state became shipped
    Click Stock update
    Check that state became Delivered
    Check that buttons Close and Refund are available
    Click Close
    Check that order state is closed
    Check that reclamation state is still Open
    Navigate to reclamations list
    Click Close on reclamation
    Check that status is now Closed
    

Order_Create_Shipment
    [Documentation]    Checks that custom shipment could be created for items of order
    Setup: placed order exists and has state 'Payment Pending' (any 2 different products)
    Login to Zed
    Open Sales/Orders screen
    Click View button on order row
    Click Create Shipment button in order items section
    Select Delivery Address
    Select Shipment Method
    Select Delivery Date
    Select 1st product via checkbox
    Click Save
    Check that message was shown 'Shipment has been successfully created.'
    Check that Order Items table now contains 2 shipments
    Check that 'Shipment 1 of 2' consists of 2nd product
    Check that 'Shipment 2 of 2' consists of 1st product (selected previously)
    Assert that for 2nd shipment Delivery Address, Shipment Method, Delivery Date have values selected in previous steps
    Check that shipment costs are zero
    Click Edit Shipment on 1st shipment
    Check that current product in this shipment (2nd product) is disabled
    Change Shipment Method
    Click Save
    Check that Shipment Method has new value
    Check that shipment costs remained unchanged
