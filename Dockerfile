FROM mcr.microsoft.com/playwright/python:latest
ENV ROBOT_WORK_DIR /opt/robotframework
RUN mkdir -p ${ROBOT_WORK_DIR}

RUN apt-get update && \
    apt-get install -y nodejs npm make && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install  \
    --no-cache-dir  \
    robotframework  \
    robotframework-pabot  \
    robotframework-browser  \
    robotframework-databaselibrary  \
    robotframework-requests \
    PyMySQL \
    psycopg2-binary \
    robotframework-jsonlibrary

RUN rfbrowser init chromium

WORKDIR ${ROBOT_WORK_DIR}

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
