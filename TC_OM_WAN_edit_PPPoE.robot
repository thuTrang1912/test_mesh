*** Settings ***
Library                      SeleniumLibrary            WITH NAME    SL
#run_on_failure=SL.Capture Page Screenshot
Library                  OperatingSystem
Library                  XML
Library                String     WITH NAME    STR
Library    Collections
Resource                 lib/Selenium_lib/OMesh.robot
#Resource                 MeshAP/venv/lib/Selenium_lib/OMesh.robot
Resource                 lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                 lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                 lib/Variable.robot
Resource                 lib/Selenium_lib/Lib_Selenium_WAN.robot

*** Variables ***
${OM_User}       one
${OM_PW}           one@2019
${Serial}               52dc

${Service1}      IPv4
${Service2}      Dual
${User}          nsi2
${PW}            ansv
${IPv6_}        Auto

${DNS1}                 8.8.8.8
${DNS2}                 8.8.0.4
${TypeV6}               Auto


*** Keywords ***
Verify config WAN PPPoE OM WebGUI
   [Arguments]                                      ${Serveice}
   ...                                              ${IP_version}
   ...                                              ${User_name}
   ...                                              ${PW}
   ${Act_service}                                   SL.Get Selected List Label       //select[@id='Input_Service']
   ${Act_IP_version}                                SL.Get Selected List Label         //select[@id='Input_IPversion']
   ${Act_User_name}                                 SL.Get Element Attribute         //input[@id='Input_Username']  value
   ${Act_PW}                                        SL.Get Element Attribute         //input[@id='Input_Password']  value
   Log To Console                                   \nIP version is ${IP_version}
   Log To Console                                   \nUser Name: ${User_name}
   Log To Console                                   \nPassword: ${PW}
   Should Be Equal                                  ${Act_service}       ${Serveice}
   Should Match Regexp                              ${Act_IP_version}            (${IP_version})
   Should Be Equal                                  ${User_name}       ${Act_User_name}
   Should Be Equal                                  ${PW}       ${Act_PW}
   Log To Console                                  \nConfig Wan PPPoE succesfully
*** Test Cases ***
1. Config WWAN0 PPPoE Ipv4
	Set Selenium Speed                  0.5
	Login to ONE Mesh                  ${OM_User}    ${OM_PW}
	Access Device detail OM            ${Serial}

	Go to Config WAN OM
	Edit WAN PPPoE for Wan OM                      ${Service1}          ${User}         ${PW}
	Sleep    30
	Verify Edit WWAN0 PPPoE for Wan OM Should Successfully         ${Service1}          ${User}         ${PW}
	Sleep    120

	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root       ${PassWord}
	Access Setting Page
    Access WAN
    Edit WWAN0
    Verify config WAN PPPoE OM WebGUI    PPPoE    ${Service1}    ${User}    ${PW}
    Close Browser

2. Config WWAN0 PPPoE Dual
	Sleep    10
	Set Selenium Speed                  0.5
	Login to ONE Mesh                  ${OM_User}    ${OM_PW}
	Access Device detail OM            ${Serial}

	Go to Config WAN OM
	Edit WAN PPPoE for Wan OM                      ${Service2}          ${User}         ${PW}
	Sleep    30
	Verify Edit WWAN0 PPPoE for Wan OM Should Successfully         ${Service2}          ${User}         ${PW}
	Sleep    120

	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root       ${PassWord}
	Access Setting Page
    Access WAN
    Edit WWAN0
    Verify config WAN PPPoE OM WebGUI    PPPoE    ${Service2}    ${User}    ${PW}