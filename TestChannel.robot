*** Settings ***
Library                      SeleniumLibrary         WITH NAME    SL
Library                      OperatingSystem
Library                      SSHLibrary
#Resource                     ../pythonProject/venv/lib/Selenium_lib/Setting_Wireless.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                     venv/lib/SSH_Lib/SSH_Connect_wifi.robot
Resource                     venv/lib/SSH_Lib/SSH_ping.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Meshpage.robot
Resource                     venv/lib/Variable.robot

*** Keywords ***
Get MAC Addr of Radio 2.4g
	${Mac_24G}                  Get Text                	//label[@id='id_mac']
	RETURN               ${Mac_24G}

Get MAC Addr of Radio 5g
	${Mac_5G}                  Get Text                	//label[@id='id_mac']
	RETURN                ${Mac_5G}

*** Test Cases ***
1. Login to WebGUI
    Open Browser            https://192.168.88.1            ${Browser}
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root            ${PassWord}
2. Edit Radio Channel 5G
	Set Selenium Speed    0.5
	Access Setting Page
	Go to Wireless
	${Mac_24G}          Get MAC Addr of Radio 2.4g
	Set Global Variable     ${Mac_24G}
	Access Wireless Radio 5G

	${Mac_5G}           Get MAC Addr of Radio 5g
	Set Global Variable     ${Mac_5G}

3. Verify on Client
    Open SSH Session Login To Local Machine
    Sleep    5
    Wait Until Keyword Succeeds    180    5    SSH_Connect_wifi.Wifi Rescan Contain   Mesh K
    ${wf_list}              SSHL.Execute Command             nmcli d wifi list          timeout= 50
    Should Match Regexp     ${wf_list}                .(${Mac_24G}).*(9)
    Should Match Regexp     ${wf_list}                .(${Mac_5G}).*(44)
