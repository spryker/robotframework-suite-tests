### store · robot-ui-to-cypress · CC-39280 · 4 scenarios

MIGRATE 4   ▸ 0/4 verified

Batches: `store`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Dynamic_multistore | ×5 | This test should exclusively run for dynamic multi-store scenarios. The test verifies that the user can successfully create a new store, assign a product and CMS page, and register a customer within the new store. _(yves)_ | `cypress/e2e/backoffice/core/dynamic-store-creation.cy.ts` | L | — |
| [ ] | Multistore_CMS | ×5 | check CMS multistore functionality. _(yves)_ | `cypress/e2e/yves/core/multistore-cms-page.cy.ts` | L | — |
| [ ] | Multistore_Product | ×3 | check product multistore functionality. _(yves)_ | `cypress/e2e/yves/core/multistore-product.cy.ts` | L | — |
| [ ] | Multistore_Product_Offer | ×3 | check product and offer multistore functionality. _(yves)_ | `cypress/e2e/yves/core/multistore-product-offer.cy.ts` | L | — |
