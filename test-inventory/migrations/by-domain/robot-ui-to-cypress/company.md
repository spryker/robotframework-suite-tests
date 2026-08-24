### company · robot-ui-to-cypress · CC-39280 · 2 scenarios

MIGRATE 2   ▸ 2/2 verified

Batches: `company`

Target PR: https://github.com/spryker/cypress-tests/pull/392

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [x] | Create_new_company_user_with_linked_entities_in_storefront | ×3 | Create a new company user on Storefront. _(yves)_ | `cypress/e2e/yves/company-account/company-structure-creation.cy.ts::company administrator should be able to create a business unit and a company user in it` | M | `local 2026-08-24 · 2 passing · 13s` |
| [x] | Create_new_company_with_linked_entities_and_customer_in_backoffice | ×3 | Create a new company with linked entities and new customer in backoffice. _(yves)_ | `cypress/e2e/backoffice/company-account/company-structure-creation.cy.ts::should build a company, a business unit, a role and a company user in the back office` | M | `local 2026-08-24 · 2 passing · 37s` |
