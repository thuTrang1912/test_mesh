*** Settings ***
Library                SSHLibrary     WITH NAME    SSHL
Library                String     WITH NAME    STR
Resource               ../venv/lib/SSH_Lib/SSH_ping.robot
Resource               ../venv/lib/SSH_Lib/SSH_ping.robot

*** Variables ***
*** Keywords ***
Open Connection And Login To Remote Machine
    [Documentation]         SSH to remote machine
    ...                     1. ssh_server_ip
    ...                     2. ssh_server_username
    ...                     3. ssh_server_password
    ...                     4. ssh_timeout: Default is 20

    [Arguments]             ${ssh_server_ip}    ${ssh_server_username}    ${ssh_server_password}
    ...                     ${ssh_timeout}=20s

    SSHL.Open Connection    ${ssh_server_ip}    timeout=${ssh_timeout}    prompt=$
    ${login_output}=        SSHL.Login          ${ssh_server_username}    ${ssh_server_password}
    Should Contain          ${login_output}     ${ssh_server_username}

Ping From PC With MTU Size
    [Documentation]    Ping from Control PC with MTU size
    ...                    Input:
    ...                    1: ping_address
    ...                    2: network_interface
    ...                    3: mtu_size
    ...                    Return:
    ...                    False: if ping_output contain 100% packet loss
    ...                    True: if not False

    [Arguments]             ${ping_address}    ${network_interface}    ${mtu_size}
    ${ping_output}     ${ping_error}      ${ping_rc}=         SSHL.Execute Command    ping -i 0.3 ${ping_address} -c 5 -I ${network_interface} -s ${mtu_size} -M do    return_rc=True    return_stderr=True
    Log To Console    Ping output: ${ping_output}
    Log To Console    Ping error: ${ping_error}
    ${isPingFailed}=        Run Keyword And Return Status     Should Contain    ${ping_output}    100% packet loss
    Return From Keyword If    '${isPingFailed}' == 'True' or '${ping_rc}' != '0'    False
    [Return]   True

Ping Should Succeed
    [Documentation]         Execute ping should be succeed
    ...                     Input:
    ...                     1. ping_address
    ...                     2. network_interface
    ...                     Return:
    ...                       Pass or Failed

    [Arguments]             ${ping_address}    ${network_interface}

    ${ping_rc}=             Ping From PC To    ${ping_address}    ${network_interface}
    ${result}=              Run Keyword And Return Status    Should Be True    '${ping_rc}' == 'True'
    Run Keyword If          '${result}' == 'True'     Log To Console    Ping successfully
    ...       ELSE          Fail     Ping failed


Ping Should Failed
    [Documentation]         Execute ping should be failed
    ...                     Input:
    ...                     1. ping_address
    ...                     Return:
    ...                       Pass or Failed

    [Arguments]             ${ping_address}    ${network_interface}

    ${ping_rc}=             Ping From PC To    ${ping_address}    ${network_interface}
    ${result}=              Run Keyword And Return Status    Should Be True    '${ping_rc}' == 'False'
    Run Keyword If          '${result}' == 'True'     Log To Console    Ping failed is true
    ...       ELSE          Fail     Ping still success

################ Xoa ket noi toi tat ca wifi da luu###############
Delete All Wireless
    Log To Console      Delete all wireless
    ${all_wireless}=    SSHL.Execute Command       nmcli --fields UUID,Type connection show | grep 'wifi' | awk '{print $1}'
    ${all_wireless}=    STR.Replace String    ${all_wireless}    \n    ${SPACE}
    Run Keyword If    '${all_wireless}' != ''    SSHL.Execute Command    sudo nmcli connection delete uuid ${all_wireless}
    ...    ELSE    Log To Console    Already deleted Wireless


###
Disable Wifi
    Log To Console      Disable Wifi
    SSHL.Execute Command    sudo nmcli radio wifi off   sudo=true   sudo_password=1
    Sleep                  0.5

Enable Wifi
    Log To Console      Enable Wifi
    SSHL.Execute Command    sudo nmcli radio wifi on    sudo=true    sudo_password=1

