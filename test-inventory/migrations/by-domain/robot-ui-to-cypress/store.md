### store · robot-ui-to-cypress · CC-39280 · 4 scenarios

MIGRATE 4   ▸ 4/4 verified

Batches: `store`

Target PR: https://github.com/spryker/cypress-tests/pull/404

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [x] | Dynamic_multistore | ×5 | This test should exclusively run for dynamic multi-store scenarios. The test verifies that the user can successfully create a new store, assign a product and CMS page, and register a customer within the new store. _(yves)_ | `cypress/e2e/backoffice/core/dynamic-store-creation.cy.ts::given a store is created in the back office when a shopper opens the storefront then the store switcher offers it` | L | `local 2026-08-26 · 4 passing · 47s` |
| [x] | Multistore_CMS | ×5 | check CMS multistore functionality. _(yves)_ | `cypress/e2e/yves/core/multistore-cms-page.cy.ts::given a cms page is unassigned from a store when a shopper opens its url on that store then the page is not found` | L | `local 2026-08-26 · 2 passing · 43s` |
| [x] | Multistore_Product | ×3 | check product multistore functionality. _(yves)_ | `cypress/e2e/yves/core/multistore-product.cy.ts::given a product is unassigned from a store when a shopper opens its detail page on that store then the page is not found` | L | `local 2026-08-26 · 2 passing · 43s` |
| [x] | Multistore_Product_Offer | ×3 | check product and offer multistore functionality. _(yves)_ | `cypress/e2e/yves/core/multistore-product-offer.cy.ts::given a store is unassigned from a product offer when a shopper opens the detail page then only the remaining store still lists that offer` | L | `local 2026-08-26 · 2 passing · 43s` |
