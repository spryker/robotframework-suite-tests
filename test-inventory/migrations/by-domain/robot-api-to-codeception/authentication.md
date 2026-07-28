### authentication · robot-api-to-codeception · 38 scenarios

MIGRATE 6 · REVIEW 18 · UNDECIDED 14   ▸ 0/6 ported

Batches: `authentication`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Delete_refresh_token_with_invalid_refresh_token | ×5 | `POST /refresh-tokens` → 204 | — | M | — |
| [ ] | Refresh_token_with_access_token | ×5 | `DELETE /refresh-tokens/` → 401 | — | M | — |
| [ ] | Refresh_token_with_empty_refresh_token | ×5 | `DELETE /refresh-tokens/$` → 422 | — | S | — |
| [ ] | Refresh_token_with_invalid_refresh_token | ×5 | `DELETE /refresh-tokens/$` → 401 | — | S | — |
| [ ] | Delete_refresh_token_for_customer | ×5 | `DELETE /refresh-tokens/$` → 201 | — | S | — |
| [ ] | Refresh_access_token_for_customer | ×5 | `DELETE /refresh-tokens/$` → 201 | — | S | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Get_access_token_with_empty_email | drop | Glue already asserts POST /access-tokens -> 422 in AccessTokensRestApiCest::requestAccessTokenWithEmptyPassword. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_access_token_with_empty_password | drop | Glue already asserts POST /access-tokens -> 422 in AccessTokensRestApiCest::requestAccessTokenWithEmptyPassword. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_access_token_with_empty_type | drop | Glue already asserts POST /access-tokens -> 400 in AccessTokensRestApiCest::requestAccessTokenWithInvalidPostData. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_access_token_with_invalid_email | drop | Glue already asserts POST /access-tokens -> 401 in AccessTokensContentTypeCest::postWithoutContentTypeIsAccepted. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_access_token_with_invalid_password | drop | Glue already asserts POST /access-tokens -> 401 in AccessTokensContentTypeCest::postWithoutContentTypeIsAccepted. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_access_token_with_invalid_type | drop | Glue already asserts POST /access-tokens -> 400 in AccessTokensRestApiCest::requestAccessTokenWithInvalidPostData. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_acess_token_with_empty_email | drop | Glue already asserts POST /access-tokens -> 422 in AccessTokensRestApiCest::requestAccessTokenWithEmptyPassword. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_acess_token_with_empty_password | drop | Glue already asserts POST /access-tokens -> 422 in AccessTokensRestApiCest::requestAccessTokenWithEmptyPassword. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_acess_token_with_empty_type | drop | Glue already asserts POST /access-tokens -> 400 in AccessTokensRestApiCest::requestAccessTokenWithInvalidPostData. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_acess_token_with_invalid_email | drop | Glue already asserts POST /access-tokens -> 401 in AccessTokensContentTypeCest::postWithoutContentTypeIsAccepted. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_acess_token_with_invalid_password | drop | Glue already asserts POST /access-tokens -> 401 in AccessTokensContentTypeCest::postWithoutContentTypeIsAccepted. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_acess_token_with_invalid_type | drop | Glue already asserts POST /access-tokens -> 400 in AccessTokensRestApiCest::requestAccessTokenWithInvalidPostData. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_access_token_for_customer | drop | Glue already asserts POST /access-tokens -> 201 in AccessTokensForCompanyUserRestApiCest::requestAccessTokenForExistingCustomerWithoutCompanyUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Delete_refresh_token_for_another_user | drop | Glue already asserts POST /refresh-tokens -> 201 in RefreshTokensRestApiCest::requestRefreshTokenWithValidRefreshTokenValue. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Delete_refresh_token_with_missing_refresh_token | drop | Glue already asserts POST /refresh-tokens -> 400 in RefreshTokensRestApiCest::requestRefreshTokenWithInvalidPostData. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Delete_refresh_token_with_no_access_token | drop | Glue already asserts POST /refresh-tokens -> 201 in RefreshTokensRestApiCest::requestRefreshTokenWithValidRefreshTokenValue. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Refresh_token_with_deleted_refresh_token | drop | Glue already asserts POST /refresh-tokens -> 201 in RefreshTokensRestApiCest::requestRefreshTokenWithValidRefreshTokenValue. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Refresh_token_with_invalid_type | drop | Glue already asserts POST /access-tokens -> 201 in AccessTokensForCompanyUserRestApiCest::requestAccessTokenForExistingCustomerWithoutCompanyUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |

#### UNDECIDED — no verdict yet
| Scenario | Contract | Eff |
|---|---|---|
| Get_token_for_customer_with_invalid_grant_type | — | S |
| Get_token_using_refresh_token_for_customer_with_invalid_grant_type | — | S |
| Get_token_for_customer_with_invalid_client_type | — | S |
| Get_token_for_customer_with_invalid_email | — | S |
| Get_token_for_customer_with_invalid_password | — | S |
| Get_token_for_customer_with_missing_email | — | S |
| Get_token_for_customer_with_missing_grant_type | — | S |
| Get_token_for_customer_with_missing_password | — | S |
| Get_token_using_refresh_token_for_customer_with_invalid_client_type | — | S |
| Get_token_using_refresh_token_for_customer_with_invalid_refresh_token | — | S |
| Get_token_using_refresh_token_for_customer_with_missing_grant_type | — | S |
| Get_token_using_refresh_token_for_customer_with_missing_refresh_token | — | S |
| Get_token_for_customer | — | S |
| Get_token_using_refresh_token_for_customer | — | S |
