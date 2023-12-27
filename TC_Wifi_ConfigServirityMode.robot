*** Settings ***
Library                      SeleniumLibrary   run_on_failure=SL.Capture Page Screenshot      WITH NAME    SL
Library                      OperatingSystem
Library                      SSHLibrary
#Resource                     ../pythonProject/venv/lib/Selenium_lib/Setting_Wireless.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                     venv/lib/SSH_Lib/SSH_ping.robot
Resource                     venv/lib/SSH_Lib/SSH_Connect_wifi.robot
Resource                     venv/lib/Variable.robot

*** Variables ***

@{List_mode}        WPA-PSK     WPA2-PSK    WPA-PSK/WPA2-PSK Mixed Mode    WPA3-SAE     WPA2-PSK/WPA3-SAE Mixed Mode
&{Sercurity}        WPA-PSK = WPA1          WPA2-PSK = WPA2     WPA-PSK/WPA2-PSK Mixed Mode= WPA1 WPA2      WPA3-SAE= WPA3      WPA2-PSK/WPA3-SAE Mixed Mode= WPA2 WPA3

${Mode_Athen}       WPA-PSK


*** Keywords ***

Config Wifi with WPA-PSK Mode
	[Arguments]                 ${Authen_Mode}
#	SL.Set Selenium Speed    0.5
#    SL.Open Browser            https://192.168.88.1            chrome
#    Chrome Pass Certificate google if present
#    Login To WebGUI on local machine         root                           ${PW}
    Access Setting Page
    Go to Wireless
    Open SSID Configuration
    Select Wireless Security                ${Authen_Mode}
    SL.Click Button                        //input[@id='button_ApplySSID']
    Sleep    10
Verify config in webGUI
	[Arguments]                 ${Authen_Mode}
	Acept Alert Reconnect Wifi If Present
	ReLogin WebGUI If Session Timeout       ${Browser}      ${user_name}        ${PassWord}
#	Sleep    50
	#SL.Set Selenium Speed    0.5
    SL.Wait Until Page Contains            Setting
    Access Setting Page
    Go to Wireless
    Open SSID Configuration
    ${Value}                        Get Wireless Security Mode
    Log                             ${Value}
    #Verify config success
    Should Match                    ${Value}   ${Authen_Mode}
    ${Stt}                          Run Keyword And Return Status           Should Match                    ${Value}   ${Authen_Mode}
    IF    $Stt == 'True'
        Log To Console              Change Sercurity successfully
    ELSE
         Log To Console             Chage failure
    END
    Should Be True    ${Stt}

Reconnect to Wifi With Correct Password
    Open SSH Session Login To Local Machine
    Sleep    5
    SSH_Connect_wifi.Enable Wifi
    SSH_Connect_wifi.Delete All Wireless
    Wait Until Keyword Succeeds    180    5    SSH_Connect_wifi.Wifi Rescan Contain   ${Mesh_SSID}
    # Connect control PC to wifi
    ${wlan_interface}=                             	SSHL.Execute Command    nmcli --fields Device,Type device status | grep 'wifi' | awk '{print $1}'
    SSH_Connect_wifi.Connect To Wifi                                	${wlan_interface}    ${Mesh_SSID}    ${Mesh_PW}
    #check internet by Ping comment
#    Ping From PC To         ${wlan_interface}               8.8.8.8
    SSH_ping.Ping Should Succeed    8.8.8.8   ${wlan_interface}
*** Test Cases ***
Config Servirity Mode
	SL.Set Selenium Speed    0.5
	Login WebGUI        ${Browser}      ${user_name}        ${PassWord}
	FOR    ${I}    IN    @{List_mode}
	    Config Wifi with WPA-PSK Mode       ${I}
	    Verify config in webGUI             ${I}
	END
	Reconnect to Wifi With Correct Password



