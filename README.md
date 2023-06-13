## Description
This repository contains sets of API and UI tests, built on the Robot Framework. API tests use the RequestsLibrary in conjunction with Robot Framework, while UI tests rely on the Browser library (powered by Playwright). 

## Installation

### Prerequisites
[Robot Framework](https://robotframework.org/) is implemented using [Python](https://www.python.org/), and a precondition to install it is having Python or its alternative implementation [PyPy](https://www.pypy.org/) installed. Another recommended precondition is having the [pip](https://pip.pypa.io/en/stable/) package manager available.
Robot Framework requires Python 3.6 or newer.

1. Install [Robot Framework](https://github.com/robotframework/robotframework/blob/master/INSTALL.rst)
```sh
python3 -m pip install -U robotframework
```
2. Install [RequestsLibrary](https://github.com/MarketSquare/robotframework-requests)
```sh
python3 -m pip install -U robotframework-requests
```
3. Install [DatabaseLibrary](https://github.com/franz-see/Robotframework-Database-Library)
 ```sh
 python3 -m pip install -U robotframework-databaselibrary
 ```
4. Install Python SQL library, depending on your configuration
   * Engine: **MySQL**
   ```sh
    python3 -m pip install PyMySQL
    ```
   * Engine: **PostgreSQL**
    ```sh
    python3 -m pip install psycopg2-binary
    ```
### Installation for UI tests
##### For UI testing installation requires Robot Framework, [RequestsLibrary](https://github.com/MarketSquare/robotframework-requests), [DatabaseLibrary](https://github.com/franz-see/Robotframework-Database-Library) and [Browser library](https://robotframework-browser.org/) powered by Playwright. 
If you installed everything from the [prerequisites](#Prerequisites), all you need to install is Node.js and the Browser library.

1. Install [Node.js®](https://nodejs.org/en/download)
2. Install [Browser library](https://robotframework-browser.org/#installation)
```sh
python3 -m pip install -U robotframework-browser
```
3. Initialize the Browser library
```sh
rfbrowser init
```
### Installation for API tests

##### For API testing installation requires Robot Framework, [RequestsLibrary](https://github.com/MarketSquare/robotframework-requests), [JSONLibrary](https://github.com/robotframework-thailand/robotframework-jsonlibrary) and [DatabaseLibrary](https://github.com/franz-see/Robotframework-Database-Library).
If you installed everything from the [prerequisites](#Prerequisites), all you need to install is the JSONLibrary.

1. Install JSONLibrary
```sh
python3 -m pip install -U robotframework-jsonlibrary
```

### Automated installation

You can also run all of the installation steps in one go by executing the shell script `install.sh`.

## How to run tests
Robot Framework test cases are executed from the command line, and the end result is, by default, an output file in XML format and an HTML report and log. After the execution, output files can be combined and otherwise post-processed with the Rebot tool.

**Note**: If you prefer to run test using the default configuration of your local environment, you can navigate to the **[Helper](#Helper)** section

Synopsis
```
robot [options] data
python -m robot [options] data
python path/to/robot/ [options] data
```
Execution is normally started using the `robot` command created as part of installation. Alternatively it is possible to execute the installed robot module using the selected Python interpreter. This is especially convenient if Robot Framework has been installed under multiple Python versions. Finally, if you know where the installed robot directory exists, it can be executed using Python as well.

Regardless of execution approach, the path (or paths) to the test data to be executed is given as an argument after the command. Additionally, different [command line options](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#using-command-line-options) can be used to alter the test execution or generated outputs in many ways.

**Basic usage example:**
`robot -v env:{ENVIRONMENT} {PATH}`

### Supported CLI Parameters

| Parameter | Comment| Example | Required |
|:--- |:--- |:--- |:--- |
| `-v env:{env}` | Environment variable. Demo data, locators and hosts in tests depend on this variable value. **It's crucial to pass the env variable as tests fully depend on it.** Supported parameters are: `api_b2b`, `api_b2c`, `api_mp_b2b`, `api_mp_b2c`, `api_suite`, `ui_b2b`, `ui_b2c`, `ui_mp_b2b`, `ui_mp_b2c`, `ui_suite`| `robot -v env:api_b2b -s tests.api.b2b.glue .` / `robot -v env:ui_b2c tests/ui/e2e/b2c.robot`| **yes** |
| `-v db_engine:{engine}`| Depending on your system setup, you can run tests against MySQL or PostgreSQL. Possible values: `mysql` or `postgresql`. **Default:** `mysql`| `robot -v env:api_b2b -v db_engine:postgresql -s tests.api.b2b.glue .` | optional |
| `-v db_host:{host}`| Depending on your system setup, you can specify db_host if it differs from the default one. **Default:** `127.0.0.1`| `robot -v env:api_b2b -v db_host:127.2.3.4 -s tests.api.b2b.glue .` | optional |
| `-v db_port:{port}`| Depending on your system setup, you can specify db_port if it differs from the default one. **Default MariaDB:** `3306` / **Default PostgreSQL:** `5432`| `robot -v env:api_b2b -v db_port:3390 -s tests.api.b2b.glue .` | optional |
| `-v db_user:{user}`| Depending on your system setup, you can specify db_user if it differs from the default one. **Default:** `spryker`| `robot -v env:api_b2b -v db_user:fake_user -s tests.api.b2b.glue .` | optional |
| `-v db_password:{pwd}`| Depending on your system setup, you can specify db_password if it differs from the default one. **Default:** `secret`| `robot -v env:api_b2b -v db_password:fake_password -s tests.api.b2b.glue .` | optional |
| `-v db_name:{name}`| Depending on your system setup, you can specify db_name if it differs from the default one. **Default:** `eu-docker`| `robot -v env:api_b2b -v db_name:fake_name -s tests.api.b2b.glue .` | optional |
| `-d {PATH}` | Path to the folder to store the run report. Like `results` | `robot -v env:api_b2b -d results tests/.../example.robot`| optional |
| `-s test_suite_name` | Test suite name is the name of any subfolder in tests folder (without path) or filename (without extension). If specified, tests from that folder/file folder will be executed.| `robot -v env:api_b2b -s tests.api.b2b.glue .` / `robot -v env:api_mp_b2b -s tests.api.mp_b2b.glue .` | optional |
| `-v yves_env:{URL}` | You can specify Yves URL if you would like to run your tests on cloud environment| `robot -v env:ui_b2c -v yves_env:http://example.com tests/ui/e2e/b2c.robot`| optional |
| `-v yves_at_env:{URL}` | You can specify Yves AT store URL if you would like to run your tests on cloud environment| `robot -v env:ui_b2c -v yves_env:http://example.com -v yves_at_env:http://at.example.com tests/ui/e2e/b2c.robot`| optional |
| `-v zed_env:{URL}` | You can specify Zed URL if you would like to run your tests on cloud environment| `robot -v env:ui_b2c -v yves_env:http://example.com -v zed_env:http://bo.example.com tests/ui/e2e/b2c.robot`| optional |
| `-v glue_env:{URL}` | You can specify Glue URL if you would like to run your tests on cloud environment| `robot -v env:api_b2c -v glue_env:http://glue.example.com -s tests.api.b2c.glue .`| optional |
| `-v bapi_env:{URL}` | You can specify BAPI URL if you would like to run your tests on cloud environment| `robot -v env:api_b2c -v glue_env:http://glue.example.com -v bapi_env:http://bapi.example.com -s tests.api.b2c.bapi .`| optional |
| `-v mp_env:{URL}` | You can specify Merchant Portal URL if you would like to run your tests on cloud environment| `robot -v env:ui_mp_b2c -v yves_env:http://example.com -v zed_env:http://bo.example.com -v mp_env:http://mp.example.com tests/ui/e2e/mp_b2c.robot`| optional |
| `-v browser:{browser}`| Defines in which browser run tests. Possible values: `chromium`,`firefox`, `webkit`. **Default:** `chromium`| `robot -v env:ui_mp_b2c -v browser:firefox tests/ui/e2e/mp_b2c.robot` | For UI tests only. optional |
| `-v headless:{headless}` |Defines if the browser should be launched in the headless mode. Possible values: `true`,`false`. **Default:** `true`| `robot -v env:ui_mp_b2c -v headless:false tests/ui/e2e/mp_b2c.robot` | For UI tests only. optional |
| `-v browser_timeout:{timeout}` |Default time for Implicit wait in UI tests. **Default:** `60s`| `robot -v env:ui_mp_b2c -v browser_timeout:30s tests/ui/e2e/mp_b2c.robot` | For UI tests only. optional |
| `-v api_timeout:${timeout}` |Default time for Implicit wait of the response in API tests. **Default:** `60s`| `robot -v env:api_b2c -v api_timeout:30s -s tests.api.b2c.glue .` | For API tests only. optional |
| `-v verify_ssl:bool` |Enables/Disables SSL verification in API and UI tests **Default:** `false`| `robot -v env:api_b2c -v verify_ssl:true -s tests.api.b2c.glue .` | optional |
| `{PATH}` | Path to the **file** to execute| `robot -v env:api_b2b tests/api/b2b/glue/cart_endpoints/carts/positive.robot` / `robot -v env:ui_b2c tests/ui/e2e/b2c.robot`| **yes for UI tests** |

#### CLI Examples
* Execute all tests in api/b2b folder (all glue and bapi API tests that exist).
   ```sh
   robot -v env:api_b2b -d results -s tests.api.b2b .
   ```
* Execute all tests in a specific folder (all API tests that exist inside the folder and sub-folders).
   ```sh
   robot -v env:api_b2b -d results -s tests.api.b2b.glue.access_token_endpoints .
   ```
* Execute only positive tests in api folder (all positive API tests that exist, from all folders).
   ```sh
   robot -v env:api_suite -d results -s positive .
   ```
* Execute all positive and negative API tests in tests/api/suite/glue/abstract_product_endpoints folder. Subfolders (other endpoints) will be executed as well.
   ```sh
   robot -v env:api_suite -d results -s tests.api.suite.glue.abstract_product_endpoints .
   ```
* Execute all positive and negative API tests in tests/api/suite/glue/abstract_product_endpoints/abstract_products
   ```sh
   robot -v env:api_suite -d results -s tests.api.suite.glue.abstract_product_endpoints.abstract_products .
   ```
* Execute all E2E UI tests for MP-B2B on specific cloud environment.
   ```sh
   robot -v env:ui_mp_b2b -v yves_env:http://yves.example.com -v zed_env:http://zed.example.com -v mp_env:http://mp.example.com -d results tests/ui/e2e/mp_b2b.robot
   ```
* Execute all API tests for B2B on specific cloud environment with custom DB configuration.
   ```sh
   robot -v env:api_b2b -v db_engine:postgresql -v db_host:124.1.2.3 -v db_port:5336 -v db_user:fake_user -v db_password:fake_password -v db_name:fake_name -s tests.api.b2b.glue .
   ```
---
### [Supported Browsers in UI tests](https://marketsquare.github.io/robotframework-browser/Browser.html#SupportedBrowsers)
Since [Playwright](https://github.com/microsoft/playwright) comes with a pack of builtin binaries for all browsers, no additional drivers e.g. geckodriver are needed.

All these browsers that cover more than 85% of the world wide used browsers, can be tested on Windows, Linux and MacOS. Theres is not need for dedicated machines anymore.
| Browser  	|Browser with this engine|
|:--- |:--- |
|chromium| 	Google Chrome, Microsoft Edge (since 2020), Opera|
|firefox| 	Mozilla Firefox|
|webkit| 	Apple Safari, Mail, AppStore on MacOS and iOS|
---
### Helper
For local testing, all tests are commonly executed against default hosts. To avoid typos in execution commands, you can use the [Makefile](https://makefiletutorial.com/) helper to quickly start your runs. 
**Note:** no installation is required on macOS and Linux systems. The `make` command is included in most Linux distributions by default. 
To run Makefile on Windows, you need to install a program called "make".

##### Supported Helper commands
| Command | Comment| Optional arguments |
|:--- |:--- |:--- |
|`make test_api_b2b`| Run all API tests for B2B on default local environment| `glue_env=` / `bapi_env=` |
|`make test_api_b2c`| Run all API tests for B2C on default local environment| `glue_env=` / `bapi_env=` |
|`make test_api_mp_b2b`| Run all API tests for MP-B2B on default local environment| `glue_env=` / `bapi_env=` |
|`make test_api_mp_b2c`| Run all API tests for MP-B2C on default local environment| `glue_env=` / `bapi_env=` |
|`make test_api_suite`| Run all API tests for Suite on default local environment| `glue_env=` / `bapi_env=` |
|`make test_ui_suite`| Run all UI tests for Suite on default local environment|`glue_env=` / `yves_env=` / `yves_at_env=` / `zed_env=` / `mp_env=`|
|`make test_ui_b2b`| Run all UI tests for B2B on default local environment|`glue_env=` / `yves_env=` / `yves_at_env=` / `zed_env=` / `mp_env=`|
|`make test_ui_b2c`| Run all UI tests for B2C on default local environment|`glue_env=` / `yves_env=` / `yves_at_env=` / `zed_env=` / `mp_env=`|
|`make test_ui_mp_b2b`| Run all UI tests for MP-B2B on default local environment|`glue_env=` / `yves_env=` / `yves_at_env=` / `zed_env=` / `mp_env=`|
|`make test_ui_mp_b2c`| Run all UI tests for MP-B2C on default local environment|`glue_env=` / `yves_env=` / `yves_at_env=` / `zed_env=` / `mp_env=`|
##### Helper Examples
* Run all API tests for B2B on local environment
   ```sh
   make test_api_b2b
   ```
* Run all API tests for B2B on cloud environment
   ```sh
   make test_api_b2c glue_env=http://glue.example.com bapi_env=http://bapi.example.com
   ```
---
## [Built-in libraries](https://robotframework.org/?tab=builtin#resources)
| Name  	|Description| Keywords documentation|
|:--- |:--- |:--- |
| Builtin |Provides a set of often needed generic keywords. Always automatically available without imports.| [Documentation](https://robotframework.org/robotframework/latest/libraries/BuiltIn.html)|
| Collections |Provides a set of keywords for handling Python lists and dictionaries.| [Documentation](https://robotframework.org/robotframework/latest/libraries/Collections.html)|
| DateTime |Library for date and time conversions.| [Documentation](https://robotframework.org/robotframework/latest/libraries/DateTime.html)|
| Dialogs |Provides means for pausing the execution and getting input from users.| [Documentation](https://robotframework.org/robotframework/latest/libraries/Dialogs.html)|
| OperatingSystem |Enables various operating system related tasks to be performed in the system where Robot Framework is running.| [Documentation](https://robotframework.org/robotframework/latest/libraries/OperatingSystem.html)|
| Process |Library for running processes in the system.| [Documentation](https://robotframework.org/robotframework/latest/libraries/Process.html)|
| Screenshot |Provides keywords to capture screenshots of the desktop.| [Documentation](https://robotframework.org/robotframework/latest/libraries/Screenshot.html)|
| String |Library for generating, modifying and verifying strings.| [Documentation](https://robotframework.org/robotframework/latest/libraries/String.html)|

---
### External libraries that can be installed based on your needs
The full list can be found on the [official website](https://robotframework.org/?tab=libraries#resources)
| Name  	|Description| Keywords documentation|
|:--- |:--- |:--- |
| Browser |A modern web testing library powered by [Playwright]((https://github.com/microsoft/playwright)). Aiming for speed, reliability and visibility. **Note: Already installed**| [Documentation](https://marketsquare.github.io/robotframework-browser/Browser.html)|
| RequestsLibrary |Library for sending and API requests and receiving the responses.| [Documentation](https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html)|
| JSONLibrary |Library for parsing JSONs that come in API responses.| [Documentation](https://robotframework-thailand.github.io/robotframework-jsonlibrary/JSONLibrary.html)|

---
## Automatically re-executing failed tests
There is often a need to re-execute a subset of tests, for example, after fixing a bug in the system under test or in the tests themselves. This can be accomplished by selecting test cases by names (--test and --suite options), tags (--include and --exclude), or by previous status (--rerunfailed or --rerunfailedsuites).

Combining re-execution results with the original results using the default combining outputs approach does not work too well. The main problem is that you get separate test suites and possibly already fixed failures are also shown. In this situation it is better to use --merge (-R) option to tell Rebot to merge the results instead. In practice this means that tests from the latter test runs replace tests in the original.
| Command  	|Description| 
|:--- |:--- |
|`robot -v env:ui_b2c -d results tests/ui/e2e/b2c.robot`|first execute all tests|
|`robot -v env:ui_b2c --rerunfailed results/output.xml --output results/rerun.xml tests/ui/e2e/b2c.robot`|then re-execute failing|
|`rebot --merge results/output.xml results/rerun.xml`| finally merge results|

The message of the merged tests contains a note that results have been replaced. The message also shows the old status and message of the test.

Merged results must always have same top-level test suite. Tests and suites in merged outputs that are not found from the original output are added into the resulting output.

---
## Viewing and Generating Keyword Documentation
Keywords used in the tests can and should be documented. If you add any new keyword into the files inside the 'common' folder, they should have [Documentation] tag in them that describes what the keyword does, what parameters mean and gives an example of the usage.

Documentation can be generated by these tags. For now only common_api.robot has documentation generated. If you added new keywords, you should re-generate the documentation and commit it together with the other changes you made.

To generate the documentation for api and bapi tests use this command:
`libdoc resources/common/common_api.robot API_Keyword_Documentation.html`

To view the documentation just open the generated html file in any browser.

---
## Output files
Several output files are created when tests are executed, and all of them are somehow related to test results.

**Log** files contain details about the executed test cases in HTML format. They have a hierarchical structure showing test suite, test case and keyword details. Log files are needed nearly every time when test results are to be investigated in detail. Even though log files also have statistics, reports are better for getting an higher-level overview.

The command line option `--log (-l)` determines where log files are created. Unless the special value NONE is used, log files are always created and their default name is log.html.