##################
Connect To Wifi_Orginer
    [Documentation]         Connect to wifi with SSID
    ...                     Input:
    ...                     1. wireless_network_interface: Default if wlan0
    ...                     2. ssid
    ...                     3. password

    [Arguments]             ${wireless_network_interface}    ${ssid}    ${ssid_password}=${EMPTY}

    # Enable Wifi
    Enable Wifi

    # Delele all Wireless
    Delete All Wireless

    # Check wifi SSID existed in wifi list
    ${wirelessList}=        SSHL.Execute Command    nmcli device wifi list
    Should Contain          ${wirelessList}         ${ssid}

    Run Keyword If         '${ssid_password}'=='${EMPTY}'    SSHL.Execute Command              sudo nmcli device wifi connect '${ssid}'
    ...        ELSE         SSHL.Execute Command              sudo nmcli device wifi connect '${ssid}' password ${ssid_password}    sudo=true   sudo_password=1

    # Verify
    ${isConnectedSuccess}=      Run Keyword And Return Status   Wait Until Keyword Succeeds      60s     1s   Check Connected To Interface    network_interface=${wireless_network_interface}
    Run Keyword If          ${isConnectedSuccess} == True        Log To Console    Connecting succeeds to wifi ${ssid}
    ...    ELSE             Fail      Connecting failed to wifi ${ssid}

Connect To Wifi
    [Documentation]         Connect to wifi with SSID
    ...                     Input:
    ...                     1. wireless_network_interface: Default if wlan0
    ...                     2. ssid
    ...                     3. password

    [Arguments]             ${wireless_network_interface}    ${ssid}    ${ssid_password}=${EMPTY}

    # Enable Wifi
    Enable Wifi

    # Delele all Wireless
    Delete All Wireless

    # Check wifi SSID existed in wifi list
    ${wirelessList}=        SSHL.Execute Command    nmcli device wifi list
    Should Contain          ${wirelessList}         ${ssid}

    Run Keyword If         '${ssid_password}'=='${EMPTY}'    SSHL.Execute Command              sudo nmcli device wifi connect '${ssid}'
    ...        ELSE         SSHL.Write              sudo nmcli device wifi connect '${ssid}' password '${ssid_password}'

    Sleep       1
    ${output}= 	SSHL.Read
    SSHL.Write      1
    Sleep       30
    ${Stt}= 	SSHL.Read
    Should Contain    ${Stt}   Device 'wlp2s0' successfully activated with
    # Verify
    ${isConnectedSuccess}=      Run Keyword And Return Status   Wait Until Keyword Succeeds      60s     1s   Check Connected To Interface    network_interface=${wireless_network_interface}
    Run Keyword If          ${isConnectedSuccess} == True        Log To Console    Connecting succeeds to wifi ${ssid}
    ...    ELSE             Fail      Connecting failed to wifi ${ssid}


###
Disconnect From Wifi
    [Documentation]         Disconnect from wifi
    ...                     Input:
    ...                     1. wireless_network_interface

    [Arguments]             ${wireless_network_interface}
    # Disconnect from wifi
    Delete All Wireless

    # Verify disconnect from wifi successfully
    ${isDisconnectedSuccess}=      Run Keyword And Return Status
    ...                     Wait Until Keyword Succeeds     60s     1s    Check Disconnected From Interface    network_interface=${wireless_network_interface}
    Run Keyword If          ${isDisconnectedSuccess}        Log To Console       Disconnecting from wifi successfully!
    ...    ELSE             Fail      Disconnecting from wifi failed

Get Network Interface Ip Address
    [Documentation]         Get IP address of network interface. Return None if IP address not found
    ...                     Input:
    ...                     1. network_interface
    ...                     Return:
    ...                     1. network_interface_ip_addr

    [Arguments]             ${network_interface}
    ${network_interface_ip_addr}=         SSHL.Execute Command    ifconfig ${network_interface} | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'
    ${return_code}=         Run Keyword And Return Status         Should Match Regexp     ${network_interface_ip_addr}    [0-9]{1,3}\\.+[0-9]{1,3}\\.+[0-9]{1,3}\\.+[0-9]{1,3}
    Return From Keyword If  '${return_code}' == 'False'           None
    [Return]                ${network_interface_ip_addr}


###
Set Network Interface
    [Documentation]         Set network interface by command "sudo nmcli device"
    ...                     Input:
    ...                     1. network_interface
    ...                     2. action: connect/disconnect

    [Arguments]             ${network_interface}    ${action}

    SSHL.Execute Command    sudo nmcli device ${action} ${network_interface} |:

###
Up Down Network Card PC Linux
    [Arguments]    ${network_interface_card}
    SSHL.Write    sudo ifconfig ${network_interface_card} down
    Sleep    5s
    SSHL.Write    sudo ifconfig ${network_interface_card} up
    Sleep    5s

###
Get IPv4 PC Linux
    [Documentation]    Updating.....
    [Arguments]    ${network_interface_card}
    SSHL.Write    ifconfig ${network_interface_card}
    Sleep    3
    ${output}=    SSHL.Read
    ${output}=    STR.Get Lines Containing String   ${output}   Mask:255.255.255.248
    ${outputipv4}=    STR.Split String    ${output}
    ${output_1}=      STR.Split String        ${outputipv4[1]}     separator=:
    [Return]          ${output_1[1]}

