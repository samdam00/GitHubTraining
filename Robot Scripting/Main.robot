*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${url}    http://www.ltts.com
${browser}    googlechrome
${STRING}          This is a long string.
...                It has multiple sentences.
...                It does not have newlines.
${MULTILINE}       SEPARATOR=\n
...                This is a long multiline string.
...                This is the second line.
...                This is the third and the last line.
@{LIST}            this     list     is      quite    long     and
...                items in it can also be long
&{DICT}            first=This value is pretty long.
...                second=This value is even longer. It has two sentences.
*** Keywords ***
Named arguments example
    [Arguments]    ${path}=.    ${options}=
    Log    ${options} 
    Log    ${path}
Free Named Arguments
    [Arguments]    @{args}    ${config}=Darwin
    Log    @{args}
    

*** Test Cases ***
Test With Settings
    [Documentation]    Another dummy test
    [Tags]    dummy    owner-johndoe
    Log    Hello, world!
Test with Named arguments example
    Named arguments example    options=-lh
    Named arguments example    path=/tmp    options=-l
Test with Free Named Arguments
    Free Named Arguments   "Logging with Aruguments"    INFO    TRUE    TRUE    config=MacOS
    

    