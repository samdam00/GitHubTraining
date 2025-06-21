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
${SETUP}          Test Start
${TEARDOWN}       Test End
${HOST}           Srinaths-MacBook-Air.local
${USER}           Srinath
${STRING}         This is a long string.    It has multiple sentences.    It does not have newlines.
${MULTILINE}      SEPARATOR=\n    This is a long multiline string.    This is the second line.    This is the third and the last line.
@{LIST}           this    list    is    quite    long    and    items in it can also be long
&{DICT}           first=This value is pretty long.    second=This value is even longer. It has two sentences.
&{DictionaryList}     A=${{["StringA1","StringA2"]}}    B=${{["StringB1","StringB2"]}}
&{outer_dict}    key1=${{'nested_key1': value1 , 'nested_key2': value2}}    key2=${{'nested_key3': value3}}

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
    #Dict of Lists
    Process DictionaryofList    ${DictionaryList}
    #Dict of Dict
    Process DictionaryofDict    &{outer_dict}


    


*** Keywords ***

Process DictionaryofList
    [Arguments]    ${dict}
    FOR    ${key}    IN    @{dict.keys()}
        ${Value} =    Set Variable    ${dict.${key}}[0]
        Log    ${Value}
    END

Process DictionaryofDict
    [Arguments]    ${dict}
    FOR    ${key}    IN    @{dict.keys()}
        ${Value} =    Set Variable    ${dict.${key}}
        Log    ${Value}
    END

Test Start
    ${robotversion} =    Run    robot --version
    Set Global Variable    ${ROBOT}    ${robotversion}
    Log    Starting test case,${ROBOT},Running on,${HOST}
  

Test End
    Log    Ending test case,${ROBOT},Running on,${HOST}

Suite Start
    log    "Suite Setup"

Suite End
    log    "Suite End"
    