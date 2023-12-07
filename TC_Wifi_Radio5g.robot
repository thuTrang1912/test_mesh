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
*** Variables ***
${Standard}         11ax
${Channel}          120
${BW}               80 MHz

*** Keywords ***
Config Standard/channel/Bw on Radio 5g
	[Arguments]                     ${Standard}      ${Channel}         ${BW}
	Click Button Edit Radio 5G
	Config Wifi Standard 5G         ${Standard}
	Config Chanel 5G                ${Channel}
	Config BW Radio 5G              ${BW}
	Wait Until Element Is Visible    //input[@id='buttonApply5G']
	Click Element                   //input[@id='buttonApply5G']

Verify config Radio 5g
	[Arguments]                     ${Standard}      ${Channel}         ${BW}
	Click Button Edit Radio 5G
	${band}                         Get BW Radio 5G
	${c}                            Get Chanel 5G
	${MoDE}	                        Get wifi standard 5G
	Log To Console                  \n Wireless Standart: ${MoDE}
	Log To Console                  \n Chanel: ${c}
	Log To Console                  \n Bandwith: ${bw}
	Should Match            ${MoDE}     ${Standard}
	Should Match            ${c}       ${Channel}
	Should Match            ${band}     ${BW}
	Log To Console         \Config Radio 5G Successfully

*** Test Cases ***
#1. Login to WebGUI
#    Open Browser            https://192.168.88.1            ${Browser}
#    Chrome Pass Certificate google if present
#    Login To WebGUI on local machine         root            ${PassWord}
#2. Edit Radio Channel 5G
#	Set Selenium Speed    0.5
#	Access Setting Page
#	Go to Wireless
#	Access Wireless Radio 5G
#	Config Standard/channel/Bw on Radio 5g        ${Standard}      ${Channel}         ${BW}
#	Sleep   120s
#	Close Browser

#3. Reconect wifi and verify config in WebGUI
#	Set Selenium Speed    0.5
#	Open Browser            https://192.168.88.1            chrome
#    Chrome Pass Certificate google if present
#    Login To WebGUI on local machine         root       ${PassWord}
#    Access Setting Page
#	Go to Wireless
#	Access Wireless Radio 5G
#	Verify config Radio 5g                  ${Standard}      ${Channel}         ${BW}
#4. Check topo Have enouht Node
#	Reload Page
#	Verify in Topology have MRE Info        ${MRE_Name_defautl}         ${MRE_Mac_Adress}
#	Close All Browsers
5. Verify in client
	Open SSH Session Login To Local Machine
    Sleep    5
    ${Ouput}            SSHL.Execute Command            sudo nmcli device wifi list         30
#    Sleep   3
#    SSHL.Write    1
#    Sleep    30
#    ${Output}                       SSHL.Read

    Log         ${Ouput}
    ${out2}      Get Lines Matching Pattern    ${Ouput}    CC:71:90:86:AF:2
    Log To Console    ${out2}
    Log                 ${out2}
#    SSH_Connect_wifi.Enable Wifi
#    SSH_Connect_wifi.Delete All Wireless
#    Wait Until Keyword Succeeds    180    5    SSH_Connect_wifi.Wifi Rescan Contain   ${Mesh_SSID}
#    # Connect control PC to wifi
#    ${wlan_interface}=                             	SSHL.Execute Command    nmcli --fields Device,Type device status | grep 'wifi' | awk '{print $1}'
#    SSH_Connect_wifi.Connect To Wifi                                	${wlan_interface}    ${Mesh_SSID}    ${Mesh_PW}
#
#    SSH_ping.Ping Should Succeed    8.8.8.8   ${wlan_interface}
#    SSHL.Execute Command            nmcli d wifi list           30
#    ${Output}                       SSHL.Read

