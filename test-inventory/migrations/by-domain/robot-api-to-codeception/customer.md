### customer · robot-api-to-codeception · 108 scenarios

MIGRATE 82 · REVIEW 26   ▸ 0/82 verified

Batches: `customer-1`, `customer-2`, `customer-3`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Create_customer_address_with_invalid_salutation | ×3 | `POST ...` → 403 | — | M | — |
| [ ] | Patch_customer_address_with_invalid_salutation | ×3 | `DELETE /customers/$` → 201 | — | M | — |
| [ ] | Restore_password_with_incorrect_restorePasswordKey | b2b | `PATCH ...` → 422 | — | S | — |
| [ ] | Create_a_customer_without_gender_and_salutation | b2b | `PATCH ...` → 422 | — | S | — |
| [ ] | Update_customer_password_with_value_not_matching_password_policy | ×2 | `PATCH /customer-password/$` → 201 | — | S | — |
| [ ] | Create_customer_address_with_customer_reference_not_matching_token | ×5 | `GET /customers/$` → 403 | — | M | — |
| [ ] | Create_customer_address_with_empty_fields | ×5 | `POST /customers/$` → 422 | — | M | — |
| [ ] | Create_customer_address_with_empty_type | ×5 | `GET /customers/$` → 400 | — | M | — |
| [ ] | Create_customer_address_with_invalid_salutation_bug | suite | `POST /customers/$` → 422 | — | M | — |
| [ ] | Create_customer_address_with_missing_required_fields | ×5 | `POST /customers/$` → 422 | — | M | — |
| [ ] | Create_customer_address_with_non_existing_customer_reference | ×5 | `POST /customers/$` → 403 | — | M | — |
| [ ] | Delete_customer_address_with_no_id | ×5 | `DELETE /customers/$` → 400 | — | M | — |
| [ ] | Delete_customer_address_with_wrong_id | ×5 | `DELETE /customers/$` → 404 | — | M | — |
| [ ] | Delete_other_customer_address_by_id | ×5 | `DELETE /customers/$` → 201 | — | M | — |
| [ ] | Get_address_list_for_non-existent_customer | ×5 | `GET /customers/$` → 403 | — | M | — |
| [ ] | Get_non-existent_customer_address | ×5 | `POST /customers/$` → 404 | — | M | — |
| [ ] | Get_other_customer_address_by_id | ×5 | `PATCH /customers/$` → 201 | — | M | — |
| [ ] | Get_other_customer_address_by_id_and_reference | ×5 | `POST /customers/$` → 201 | — | M | — |
| [ ] | Get_other_customer_address_list | ×5 | `GET /customers/$` → 201 | — | M | — |
| [ ] | Patch_another_customer_address | ×5 | `PATCH /customers/$` → 201 | — | M | — |
| [ ] | Patch_another_customer_address_by_id_using_reference | ×5 | `DELETE /customers/$` → 201 | — | M | — |
| [ ] | Patch_customer_address_with_empty_required_fields | ×5 | `POST /customers/$` → 201 | — | M | — |
| [ ] | Patch_customer_address_with_fake_id | ×5 | `PATCH /customers/$` → 404 | — | M | — |
| [ ] | Patch_customer_address_with_invalid_salutation_bug_CC-15866 | suite | `DELETE /customers/$` → 201 | — | M | — |
| [ ] | Patch_customer_address_with_no_reference | ×5 | `POST /customers/$` → 201 | — | M | — |
| [ ] | Patch_customer_address_with_wrong_reference | ×5 | `PATCH /customers/$` → 201 | — | M | — |
| [ ] | Patch_customer_address_without_id | ×5 | `POST /customers/$` → 400 | — | M | — |
| [ ] | Create_customer_address_as_billing_default | ×5 | `GET /customers/$` → 201 | — | M | — |
| [ ] | Create_customer_address_as_shipping_default | ×5 | `POST /customers/$` → 201 | — | M | — |
| [ ] | Create_customer_address_only_required_fields | ×5 | `POST /customers/$` → 201 | — | M | — |
| [ ] | Create_customer_address_with_all_fields | ×5 | `POST /customers/$` → 201 | — | M | — |
| [ ] | Delete_customer_address | ×5 | `PATCH /customers/$` → 201 | — | M | — |
| [ ] | Get_empty_list_of_customer_addresses | ×5 | `DELETE /customers/$` → 200 | — | M | — |
| [ ] | Get_list_of_customer_addresses_with_1_address | ×5 | `POST /customers/$` → 201 | — | M | — |
| [ ] | Get_list_of_customer_addresses_with_2_addresses | ×5 | `GET /customers/$` → 201 | — | M | — |
| [ ] | Update_customer_address_several_fields | ×5 | `DELETE /customers/$` → 201 | — | M | — |
| [ ] | Access_restricted_resource_as_not_authorized_customer | ×3 | `GET /wishlists` → 403 | — | S | — |
| [ ] | Access_restricted_resource_as_authorized_customer | ×5 | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Resources_list_which_customer_can_access | ×3 | `DELETE /wishlists/$` → 200 | — | S | — |
| [ ] | Customer_confirmation_with_already_used_confirmation_key | ×5 | `DELETE /customers/$` → 201 | — | L | — |
| [ ] | Customer_confirmation_with_empty_confirmation_key | ×5 | `DELETE /customers/$` → 422 | — | S | — |
| [ ] | Customer_confirmation_with_empty_type | ×5 | `DELETE /customers/$` → 400 | — | S | — |
| [ ] | Customer_confirmation_with_wrong_confirmation_key | ×5 | `DELETE /customers/$` → 422 | — | S | — |
| [ ] | Customer_confirmation_without_confirmation_key | ×5 | `DELETE /customers/$` → 422 | — | S | — |
| [ ] | Customer_confirmation | ×5 | `DELETE /customers/$` → 201 | — | L | — |
| [ ] | Forgot_password_incorrect_type | ×5 | `POST /customer-forgotten-password` → 400 | — | S | — |
| [ ] | Update_customer_password_with_empty_data_type | ×5 | `PATCH /customer-password/$` → 400 | — | M | — |
| [ ] | Update_customer_password_with_missing_customer_reference | ×5 | `PATCH /customer-password/$` → 400 | — | M | — |
| [ ] | Update_customer_password_with_not_valid_user_password | ×5 | `PATCH /customer-password/test123` → 400 | — | M | — |
| [ ] | Restore_password_with_empty_new_confirmation_password_value | ×5 | `PATCH /customer-restorepassword/$` → 422 | — | S | — |
| [ ] | Restore_password_with_empty_type | ×5 | `PATCH /customer-restore-password/$` → 400 | — | S | — |
| [ ] | Restore_password_with_incorrect_type | ×4 | `PATCH /customer-restore-password/$` → 400 | — | S | — |
| [ ] | Restore_password_with_incorrect_url | ×5 | `PATCH /customer-restorepassword/$` → 404 | — | S | — |
| [ ] | Restore_password_with_not_equal_new_password_and_confirm_password | ×5 | `PATCH /customer-restorepassword/$` → 422 | — | S | — |
| [ ] | Restore_password_with_too_long_new_password | ×5 | `PATCH /customer-restorepassword/$` → 422 | — | S | — |
| [ ] | Restore_password_with_too_short_new_password | ×5 | `PATCH /customer-restorepassword/$` → 422 | — | S | — |
| [ ] | Restore_password_without_customer_id | ×5 | `PATCH /customer-restore-password/$` → 400 | — | S | — |
| [ ] | Restore_password_with_all_required_fields_and_valid_data | ×5 | `DELETE /customers/$` → 201 | — | L | — |
| [ ] | Create_a_customer_with_absent_type | ×3 | `GET /customers/DE35` → 400 | — | S | — |
| [ ] | Create_a_customer_with_already_existing_email | ×3 | `POST /customers/` → 422 | — | S | — |
| [ ] | Create_a_customer_with_empty_type | ×3 | `POST /customers/` → 400 | — | S | — |
| [ ] | Create_a_customer_with_empty_values_for_required_fields | ×3 | `POST /customers/` → 422 | — | S | — |
| [ ] | Create_a_customer_with_missing_required_fields | ×3 | `GET /customers/$` → 422 | — | S | — |
| [ ] | Create_a_customer_with_not_accepted_terms_and_coditions | ×3 | `POST /customers/` → 422 | — | S | — |
| [ ] | Create_a_customer_with_not_equal_passwords | ×3 | `POST /customers/` → 422 | — | S | — |
| [ ] | Create_a_customer_with_too_long_password | ×3 | `POST /customers/` → 422 | — | S | — |
| [ ] | Create_a_customer_with_too_short_password | ×3 | `POST /customers/` → 422 | — | S | — |
| [ ] | Create_a_customer_with_wrong_email_format | ×3 | `GET /customers/DE35` → 422 | — | S | — |
| [ ] | Delete_a_cusomer_without_access_token | ×3 | `DELETE /customers/fake-id` → 403 | — | S | — |
| [ ] | Delete_a_customer_with_access_token_from_another | ×3 | `DELETE /customers/fake-id` → 403 | — | M | — |
| [ ] | Delete_a_customer_with_invalid_id | suite | `DELETE /customers/fake-id` → 403 | — | M | — |
| [ ] | Delete_a_customer_without_id | ×3 | `DELETE /customers/fake-id` → 400 | — | M | — |
| [ ] | Get_a_customer_with_access_token_from_another_user | ×3 | `PATCH /customers/$` → 404 | — | M | — |
| [ ] | Get_a_customer_with_wrong_id | ×3 | `PATCH /customers/$` → 404 | — | M | — |
| [ ] | Update_a_customer_with_absent_type | ×3 | `DELETE /customers/DE--35` → 400 | — | M | — |
| [ ] | Update_a_customer_with_invalid_data | ×3 | `DELETE /customers/DE--30` → 422 | — | M | — |
| [ ] | Update_a_customer_without_access_token | ×3 | `DELETE /customers/fake-id` → 403 | — | S | — |
| [ ] | Update_a_customer_without_id | ×3 | `DELETE /customers/fake-id` → 400 | — | M | — |
| [ ] | Delete_customer | ×3 | `DELETE /customers/$` → 201 | — | L | — |
| [ ] | Get_customer_array_contains_all_available_fields | ×3 | `DELETE /customers/$` → 200 | — | M | — |
| [ ] | New_customer_can_login_after_confirmation | ×3 | `GET /customers/$` → 201 | — | L | — |
| [ ] | Update_customer | ×3 | `POST /customers/` → 200 | — | M | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Get_resources_customer_can_access | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Delete_a_customer_with_wrong_id | drop | Glue already asserts DELETE /customers/{id} -> 403 in DeleteMethodRestApiCest::ensureDeleteRequestForbidden. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_customer_address_with_empty_customer_reference | drop | Glue already asserts DELETE /customers/{id} -> 403 in DeleteMethodRestApiCest::ensureDeleteRequestForbidden. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_address_list_with_no_token | drop | Glue already asserts DELETE /customers/{id} -> 403 in DeleteMethodRestApiCest::ensureDeleteRequestForbidden. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Forgot_password_empty_email | drop | Glue already asserts POST /customer-forgotten-password -> 422 in CustomerForgottenPasswordCest::requestPostCustomerForgottenPasswordFailsValidation. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Forgot_password_wrong_email_format | drop | Glue already asserts POST /customer-forgotten-password -> 422 in CustomerForgottenPasswordCest::requestPostCustomerForgottenPasswordFailsValidation. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Forgot_password_with_all_required_fields_and_valid_data | drop | Glue already asserts POST /customer-forgotten-password -> 204 in CustomerForgottenPasswordCest::requestPostCustomerForgottenPasswordRunsOk. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_customer_password_with_empty_current_password | drop | Glue already asserts PATCH /customer-password/{id} -> 422 in CustomerPasswordCest::requestPatchCustomerPasswordFailsValidation. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_customer_password_with_empty_new_password | drop | Glue already asserts PATCH /customer-password/{id} -> 422 in CustomerPasswordCest::requestPatchCustomerPasswordFailsValidation. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_customer_password_with_empty_new_password_confirmation | drop | Glue already asserts PATCH /customer-password/{id} -> 422 in CustomerPasswordCest::requestPatchCustomerPasswordFailsValidation. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_customer_password_with_invalid_access_token | drop | Glue already asserts PATCH /customer-password/{id} -> 403 in CustomerPasswordCest::requestPatchCustomerPasswordFailsToUseAnotherCustomerReference. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_customer_password_with_missing_mandatory_fields | drop | Glue already asserts PATCH /customer-password/{id} -> 422 in CustomerPasswordCest::requestPatchCustomerPasswordFailsValidation. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_customer_password_with_non_autorizated_user | drop | Glue already asserts PATCH /customer-password/{id} -> 403 in CustomerPasswordCest::requestPatchCustomerPasswordFailsToUseAnotherCustomerReference. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_customer_password_with_not_equal_new_password | drop | Glue already asserts PATCH /customer-password/{id} -> 422 in CustomerPasswordCest::requestPatchCustomerPasswordFailsValidation. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_customer_password_with_too_long_password | drop | Glue already asserts PATCH /customer-password/{id} -> 422 in CustomerPasswordCest::requestPatchCustomerPasswordFailsValidation. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_customer_password_with_too_short_password | drop | Glue already asserts PATCH /customer-password/{id} -> 422 in CustomerPasswordCest::requestPatchCustomerPasswordFailsValidation. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_customer_password_with_all_required_fields_and_valid_data | drop | Glue already asserts POST /access-tokens -> 201 in AccessTokensForCompanyUserRestApiCest::requestAccessTokenForExistingCustomerWithoutCompanyUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Restore_password_with_empty_new_password_value | drop | Glue already asserts PATCH /customer-restore-password/{id} -> 422 in CustomerRestorePasswordCest::requestPatchCustomerPasswordFailsValidation. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Restore_password_without_restorePasswordKey | drop | Glue already asserts PATCH /customer-restore-password/{id} -> 422 in CustomerRestorePasswordCest::requestPatchCustomerPasswordFailsValidation. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_a_customer_with_wrong_gender | drop | Glue already asserts PATCH /customers/{id} -> 422 in CustomerUpdateCest::requestPatchCustomerFailsToUseAnotherCustomersEmail. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_a_cusomer_without_access_token | drop | Glue already asserts PATCH /customers/{id} -> 403 in CustomerUpdateCest::requestPatchCustomerFailsToUseAnotherCustomersCustomerReference. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_a_customer_with_empty_type | drop | Glue already asserts PATCH /customers/{id} -> 400 in CustomerUpdateCest::requestPatchCustomerFailsWithoutCustomerReference. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_a_customer_with_empty_values_for_required_fields | drop | Glue already asserts PATCH /customers/{id} -> 422 in CustomerUpdateCest::requestPatchCustomerFailsToUseAnotherCustomersEmail. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_a_customer_with_wrong_id | drop | Glue already asserts PATCH /customers/{id} -> 403 in CustomerUpdateCest::requestPatchCustomerFailsToUseAnotherCustomersCustomerReference. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_customer | drop | Glue already asserts POST /access-tokens -> 201 in AccessTokensForCompanyUserRestApiCest::requestAccessTokenForExistingCustomerWithoutCompanyUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_customer_contains_all_available_fields | drop | Glue already asserts GET /customers/{id} -> 200 in CustomerReadCest::requestGetCustomerByIdReturnsOneResource. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
