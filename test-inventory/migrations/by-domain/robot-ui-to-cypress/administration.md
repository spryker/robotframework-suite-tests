### administration · robot-ui-to-cypress · 6 scenarios

MIGRATE 5 · OBSOLETE 1   ▸ 0/5 verified

Batches: `administration`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Glossary | ×5 | Create + edit glossary translation in BO. _(yves)_ | `cypress/e2e/backoffice/administration/glossary-management.cy.ts` | L | — |
| [ ] | Payment_method_update | ×2 | Deactivate payment method, unset payment method for stores in zed and check its impact on yves. _(yves)_ | `cypress/e2e/backoffice/administration/payment-method-availability.cy.ts` | L | — |
| [ ] | Zed_navigation_ordering_and_naming | ×5 | Verifies each left navigation node can be opened. DMS ON: https://spryker.atlassian.net/browse/FRW-7394. _(backoffice)_ | `cypress/e2e/backoffice/navigation/navigation-smoke.cy.ts` | M | — |
| [ ] | Agent_Assist | ×5 | Checks customer data and checkout as an agent. _(yves)_ | `cypress/e2e/yves/agent-assist/customer-impersonation-checkout.cy.ts` | L | — |
| [ ] | User_Control | ×5 | Create a user with limited access. _(backoffice)_ | `cypress/e2e/backoffice/acl/acl-navigation-access.cy.ts::Given a back office role with an explicit deny rule When the denied action is opened Then access is denied and a deactivated user cannot log in` | M | — |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Minimum_Order_Value | Duplicate journey — retired by the port of platform/Minimum_Order_Value; delete it in that sibling's batch, it needs no port of its own. | robot:tests/parallel_ui/suite/misc/static_demodata_set.robot::Minimum_Order_Value |
