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
*** Test Cases ***
Enable Guest SSID
	Set Selenium Speed    0.5
	Login to ONE Mesh                  ${User_N}    ${PW}
	Access Device detail OM            ${Serial}
	Go to Config Wifi OM
	Enable Guest SSID 24G OM        ${Guest2_SSID}      ${Authen2_Mode}     ${Guest2_PW}
	Enable Guest SSID 5G OM         ${Guest5_SSID}      ${Authen5_Mode}     ${Guest5_PW}
	Click button Save Wifi
	Sleep     60
	Verify Enable Guest SSID 24G OM             ${Guest2_SSID}      ${Authen2_Mode}     ${Guest2_PW}
	Verify Edit Guest SSID 5G OM                ${Guest5_SSID}      ${Authen5_Mode}     ${Guest5_PW}