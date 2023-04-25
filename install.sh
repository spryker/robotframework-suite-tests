#!/bin/bash

if command -v python3 &>/dev/null; then
    python_cmd=python3
elif command -v python &>/dev/null; then
    python_cmd=python
else
    echo "Python is not installed."
    exit 1
fi

$python_cmd -m pip install -U robotframework
$python_cmd -m pip install -U robotframework-requests
$python_cmd -m pip install -U robotframework-databaselibrary
$python_cmd -m pip install PyMySQL
$python_cmd -m pip install psycopg2-binary
$python_cmd -m pip install -U robotframework-browser
rfbrowser init
$python_cmd -m pip install -U robotframework-jsonlibrary
