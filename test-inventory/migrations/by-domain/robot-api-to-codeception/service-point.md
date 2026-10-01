### service-point · robot-api-to-codeception · 116 scenarios

MIGRATE 103 · REVIEW 12 · UNDECIDED 1   ▸ 0/103 verified

Batches: `service-point-1`, `service-point-2`, `service-point-3`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Update_Service_Point_Address_Without_Authentication | ×2 | `PATCH /service-points/$` → 403 | — | S | — |
| [ ] | Retrieves_a_service_point_address_by_existing_service_point_and_not_existing_service_point_address_ids | mp_b2c | `GET /service-point/$` → 404 | — | S | — |
| [ ] | Retrieves_a_service_point_address_by_incorrect_url | mp_b2c | `GET /service-point/$` → 404 | — | S | — |
| [ ] | Retrieves_a_service_point_address_by_not_existing_service_point_and_existing_service_point_address_ids | mp_b2c | `GET /service-point/$` → 404 | — | S | — |
| [ ] | Retrieves_a_service_point_address_by_not_existing_service_point_and_service_point_address_ids | mp_b2c | `GET /service-point/$` → 404 | — | S | — |
| [ ] | Retrieves_list_of_service_point_addresses | mp_b2c | `GET /service-point/$` → 404 | — | S | — |
| [ ] | Retrieves_a_service_point_address_by_id | mp_b2c | `GET /service-points/$` → 200 | — | S | — |
| [ ] | Retrieves_a_service_point_by_incorrect_url | mp_b2c | `GET /service-points/NonExistId` → 404 | — | S | — |
| [ ] | Retrieves_a_service_point_by_not_existing_id | mp_b2c | `GET /service-points/NonExistId` → 404 | — | S | — |
| [ ] | Retrieves_list_of_service_points_by_incorrect_url | mp_b2c | `GET /service-points/NonExistId` → 404 | — | S | — |
| [ ] | Retrieves_a_service_point_by_id | mp_b2c | `GET /service-points/$` → 200 | — | S | — |
| [ ] | Retrieves_a_service_point_by_id_with_address_relation | mp_b2c | `GET /service-points/$` → 200 | — | S | — |
| [ ] | Retrieves_a_service_point_by_id_with_empty_address_relation | mp_b2c | `GET /service-points/$` → 200 | — | S | — |
| [ ] | Retrieves_list_of_service_points_with_addresses_relations | mp_b2c | `GET /service-points/$` → 200 | — | S | — |
| [ ] | Create_Duplicate_Service_Point_Address | ×2 | `POST /service-points` → 400 | — | S | — |
| [ ] | Create_Service_Point_Address_With_Incorrect_Token | ×2 | `POST /service-points/$` → 401 | — | S | — |
| [ ] | Create_Service_Point_Address_Without_Authentication | ×2 | `POST /service-points` → 401 | — | S | — |
| [ ] | Create_Service_Point_address_with_empty_address | ×2 | `POST /service-points` → 400 | — | S | — |
| [ ] | Create_Service_Point_address_with_not_existing_country | ×2 | `PATCH /service-points/$` → 201 | — | S | — |
| [ ] | Create_Service_Point_address_with_not_existing_region | ×2 | `POST /service-points/$` → 201 | — | S | — |
| [ ] | Create_Service_Point_address_without_address | ×2 | `POST /service-points/$` → 400 | — | S | — |
| [ ] | Read_Service_Point_Address_No_Authentication | ×2 | `GET /service-points/$` → 401 | — | S | — |
| [ ] | Retrieve_address_for_Nonexistent_Service_Point | ×2 | `GET /service-points/$` → 404 | — | S | — |
| [ ] | Update_Nonexistent_Service_Point_Address | ×2 | `GET /service-points/NonexistentID/service-point-addresses` → 400 | — | S | — |
| [ ] | Update_Service_Point_Address_Empty_Zip_Code | ×2 | `GET /service-points/$` → 400 | — | S | — |
| [ ] | Update_Service_Point_Address_Invalid_Content_Type | ×2 | `GET /service-points/$` → 404 | — | S | — |
| [ ] | Update_Service_Point_Address_Invalid_Region | ×2 | `GET /service-points/$` → 400 | — | S | — |
| [ ] | Update_Service_Point_Address_Nonexistent_Service_Point | ×2 | `GET /service-points/$` → 404 | — | S | — |
| [ ] | Update_Service_Point_Address_With_Incorrect_Token | ×2 | `PATCH /service-points/$` → 401 | — | S | — |
| [ ] | Create_Service_Point_Address | ×2 | `POST /service-points/$` → 201 | — | S | — |
| [ ] | Create_Service_Point_Address_with_address_3 | ×2 | `PATCH /service-points/$` → 201 | — | S | — |
| [ ] | Create_Service_Point_Address_with_region_uuid | ×2 | `PATCH /service-points/$` → 201 | — | S | — |
| [ ] | Retrieve_Service_Point_Address | ×2 | `GET /service-points/$` → 200 | — | S | — |
| [ ] | Update_Service_Point_Address | ×2 | `GET /service-points/$` → 201 | — | S | — |
| [ ] | Create_Service_Point_With_Empty_Body | suite | `PATCH /service-points/random-id` → 400 | — | S | — |
| [ ] | Create_Service_Point_With_Empty_Key | suite | `POST /service-points` → 400 | — | S | — |
| [ ] | Create_Service_Point_With_Empty_Name | suite | `POST /service-points` → 400 | — | S | — |
| [ ] | Create_Service_Point_With_Existing_Key | suite | `POST /service-points` → 201 | — | S | — |
| [ ] | Create_Service_Point_With_Invalid_Content_Type | suite | `PATCH /service-points/nonexistent-id` → 400 | — | S | — |
| [ ] | Create_Service_Point_With_Invalid_Key_Length | suite | `POST /service-points` → 400 | — | S | — |
| [ ] | Create_Service_Point_With_Invalid_Store | suite | `PATCH /service-points/$` → 400 | — | S | — |
| [ ] | Create_Service_Point_With_Invalid_Token | suite | `POST /service-points` → 401 | — | S | — |
| [ ] | Create_Service_Point_With_Missing_Required_Fields | suite | `PATCH /ser` → 400 | — | S | — |
| [ ] | Create_Service_Point_Without_Authorization | suite | `POST /service-points` → 401 | — | S | — |
| [ ] | Get_Service_Point_By_Nonexistent_ID | suite | `GET /service-points/NonexistentID` → 404 | — | S | — |
| [ ] | Get_Service_Points_With_Incorrect_Token | suite | `GET /service-points/NonexistentID` → 401 | — | S | — |
| [ ] | Get_Service_Points_Without_Authentication | suite | `GET /service-points/NonexistentID` → 401 | — | S | — |
| [ ] | Update_Service_Point_With_Empty_Name | suite | `GET /service-points/NonexistentID` → 400 | — | S | — |
| [ ] | Update_Service_Point_With_Nonexistent_ID | suite | `GET /service-points` → 404 | — | S | — |
| [ ] | Update_Service_Point_With_Wrong_type | suite | `PATCH /service-points/$` → 400 | — | S | — |
| [ ] | Update_Service_Point_With_incorrect_token | suite | `GET /service-points/NonexistentID` → 401 | — | S | — |
| [ ] | Update_Service_Point_With_not_existing_key | suite | `GET /service-points/NonexistentID` → 200 | — | S | — |
| [ ] | Update_Service_Point_Without_Authorization | suite | `POST /service-points` → 401 | — | S | — |
| [ ] | Create_Service_Point_With_Valid_Key_Length | suite | `GET /service-points/$` → 201 | — | S | — |
| [ ] | Create_new_service_point | suite | `POST /service-points` → 201 | — | S | — |
| [ ] | Create_new_service_point_with_existing_name | suite | `PATCH /service-points/$` → 201 | — | S | — |
| [ ] | Get_All_Service_Points | ×2 | `POST /service-points` → 200 | — | S | — |
| [ ] | Get_Service_Point_By_ID | suite | `GET /service-points/$` → 201 | — | S | — |
| [ ] | Update_Service_Point | suite | `GET /service-points/$` → 200 | — | S | — |
| [ ] | Create_Duplicate_Service_Type_Key | ×2 | `PATCH /service-types/update-service-type-key$` → 400 | — | S | — |
| [ ] | Create_Service_Type_With_256_Length_Name | ×2 | `POST /service-types` → 400 | — | S | — |
| [ ] | Create_Service_Type_With_Duplicate_Name | ×2 | `PATCH /service-types/not-existing-service-type` → 400 | — | S | — |
| [ ] | Create_Service_Type_With_Empty_Key | ×2 | `PATCH /service-types/serv-ty$` → 400 | — | S | — |
| [ ] | Create_Service_Type_With_Empty_Name | ×2 | `PATCH /service-types/12345678$` → 400 | — | S | — |
| [ ] | Create_Service_Type_With_Maximum_Length_Key | ×2 | `POST /service-types` → 400 | — | S | — |
| [ ] | Create_Service_Type_with_incorrect_Auth | ×2 | `GET /service-types/service-by-id$` → 401 | — | S | — |
| [ ] | Create_Service_Type_without_Auth | ×2 | `GET /service-types` → 401 | — | S | — |
| [ ] | Get_Nonexistent_Service_Type | ×2 | `GET /service-types/nonexistent_id` → 404 | — | S | — |
| [ ] | Get_Service_Type_By_ID_No_Auth | ×2 | `GET /service-types/nonexistent_id` → 401 | — | S | — |
| [ ] | Get_Service_Type_By_ID_invalid_Auth | ×2 | `GET /service-types/nonexistent_id` → 401 | — | S | — |
| [ ] | Get_Service_Types_Invalid_Auth | ×2 | `GET /service-types/nonexistent_id` → 401 | — | S | — |
| [ ] | Get_Service_Types_No_Auth | ×2 | `GET /service-types/nonexistent_id` → 401 | — | S | — |
| [ ] | Update_Not_Existing_Service_Type | ×2 | `GET /service-types/nonexistent_id` → 404 | — | S | — |
| [ ] | Update_Service_Type_Key | ×2 | `GET /service-types/service-by-id$` → 400 | — | S | — |
| [ ] | Update_Service_Type_with_incorrect_type | ×2 | `GET /service-types/nonexistent_id` → 400 | — | S | — |
| [ ] | Update_Service_Type_without_Auth | ×2 | `GET /service-types/nonexistent_id` → 401 | — | S | — |
| [ ] | Create_Service_Type | ×2 | `GET /service-types/$` → 201 | — | S | — |
| [ ] | Get_Service_Type_by_id | ×2 | `GET /service-types/$` → 201 | — | S | — |
| [ ] | Get_Service_Types_List | ×2 | `GET /service-types/$` → 200 | — | S | — |
| [ ] | Update_Service_Type | ×2 | `GET /service-types/$` → 201 | — | S | — |
| [ ] | Create_Duplicate_Service_Point_Service_Relation | ×2 | `POST /services` → 201 | — | S | — |
| [ ] | Create_Service_Invalid_Auth | ×2 | `POST /services` → 401 | — | S | — |
| [ ] | Create_Service_No_Auth | ×2 | `POST /service-points` → 404 | — | S | — |
| [ ] | Get_Nonexistent_Service | ×2 | `POST /services` → 400 | — | S | — |
| [ ] | Get_Service_By_ID__No_Auth | ×2 | `POST /services` → 404 | — | S | — |
| [ ] | Get_Services_No_Auth | ×2 | `POST /services` → 404 | — | S | — |
| [ ] | Create_Service | ×2 | `PATCH /services/$` → 201 | — | S | — |
| [ ] | Get_Service_By_ID | ×2 | `GET /services/$` → 201 | — | S | — |
| [ ] | Get_Services_List | ×2 | `POST /service-types` → 200 | — | S | — |
| [ ] | Update_Service | ×2 | `GET /services/$` → 201 | — | S | — |
| [ ] | Retrieves_a_service_point_address_by_existing_service_point_and_not_existing_service_point_address_ids | suite | `GET /service-point/$` → 404 | — | S | — |
| [ ] | Retrieves_a_service_point_address_by_incorrect_url | suite | `GET /service-point/$` → 404 | — | S | — |
| [ ] | Retrieves_a_service_point_address_by_not_existing_service_point_and_existing_service_point_address_ids | suite | `GET /service-point/$` → 404 | — | S | — |
| [ ] | Retrieves_a_service_point_address_by_not_existing_service_point_and_service_point_address_ids | suite | `GET /service-point/$` → 404 | — | S | — |
| [ ] | Retrieves_list_of_service_point_addresses_by_wrong_url | suite | `GET /service-point/$` → 404 | — | S | — |
| [ ] | Retrieves_a_service_point_address_by_id | suite | `GET /service-points/$` → 200 | — | S | — |
| [ ] | Retrieves_a_service_point_by_incorrect_url | suite | `GET /service-points/NonExistId` → 404 | — | S | — |
| [ ] | Retrieves_a_service_point_by_not_existing_id | suite | `GET /service-points/NonExistId` → 404 | — | S | — |
| [ ] | Retrieves_list_of_service_points_by_incorrect_url | suite | `GET /service-points/NonExistId` → 404 | — | S | — |
| [ ] | Retrieves_a_service_point_by_id | suite | `GET /service-points/$` → 200 | — | S | — |
| [ ] | Retrieves_a_service_point_by_id_with_address_relation | suite | `GET /service-points/$` → 200 | — | S | — |
| [ ] | Retrieves_a_service_point_by_id_with_empty_address_relation | suite | `GET /service-points/$` → 200 | — | S | — |
| [ ] | Retrieves_list_of_service_points_with_addresses_relations | suite | `GET /service-points/$` → 200 | — | S | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Retrieves_list_of_service_points | drop | Glue already asserts GET /service-points -> 200 in BackofficeUserScopeAuthorizeBackendApiCest::requestServicePointsForBackofficeUserAllowed. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieves_list_of_service_points_filtered_by_address_line_1_using_full_text_search | drop | Glue already asserts GET /service-points -> 200 in BackofficeUserScopeAuthorizeBackendApiCest::requestServicePointsForBackofficeUserAllowed. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieves_list_of_service_points_filtered_by_name_using_full_text_search | drop | Glue already asserts GET /service-points -> 200 in BackofficeUserScopeAuthorizeBackendApiCest::requestServicePointsForBackofficeUserAllowed. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieves_list_of_service_points_filtered_by_service_type_key | drop | Glue already asserts GET /service-points -> 200 in BackofficeUserScopeAuthorizeBackendApiCest::requestServicePointsForBackofficeUserAllowed. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieves_list_of_service_points_sort_by_city_asc | drop | Glue already asserts GET /service-points -> 200 in BackofficeUserScopeAuthorizeBackendApiCest::requestServicePointsForBackofficeUserAllowed. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieves_list_of_service_points_sort_by_city_desc | drop | Glue already asserts GET /service-points -> 200 in BackofficeUserScopeAuthorizeBackendApiCest::requestServicePointsForBackofficeUserAllowed. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieves_list_of_service_points | drop | Glue already asserts GET /service-points -> 200 in BackofficeUserScopeAuthorizeBackendApiCest::requestServicePointsForBackofficeUserAllowed. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieves_list_of_service_points_filtered_by_address_line_1_using_full_text_search | drop | Glue already asserts GET /service-points -> 200 in BackofficeUserScopeAuthorizeBackendApiCest::requestServicePointsForBackofficeUserAllowed. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieves_list_of_service_points_filtered_by_name_using_full_text_search | drop | Glue already asserts GET /service-points -> 200 in BackofficeUserScopeAuthorizeBackendApiCest::requestServicePointsForBackofficeUserAllowed. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieves_list_of_service_points_filtered_by_service_type_key | drop | Glue already asserts GET /service-points -> 200 in BackofficeUserScopeAuthorizeBackendApiCest::requestServicePointsForBackofficeUserAllowed. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieves_list_of_service_points_sort_by_city_asc | drop | Glue already asserts GET /service-points -> 200 in BackofficeUserScopeAuthorizeBackendApiCest::requestServicePointsForBackofficeUserAllowed. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieves_list_of_service_points_sort_by_city_desc | drop | Glue already asserts GET /service-points -> 200 in BackofficeUserScopeAuthorizeBackendApiCest::requestServicePointsForBackofficeUserAllowed. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |

#### UNDECIDED — no verdict yet
| Scenario | Contract | Eff |
|---|---|---|
| Delete_all_non-default_service_points_from_DB_with_p&s | — | S |
