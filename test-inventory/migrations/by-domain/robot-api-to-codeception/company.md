### company · robot-api-to-codeception · 71 scenarios

MIGRATE 64 · REVIEW 7   ▸ 0/64 ported

Batches: `company-1`, `company-2`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Request_company_user_by_wrong_ID | b2b | `GET /company-users` → 404 | — | M | — |
| [ ] | Request_company_user_with_wrong_access_token | b2b | `GET /company-users` → 401 | — | S | — |
| [ ] | Request_company_user_without_access_token | b2b | `GET /company-users` → 403 | — | S | — |
| [ ] | Request_companies_users_if_user_has_4_companies | b2b | `GET /company-users?include=customers&filter[company-roles.id]=$` → 200 | — | M | — |
| [ ] | Request_companies_users_with_include_customers_and_filtered_by_company_role | b2b | `GET /company-users?include=customers&filter[company-roles.id]=$` → 200 | — | M | — |
| [ ] | Request_company_users | b2b | `GET /company-users?include=customers,company-business-units,company-roles` → 200 | — | M | — |
| [ ] | Request_company_users_by_id | b2b | `GET /company-users/mine` → 200 | — | M | — |
| [ ] | Request_company_users_by_mine | b2b | `GET /company-users?include=customers&filter[comp` → 200 | — | M | — |
| [ ] | Request_company_users_include_customers_and_roles_and_business_units | b2b | `GET /company-users?include=customers&filter[company-roles.id]=$` → 200 | — | M | — |
| [ ] | Request_company_by_user | mp_b2b | `GET /companies/mine` → 200 | — | M | — |
| [ ] | Request_business_unit_with_Invalid_access_token | mp_b2b | `GET /company-business-units/mine` → 401 | — | S | — |
| [ ] | Request_business_unit_with_customer_has_no_company_assignement | mp_b2b | `GET /company-business-units/mine` → 403 | — | L | — |
| [ ] | Request_business_unit_with_empty_access_token | mp_b2b | `GET /company-business-units/mine` → 403 | — | S | — |
| [ ] | Get_business_unit_address_with_empty_access_token | mp_b2b | `GET /company-business-unit-addresses/mine` → 403 | — | S | — |
| [ ] | Get_business_unit_address_with_invalid_access_token | mp_b2b | `GET /company-business-unit-addresses/mine` → 401 | — | S | — |
| [ ] | Get_business_unit_address_with_mine | mp_b2b | `GET /company-business-unit-addresses/mine` → 404 | — | M | — |
| [ ] | Get_business_unit_address_with_wrong_ID | mp_b2b | `GET /company-business-unit-addresses/mine` → 404 | — | M | — |
| [ ] | Get_business_units_address_by_id | mp_b2b | `GET /company-business-unit-addresses/$` → 200 | — | M | — |
| [ ] | Request_company_role_by_wrong_company_ID | mp_b2b | `GET /company-roles/mine` → 404 | — | M | — |
| [ ] | Request_company_role_when_customer_has_no_company_assignment | mp_b2b | `GET /company-roles/mine` → 403 | — | L | — |
| [ ] | Request_company_role_with_invalid_access_token | mp_b2b | `GET /company-roles/mine` → 401 | — | S | — |
| [ ] | Retrieve_company_user_with incorrect_token | mp_b2b | `GET /company-users/` → 401 | — | M | — |
| [ ] | Request_company_by_wrong_ID | ×3 | `GET /companies/$` → 404 | — | M | — |
| [ ] | Request_company_if_company_belong_to_other_users | ×3 | `GET /companies/$` → 404 | — | M | — |
| [ ] | Request_company_with_wrong_access_token | ×3 | `GET /companies/$` → 401 | — | S | — |
| [ ] | Request_company_without_access_token | ×3 | `GET /companies/$` → 403 | — | S | — |
| [ ] | Request_company_by_ID | ×3 | `GET /companies/mine` → 200 | — | M | — |
| [ ] | Request_company_by_mine | ×2 | `GET /companies/mine` → 200 | — | M | — |
| [ ] | Request_business_unit_by_wrong_ID | ×3 | `GET /company-business-units/$` → 404 | — | M | — |
| [ ] | Request_business_unit_if_company_belong_to_other_users | ×3 | `GET /company-business-units/$` → 404 | — | M | — |
| [ ] | Request_business_unit_with_wrong_access_token | ×2 | `GET /company-business-units/$` → 401 | — | S | — |
| [ ] | Request_business_unit_without_access_token | ×2 | `GET /company-business-units/$` → 403 | — | S | — |
| [ ] | Request_business_unit_by_id | ×3 | `GET /company-business-units/mine?include=company-business-unit-addresses,companies` → 200 | — | M | — |
| [ ] | Request_business_unit_by_id_with_include_address_and_company | ×3 | `GET /company-business-units/mine?include=company-business-unit-addresses,companies` → 200 | — | M | — |
| [ ] | Request_business_unit_by_mine | ×3 | `GET /company-business-units/mine?include=company-business-unit-addresses,companies` → 200 | — | M | — |
| [ ] | Request_business_unit_by_mine_include_address_and_company | ×3 | `GET /company-business-units/mine?include=company-business-unit-addresses,companies` → 200 | — | M | — |
| [ ] | Request_business_unit_address_by_wrong_ID | ×2 | `GET /company-business-unit-addresses/mine` → 404 | — | M | — |
| [ ] | Request_business_unit_address_with_mine | ×2 | `GET /company-business-unit-addresses/mine` → 404 | — | M | — |
| [ ] | Request_business_unit_address_with_wrong_access_token | ×2 | `GET /company-business-unit-addresses/mine` → 401 | — | S | — |
| [ ] | Request_business_unit_address_without_access_token | ×2 | `GET /company-business-unit-addresses/mine` → 403 | — | S | — |
| [ ] | Request_business_units_address_by_id | ×2 | `GET /company-business-unit-addresses/$` → 200 | — | M | — |
| [ ] | Request_company_role_by_wrong_ID | ×2 | `GET /company-roles/$` → 404 | — | M | — |
| [ ] | Request_company_role_if_role_belong_to_other_users | ×3 | `GET /company-roles/$` → 404 | — | M | — |
| [ ] | Request_company_role_with_wrong_access_token | ×2 | `GET /company-roles/$` → 401 | — | S | — |
| [ ] | Request_company_role_without_access_token | ×3 | `GET /company-roles/$` → 403 | — | S | — |
| [ ] | Request_company_role_by_id | ×3 | `GET /company-roles/$` → 200 | — | M | — |
| [ ] | Request_company_role_by_id_with_include_companies | ×3 | `GET /company-roles/$` → 200 | — | M | — |
| [ ] | Request_company_role_by_mine | ×3 | `GET /company-roles/$` → 200 | — | M | — |
| [ ] | Request_company_role_by_mine_with_include_companies | ×3 | `GET /company-roles/$` → 200 | — | M | — |
| [ ] | Request_access_token_with_missing_token | ×3 | `POST /company-user-access-tokens` → 403 | — | S | — |
| [ ] | Retrieve_company_user_by_incorrect_id | ×2 | `GET /company-users/` → 404 | — | M | — |
| [ ] | Retrieve_company_user_with_incorrect_token | suite | `GET /company-users/` → 401 | — | M | — |
| [ ] | Retrieve_list_of_company_users_by_user_without_admin_role | ×3 | `GET /company-users/` → 403 | — | M | — |
| [ ] | Retrieve_list_of_company_users_without_access_token | ×2 | `GET /company-users/` → 403 | — | S | — |
| [ ] | Retrieve_user_who_doesn't_belong_to_company | ×2 | `GET /company-users/` → 403 | — | L | — |
| [ ] | Retrieve_company_user_by_id | ×2 | `GET /company-users?include=company-business-units` → 200 | — | M | — |
| [ ] | Retrieve_company_user_including_companies | ×2 | `GET /company-users?include=customers&filter[company-roles.id]=$` → 200 | — | M | — |
| [ ] | Retrieve_company_user_including_company_business_units | ×2 | `GET /company-users?include=companies` → 200 | — | M | — |
| [ ] | Retrieve_company_user_including_company_roles | ×2 | `GET /company-roles/mine` → 200 | — | M | — |
| [ ] | Retrieve_company_user_including_customers | ×2 | `GET /company-users?include=company-roles` → 200 | — | M | — |
| [ ] | Retrieve_company_users_by_mine | ×2 | `GET /company-users/mine` → 200 | — | M | — |
| [ ] | Retrieve_list_of_company_users | ×2 | `GET /company-users?include=company-business-units` → 200 | — | M | — |
| [ ] | Retrieve_list_of_company_users_if_user_has_4_companies | ×2 | `GET /company-users/mine` → 200 | — | M | — |
| [ ] | Retrieve_list_of_company_users_with_include_customers_and_filtered_by_company_role | ×2 | `GET /company-users/mine` → 200 | — | M | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Request_access_token_by_empty_company_id | drop | Glue already asserts POST /company-user-access-tokens -> 422 in CompanyUserAuthAccessTokensRestApiCest::requestCompanyUserAccessTokenWithNoExistingIdCompanyUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_access_token_by_invalid_company_id | drop | Glue already asserts POST /company-user-access-tokens -> 422 in CompanyUserAuthAccessTokensRestApiCest::requestCompanyUserAccessTokenWithNoExistingIdCompanyUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_access_token_if_user_belong_to_other_company | drop | Glue already asserts POST /company-user-access-tokens -> 401 in CompanyUserAuthAccessTokensRestApiCest::requestCompanyUserAccessTokenWithUuidOfAnotherCompanyUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_access_token_using_invalid_token | drop | Glue already asserts POST /company-user-access-tokens -> 401 in CompanyUserAuthAccessTokensRestApiCest::requestCompanyUserAccessTokenWithUuidOfAnotherCompanyUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_access_token_with_empty_type | drop | Glue already asserts POST /company-user-access-tokens -> 400 in CompanyUserAuthAccessTokensRestApiCest::requestCompanyUserAccessTokenForExistingCustomerWithWrongType. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_access_token_with_invalid_type | drop | Glue already asserts POST /company-user-access-tokens -> 400 in CompanyUserAuthAccessTokensRestApiCest::requestCompanyUserAccessTokenForExistingCustomerWithWrongType. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_access_token_for_company_user_by_id | drop | Glue already asserts POST /company-user-access-tokens -> 201 in CompanyUserAuthAccessTokensRestApiCest::requestCompanyUserAccessTokenForExistingCustomerWithCompanyUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
