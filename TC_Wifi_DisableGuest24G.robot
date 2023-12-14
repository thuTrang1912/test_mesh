*** Settings ***
Library                      SeleniumLibrary         WITH NAME    SL
Library                      OperatingSystem
Library                      SSHLibrary
#Resource                     ../pythonProject/venv/lib/Selenium_lib/Setting_Wireless.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                     venv/lib/SSH_Lib/SSH_Connect_wifi.robot

*** Variables ***
${User_name}        root
${PW}               ttcn@99CN

${Mesh_SSID}        R1
${Mesh_PW}          12345678

${Guest_SSID}       R1_Guest24
${Authen_Mode}      WPA-PSK/WPA2-PSK Mixed mode
${Guest_PW}         12345678

${CAP_Name}         EW_0b52dc
${MRE_Name}         EW_86af28

${ssh_server_IP}                192.168.88.200
${ssh_server_username}          ubuntu
${ssh_server_PW}                1

*** Keywords ***
Open SSH Session Login To Local Machine
    SSHL.Open Connection        ${ssh_server_IP}
    ${login_output}             SSHL.Login                ${ssh_server_username}        ${ssh_server_PW}
    Should Contain              ${login_output}     ${ssh_server_username}
    SSHL.Execute Command         sudo su
    SSHL.Write    1
Ping From PC To
    [Documentation]         SSH to remote machine to ping to an address. Return True if ping succeed, else return False
    ...                     Input:
    ...                     1. ping_address
    ...                     Return:
    ...                     1. True or False

    [Arguments]             ${ping_address}    ${network_interface}
    ${ping_output}     ${ping_error}      ${ping_rc}=         SSHL.Execute Command    ping -i 0.3 ${ping_address} -c 5 -I ${network_interface}    return_rc=True    return_stderr=True
    Log To Console    Ping output: ${ping_output}
    Log To Console    Ping error: ${ping_error}
    ${isPingFailed}=        Run Keyword And Return Status     Should Contain    ${ping_output}    100% packet loss
    Return From Keyword If    '${isPingFailed}' == 'True' or '${ping_rc}' != '0'    False
    [Return]   True

*** Test Cases ***
1. Login to WebGUI
    Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root                           ${PW}

2. Disable Guest SSID 2.4G
    Access Setting Page
    Open Wireless Guest SSID 2.4G Setting
    Log To Console      \nCheck Guest 2.4G are Enable or NOT
    ${Stt}              Run Keyword And Return Status    Checkbox Should Be Selected    //input[@id='enable_guest_2g']
    Log To Console      \n Checkbox Should Be Selected: ${Stt}
    IF    ${Stt}
          Unselect Checkbox    //input[@id='enable_guest_2g']
    ELSE
         Log To Console      \n Checkbox Not Be Selected
    END
          Click Button        //input[@id='button_ApplyGuest2G']
    Sleep   80
    Close Browser

3. Verify in WebGui
    #Set Selenium Speed       0.5
    Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root                           ${PW}
    Access Setting Page
    Open Wireless Guest SSID 2.4G Setting
    ${Stt}              Run Keyword And Return Status    Checkbox Should Not Be Selected    //input[@id='enable_guest_2g']
    Log To Console      \n Checkbox Should Not Be Selected: ${Stt}
    IF    ${Stt}
          Log To Console    \n disable Guest 2G Succesfully
    ELSE
         Log To Console      \n  disable Guest 2G fail
    END
    Should Be True    ${Stt}
4. Verify on client dose not detect wifi Guest 24G
    Open SSH Session Login To Local Machine
    Sleep    5
    SSH_Connect_wifi.Enable Wifi
    Wait Until Keyword Succeeds   180    5    Wifi Rescan Not Contain       ${Guest_SSID}



