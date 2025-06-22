*** Settings ***
Suite Setup       Suite Start
Suite Teardown    Suite End
Test Setup        Test Start
Test Teardown     Test End
Library           String
Library           Collections
Library           SeleniumLibrary
Library           OperatingSystem
Library           AppiumLibrary
Library           ScreenCapLibrary
Library           MyCustomLibrary.py

*** Variables ***
${NAME}           Robot Framework-7.1
${VERSION}        4.1.3
${ROBOT}          ${NAME} ${VERSION}
${HOST}           Srinaths-MacBook-Air.local
${USER}           Srinath
${STRING}         This is a long string. It has multiple sentences. It does not have newlines.
${MULTILINE}      SEPARATOR=\n    This is a long multiline string.    This is the second line.    This is the third and the last line.
@{LIST}           this    list    is    quite    long    and    items in it can also be long
&{DICT}           first=This value is pretty long.    second=This value is even longer. It has two sentences.
&{DictionaryList}     A=${{["StringA1","StringA2"]}}    B=${{["StringB1","StringB2"]}}
&{OUTER_DICT}     key1=${{'nested_key1': 'value1', 'nested_key2': 'value2'}}    key2=${{'nested_key3': 'value3'}}

*** Test Cases ***
TestCase_BuiltIn_Keywords
    [Documentation]    Demonstrates usage of various Robot Framework built-in keywords for string, list, and dictionary operations.
    ${joined}=    Catenate    SEPARATOR=,    one    two    three
    Log    ${joined}
    Should Be Equal    ${joined}    one,two,three
    ${random}=    Generate Random String    8
    Log    ${random}
    ${now}=    Get Time    epoch
    Log    ${now}
    ${copy}=    Copy Dictionary    ${DICT}
    Log    ${copy}
    ${list_length}=    Get Length    ${LIST}
    Log    ${list_length}
    List Should Contain Value    ${LIST}    long

TestCase_String_Functions
    [Documentation]    Demonstrates usage of Robot Framework built-in string manipulation keywords.
    ${upper}=    Convert To Upper Case    ${STRING}
    Log    ${upper}
    ${lower}=    Convert To Lower Case    ${STRING}
    Log    ${lower}
    ${title}=    Title Case    ${STRING}
    Log    ${title}
    ${replaced}=    Replace String    ${STRING}    long    short
    Log    ${replaced}
    ${split}=    Split String    ${STRING}    .
    Log    ${split}
    ${count}=    Count Substring    ${STRING}    is
    Log    ${count}
    ${trimmed}=    Strip String    ${STRING}
    Log    ${trimmed}

*** Keywords ***
Process DictionaryofList
    [Documentation]    Logs the first item of each list value in the given dictionary of lists.
    [Arguments]    ${dict}
    FOR    ${key}    IN    @{dict.keys()}
        ${value}=    Set Variable    ${dict[${key}][0]}
        Log    ${value}
    END

Process DictionaryofDict
    [Documentation]    Logs the value of each key in the given dictionary of dictionaries.
    [Arguments]    ${dict}
    FOR    ${key}    IN    @{dict.keys()}
        ${value}=    Set Variable    ${dict[${key}]}
        Log    ${value}
    END

Test Start
    [Documentation]    Runs at the start of each test. Logs Robot Framework version and host information.
    ${robotversion}=    Run    robot --version
    Set Global Variable    ${ROBOT}    ${robotversion}
    Log    Starting test case, ${ROBOT}, Running on, ${HOST}

Test End
    [Documentation]    Runs at the end of each test. Logs test completion information.
    Log    Ending test case, ${ROBOT}, Running on, ${HOST}

Suite Start
    [Documentation]    Runs at the start of the suite. Logs suite setup information.
    Log    Suite Setup

Suite End
    [Documentation]    Runs at the end of the suite. Logs suite end information.
    Log    Suite End
