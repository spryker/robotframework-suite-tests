### content · robot-api-to-codeception · 19 scenarios

MIGRATE 19   ▸ 0/19 ported

Batches: `content`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Get_cms_page_list_by_wrong_id | b2c | `GET /cms-pages/$` → 404 | — | S | — |
| [ ] | Get_cms_page_list_by_fake_id | ×5 | `GET /cms-pages/$` → 404 | — | S | — |
| [ ] | Get_cms_page_list_by_wrond_id | ×4 | `GET /cms-pages/$` → 404 | — | S | — |
| [ ] | Get_cms_pages_list | ×5 | `GET /cms-pages?page[limit]=10&page[offset]=0` → 200 | — | S | — |
| [ ] | Get_cms_pages_with_Pagination | suite | `GET /cms-pages/$` → 200 | — | S | — |
| [ ] | Get_specific_cms_page | ×5 | `GET /cms-pages/$` → 200 | — | S | — |
| [ ] | Get_specific_cms_with_includes | ×5 | `GET /cms-pages/$` → 200 | — | S | — |
| [ ] | Get_banner_with_invalid_content_id | ×5 | `GET /content-banners/fake` → 404 | — | S | — |
| [ ] | Get_banner_with_wrong_content_id_type | ×5 | `GET /content-banners/fake` → 422 | — | S | — |
| [ ] | Get_banner_without_id | ×5 | `GET /content-banners/fake` → 400 | — | S | — |
| [ ] | Get_banner | ×5 | `GET /content-banners/$` → 200 | — | S | — |
| [ ] | Get_abstract_product_list_by_fake_id | ×5 | `GET /content-product-abstract-lists/abstract-products` → 404 | — | S | — |
| [ ] | Get_abstract_product_list_products_by_fake_id | ×5 | `GET /content-product-abstract-lists/abstract-products` → 404 | — | S | — |
| [ ] | Get_abstract_product_list_products_with_missing_id | ×5 | `GET /content-product-abstract-lists/abstract-products` → 400 | — | S | — |
| [ ] | Get_abstract_product_list_products_with_no_id | ×5 | `GET /content-product-abstract-lists/abstract-products` → 404 | — | S | — |
| [ ] | Get_abstract_product_list_with_no_id | ×5 | `GET /content-product-abstract-lists/abstract-products` → 400 | — | S | — |
| [ ] | Abstract_product_list | ×5 | `GET /content-product-abstract-lists/$` → 200 | — | S | — |
| [ ] | Abstract_product_list_abstract_products | ×5 | `GET /content-product-abstract-lists/$` → 200 | — | S | — |
| [ ] | Abstract_product_list_with_include | ×5 | `GET /content-product-abstract-lists/$` → 200 | — | S | — |
