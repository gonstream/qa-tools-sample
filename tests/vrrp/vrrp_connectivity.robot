*** Settings ***
Library       SSHLibrary
Library       Collections

*** Variables ***
${HOST_ACT}    10.64.32.109
${HOST_SBY}    10.64.32.110
${USERNAME}    admin
${PASSWORD}    versa123

*** Keywords ***
Open Connection And log In Active
    Open Connection    ${HOST_ACT}
    Login              ${USERNAME}    ${PASSWORD}

Open Connection And log In Standby
    Open Connection    ${HOST_SBY}
    Login              ${USERNAME}    ${PASSWORD}

Versa cli Login
    [Documentation]    Get into cli
　   Write    cli
　   ${std_output}=    Read    delay=3s
　   Should Contain    ${std_output}    admin connected from

VRRP Active Status Check
    [Documentation]    Check Vrrp Active State
    Write    show vrrp | nomore
    ${std_output}=    Read    delay=3s
    Should Contain    ${std_output}    Master     Active     200(200)     Primary

VRRP Standby Status Check
    [Documentation]    Check Vrrp Standby State
    Write    show vrrp | nomore
    ${std_output}=    Read    delay=3s
    Should Contain    ${std_output}    Backup     Active     150(150)     Primary

*** Test Cases ***
1__VRRP ACT STATUS CHECK
    [Tags]    Teng
    Open Connection And log In Active
    Versa cli Login
    VRRP Active Status Check

2__VRRP SBY STATUS CHECK
    [Tags]    Teng
    Open Connection And log In Standby
    Versa cli Login
    VRRP Standby Status Check
    
