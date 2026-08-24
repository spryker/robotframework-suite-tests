### administration · robot-ui-to-cypress · CC-39280 · 6 scenarios

MIGRATE 4 · OBSOLETE 1 · DEFER 1   ▸ 4/4 verified

Batches: `administration`

Target PR: https://github.com/spryker/cypress-tests/pull/395

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [x] | Glossary | ×5 | Create + edit glossary translation in BO. _(yves)_ | `cypress/e2e/backoffice/administration/glossary-management.cy.ts::should create a translation and list it` | L | `local 2026-08-24 · 2 passing · 13s` |
| [x] | Zed_navigation_ordering_and_naming | ×5 | Verifies each left navigation node can be opened. DMS ON: https://spryker.atlassian.net/browse/FRW-7394. _(backoffice)_ | `cypress/e2e/backoffice/navigation/navigation-smoke.cy.ts::should open every left navigation node without an error` | M | `local 2026-08-24 · 2 passing · 29s` |
| [x] | Agent_Assist | ×5 | Checks customer data and checkout as an agent. _(yves)_ | `cypress/e2e/yves/agent-assist/customer-impersonation.cy.ts::agent should be able to place an order for the impersonated customer` | L | `local 2026-08-24 · 4 passing · 40s` |
| [x] | User_Control | ×5 | Create a user with limited access. _(backoffice)_ | `cypress/e2e/backoffice/acl/acl-navigation-access.cy.ts::should deny an action for a role with an explicit deny rule` | M | `local 2026-08-24 · 4 passing · 22s` |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Minimum_Order_Value | Duplicate journey — retired by the port of platform/Minimum_Order_Value; delete it in that sibling's batch, it needs no port of its own. | robot:tests/parallel_ui/suite/misc/static_demodata_set.robot::Minimum_Order_Value |

#### DEFER — parked, not counted as migrated
| Scenario | Placeholder | Blocked by |
|---|---|---|
| Payment_method_update | `cypress/e2e/backoffice/administration/payment-method-availability.cy.ts` | Deactivates the Invoice payment method globally to prove it disappears from checkout. dummyPaymentInvoice is depended on by the checkout, order-amendment and recurring-order specs, Cypress shards run concurrently against one application, and shard packing is nondeterministic, so whichever of those is packed alongside would fail. A fixture-created payment method is not a way round it: with no storefront plugin behind it, it does not render in checkout. Needs a serial lane or per-test payment-method state. |
