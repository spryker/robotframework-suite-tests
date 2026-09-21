### navigation · robot-api-to-codeception · 8 scenarios

MIGRATE 8   ▸ 0/8 verified

Batches: `navigation`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Get_absent_navigations | ×2 | `GET /navigations` → 400 | — | S | — |
| [ ] | Get_navigations_by_non_exist_id | ×2 | `GET /navigations` → 404 | — | S | — |
| [ ] | Get_navigation_tree_using_valid_navigation_key | ×2 | `GET /navigations/MAIN_NAVIGATION?include=category-nodes` → 200 | — | S | — |
| [ ] | Get_navigation_tree_using_valid_navigation_key_with_category_nodes_included | ×2 | `GET /navigations/MAIN_NAVIGATION?include=category-nodes` → 200 | — | S | — |
| [ ] | Get_absent_navigations | ×3 | `GET /navigations` → 400 | — | S | — |
| [ ] | Get_navigations_by_non_exist_id | ×3 | `GET /navigations` → 404 | — | S | — |
| [ ] | Get_navigation_tree_using_valid_navigation_key_with_category_nodes_included | ×3 | `GET /navigations/MAIN_NAVIGATION?include=category-nodes` → 200 | — | S | — |
| [ ] | To_retrieve_a_navigation_tree | ×3 | `GET /navigations/MAIN_NAVIGATION?include=category-nodes` → 200 | — | S | — |
