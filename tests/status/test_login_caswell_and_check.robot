*** Settings ***
Library       SSHLibrary
Library       Collections

Suite Setup       Open Connection And Log In
Suite Teardown   Close All Connections

Test Setup  Test Case Setup
Test Teardown  Test Case Teardown

*** Variables ***
${HOST}    10.64.32.112
${USERNAME}    admin
${PASSWORD}    versa123

*** Keywords ***

Open Connection And log In
    Open Connection    ${HOST}
    Login              ${USER_NAME}    ${PASS_WORD}

Versa cli Login
    [Documentation]    Get into cli
    ${output}=    Execute Command    cli
    Should Contain    ${output}      admin connected from

Load Balance Status Check
    [Documentation]    Check Load Balance State
    ${output}=    Execute Command    show orgs org NS-RegA sessions sdwan brief
    Should Contain    ${output2}    Established

Test Case Setup
    Get Timestamp

Test Case Teardown
    Run Keyword If Test Failed

*** Test Cases ***
1__LAN BGP Redundancy Full Mesh
    [Tags]    Teng
    Open Connection And log In
    Versa cli Login
    Load Balance Status Check
