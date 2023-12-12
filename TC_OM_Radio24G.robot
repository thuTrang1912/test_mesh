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

${Standard}             ng
${Channel}              10
${BW}                   40Mhz

*** Keywords ***
Verify config Radio 2.4g WebGUI
	[Arguments]             ${Standard}        ${BW}            ${Channel}
	Click Button Edit Radio 2.4
	${MoDE}                 Get wifi standard 2G
	${c}                    Get Chanel 2.4
	${band}                  Get BW Radio 2.4
	${band_mo1}               Replace String                  ${band}       H     h
	${band_mo2}               Replace String                  ${band}       ${SPACE}    ${EMPTY}
	Log To Console          \n Wireless Standart: ${MoDE}
	Log To Console          \n Chanel: ${c}
	Log To Console          \n Bandwith: ${bw}
	Should Match  Regex          ${MoDE}     11(${Standard})
	Should Match            ${c}       ${Channel}
	Should Match            ${band_mo2}     ${BW}
	Log To Console         \Config Radio 2.4G Successfully
######### Login ##############################
*** Test Case ***
1. Config wifi Radio 2.4g
	Login to ONE Mesh                  ${User_N}    ${PW}
	Access Device detail OM            ${Serial}
	Go to Config Wifi OM
	Config Wifi Radio 2.4Ghz OM        ${Standard}      ${Channel}         ${BW}
	Sleep    30
	Verify config Radio 2.4Ghz OM       ${Standard}      ${Channel}         ${BW}
	Log To Console                      \nVerify on WebGUI

	Sleep        90
	Log To Console                      \nVerify on WebGUI
	#3. Reconect wifi and verify config
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root       ${PassWord}
    Access Setting Page
	Go to Wireless
	Verify config Radio 2.4g WebGUI               ${Standard}      ${Channel}         ${BW}




