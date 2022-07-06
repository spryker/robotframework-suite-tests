Order_Return
    [Documentation]    Checks that return could be created and will have correct values
    Setup: placed order exists and has state 'Delivered'. Grand total is known value
    Login to Zed
    Open Sales/Orders screen
    Click View button
    On Order Items section click Return button on the top of page
    On return creation page select products and pick return return reason
    Save the return
    Navigate to returns page
    Check that new row was added with today's date
    Assert order reference, returned products quantity
    State should be 'Waiting for return'
    Click Print Slip
    Check that slip page was opened
    Go back to returns page
    Click View on created return
    Assert order reference, products quantity, date, state
    Assert product table values: name, quantity, price
    Assert Remuneration Total - should be same value as order total
    Click Execute Return
    Check that state changed to returned
    Click Refund
    Check that state changed to refunded
    Check that new refund appeared on Refunds page
