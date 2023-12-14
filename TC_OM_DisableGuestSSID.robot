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

*** Keyword ***
Verify Disable Guest 2.4 on WebGui should successfully
    Access Setting Page
    Open Wireless Guest SSID 2.4G Setting
    ${Stt}              Run Keyword And Return Status    Checkbox Should Not Be Selected    //input[@id='enable_guest_2g']
    Log To Console      \n Checkbox Should Not Be Selected: ${Stt}
    IF    ${Stt}
          Log To Console    \n disable Guest 2G Succesfully
    ELSE
         Log To Console      \n  disable Guest 2G fail
    END
    Should Be True    ${Stt}


Verify Disable Guest 5g on WebGui should successfully
	Access Setting Page
    Open Wireless Guest SSID 5G Setting
     ${Stt}              Run Keyword And Return Status    Checkbox Should Not Be Selected    //input[@id='5G_Enable_Guest']
    Log To Console      \n Checkbox Should Not Be Selected: ${Stt}
    IF    ${Stt}
          Log To Console    \n disable Guest 5G Succesfully
    ELSE
         Log To Console      \n  disable Guest 5G fail
    END
    Should Be True    ${Stt}

*** Test case ***
Disable Guest SSID on OM
	Set Selenium Speed    0.5
	Login to ONE Mesh                  ${User_N}    ${PW}
	Access Device detail OM            ${Serial}
	### Config
	Go to Config Wifi OM
	Disable Guest 2.4 OM
	Disable Guest 5g OM
	Click button Delete Guest SSID
	Sleep       30
	### Verify config on OM
	Verify Disable Guest 2.4 OM should successfully
	Verify Disable Guest 5g OM should successfully
	Sleep       120
	# Verify on WebGUI on WebGUI
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root       ${PassWord}
	Verify Disable Guest 2.4 on WebGui should successfully
	Verify Disable Guest 5g on WebGui should successfully