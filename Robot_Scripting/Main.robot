*** Settings ***
Test Setup        Test Start
Test Teardown     Test End
Library           SeleniumLibrary
Library           OperatingSystem
Library           AppiumLibrary
Library           ScreenCapLibrary
Library           MyCustomLibrary.py
Library    ../Python3/lib/python3.11/site-packages/robot/libraries/Telnet.py
Library    ../Python3/lib/python3.11/site-packages/robot/libraries/String.py

*** Variables ***
${NAME}           Robot Framework-
${VERSION}        4.1.3
${ROBOT}          ${NAME} ${VERSION}
${SETUP}          Test Start
${TEARDOWN}       Test End
${HOST}           Srinaths-MacBook-Air.local
${USER}           Srinath
${STRING}         This is a long string.    It has multiple sentences.    It does not have newlines.
${MULTILINE}      SEPARATOR=\n    This is a long multiline string.    This is the second line.    This is the third and the last line.
@{LIST}           this    list    is    quite    long    and    items in it can also be long
&{DICT}           first=This value is pretty long.    second=This value is even longer. It has two sentences.
*** Test Cases ***
TC_01
    [Documentation]    Verify list of characters from a string
    ${index} =    Set Variable    0
    ${length} =    Get Length    ${STRING}
    FOR    ${index}    IN RANGE    0    ${length} 
        ${char} =    Set Variable    ${STRING[${index}]}
        Log    ${char}
    END
    FOR    ${index}    IN RANGE    0    61
        Log    ${index}
    END

*** Keywords ***
Test Start
    ${robotversion} =    Run    robot --version
    ${hostname} =    Run    hostname
    Set Global Variable    ${ROBOT}    ${robotversion}
    Set Global Variable    ${HOST}   ${hostname}   
    Log    Starting test case,${ROBOT},Running on,${HOST}
  

Test End
    Log    Ending test case,${ROBOT},Running on,${HOST}
