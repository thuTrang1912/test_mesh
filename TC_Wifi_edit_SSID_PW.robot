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
${PW}               12345a@A

${Mesh_SSID}        Change SSID 999
${Mesh_PW}          12345678 9 c

${New_SSID}         Change5 SSID 999
${New_PW}           12345678 9 c5

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

Check Connected To Interface
    [Documentation]         Verify connect successfully to Mesh via LAN connection.
    ...                     Input:
    ...                     1. network_interface

    [Arguments]             ${network_interface}

    ${ifconfigOut}=         SSHL.Execute Command    ifconfig ${network_interface} | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'
    ${return}=              Should Match Regexp     ${ifconfigOut}    [0-9]{1,3}\\.+[0-9]{1,3}\\.+[0-9]{1,3}\\.+[0-9]{1,3}

    Log To Console          PC Get IP Address on interface ${network_interface}: ${return}
*** Test Cases ***
1. Edit SSID and PW
    Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root                           ${PW}
    Access Setting Page
    Go to Wireless
    Open SSID Configuration
    ${SSID_value}=                      Get Element Attribute               //input[@id='Input_SSID']           value
    Log    ${SSID_value}
    #Input Text                          //input[@name='SSID']   TRangtest
    #SL.Handle Alert
    Log                          ${New_SSID}
    Change SSID and PW to                ${New_SSID}             ${New_PW}
    Sleep                   90
    Close Browser

2. Verify that the SSID & PW configuration change is successful
    Sleep                   2
    Open Browser            https://192.168.88.1            chrome
    Reload Page
    Chrome Pass Certificate google if present
    #Wait Until Page Contains        Setting             20
    #Reload Page
    Login To WebGUI on local machine               root                           ${PW}
    Access Setting Page
    Go to Wireless
    Open SSID Configuration
    #Get PW from webUI
    ${SSID_web}                           Get SSID from webUI
    ${PW_web}                             Get PW from webUI
    ${Stt1}                               Run Keyword And Return Status             Should Match    ${SSID_web}     ${New_SSID}
    ${Stt2}                               Run Keyword And Return Status             Should Match    ${PW_web}     ${New_PW}
    IF    ${Stt1}
        Log To Console                    \nEdit Successfully
    ELSE
        Log To Console                    \Edit Failue
    END
    Should Be True    ${Stt1}

3. Check the Mesh topo should has enough nodes
    Log To Console                         \Check whether the Mesh topology has enough nodes or not
    Click Element                          //a[@id='titleHome']
    Sleep    5
    Page Should Contain                     ${CAP_Name}
    Page Should Contain                     ${MRE_Name}

4. Reconnect to Wifi With Correct Password
    Open SSH Session Login To Local Machine
    Sleep    5
    SSH_Connect_wifi.Enable Wifi
    SSH_Connect_wifi.Delete All Wireless
    Wait Until Keyword Succeeds    180    5    SSH_Connect_wifi.Wifi Rescan Contain   ${New_SSID}
    # Connect control PC to wifi
    ${wlan_interface}=                             	SSHL.Execute Command    nmcli --fields Device,Type device status | grep 'wifi' | awk '{print $1}'
    SSH_Connect_wifi.Connect To Wifi                                	${wlan_interface}    ${New_SSID}    ${New_PW}
    #check internet by Ping comment
#    Ping From PC To         ${wlan_interface}               8.8.8.8
    Ping Should Succeed    8.8.8.8   ${wlan_interface}







