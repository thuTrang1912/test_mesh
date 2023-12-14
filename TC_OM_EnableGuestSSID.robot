*** Settings ***
Library                      SeleniumLibrary            WITH NAME    SL
#run_on_failure=SL.Capture Page Screenshot
Library                  OperatingSystem
Library                  XML
Library                String     WITH NAME    STR
Resource                 lib/Selenium_lib/OMesh.robot
#Resource                 MeshAP/venv/lib/Selenium_lib/OMesh.robot
Resource                 lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                 lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                 lib/Variable.robot

*** Variables ***
${User_N}       one
${PW}           one@2019

${Serial}               52dc
${New_ssid}             R1_change
${new_authen}           WPA-PSK/ WPA2-PSK Mixed Mode
${New_PW}               12345678_c

${Guest2_SSID}       R1_Guest24
${Authen2_Mode}      WPA2-PSK
${Guest2_PW}         12345678

${Guest5_SSID}       R1_Guest5
${Authen5_Mode}      WPA2-PSK
${Guest5_PW}         12345678

*** Keywords ***
Verify Enable Guest SSID 24G OM Should Successfully
	[Arguments]             ${Guest2_SSID}      ${Authen2_Mode}     ${Guest2_PW}
	Log to console           \n Verify Enable Guest SSID 5G OM :
    Access Setting Page
    Open Wireless Guest SSID 2.4G Setting
    ${value_SSID}           Get 2.4g SSID Guest
    Log To Console          \Guest SSID on WebGUI: ${value_SSID}
    ${value_Mode}           Get 2.4g Guest Serverity Mode
    Log To Console          \Guest Authen Mode on WebGUI: ${value_Mode}
    ${value_PW}             Get 2.4 Guest PW
    Log To Console          \Guest PW on WebGUI: ${value_PW}
    Should Match            ${value_SSID}   ${Guest2_SSID}
    Should Match            ${value_Mode}   ${Authen2_Mode}
    Should Match            ${value_PW}     ${Guest2_PW}
    Log to console          \t: Successfully

Verify Enable Guest SSID 5G OM Should Successfully
	[Arguments]              ${Guest5_SSID}      ${Authen5_Mode}     ${Guest5_PW}
	Log to console           \n Verify Enable Guest SSID 5G OM :
	Access Setting Page
    Open Wireless Guest SSID 5G Setting
    ${value_SSID}           Get 5g SSID Guest
    Log To Console          \Guest SSID on WebGUI: ${value_SSID}
    ${value_Mode}           Get 5g Guest Serverity Mode
    Log To Console          \Guest Authen Mode on WebGUI: ${value_Mode}
    ${value_PW}             Get 5 Guest PW
    Log To Console          \Guest PW on WebGUI: ${value_PW}
    Should Match            ${value_SSID}   ${Guest5_SSID}
    Should Match            ${value_Mode}   ${Authen5_Mode}
    Should Match            ${value_PW}     ${Guest5_PW}
    Log to console          \t: Successfully

*** Test Cases ***
Enable Guest SSID
	Set Selenium Speed    0.5
	Login to ONE Mesh                  ${User_N}    ${PW}
	Access Device detail OM            ${Serial}

	## Config
	Go to Config Wifi OM
	Enable Guest SSID 24G OM        ${Guest2_SSID}      ${Authen2_Mode}     ${Guest2_PW}
	Enable Guest SSID 5G OM         ${Guest5_SSID}      ${Authen5_Mode}     ${Guest5_PW}
	Click button Save Wifi
	Sleep     60
	##Verify on OMesh
	Verify Enable Guest SSID 24G OM             ${Guest2_SSID}      ${Authen2_Mode}     ${Guest2_PW}
	Verify Edit Guest SSID 5G OM                ${Guest5_SSID}      ${Authen5_Mode}     ${Guest5_PW}
	Sleep      120

	## Verify on WebGUI
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root       ${PassWord}
    Verify Enable Guest SSID 24G OM Should Successfully         ${Guest2_SSID}      ${Authen2_Mode}     ${Guest2_PW}
    Verify Enable Guest SSID 5G OM Should Successfully          ${Guest5_SSID}      ${Authen5_Mode}     ${Guest5_PW}



