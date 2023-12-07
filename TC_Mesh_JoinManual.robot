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

*** Test Cases ***
*** Test Cases ***
### test cam lan vao IP can Join
1. Dang nhap WebGui
    Open Browser            https://192.168.88.1            ${Browser}
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         ${user_name}                  ${defaul_PW}
    Verify first Login Should contain Password change notifycation
    Change Administator Password            ${PassWord}
    Reload Page
    Login To WebGUI on local machine         ${user_name}                  ${PassWord}
    Verify login WebGUI Successfully
2. Join Mesh Manual
	Set Selenium Speed   0.5
    Access Mesh Page
	Click Button Join Mesh NetWork
	Join Mesh Manual            ${Mesh_SSID}        ${Mesh_PW}
	Sleep       90
	Close Browser
3. Connect To wifi and check Join Mesh Status
	Sleep   60
	SL.Set Selenium Speed    0.5
	Open Browser            https://192.168.88.1            ${Browser}
	Chrome Pass Certificate google if present
	Login To WebGUI on local machine         ${user_name}                  ${PassWord}
	Verify in Topology have MRE Info        ${MRE_Name_defautl}         ${MRE_Mac_Adress}

#    Open SSH Session Login To Local Machine
#    Sleep    5
#    SSH_Connect_wifi.Enable Wifi
#    SSH_Connect_wifi.Delete All Wireless
#    Wait Until Keyword Succeeds    180    5    SSH_Connect_wifi.Wifi Rescan Contain   ${Mesh_SSID}
#    # Connect control PC to wifi
#    ${wlan_interface}=                             	SSHL.Execute Command    nmcli --fields Device,Type device status | grep 'wifi' | awk '{print $1}'
#    SSH_Connect_wifi.Connect To Wifi                                	${wlan_interface}    ${Mesh_SSID}    ${Mesh_PW}
#
#
#	Open Browser            https://192.168.99.1            ${Browser}
#	Chrome Pass Certificate google if present
#	Login To WebGUI on local machine         ${user_name}                  ${PassWord}
