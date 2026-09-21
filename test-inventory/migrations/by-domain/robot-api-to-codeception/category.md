### category · robot-api-to-codeception · 8 scenarios

MIGRATE 8   ▸ 0/8 verified

Batches: `category`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Get_category_node_is_leaf_by_id | b2b | `GET /category-nodes/$` → 200 | — | S | — |
| [ ] | Get_absent_category_node | ×5 | `GET /category-nodes` → 400 | — | S | — |
| [ ] | Get_category_node_by_invalid_id | ×5 | `GET /category-nodes` → 400 | — | S | — |
| [ ] | Get_category_node_by_non_exist_id | ×5 | `GET /category-nodes` → 404 | — | S | — |
| [ ] | Get_category_node_has_children_by_id | ×5 | `GET /category-nodes/$` → 200 | — | S | — |
| [ ] | Get_category_node_is_root_by_id | ×5 | `GET /category-nodes/$` → 200 | — | S | — |
| [ ] | Get_category_node_that_has_only_parents_by_id | ×4 | `GET /category-nodes/$` → 200 | — | S | — |
| [ ] | Get_category_trees | ×4 | `GET /category-trees` → 200 | — | S | — |
