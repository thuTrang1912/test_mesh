*** Settings ***
Library                      SeleniumLibrary         WITH NAME    SL
Library                      OperatingSystem
Library                      SSHLibrary
#Resource                     ../pythonProject/venv/lib/Selenium_lib/Setting_Wireless.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                     venv/lib/SSH_Lib/SSH_Connect_wifi.robot
Resource                     venv/lib/Variable.robot

*** Variables ***


${Guest_SSID}       R1_Guest24
${Authen_Mode}      WPA-PSK/WPA2-PSK Mixed mode
${Guest_PW}         12345678

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
    Login To WebGUI on local machine         root       ${PassWord}
2. Enable Guest SSID 2.4G
    Access Setting Page
    Open Wireless Guest SSID 2.4G Setting
    Enable Guest SSID 2.4G
    Create Guest 24g       ${Guest_SSID}   ${Authen_Mode}      ${Guest_PW}
    Sleep       70
    Close Browser

3. Verify config Guest 2.4g Successfully
    Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root            ${PassWord}
    Access Setting Page
    Open Wireless Guest SSID 2.4G Setting
    ${value_SSID}           Get 2.4g SSID Guest
    Log To Console          \Guest SSID on WebGUI: ${value_SSID}
    ${value_Mode}           Get 2.4g Guest Serverity Mode
    Log To Console          \Guest Authen Mode on WebGUI: ${value_Mode}
    ${value_PW}             Get 2.4 Guest PW
    Log To Console          \Guest PW on WebGUI: ${value_PW}
    Should Match            ${value_SSID}   ${Guest_SSID}
    Should Match            ${value_Mode}   ${Authen_Mode}
    Should Match            ${value_PW}     ${Guest_PW}

4. Connect to Guest 2.4g and check internet service
    Sleep    120
    Open SSH Session Login To Local Machine
    Sleep    5
    SSH_Connect_wifi.Enable Wifi
    SSH_Connect_wifi.Delete All Wireless
    Wait Until Keyword Succeeds    180    5    SSH_Connect_wifi.Wifi Rescan Contain   ${Guest_SSID}
    # Connect control PC to wifi
    ${wlan_interface}=                             	SSHL.Execute Command    nmcli --fields Device,Type device status | grep 'wifi' | awk '{print $1}'
    SSH_Connect_wifi.Connect To Wifi                                	${wlan_interface}    ${Guest_SSID}     ${Guest_PW}
    #check internet by Ping comment
#   Ping From PC To         ${wlan_interface}               8.8.8.8
    Ping Should Succeed    8.8.8.8   ${wlan_interface}







