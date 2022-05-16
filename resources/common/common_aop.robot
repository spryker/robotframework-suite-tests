*** Settings ***
Library                   Browser    jsextension=${CURDIR}/../libraries/playwright/module.js
Resource                  common.robot

*** Variable ***
${apps_url}                        http://apps.spryker.local
${aop_store_reference}             dev-DE
${aop_payone_beeceptor}            https://beeceptor.com/console/spryker
${aop_payone_notifications_url}    /payone/payment-notification
