*** Settings ***

Documentation  Sample of using google to search versa 

Resource  test_environment.txt
Resource  test_actions.txt

*** Test Cases ***

Open the Google page and search Versa
    Open google page
    Input keyword to search    Versa networks
    Click search button

Open the hitted versa site
    Click the versa site link
    Versa site link should open

    [Teardown]  Close Browser