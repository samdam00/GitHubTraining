*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${url}    http://www.ltts.com
${browser}    googlechrome

*** Test Cases ***
TC_1
    Open Browser    ${url}    ${browser}