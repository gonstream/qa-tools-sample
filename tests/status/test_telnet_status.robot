*** Settings ***
Library    Telnet

*** Variables ***
${PORT}    23
${HOST1}    10.64.32.60
${HOST2}
${USERNAME}    nttcom
${PASSWORD}    nttcom

*** Keywords ***
Open Connection And log In
    Open Connection    ${HOST1}    prompt=password    alias=conn01
    Write    ${PASSWORD}
    Read Until    >
    Write    enable
    Read Until    Password:
    Write    ${PASSWORD}
    Read Until    \#
    Write    ter len 0
    Read Until    \#

Show ip route
    [Documentation]    Show ip route
    Write    show ip route
    ${std_output}=    Read
    Should Contain    ${std_output}    10.64.33.0/24 [20/0] via 100.100.161.2

List files
    [Arguments]    ${path}=.    ${options}=
    Execute command    ls ${options} ${path}

*** Test Cases ***
1__Telnet to MGMT-R
    Open Connection And log In

STATUS CHECK
    Show ip route