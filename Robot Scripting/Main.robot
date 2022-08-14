*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${url}    http://www.ltts.com
${browser}    googlechrome

*** Keywords ***
My Keyword
    Open Browser    ${url}    ${browser}


*** Test Cases ***
TC_1
    My Keyword
    