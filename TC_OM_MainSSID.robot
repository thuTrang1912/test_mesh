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

*** Keywords ***
Verify Edit Main SSID WebGUI should successfully
	[Arguments]                         ${New_ssid}     ${new_authen}       ${New_PW}
    Open SSID Configuration
    #Get PW from webUI
    ${SSID_web}                           Get SSID from webUI
    ${PW_web}                             Get PW from webUI
    ${authen_web}                         Get Wireless Security Mode
    ${Stt1}                               Run Keyword And Return Status             Should Match    ${SSID_web}     ${New_ssid}
    ${Stt2}                               Run Keyword And Return Status             Should Match    ${PW_web}     ${New_PW}

    IF    ${Stt1}
        Log To Console                    \nEdit Successfully
    ELSE
        Log To Console                    \Edit Failue
    END
    Should Match                           ${authen_web}    ${new_authen}
    Should Be True    ${Stt1}
*** Test Cases ***
1. Config wifi Main SSID
	Set Selenium Speed    0.5
#	Login to ONE Mesh                  ${User_N}    ${PW}
#	Access Device detail OM            ${Serial}
#	Go to Config Wifi OM
#	Edit Main SSID OM           ${New_ssid}     ${new_authen}       ${New_PW}
#	Sleep    40
#	Verify Edit Main SSID OM    ${New_ssid}     ${new_authen}       ${New_PW}
#	Log To Console              \n Verify config in webgui

	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root       ${PassWord}
    Access Setting Page
	Go to Wireless
	Verify Edit Main SSID WebGUI should successfully            ${New_ssid}     ${new_authen}       ${New_PW}