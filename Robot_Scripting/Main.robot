*** Settings ***
Suite Setup       Suite Start
Suite Teardown    Suite End
Test Setup        Test Start
Test Teardown     Test End
Library           String
Library           SeleniumLibrary
Library           OperatingSystem
Library           AppiumLibrary
Library           ScreenCapLibrary
Library           MyCustomLibrary.py

*** Variables ***
${NAME}           Robot Framework-7.1
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
TestCase_01
    [Documentation]    Verify operations on the string
    ${index} =    Set Variable    0
    ${length} =    Get Length    ${STRING}
    #Character in Integer
    FOR    ${index}    IN RANGE    0    ${length} 
        ${char} =    Set Variable    ${STRING[${index}]}
        ${integer} =    Evaluate    ord('${char}')
        Log    ${integer}
    END
    #convert to lower case
    ${lowercase} =    Convert To Lower Case   ${String}



*** Keywords ***
Test Start
    ${robotversion} =    Run    robot --version
    Set Global Variable    ${ROBOT}    ${robotversion}
    Log    Starting test case,${ROBOT},Running on,${HOST}
  

Test End
    Log    Ending test case,${ROBOT},Running on,${HOST}

Receive dictionary
    [Arguments]    ${dict}
    log    ${dict}
    &{dict}=    Create Dictionary    A=1
    RETURN   &{dict}

Suite Start
    log    "Suite Setup"

Suite End
    log    "Suite End"
    