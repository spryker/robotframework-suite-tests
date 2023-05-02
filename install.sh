#!/bin/bash

# Check if a Python executable is present.
if command -v python3 &>/dev/null; then
    python_cmd=python3
elif command -v python &>/dev/null; then
    python_cmd=python
else
    echo "Python is not installed."
    exit 1
fi

# Get the version number of Python installed on the system.
python_version=$($python_cmd --version 2>&1 | awk '{print $2}')

# Extract the major version number (i.e. 3 from 3.x).
major_version=$(echo $python_version | cut -d. -f1)

if [ "$major_version" == "3" ]; then
    echo "Python 3 is installed."
else
    echo "Python 3 is not installed."
    exit 1
fi

# Execute the installation
$python_cmd -m pip install -U robotframework
$python_cmd -m pip install -U robotframework-requests
$python_cmd -m pip install -U robotframework-databaselibrary
$python_cmd -m pip install PyMySQL
$python_cmd -m pip install psycopg2-binary
$python_cmd -m pip install -U robotframework-browser
rfbrowser init
$python_cmd -m pip install -U robotframework-jsonlibrary
