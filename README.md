# Installation

Please follow this guide https://spryker.atlassian.net/wiki/spaces/PS/pages/1488748622/Automation+-+Installation+instruction+and+Tools

# How to run tests

`robot -v env:b2b -v host:https://www.de.b2b-internal.cloud.demo-spryker.com/ -v zed_url:https://os.de.b2b-internal.cloud.demo-spryker.com/  -d Results Tests/E2E/B2B_E2E.robot`


* `-d Results` - path to the folder to store run report
* `-v env:b2b` - environment variable. Demodata in tests will depend on this variable value. Possible values: `b2b`, `b2c`, `suite-nonsplit`
* `-v host` `-v zed_url` - optional variable to specify Yves and Zed URLs
* `Tests/E2E/B2B_E2E.robot` - path to the file to execute
* `-v browser` - optional variable of the browser. By default, `headlesschrome` is used. Possible values: `headlesschrome`, `chrome`, `firefox`, etc.
