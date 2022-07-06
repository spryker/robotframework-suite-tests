Order_Refund
    [Documentation]    Checks that order refund could be created and will have correct amount
    Setup: placed order exists and has state 'Delivered'. Grand total is known value
    Login to Zed
    Open Sales/Orders screen
    Click View button
    On Order Items section click Refund
    Check that 'Status change triggered successfully.' message shown
    Check that order grand total is now 0
    Check that refund total is filled by ex order total value
    Navigate to Refunds page
    Check that new row was added with today's date
    Sales order id is same as on order list
    Amount is same value as order's grand total

Order_Refund_1_item
    [Documentation]    Checks that refund could be created for separate item and will have correct amount
    Setup: placed order exists and has state 'Delivered'. Grand total, unit price and shipment amount are known
    Login to Zed
    Open Sales/Orders screen
    Click View button
    On Order Items section click Refund in 1 product row
    Check that state of this product became Refunded
    Check that order grand total decreased by refunded value
    Check that refund total is filled by ex product total value
    Return to orders list anc check that order states are now Refunded and Delivered
    Navigate to Refunds page
    Check that new row was added with today's date
    Sales order id is same as on order list
    Amount is same value as product total(unit price considering discounts if it was applied)