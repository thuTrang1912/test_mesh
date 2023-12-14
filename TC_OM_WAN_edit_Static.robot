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
${Service2}      Dual
${IPAddr}       192.168.88.10
${Subnet}       255.255.0.0
${IPGate}       192.168.88.1
${DNS1}         1.1.1.1
${DNS2}         1.1.0.1

${ipv6_addr}    2001:ee0:4102:878a:b0a2:eb58:f033:8d0
${ipv6_Gateway}     fe80::561e:56ff:fe3b:3d3

*** Keyword ***


*** Test Cases ***
#1. Config WWAN0 Static Ipv4 OM
#	Set Selenium Speed                  0.5
#	Login to ONE Mesh                  ${OM_User}    ${OM_PW}
#	Access Device detail OM            ${Serial}
#	#### config
#	Go to Config WAN OM
#	Edit WAN Static IPV4 OM        ${Service1}      ${IPAddr}     ${Subnet}     ${IPGate}    ${DNS1}         ${DNS2}
#	Click Button Update Wan
#	Sleep       30
#	### verify on OM
#	Verify Config WWAN0 Static IPV4 OM          ${Service1}      ${IPAddr}     ${Subnet}   ${IPGate}   ${DNS1}     ${DNS2}
#
#	Sleep       120
#		### verify on WebGui
#	Open Browser            https://192.168.88.1            chrome
#    Chrome Pass Certificate google if present
#    Login To WebGUI on local machine         root       ${PassWord}
#	Access Setting Page
#    Access WAN
#    Edit WWAN0
#    Verify config WAN Static Ipv4    ${IPAddr}        ${IPGate}       ${Subnet}      ${DNS1}     ${DNS2}
#    IF  $Service1=='Dual'
#		Verify WAN Stactic IPv6 Address and Gateway      ${v6_addr}      ${v6_Gate}
#		ELSE
#			Log to console              Verify Cònfig wan static in webgui successfully
#    END
#    Sleep   10
#    Close Browser

2. Config WWAN0 Static Dual stack OM
	Set Selenium Speed                  0.5
	Login to ONE Mesh                  ${OM_User}    ${OM_PW}
	Access Device detail OM            ${Serial}
	## COnfig wan static
	Go to Config WAN OM
#	Edit WAN Static IPV4 OM         ${Service2}     ${IPAddr}          ${Subnet}      ${IPGate}     ${DNS1}     ${DNS2}
#	Edit WAN Static IPV6 OM         ${Service2}          ${ipv6_addr}    ${ipv6_Gateway}
#	Click Button Update Wan
#	Sleep     30

	### Verify in OM
	Verify Config WWAN0 Static IPV4 OM          ${Service2}      ${IPAddr}     ${Subnet}   ${IPGate}   ${DNS1}     ${DNS2}
	Verify Config WWAN0 Static IPV6 OM          ${ipv6_addr}    ${ipv6_Gateway}
	### Verify on WebGUI
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root       ${PassWord}
	Access Setting Page
    Access WAN
    Edit WWAN0
    Verify config WAN Static Ipv4    ${IPAddr}        ${IPGate}       ${Subnet}      ${DNS1}     ${DNS2}
    IF  $Service2=='Dual'
		Verify WAN Stactic IPv6 Address and Gateway      ${ipv6_addr}    ${ipv6_Gateway}
		ELSE
			Log to console              Verify Cònfig wan static in webgui successfully
    END
    Sleep   10
    Close Browser



