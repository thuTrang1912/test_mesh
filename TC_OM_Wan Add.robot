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
## PPPoE
${Service1}      IPv4
${Service2}      Dual
${User}          nsi2
${PW}            ansv
${IPv6_}         Auto

###DHCP
${service1}             IPv4
${service2}             Dual
${D_DNS1}                 8.8.8.8
${D_DNS2}                 8.8.0.4
${TypeV6}               Auto

### static
${IPAddr}       192.168.88.10
${Subnet}       255.255.0.0
${IPGate}       192.168.88.1
${S_DNS1}         1.1.1.1
${S_DNS2}         1.1.0.1

${ipv6_addr}    2001:ee0:4102:878a:b0a2:eb58:f033:8d0
${ipv6_Gateway}     fe80::561e:56ff:fe3b:3d3

${Serial}               52dc

*** Keywords ***
*** Test Cases ***
1 Add wan IPv4
	Set Selenium Speed                  0.5
	Login to ONE Mesh                  ${OM_User}    ${OM_PW}
	Access Device detail OM            ${Serial}

	Go to Config WAN OM
	FOR     ${i}        IN RANGE    3
		Click button Add Wan OM
	END
	Log to console                      \n Add Wan1 DHCP OM
	Add Wan1 DHCP OM            11      ${service1}      ${D_DNS1}     ${D_DNS2}     ${TypeV6}
	Log to console                      \n Add Wan1 PPPoE OM
	Add Wan2 PPPoE OM           12            ${service1}       ${User}         ${PW}      ${TypeV6}
	Log to console                      \n Add Wan1 Static OM
	Add Wan3 Static IPV4 OM          60      ${Service1}      ${IPAddr}     ${Subnet}   ${IPGate}   ${S_DNS1}     ${S_DNS2}
	Click Button Update Wan
	Sleep      5
2. Verify on OM
	Verify Add Wan1 DHCP OM         11       ${service1}      ${D_DNS1}     ${D_DNS2}     ${TypeV6}
	Verify Add Wan2 PPPoE OM        12       ${service1}       ${User}         ${PW}      ${TypeV6}
	Verify Add Wan3 Static IPv4 OM      60       ${Service1}      ${IPAddr}     ${Subnet}   ${IPGate}   ${S_DNS1}     ${S_DNS2}

3.1 Edit Wan To Dual Stack
	Log to console                      \n Add Wan1 DHCP OM
	Add Wan1 DHCP OM            11      ${service2}      ${D_DNS1}     ${D_DNS2}     ${TypeV6}
	Log to console                      \n Add Wan1 PPPoE OM
	Add Wan2 PPPoE OM           12            ${service2}       ${User}         ${PW}      ${TypeV6}
	Log to console                      \n Add Wan1 Static OM
	Add Wan3 Static IPV4 OM          60      ${Service2}      ${IPAddr}     ${Subnet}   ${IPGate}   ${S_DNS1}     ${S_DNS2}
	Add Wan3 Static IPV6 OM             ${ipv6_addr}        ${ipv6_Gateway}
	Click Button Update Wan
	Sleep   30

3.2 Verify Edit Wan
	Verify Add Wan1 DHCP OM         11       ${service2}      ${D_DNS1}     ${D_DNS2}     ${TypeV6}
	Verify Add Wan2 PPPoE OM        12       ${service2}       ${User}         ${PW}      ${TypeV6}
	Verify Add Wan3 Static IPv4 OM      60       ${Service2}      ${IPAddr}     ${Subnet}   ${IPGate}   ${S_DNS1}     ${S_DNS2}




