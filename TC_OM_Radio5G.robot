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

${Standard}             ax
${Channel}              64
${BW}                   80Mhz

*** Keywords ***
Verify config Radio 5g WebGUI
	[Arguments]                     ${Standard}      ${BW}       ${Channel}
	Click Button Edit Radio 5G
	${band}                         Get BW Radio 5G
	${band_mo1}                       Replace String                  ${band}       H     h
	${band_mo2}                     Replace String                  ${band}       ${SPACE}    ${EMPTY}
	${c}                            Get Chanel 5G
	${MoDE}	                        Get wifi standard 5G
	Log To Console                  \n Wireless Standart: ${MoDE}
	Log To Console                  \n Chanel: ${c}
	Log To Console                  \n Bandwith: ${bw}
	Should Match Regexp           ${MoDE}     11(${Standard})
	Should Match            ${c}       ${Channel}
	Should Match            ${band_mo2}     ${BW}
	Log To Console         \Config Radio 5G Successfully
######### Login ##############################
*** Test Case ***
1. Config wifi Radio 5G
	Set Selenium Speed    0.5
	Login to ONE Mesh                  ${User_N}    ${PW}
	Access Device detail OM            ${Serial}
	Go to Config Wifi OM
	Config Wifi Radio 5Ghz OM         ${Standard}      ${BW}       ${Channel}
	Sleep    30
	Verify config Radio 5Ghz OM        ${Standard}      ${BW}       ${Channel}
	Log To Console                      \nVerify on WebGUI

	Sleep        90
	Log To Console                      \nVerify on WebGUI
#	#3. Reconect wifi and verify config
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root       ${PassWord}
    Access Setting Page
	Go to Wireless
	Access Wireless Radio 5G
	Verify config Radio 5g WebGUI                ${Standard}      ${BW}       ${Channel}
