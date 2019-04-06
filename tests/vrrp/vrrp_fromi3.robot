*** Settings ***
Documentation    Suite for testing VRRP

Resource    resources/variables.robot
Resource    resources/ss_keywords.robot
Library     Collections
Library     libraries.common.Helpers
Library     libraries.VRRPFunctions    ${DEMO_USERNAME}   ${DEMO_PASSWORD}    ${DEMO_TENANT}    ${GOHAN ENDPOINT}    ${FALSE}    ${USERNAME}    ${PASSWORD}    WITH NAME    Worker

Force Tags    vrrp    vrrp_connectivity

Test Setup       Test Case Setup
Test Teardown    Test Case Teardown

*** Test Cases ***

Redundant ESE to Single ESE
    [Tags]    TCMS-10-29

    ${ese_device}=       Load Yaml   ${path}/one_single_one_redundant/ese_devices.yml
    ${devices}=          Load Yaml   ${path}/one_single_one_redundant/devices.yml
    ${endhosts}=         Load Yaml   ${path}/one_single_one_redundant/endhosts.yml
    ${logical_ports}=    Load Yaml   ${path}/one_single_one_redundant/set_subnets.yml
    ${devices_var}=      Worker.Setup Vpn Environment    ${ese_device}    ${logical_ports}    ${devices}    endhosts=${endhosts}

    Set Suite Variable    ${endhosts}    ${endhosts}
    Set Suite Variable    ${devices_var}    ${devices_var}

    Worker.Check VPN Connectivity

    Worker.Wait For Vrrp Status     ${ese_device_2_vlport1_id}   master   backup
    ...                             ${ese_device_2_id}    ${ese_device_3_id}

    ${checks}=    Load Yaml   ${path}/one_single_one_redundant/checks.yml
    Worker.Perform Checks    ${checks}
    

*** Keywords ***

Test Case Setup
    Get Timestamp
    ${prefix}=         Get Variable Value    ${PREFIXES}
    ${devices_var}=    Get Variable Value    ${devices_var}
    Set Suite Variable    ${endhosts}    ${None}
    Set Suite Variable    ${pingers}    ${None}
    Set Suite Variable    ${path}    ${EXECDIR}/data/vrrp
    Set Suite Variable    ${prefix}    ${prefix}
    Set Suite Variable    ${devices_var}    ${devices_var}
    ${init}=    Load Yaml   ${path}/init.yml
    Worker.Perform Test Scenario    ${init}

Test Case Teardown
    Run Keyword If Test Failed     Run Snapshot
    Run Keyword If    ${DELETE_DATA} == ${TRUE}    Worker.Reverse Interface Changes    ${endhosts}
    Run Keyword If    ${DELETE_DATA} == ${TRUE}    Worker.Delete All    devices=${devices_var}

Ping Stop Teardown
    Worker.Stop Pingers    ${pingers}
    Test Case Teardown
