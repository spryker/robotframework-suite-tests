# Installation

Please follow this [guide](https://spryker.atlassian.net/wiki/spaces/PS/pages/1488748622/Automation+-+Installation+instruction+and+Tools).

# How to run tests

`robot -v env:{ENVIRONMENT} {PATH}`

### Run tests in chrome browser

`robot -v env:{ENVIRONMENT} -v browser:chrome {PATH}`

## Example

### B2B

`robot -v env:b2b Tests/E2E/B2B_E2E.robot`

You can also test the B2B internal via the environment `b2b-internal`.

### B2C

`robot -v env:b2c Tests/E2E/B2C_E2E.robot`

You can also test the B2C internal via the environment `b2c-internal`.

### Custom

`robot -v env:b2b -v host:https://www.de.b2b-internal.cloud.demo-spryker.com/ -v zed_url:https://os.de.b2b-internal.cloud.demo-spryker.com/  -d Results Tests/E2E/B2B_E2E.robot`

| Parameter | Comment |
|:--- |:--- |
| `-d {PATH}` | Path to the folder to store the run report. Like `Results` |
| `-v env:{ENVIRONMENT}` | Environment variable. Demo in tests will depend on this variable value. Possible values: `b2b`, `b2b-internal`, `b2c`, `b2c-internal`, and `suite-nonsplit`. |
| `-v host:{URL}` | Yves URL |
| `-v zed_url:{URL}` | Zed URL |
| `-v browser:{browser}` | chrome |
| `{PATH}` | Path to the file to execute |
