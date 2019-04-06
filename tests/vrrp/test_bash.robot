*** Settings ***
Library       SSHLibrary
Library       Collections

*** Variables ***
${HOST_ACT}    10.64.32.109
${HOST_SBY}    10.64.32.110
${USERNAME}    admin
${PASSWORD}    versa123

*** Keywords ***
Open Connection And log In
    Open Connection    ${HOST_ACT}
    Login              ${USERNAME}    ${PASSWORD}

Versa cli Login
    [Documentation]    Get into cli
    ${output}=    Execute Command    pwd




*** Test Cases ***
1__VRRP ACT STATUS CHECK
    [Tags]    Teng
    Open Connection And log In
    Versa cli Login
