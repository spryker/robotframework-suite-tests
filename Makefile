# Set default if not defined or if it's empty
ifeq ($(strip $(ignore_console)),)
ignore_console := True
endif

.PHONY: test_api_b2b test_api_b2c test_api_mp_b2c test_api_mp_b2b test_api_suite test_ui_b2b test_ui_b2c test_ui_mp_b2c test_ui_mp_b2b test_ui_suite

ENV_API_B2B := api_b2b
ENV_API_B2C := api_b2c
ENV_API_MP_B2C := api_mp_b2c
ENV_API_MP_B2B := api_mp_b2b
ENV_API_SUITE := api_suite
ENV_UI_B2B := ui_b2b
ENV_UI_B2C := ui_b2c
ENV_UI_MP_B2C := ui_mp_b2c
ENV_UI_MP_B2B := ui_mp_b2b
ENV_UI_SUITE := ui_suite

test_api_b2b:
	robot -v env:$(ENV_API_B2B) -v glue_env:${glue_env} -v bapi_env:${bapi_env} -v sapi_env:${sapi_env} -v docker:${docker} -v ignore_console:${ignore_console} -v project_location:${project_location} --exclude skip-due-to-issueORskip-due-to-refactoring -d results -s '*'.tests.api.b2b .

test_api_b2c:
	robot -v env:$(ENV_API_B2C) -v glue_env:${glue_env} -v bapi_env:${bapi_env} -v sapi_env:${sapi_env} -v docker:${docker} -v ignore_console:${ignore_console} -v project_location:${project_location} --exclude skip-due-to-issueORskip-due-to-refactoring -d results -s '*'.tests.api.b2c .

test_api_mp_b2c:
	robot -v env:$(ENV_API_MP_B2C) -v glue_env:${glue_env} -v bapi_env:${bapi_env} -v sapi_env:${sapi_env} -v docker:${docker} -v ignore_console:${ignore_console} -v project_location:${project_location} --exclude skip-due-to-issueORskip-due-to-refactoring -d results -s '*'.tests.api.mp_b2c .

test_api_mp_b2b:
	robot -v env:$(ENV_API_MP_B2B) -v glue_env:${glue_env} -v bapi_env:${bapi_env} -v sapi_env:${sapi_env} -v docker:${docker} -v ignore_console:${ignore_console} -v project_location:${project_location} --exclude skip-due-to-issueORskip-due-to-refactoring -d results -s '*'.tests.api.mp_b2b .

test_api_suite:
	robot -v env:$(ENV_API_SUITE) -v glue_env:${glue_env} -v bapi_env:${bapi_env} -v sapi_env:${sapi_env} -v docker:${docker} -v ignore_console:${ignore_console} -v project_location:${project_location} --exclude skip-due-to-issueORskip-due-to-refactoring -d results -s '*'.tests.api.suite .

test_ui_b2b:
	robot -v env:$(ENV_UI_B2B) -v glue_env:${glue_env} -v bapi_env:${bapi_env} -v yves_env:${yves_env} -v yves_at_env:${yves_at_env} -v zed_env:${zed_env} -v mp_env:${mp_env} -v docker:${docker} -v ignore_console:${ignore_console} -v project_location:${project_location} --exclude skip-due-to-issueORskip-due-to-refactoring -d results -s '*'.tests.ui.b2b .

test_ui_b2c:
	robot -v env:$(ENV_UI_B2C) -v glue_env:${glue_env} -v bapi_env:${bapi_env} -v yves_env:${yves_env} -v yves_at_env:${yves_at_env} -v zed_env:${zed_env} -v mp_env:${mp_env} -v docker:${docker} -v ignore_console:${ignore_console} -v project_location:${project_location} --exclude skip-due-to-issueORskip-due-to-refactoring -d results -s '*'.tests.ui.b2c .

test_ui_mp_b2c:
	robot -v env:$(ENV_UI_MP_B2C) -v glue_env:${glue_env} -v bapi_env:${bapi_env} -v yves_env:${yves_env} -v yves_at_env:${yves_at_env} -v zed_env:${zed_env} -v mp_env:${mp_env} -v docker:${docker} -v ignore_console:${ignore_console} -v project_location:${project_location} --exclude skip-due-to-issueORskip-due-to-refactoring -d results -s '*'.tests.ui.mp_b2c .

test_ui_mp_b2b:
	robot -v env:$(ENV_UI_MP_B2B) -v glue_env:${glue_env} -v bapi_env:${bapi_env} -v yves_env:${yves_env} -v yves_at_env:${yves_at_env} -v zed_env:${zed_env} -v mp_env:${mp_env} -v docker:${docker} -v ignore_console:${ignore_console} -v project_location:${project_location} --exclude skip-due-to-issueORskip-due-to-refactoring -d results -s '*'.tests.ui.mp_b2b .

test_ui_suite:
	robot -v env:$(ENV_UI_SUITE) -v glue_env:${glue_env} -v bapi_env:${bapi_env} -v yves_env:${yves_env} -v yves_at_env:${yves_at_env} -v zed_env:${zed_env} -v mp_env:${mp_env} -v docker:${docker} -v ignore_console:${ignore_console} -v project_location:${project_location} --exclude skip-due-to-issueORskip-due-to-refactoring -d results -s '*'.tests.ui.suite .
