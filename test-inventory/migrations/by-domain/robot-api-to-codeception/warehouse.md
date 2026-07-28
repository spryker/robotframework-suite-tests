### warehouse · robot-api-to-codeception · 32 scenarios

MIGRATE 32   ▸ 0/32 verified

Batches: `warehouse`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | New_warehouse_token_with_invalid_token | ×3 | `POST /warehouse-tokens` → 401 | — | S | — |
| [ ] | New_warehouse_token_without_autorization | ×3 | `POST /warehouse-tokens` → 401 | — | S | — |
| [ ] | Create_warehouse_user_assignment_with_empty_body | ×2 | `GET /warehouse-user-assignments/$` → 400 | — | S | — |
| [ ] | Delete_warehouse_user_assignment_without_token | ×3 | `DELETE /warehouse-user-assignments/$` → 400 | — | S | — |
| [ ] | Get_user_assignments_list_without_token | ×3 | `DELETE /warehouse-user-assignments/$` → 403 | — | S | — |
| [ ] | Get_warehouse_user_assignments_by_UUID_without_token | ×3 | `GET /warehouse-user-assignments/` → 403 | — | S | — |
| [ ] | Update_warehouse_user_assignment_with_invalid_token | ×3 | `DELETE /warehouse-user-assignments/$` → 403 | — | S | — |
| [ ] | Update_warehouse_user_assignment_without_token | ×3 | `DELETE /warehouse-user-assignments/$` → 401 | — | S | — |
| [ ] | Get_user_assignments_by_UUID_with_invalid_token | ×3 | `GET /warehouse-user-assignments/` → 401 | — | S | — |
| [ ] | Get_user_assignments_list_with_invalid_token | ×3 | `PATCH /warehouse-user-assignments/$` → 403 | — | S | — |
| [ ] | New_warehouse_token_for_admin_user_who_is_not_a_WH_user | ×3 | `POST /warehouse-tokens` → 200 | — | S | — |
| [ ] | Generate_new_user_token | ×3 | `POST /warehouse-tokens` → 200 | — | S | — |
| [ ] | Create_warehouse_user_assignment_as_warehouse_user_for_other_user | ×2 | `DELETE /warehouse-user-assignments/$` → 404 | — | S | — |
| [ ] | Create_warehouse_user_assignment_with_duplicate_assignment | ×3 | `GET /warehouse-user-assignments/$` → 201 | — | S | — |
| [ ] | Create_warehouse_user_assignment_with_incorrect_type | ×3 | `GET /warehouse-user-assignments/$` → 400 | — | S | — |
| [ ] | Create_warehouse_user_assignment_with_invalid_body | ×3 | `GET /warehouse-user-assignments/$` → 400 | — | S | — |
| [ ] | Create_warehouse_user_assignment_with_invalid_token | ×3 | `POST /warehouse-user-assignments` → 401 | — | S | — |
| [ ] | Create_warehouse_user_assignment_without_token | ×3 | `POST /warehouse-user-assignments` → 401 | — | S | — |
| [ ] | Delete_warehouse_user_assignment_with_invalid_token | suite | `DELETE /warehouse-user-assignments/$` → 401 | — | S | — |
| [ ] | Get_user_assignments_by_invalid_UUID | ×3 | `PATCH /warehouse-user-assignments/$` → 404 | — | S | — |
| [ ] | Update_warehouse_user_assignment_without_uuid | ×3 | `DELETE /warehouse-user-assignments/$` → 201 | — | S | — |
| [ ] | Assign_user_to_warehouse | ×3 | `DELETE /warehouse-user-assignments/$` → 201 | — | S | — |
| [ ] | Assign_user_to_warehouse_with_include | ×3 | `DELETE /warehouse-user-assignments/$` → 201 | — | S | — |
| [ ] | Create_warehouse_user_assignment_with_multiple_active_assignments | suite | `DELETE /warehouse-user-assignments/$` → 204 | — | S | — |
| [ ] | Get_warehouse_user_assignments_by_UUID | ×3 | `GET /warehouse-user-assignments` → 201 | — | S | — |
| [ ] | Get_warehouse_user_assignments_list | ×3 | `POST /warehouse-user-assignments?include=users` → 201 | — | S | — |
| [ ] | Get_warehouse_user_assignments_with_filter_by_isActive | ×3 | `PATCH /warehouse-user-assignments/$` → 201 | — | S | — |
| [ ] | Get_warehouse_user_assignments_with_filter_by_user_uuid | ×3 | `GET /warehouse-user-assignments/?filter[warehouse-user-assignments.isAct` → 201 | — | S | — |
| [ ] | Get_warehouse_user_assignments_with_filter_by_warehouse_assignment_uuid | ×3 | `POST /warehouse-user-assignments?include=users` → 201 | — | S | — |
| [ ] | Get_warehouse_user_assignments_with_filter_by_warehouse_uuid | ×3 | `GET /warehouse-user-assignm` → 201 | — | S | — |
| [ ] | Update_one_of_already exist_warehouse_user_assignment_with_two_assignments_to active | ×3 | `DELETE /warehouse-user-assignments/$` → 201 | — | S | — |
| [ ] | Update_warehouse_user_assignment | ×3 | `DELETE /warehouse-user-assignments/$` → 201 | — | S | — |
