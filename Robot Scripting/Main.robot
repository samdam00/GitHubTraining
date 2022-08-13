*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${Name}    Srinath Kuppuswamy
${Age}    100
${Mobile}    9159348735

*** Test Cases ***
TC_1
    Log   ${Name}
    Log    ${Age}
    Log    ${Mobile}
    Open Browser    http://www.ltts.com    googlechrome