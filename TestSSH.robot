*** Settings ***
Library                      SeleniumLibrary         WITH NAME    SL
#run_on_failure=SL.Capture Page Screenshot
Library                      OperatingSystem
Library                      SshLibrary
Library    Collections
Resource                    venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                    venv/lib/Selenium_lib/Lib_Selenium_Meshpage.robot
Resource                    venv/lib/SSH_Lib/SSH_Connect_wifi.robot
Resource                    venv/lib/SSH_Lib/SSH_ping.robot
Resource                    venv/lib/Variable.robot

*** Keywords ***
Connect To Wifi
    [Documentation]         Connect to wifi with SSID
    ...                     Input:
    ...                     1. wireless_network_interface: Default if wlan0
    ...                     2. ssid
    ...                     3. password

    [Arguments]             ${wireless_network_interface}    ${ssid}    ${ssid_password}=${EMPTY}

    # Enable Wifi
    #Enable Wifi

    # Delele all Wireless
    #Delete All Wireless

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
#    Verify
    ${isConnectedSuccess}=      Run Keyword And Return Status   Wait Until Keyword Succeeds      60s     2s   Check Connected To Interface    network_interface=${wireless_network_interface}
    Run Keyword If          ${isConnectedSuccess} == True        Log To Console    Connecting succeeds to wifi ${ssid}
    ...    ELSE             Fail      Connecting failed to wifi ${ssid}

Check Connected To Interface
    [Documentation]         Verify connect successfully to ONT via LAN connection.
    ...                     Input:
    ...                     1. network_interface

    [Arguments]             ${network_interface}

    ${ifconfigOut}=         SSHL.Execute Command    ifconfig ${network_interface} | grep 'inet' | cut -d: -f2 | awk '{print $2}'
    ${return}=              Should Match Regexp     ${ifconfigOut}    [0-9]{1,3}\\.+[0-9]{1,3}\\.+[0-9]{1,3}\\.+[0-9]{1,3}

    Log To Console          PC Get IP Address on interface ${network_interface}: ${return}
Connect to Wifi Hidden
    [Arguments]             ${SSID}
    ...                     ${Password}
    ...                     ${Security}=wpa-psk
    ...                     ${wireless_network_interface}=wlp2s0
    SSHL.Execute Command    nmcli c add type wifi con-name wifi-hidden ifname ${wireless_network_interface} ssid ${SSID}        sudo=su     sudo_password=1
    Sleep                   10s
    ${log}=                 SSHL.read
    Log                     ${log}
    SSHL.Execute Command    nmcli con modify wifi-hidden wifi-sec.key-mgmt ${Security}      sudo=su     sudo_password=1
    SSHL.Execute Command    nmcli con modify wifi-hidden wifi-sec.psk ${Password}           sudo=su     sudo_password=1
    ${status_log1}=          SSHL.Execute Command    nmcli con up wifi-hidden           delay=10s   sudo=su     sudo_password=1
    Should Contain          ${status_log1}      Connection successfully activated
    ${status_log2}=          SSHL.Execute Command    nmcli con delete wifi-hidden       delay=10s   sudo=su     sudo_password=1
    Should Contain          ${status_log2}      successfully deleted
*** Test Case ***
4. Reconnect to Wifi With Correct Password and Check ping to Internet
    Open SSH Session Login To Local Machine
    Sleep    5
    Connect to Wifi Hidden  Wifi1   12345678
#    SSHL.Write    nmcli d wifi list | grep EW_86af28 | awk '{print $1, $4}'
#    Sleep       30
#    ${Out}       SSHL.Read
#
#    ${Line_count}               Get Line Count    ${Out}
#
#
#    ${1}    ${2}             	Split String        ${Out}       \n
###################
#    Connect To Wifi           wlp2s0              EW_86af28         EW@86af28
#    Check Connected To Interface        wlp2s0
#    SSH_Connect_wifi.Enable Wifi
#    SSH_Connect_wifi.Delete All Wireless
#    Wait Until Keyword Succeeds    180    5    SSH_Connect_wifi.Wifi Rescan Contain   ${Mesh_SSID}
#    # Connect control PC to wifi
#    ${wlan_interface}=                             	SSHL.Execute Command    nmcli --fields Device,Type device status | grep 'wifi' | awk '{print $1}'
#    SSH_Connect_wifi.Connect To Wifi_Orginer                                	${wlan_interface}    ${Mesh_SSID}    ${Mesh_PW}
    #check internet by Ping comment
#    Ping From PC To         ${wlan_interface}               8.8.8.8
#    SSH_ping.Ping Should Succeed    8.8.8.8   ${wlan_interface}
