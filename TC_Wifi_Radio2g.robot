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
${Standard}         11ng
${Channel}          6
${BW}               20/40 MHz

&{dir}              name = Nguyen Van A    age = 23




*** Keywords ***
Config Standard/channel/Bw on Radio 2.4g
	[Arguments]             ${Standard}      ${Channel}         ${BW}

	Config Wifi Standard 2G     ${Standard}
	Config Chanel 2.4G      ${Channel}
	Config BW Radio 2G           ${BW}
	Wait Until Element Is Visible   //input[@id='buttonApply2G']
	Click Element                    //input[@id='buttonApply2G']

Verify config Radio 2.4g
	[Arguments]             ${Standard}      ${Channel}         ${BW}
	Click Button Edit Radio 2.4
	${MoDE}                 Get wifi standard 2G
	${c}                    Get Chanel 2.4
	${band}                   Get BW Radio 2.4
	Log To Console          \n Wireless Standart: ${MoDE}
	Log To Console          \n Chanel: ${c}
	Log To Console          \n Bandwith: ${bw}
	Should Match            ${MoDE}     ${Standard}
	Should Match            ${c}       ${Channel}
	Should Match            ${band}     ${BW}
	Log To Console         \Config Radio 2.4G Successfully

Get MAC Addr of Radio 2.4g
	${Mac_24G}                  Get Text                	//label[@id='id_mac']
	RETURN                      ${Mac_24G}
*** Test Cases ***
1. Login to WebGUI
    Open Browser            https://192.168.88.1            ${Browser}
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root            ${PassWord}
2. Edit Radio Channel
	Set Selenium Speed    0.5
	Access Setting Page
	Go to Wireless
	Click Button Edit Radio 2.4
	Config Standard/channel/Bw on Radio 2.4g        ${Standard}      ${Channel}         ${BW}
	Sleep   120s
	Close Browser

3. Reconect wifi and verify config
	Set Selenium Speed    0.5
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root       ${PassWord}
    Access Setting Page
	Go to Wireless
	${Mac_24G}          Get MAC Addr of Radio 2.4g
	Set Global Variable     ${Mac_24G}
	Verify config Radio 2.4g                  ${Standard}      ${Channel}         ${BW}

4. Check topo Have enouht Node
	Reload Page
	Verify in Topology have MRE Info        ${MRE_Name_defautl}         ${MRE_Mac_Adress}


5. Verify in client
	Open SSH Session Login To Local Machine
    Sleep    5
    SSH_Connect_wifi.Enable Wifi
    SSH_Connect_wifi.Delete All Wireless
    Wait Until Keyword Succeeds    180    5    SSH_Connect_wifi.Wifi Rescan Contain   ${Mesh_SSID}
    ##### Verify Channel in Client
    ${wf_list}              SSHL.Execute Command             nmcli d wifi list          timeout= 50
    Should Match Regexp     ${wf_list}                .(${Mac_24G}).*(${Channel})

    # Connect control PC to wifi
    ${wlan_interface}=                             	SSHL.Execute Command    nmcli --fields Device,Type device status | grep 'wifi' | awk '{print $1}'
    SSH_Connect_wifi.Connect To Wifi                                	${wlan_interface}    ${Mesh_SSID}    ${Mesh_PW}
    #check internet by Ping comment
#    Ping From PC To         ${wlan_interface}               8.8.8.8
    SSH_ping.Ping Should Succeed    8.8.8.8   ${wlan_interface}





