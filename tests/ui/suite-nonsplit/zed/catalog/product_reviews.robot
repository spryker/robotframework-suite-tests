Product_Reviews_Actions
    Setup: review exists in Pending status
    [Documentation]    Checks possibility to change status of product review
    Log into Zed
    Open Product Reviews screen
    Check that for review in Pending status Actions column contains 'Approve' and 'Reject' buttons
    Click Approve button
    Check that status became 'Approved'
    Check that Actions column for this review doesn't contain 'Approve' anymore
    Click Reject button
    Check that status became 'Rejected'
    Check that Actions column for this review doesn't contain 'Reject' anymore
    Click Approve button
    Check that status became 'Approved'

Delete_Product_Review
    [Documentation]    Checks possibility to delete product review
    Log into Zed
    Open Product Reviews screen
    Select review and save it's ID
    Click Delete in review row
    Check that message shown 'Product Review #${ID} deleted successfully.'
    Try to find review in table and check that 0 results found