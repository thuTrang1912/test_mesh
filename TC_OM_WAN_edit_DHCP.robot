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
${User_N}       one
${PW}           one@2019

${service1}             IPv4
${service2}             Dual
${DNS1}                 8.8.8.8
${DNS2}                 8.8.0.4
${TypeV6}               Auto

${Serial}               52dc
*** Keywords ***
Verify Config WWAN0 DHCP on OM should successfully
	[Arguments]                             ${service1}      ${DNS1}     ${DNS2}     ${TypeV6}
    Access Setting Page
    Access WAN
    Edit WWAN0
    IF    $service1 == 'Dual'
        Verify config WAN DHCP Dual Stack_ IPv6 Type        ${TypeV6}
    END
    Verify config WAN DHCP IPv4 OM       DHCP Client         ${service1}            ${DNS1}        ${DNS2}

Verify config WAN DHCP IPv4 OM
    [Arguments]                                     ${Service}  ${Ip_ver}   ${Primary DNS}      ${Second_DNS}
    ${Act_service}                                   SL.Get Selected List Label       //select[@id='Input_Service']
    ${Act_IP_version}                                SL.Get Selected List Label         //select[@id='Input_IPversion']
    ${Act_DNS1}=                                    Get Value       //input[@id='Input_DNS_DHCP_ipv4']
    ${Act_DNS2}=                                    Get Value       //input[@id='Input_DNS_SECOND_DHCP_ipv4']
    Log To Console                                  \n Service: ${Act_service}
    Log To Console                                  \n Ip_version: ${Act_IP_version}
    Log To Console                                  \n DNS1:  ${Act_DNS1}
    Log To Console                                  \n DNS2:  ${Act_DNS2}
    Should Match                                    ${Act_service}       ${Service}
    Should Match Regexp                             ${Act_IP_version}            (${IP_ver}).\\w+
    Should Be Equal                                 ${Primary DNS}      ${Act_DNS1}
    Should Be Equal                                 ${Second_DNS}       ${Act_DNS2}
*** Test Cases ***
1. Config Wan defaul DHCP IPv4r
	Set Selenium Speed    0.5
	Login to ONE Mesh                  ${User_N}    ${PW}
	Access Device detail OM            ${Serial}

	## Config
	Go to Config WAN OM
	Edit WWan0 DHCP OM          ${service1}      ${DNS1}     ${DNS2}     ${TypeV6}
	Sleep    30
	# Verify OM
	Verify Edit WWan0 DHCP OM Should Successfully       ${service1}      ${DNS1}     ${DNS2}     ${TypeV6}

	#Verify WebGUI
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root       ${PassWord}
    Verify Config WWAN0 DHCP on OM should successfully          ${service1}      ${DNS1}     ${DNS2}     ${TypeV6}
    Close Browser


2. Config Wan defaul DHCP Dual
	Sleep    20
	Set Selenium Speed    0.5
	Login to ONE Mesh                  ${User_N}    ${PW}
	Access Device detail OM            ${Serial}

	## Config
	Go to Config WAN OM
	Edit WWan0 DHCP OM          ${service2}      ${DNS1}     ${DNS2}     ${TypeV6}
	Sleep    30
	# Verify OM
	Verify Edit WWan0 DHCP OM Should Successfully       ${service2}      ${DNS1}     ${DNS2}     ${TypeV6}

	#Verify WebGUI
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root       ${PassWord}
    Verify Config WWAN0 DHCP on OM should successfully          ${service2}      ${DNS1}     ${DNS2}     ${TypeV6}