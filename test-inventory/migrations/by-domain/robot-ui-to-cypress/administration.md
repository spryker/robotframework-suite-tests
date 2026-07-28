### administration · robot-ui-to-cypress · 6 scenarios

MIGRATE 3 · REVIEW 3   ▸ 0/3 ported

Batches: `administration`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Glossary | ×5 | Create + edit glossary translation in BO. _(yves)_ | `cypress/e2e/backoffice/administration/glossary-management.cy.ts` | L | — |
| [ ] | Payment_method_update | ×2 | Deactivate payment method, unset payment method for stores in zed and check its impact on yves. _(yves)_ | `cypress/e2e/backoffice/administration/payment-method-availability.cy.ts` | L | — |
| [ ] | Agent_Assist | ×5 | Checks customer data and checkout as an agent. _(yves)_ | `cypress/e2e/yves/agent-assist/customer-impersonation-checkout.cy.ts` | L | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Minimum_Order_Value | merge into cypress/e2e/yves/checkout/minimum-order-value.cy.ts | Same journey as parallel_ui/suite/misc/static_demodata_set.robot::Minimum_Order_Value (hard min/max plus soft threshold with fixed fee, surcharge in cart and summary, grand total); that variant uses dynamic fixtures and is the better port source. |
| Zed_navigation_ordering_and_naming | port as a single cypress/e2e/backoffice/navigation/navigation-smoke.cy.ts that opens each node | Three keywords that walk every left-navigation root and second-level node plus icons - broad but assertion-thin, and backoffice/acl/acl-navigation-access.cy.ts plus backoffice/navigation/menu-filter.cy.ts already exercise menu items from other angles. |
| User_Control | port the action-deny and deactivation deltas into cypress/e2e/backoffice/acl/acl-navigation-access.cy.ts | BO role with an explicit deny rule, group, and user; the denied action returns 'Access denied' and a deactivated user cannot log in. backoffice/acl/acl-navigation-access.cy.ts covers allow/deny at navigation and path level but not action-level deny or user deactivation. |
