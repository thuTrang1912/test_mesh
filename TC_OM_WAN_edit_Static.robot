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
${OM_User}              one
${OM_PW}                one@2019
${Serial}               52dc

${Service1}      IPv4
${Service1}      Dual
${Addr}         192.168.88.10
${Subnet}       255.255.255.0
${IPGate}       192.168.88.1
${DNS1}         1.1.1.1
${DNS2}         1.1.0.1

${v6_addr}
${v6_Gate}
*** Keyword ***


*** Test Cases ***
1. Config WWAN0 Static Ipv4
	Set Selenium Speed                  0.5
	Login to ONE Mesh                  ${OM_User}    ${OM_PW}
	Access Device detail OM            ${Serial}

	Go to Config WAN OM
	Edit WAN Static for Wan index OM        ${Service1}      ${Addr}     ${Subnet}   ${IPGate}   ${DNS1}     ${DNS2}
	Sleep       30
	Verify Config WWAN0 Static for Wan index OM          ${Service1}      ${Addr}     ${Subnet}   ${IPGate}   ${DNS1}     ${DNS2}

	Sleep       120
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root       ${PassWord}
	Access Setting Page
    Access WAN
    Edit WWAN0
    Verify config WAN Static Ipv4    ${Addr}     ${Subnet}   ${IPGate}   ${DNS1}     ${DNS2}
    IF  ${Service1}=='Dual'
		Verify WAN Stactic IPv6 Address and Gateway      ${v6_addr}      ${v6_Gate}
    END
