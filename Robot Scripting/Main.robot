*** Settings ***
Test Setup       Test Start
Test Teardown    Test End
Library    SeleniumLibrary
Library    OperatingSystem
Library    Process

*** Variables ***
${NAME}    Robot Framework
${VERSION}    5.0
${ROBOT}    ${NAME} ${VERSION}
${SETUP}    Test Start
${TEARDOWN}    Test End
${HOST}    Srinaths-MacBook-Air.local
${USER}    Srinath
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
Test Start
    Log    ${ROBOT},Starting test case
Test End
    Log   ${ROBOT},Ending test case

*** Test Cases ***
#Using Arguments in keyword
Test with Named arguments example
    Named arguments example    options=-lh
    Named arguments example    path=/tmp    options=-l
Test with Free Named Arguments
    Free Named Arguments   "Logging with Aruguments"    INFO    TRUE    TRUE    config=MacOS

#Failures
#Normal Error
#    Fail    This is a rather boring example...

#HTML Error
#    ${number} =    Get Number
#    Should Be Equal    ${number}    42    *HTML* Number is not my <b>MAGIC</b> number.

#Test case name and documentation
Simple
    [Documentation]    Simple documentation
    No Operation

Formatting
    [Documentation]    *This is bold*, _this is italic_  and here is a link: http://robotframework.org
    No Operation

Variables
    [Documentation]    Executed at ${HOST} by ${USER}
    No Operation

Splitting
    [Documentation]    This documentation    is split    into multiple columns
    No Operation

Many lines
    [Documentation]    Here we have
    ...                an automatic newline
    ...                added 
    No Operation
#Test setup and teardown
Using variables
    [Documentation]    Setup and teardown specified using variables
    [Setup]    ${SETUP}
    Log    ${STRING}
    Log    ${MULTILINE} 
    [Teardown]    ${TEARDOWN}
#Using list variables 
Using list Variables
    Log Many    @{LIST}
#Using dict variables 
Using Dict Variables
    Log Many    &{DICT}


    

    