###
Check IPv4 Public By Web
    [Arguments]   ${link}        ${ip_ubuntu_control}=${REMOTE_SELENIUM_SERVER}
    SL.Open Browser    ${link}    chrome    remote_url=http://${ip_ubuntu_control}:5555/wd/hub
    BuiltIn.Sleep    10
    SL.Page Should Contain Element               xpath=//section[@id="main"]/div[@id="ipv4"]/p[@class="ipaddress"]
    ${noidung}=                   SL.Get Text    xpath=//section[@id="main"]/div[@id="ipv4"]/p[@class="ipaddress"]
    Log To Console                \nIPv4 nhan duoc thuc te tren WEB la: ${noidung}
Get Time PC
    ${time_cur}=                        SSHL.Execute Command        date +%A


    Return From Keyword                  ${time_cur}
Renew IP Address
    [Arguments]             ${network_interface}    ${ip_adrress_contain}
    SSHL.Execute Command		sudo ifconfig ${network_interface} down		delay=3s
    Sleep                   10s
    SSHL.Execute Command		sudo ifconfig ${network_interface} up		delay=3s
    Sleep                   10s
    ${ip_address_on_pc}=    Get Network Interface Ip Address    network_interface=${network_interface}
    Should Contain          ${ip_address_on_pc}    ${ip_adrress_contain}


Get Remote File
    [Documentation]             Get file from remote server to local.
    ...                         Input:
    ...                         1. server_ip                    remote server ip
    ...                         2. user_name                    uername
    ...                         3. password                     password
    ...                         4. file_dir                     location of file
    ...                         5. local_dir                    location of file (default: Current Dir)
    [Arguments]                     ${server_ip}           ${user_name}      ${password}           ${remote_file}         ${local_dir}=.
    SSHL.Open Connection            ${server_ip}            port=22
    SSHL.Login                      ${user_name}            ${password}
    SSHL.Get File                   ${remote_file}             ${local_dir}
    [Teardown]                      SSHL.Close Connection


Verify Backup Success
	[Documentation]             Verify file backup exist in local by backup success
	...                         Input:
    ...                         1. server_ip                    remote server ip
    ...                         2. user_name                    uername
    ...                         3. password                     password
    ...                         4. file_dir                     location of file
	[Arguments]                     ${server_ip}           ${user_name}      ${password}           ${file_dir}
	SSHL.Open Connection            ${server_ip}            port=22
    SSHL.Login                      ${user_name}            ${password}
    SSHL.File Should Exist		${file_dir}
    Log To Console				\nCheck backup file existed in local


Del Old File
    Open Connection And Login To Remote Machine    ssh_server_ip=${REMOTE_SERVER_IP}
    ...                                            ssh_server_username=${REMOTE_SERVER_USERNAME}
    ...                                            ssh_server_password=${REMOTE_SERVER_PASSWORD}
    SSHL.Execute Command                           mkdir -p ${DOWNLOAD_DIR} && rm -f ${DOWNLOAD_DIR}/${CONFIG_FILE_NAME}
    SSHL.Execute Command                           touch ${DOWNLOAD_DIR}/${INVALID_CONFIG_FILE_NAME}
    SSHL.Close Connection


Wifi Rescan Contain
    [Arguments]                                    ${wifi_ssid}
    SSHL.Execute Command                           nmcli device wifi rescan         30
    ${wirelessList}=                               SSHL.Execute Command    nmcli device wifi list
    Should Contain                                 ${wirelessList}    ${wifi_ssid}
    Log To Console                                 \nSSID is Visiable


Wifi Rescan Not Contain
    [Arguments]                                  ${wifi_ssid}
    SSHL.Execute Command                         nmcli device wifi rescan
    ${wirelessList}=                             SSHL.Execute Command    nmcli device wifi list
    Should Not Contain                           ${wirelessList}    ${wifi_ssid}


Check Download BW
    [Arguments]           ${download}
    SSHL.Write                     speedtest --server 6085
    Sleep                                    30s
    ${check_output_speedtest}=               SSHL.Read      delay=5s
    ${check_output_speedtest_1}=             STR.Remove String       ${check_output_speedtest}         ${SPACE}
    Should Contain                           ${check_output_speedtest_1}     ${download}

Check Upload BW
    [Arguments]           ${upload}
    SSHL.Write                     speedtest --server 6085
    Sleep                                    30s
    ${check_output_speedtest}=               SSHL.Read      delay=5s
    ${check_output_speedtest_1}=             STR.Remove String       ${check_output_speedtest}         ${SPACE}
    Should Contain                           ${check_output_speedtest_1}
*** Keywords ***
