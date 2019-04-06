*** Settings ***
Library       SSHLibrary
Library       libraries.common.Helpers
Library       libraries.common.ScenarioHelpers
Library       libraries.ScenarioCheck
Library       libraries.common.DeviceConnections
Library       libraries.Connections
Library       Collections
Resource      resources/variables.robot
Resource      resources/bgp_for_lan/redundancy_link_up_down.robot
Resource      resources/ss_keywords.robot

Library     libraries.tests.bgp_for_lan.RedundancyRR    ${HOST_USERNAME}    ${KEYFILE}
...         WITH NAME     RedundancyRR

Library     libraries.BasicFunctions    ${DEMO USERNAME}   ${DEMO PASSWORD}    ${DEMO_TENANT}
...         ${GOHAN ENDPOINT}    ${TRUE}    ${USERNAME}    ${PASSWORD}    WITH NAME    ScenarioEngine

Suite Setup       Open Connection And Log In
Suite Teardown   Close All Connections

Test Setup  Test Case Setup
Test Teardown  Test Case Teardown

Force Tags  bgp_for_lan_redundancy_normal    bgp_for_lan

*** Variables ***
${HOST}    10.15.4.254
${USER_NAME}    i3admin
${PASS_WORD}    xyz123
${IMAGE_NAME}    quagga-bgp-lan-fumina



*** Keywords ***
Log Test Start!!

Open Connection And log In
    Open Connection    ${HOST}
    Login              ${USER_NAME}    ${PASS_WORD}

ESE Connectivity Ping Test
    [Documentation]    Ping Test End to End
    ${output}=    Execute Command    sudo ip netns exec ese-06-01 ping 100.100.1.2 -c 5
    Should Contain    ${output}      64 bytes from 100.100.1.2

BGP Health Check
    [Documentation]    Check BGP State
    ${output}=    Execute Command   sudo docker ps | grep ${IMAGE_NAME}| cut -d' ' -f1
    ${output2}  ${stderr}=    Execute Command    sudo docker exec -i ${output} vtysh -c 'show bgp neighbor'   return_stderr=True
    Should Contain    ${output2}    Established

Test Case Setup
    Get Timestamp

Test Case Teardown
    Run Keyword If Test Failed     Run Snapshot

*** Test Cases ***
1__LAN BGP Redundancy Full Mesh
    [Tags]    Teng
    Open Connection And log In
    ESE Connectivity Ping Test
    BGP Health Check

