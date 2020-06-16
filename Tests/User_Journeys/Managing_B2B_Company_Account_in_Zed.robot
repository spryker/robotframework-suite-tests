*** Settings ***
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Library           SeleniumLibrary



*** Test Cases ***
UJ:Managing_B2B_Copmany_Account_in_Zed_Part_1
    [Documentation]    This user journey is to check possibility to Create Company, Business unit and initial Admin user with Permissions for Managing User in Zed
    Zed: Login on Zed with Provided Credentials  ${admin_email}  ${default_password}
    Zed: Create New Company with Provided Name   Robot+${random}
    Zed: Click Action Button in a Table For Row That Contains  Robot+${random}      Approve
    Zed: Click Action Button in a Table For Row That Contains  Robot+${random}      Activate
    Zed: Create New Company Role with Prodided Permissions  Robot+${random}     Test Robot Role+${random}   false  Add company users   Invite users   Enable / Disable company users    See Company Menu    Add item to cart    Change item in cart     Remove item from cart   Place Order     Alter Cart Up To Amount
    Zed: Create New Company Role with Prodided Permissions  Trial     Existing Role+${random}   false  Add company users   Invite users   Enable / Disable company users    See Company Menu    Add item to cart    Change item in cart     Remove item from cart   Place Order     Alter Cart Up To Amount
    Zed: Create New Company Business Unit with Prodived Name and Company  Test Robot BU+${random}   Robot+${random}
    Zed: Create New Company User with Provided Email/Company/Business Unit and Role(s)  ${test_customer_email}   Robot+${random}     Test Robot BU+${random} (id: ${newly_created_business_unit_id})    Test Robot Role+${random}
    Yves: Change Password on Default One via Link from Email for Provided User   ${test_customer_email}
    Yves: Login on Yves with Provided Credentials     ${test_customer_email}
    Yves: Check that Company Menu is available for Logged in User
    Zed: Click Button in Header  button_name

UJ:Managing_B2B_Copmany_Account_in_Zed_Part_1
    [Documentation]    This user journey is to check possibility to Create Company, Business unit and initial Admin user with Permissions for Managing User in Zed
    Given user with <email> and <password> is logged into Zed

