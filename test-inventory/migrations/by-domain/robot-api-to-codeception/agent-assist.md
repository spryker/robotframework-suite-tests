### agent-assist · robot-api-to-codeception · 43 scenarios

MIGRATE 21 · REVIEW 22   ▸ 0/21 verified

Batches: `agent-assist-1`, `agent-assist-2`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Agent_searches_for_customers_with_no_token | ×3 | `GET /agent-customer-search` → 401 | — | S | — |
| [ ] | Agent_can_get_search_for_customers_by_substring_and_not_find_any | ×3 | `GET /agent-customer-search?page[offset]=30&page[limit]=10` → 201 | — | S | — |
| [ ] | Agent_can_get_search_for_customers_with_larger_page_size | ×3 | `GET /agent-customer-search?page[offset]=30&page[limit]=10` → 201 | — | S | — |
| [ ] | Get_access_token_by_invalid_data_type | ×2 | `POST /agent-access-tokens` → 400 | — | S | — |
| [ ] | Get_agent_token_with_wrong_type | ×3 | `POST /agent-access-tokens` → 400 | — | S | — |
| [ ] | Agent_cannot_impersonate_customer_with_empty_customer_reference | ×5 | `POST /agent-customer-impersonation-access-tokens` → 201 | — | S | — |
| [ ] | Agent_cannot_impersonate_customer_with_invalid_customer_reference | ×5 | `POST /agent-customer-impersonation-access-tokens` → 201 | — | S | — |
| [ ] | Agent_cannot_impersonate_customer_with_invalid_token | ×5 | `POST /agent-customer-impersonation-access-` → 401 | — | S | — |
| [ ] | Agent_cannot_impersonate_customer_with_missing_customer_reference | ×5 | `POST /agent-customer-impersonation-access-tokens` → 201 | — | S | — |
| [ ] | Agent_cannot_impersonate_customer_with_wrong_token_type | ×5 | `POST /agent-customer-impersonation-access-tokens` → 401 | — | M | — |
| [ ] | Agent_cannot_impersonate_customer_with_wrong_type | ×5 | `POST /agent-customer-impersonation-access-tokens` → 201 | — | S | — |
| [ ] | Agent_can_get_customer_impersonation_token | ×5 | `GET /carts/$` → 201 | — | S | — |
| [ ] | Customer_impersonation_token_can_be_used | ×3 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Agent_can't_get_search_for_customers_without_token | ×2 | `GET /agent-customer-search` → 401 | — | S | — |
| [ ] | Agent_searches_for_customers_with_customer_token | ×4 | `GET /agent-customer-search` → 401 | — | M | — |
| [ ] | Not_agent_can't_get_search_for_customers | ×2 | `GET /agent-customer-search` → 401 | — | S | — |
| [ ] | Agent_can_get_search_for_customers_by_email | ×5 | `GET /agent-customer-search?q=$` → 201 | — | S | — |
| [ ] | Agent_can_get_search_for_customers_by_first_name | ×5 | `GET /agent-customer-search?page[offset]=0&page[limit]=20` → 201 | — | S | — |
| [ ] | Agent_can_get_search_for_customers_by_incorrect_keyword | ×2 | `GET /agent-customer-search?page[offset]=30&page[limit]=10` → 201 | — | S | — |
| [ ] | Agent_can_get_search_for_customers_from_last_page | ×4 | `GET /agent-customer-search?page[offset]=30&page[limit]=10` → 201 | — | S | — |
| [ ] | Agent_can_get_search_for_customers_with_changed_page_limit | ×2 | `GET /agent-customer-search?q=mar` → 201 | — | S | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Get_agent_access_token_by_empty_email_and_valid_password | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_access_token_by_invalid_email_and_invalid_password | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_access_token_by_invalid_email_and_valid_password | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_access_token_by_non_agent.email_and_password | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_access_token_by_vaild_email_and_invalid_password | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_access_token_by_valid_email_and_empty_password | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_access_token_by_wrong_email_format | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_access_tokens | drop | Glue already asserts POST /agent-access-tokens -> 201 in AgentAccessTokensRestApiCest::requestAccessTokenForExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_access_token_by_non_agent_email_and_password | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_access_token_by_empty_email_and_empty_password | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_access_token_by_non_existent_user | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_access_token_with_blank_spaces | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_token_for_user_who_is_not_agent | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_token_with_empty_email | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_token_with_empty_password | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_token_with_invalid_password | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_agent_token_with_non-existent_email | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Agent_can_get_access_token | drop | Glue already asserts POST /agent-access-tokens -> 201 in AgentAccessTokensRestApiCest::requestAccessTokenForExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Agent_cannot_impersonate_customer_with_no_agent_token | drop | Glue already asserts POST /agent-access-tokens -> 401 in AgentAccessTokensRestApiCest::requestAccessTokenForNonExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Agent_can_get_search_for_customers_by_last_name | drop | Glue already asserts POST /agent-access-tokens -> 201 in AgentAccessTokensRestApiCest::requestAccessTokenForExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Agent_can_get_search_for_customers_by_substring | drop | Glue already asserts POST /agent-access-tokens -> 201 in AgentAccessTokensRestApiCest::requestAccessTokenForExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Agent_can_get_search_for_customers_without_search_parameters | drop | Glue already asserts POST /agent-access-tokens -> 201 in AgentAccessTokensRestApiCest::requestAccessTokenForExistingAgentUser. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