#1.1 Config Wifi with WPA-PSK Mode
#	SL.Set Selenium Speed    0.5
#    SL.Open Browser            https://192.168.88.1            chrome
#    Chrome Pass Certificate google if present
#    Login To WebGUI on local machine         root                           ${PW}
#    Access Setting Page
#    Go to Wireless
#    Open SSID Configuration
#    Select Wireless Security                ${Mode_Athen}
#    SL.Click Button                        //input[@id='button_ApplySSID']
#    Sleep    60
#
#1.2 Verify config in webGUI
#	SL.Set Selenium Speed    0.5
#    SL.Open Browser            https://192.168.88.1            chrome
#    SL.Reload Page
#    Chrome Pass Certificate google if present
#    Login To WebGUI on local machine         root                           ${PW}
#    SL.Wait Until Page Contains            Setting
#    Access Setting Page
#    Go to Wireless
#    Open SSID Configuration
#    ${Value}                        Get Wireless Security Mode
#    Log                             ${Value}
#    #Verify config success
#    Should Match                    ${Value}   ${Mode_Athen}
#    ${Stt}                          Run Keyword And Return Status           Should Match                    ${Value}   ${Mode_Athen}
#    IF    $Stt == 'True'
#        Log To Console              Change Sercurity successfully
#    ELSE
#         Log To Console             Chage failure
#    END
#    Should Be True    ${Stt}
#1.3 Reconnect to Wifi With Correct Password
#    Open SSH Session Login To Local Machine
#    Sleep    5
#    SSH_Connect_wifi.Enable Wifi
#    SSH_Connect_wifi.Delete All Wireless
#    Wait Until Keyword Succeeds    180    5    SSH_Connect_wifi.Wifi Rescan Contain   ${New_SSID}
#    # Connect control PC to wifi
#    ${wlan_interface}=                             	SSHL.Execute Command    nmcli --fields Device,Type device status | grep 'wifi' | awk '{print $1}'
#    SSH_Connect_wifi.Connect To Wifi                                	${wlan_interface}    ${Mesh_SSID}    ${Mesh_PW}
#    #check internet by Ping comment
##    Ping From PC To         ${wlan_interface}               8.8.8.8
#    SSH_ping.Ping Should Succeed    8.8.8.8   ${wlan_interface}
#
#2.1. Config Wifi with WPA2-PSK Mode
##    Open Browser            https://192.168.88.1            chrome
##    Chrome Pass Certificate google if present
##    Login To WebGUI on local machine         root                           ${PW}
#    Access Setting Page
#    Go to Wireless
#    Open SSID Configuration
#    Select Wireless Security                WPA2-PSK
#    SL.Click Button                        //input[@id='button_ApplySSID']
#    Sleep    80
#    SL.Close Browser
#2.2 Verify config in webGUI
##    Sleep       90
##    Wait Until Page Contains            Setting
#    SL.Open Browser            https://192.168.88.1            chrome
#    SL.Reload Page
#    Chrome Pass Certificate google if present
#    Login To WebGUI on local machine         root                           ${PW}
#    SL.Wait Until Page Contains            Setting
#    Access Setting Page
#    Go to Wireless
#    Open SSID Configuration
#    ${Value}                        Get Wireless Security Mode
#    Log                             ${Value}
#    #Verify config success
#    Should Match                    ${Value}   WPA2-PSK
#
#3.1 Config Wifi with WPA-PSK/WPA2-PSK Mixed Mode
##    Open Browser            https://192.168.88.1            chrome
##    Chrome Pass Certificate google if present
##    Login To WebGUI on local machine         root                           ${PW}
#    Access Setting Page
#    Go to Wireless
#    Open SSID Configuration
#    Select Wireless Security               WPA-PSK/WPA2-PSK Mixed Mode
#    SL.Click Button                           //input[@id='button_ApplySSID']
#    Sleep    90
#    SL.Close Browser
#
#3.2 Verify config in webGUI
#    SL.Open Browser            https://192.168.88.1            chrome
#    Reload Page
#    Chrome Pass Certificate google if present
#    Login To WebGUI on local machine         root                           ${PW}
#
#    Wait Until Element Is Visible       //a[@id='titleSettingCap']          30
#    Access Setting Page
#    Go to Wireless
#    Open SSID Configuration
#    ${Value}                        Get Wireless Security Mode
#    Log                             ${Value}
#    #Verify config success
#    Should Match                    ${Value}        WPA-PSK/WPA2-PSK Mixed Mode
#
1.3 Reconnect to Wifi With Correct Password
    Open SSH Session Login To Local Machine
    Sleep    5
    SSH_Connect_wifi.Enable Wifi
    SSH_Connect_wifi.Delete All Wireless
    Wait Until Keyword Succeeds    180    5    SSH_Connect_wifi.Wifi Rescan Contain   ${New_SSID}

	Log To Console    Verify Security Mode in client
	${wf_list}              SSHL.Execute Command             nmcli d wifi list          timeout= 50
    FOR     ${key}      ${value}     IN    &{Sercurity}
            IF      $Mode_Athen= ${key}
                Log To Console         Sercurity Mode is: ${key} / (${value})
                Should Match Regexp    ${wf_list}    .*(${Mesh_SSID}).*($value)
            END
    END
#    # Connect control PC to wifi
    ${wlan_interface}=                             	SSHL.Execute Command    nmcli --fields Device,Type device status | grep 'wifi' | awk '{print $1}'
    SSH_Connect_wifi.Connect To Wifi                                	${wlan_interface}    ${New_SSID}    ${New_PW}
    #check internet by Ping comment
#    Ping From PC To         ${wlan_interface}               8.8.8.8
    SSH_ping.Ping Should Succeed    8.8.8.8   ${wlan_interface}