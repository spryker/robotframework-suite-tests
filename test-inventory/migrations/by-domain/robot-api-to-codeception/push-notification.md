### push-notification · robot-api-to-codeception · 24 scenarios

MIGRATE 24   ▸ 0/24 verified

Batches: `push-notification`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Delete_push_notification_provider_while_push_notification_subscribtion_exists | b2c | `DELETE /push-notification-providers/$` → 201 | — | S | — |
| [ ] | Create_push_notification_provider_with_256_characters_in_the_name | ×3 | `POST /push-notification-providers` → 400 | — | S | — |
| [ ] | Create_push_notification_provider_with_invalid_type | ×3 | `POST /push-notification-providers` → 400 | — | S | — |
| [ ] | Create_push_notification_provider_without_authorization | ×3 | `PATCH /push-notification-providers/$` → 401 | — | S | — |
| [ ] | Create_push_notification_provider_without_name | ×3 | `POST /push-notification-providers` → 400 | — | S | — |
| [ ] | Create_two_push_notification_providers_with_same_name | ×3 | `DELETE /push-notification-providers/$` → 201 | — | S | — |
| [ ] | Delete_push_notification_provider_with_not_exist_id | ×3 | `DELETE /push-notification-providers/invalid` → 404 | — | S | — |
| [ ] | Retrieve_non-existent_push_notification_provider | ×3 | `POST /push-notification-providers` → 404 | — | S | — |
| [ ] | Retrieve_push_notification_providers_with_incorrect_token | ×3 | `POST /push-notifi` → 401 | — | S | — |
| [ ] | Retrieve_push_notification_providers_without_authorization | ×3 | `DELETE /push-notificatio` → 401 | — | S | — |
| [ ] | Update_non-existent_push_notification_provider | ×3 | `DELETE /push-notification-providers/invalid` → 404 | — | S | — |
| [ ] | Update_push_notification_provider_with_incorrect_auth | ×3 | `DELETE /push-notification-providers/invalid` → 401 | — | S | — |
| [ ] | Update_push_notification_provider_without_name | ×3 | `DELETE /push-notification-provide` → 400 | — | S | — |
| [ ] | Create_push_notification_provider | ×3 | `POST /push-` → 201 | — | S | — |
| [ ] | Create_push_notification_provider_with_255_characters_in_the_name | ×3 | `GET /push-notification-providers` → 201 | — | S | — |
| [ ] | Delete_push_notification_provider_while_push_notification_subscription_exists | ×2 | `DELETE /push-notification-providers/$` → 201 | — | S | — |
| [ ] | Retrieve_push_notification_provider_by_id | ×3 | `DELETE /push-notificati` → 201 | — | S | — |
| [ ] | Retrieve_push_notification_provider_with_pagination | ×3 | `GET /push-notification-providers/$` → 200 | — | S | — |
| [ ] | Retrieve_push_notification_provider_with_sorting | ×3 | `POST /push-notification-subscriptions` → 200 | — | S | — |
| [ ] | Retrieve_push_notification_providers | ×3 | `POST /push-notification-providers` → 200 | — | S | — |
| [ ] | Update_push_notification_provider | ×3 | `GET /push-notification-providers?page[offset]=1&page` → 200 | — | S | — |
| [ ] | Creates_push_notification_subscription_with_incorrect_locale | ×3 | `POST /push-notification-subscriptions` → 400 | — | S | — |
| [ ] | Creates_push_notification_subscription_with_correct_locale | ×3 | `POST /push-notification-subscriptions` → 201 | — | S | — |
| [ ] | Creates_push_notification_subscription_without_locale | ×3 | `POST /push-notification-subscriptions` → 201 | — | S | — |
