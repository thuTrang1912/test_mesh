*** Settings ***
Library                      SeleniumLibrary            WITH NAME    SL
#run_on_failure=SL.Capture Page Screenshot
Library                 OperatingSystem
Library                  XML
Library                  String     WITH NAME    STR
Library                  Collections
Library    AppiumLibrary
Resource                 lib/Selenium_lib/OMesh.robot
#Resource                 MeshAP/venv/lib/Selenium_lib/OMesh.robot
Resource                 lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                 lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                 lib/Variable.robot
Resource                 lib/Selenium_lib/Lib_Selenium_WAN.robot
Resource    lib/SSH_Lib/SSH_Connect_wifi.robot

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
Verify config WAN DHCP IPv4
    [Arguments]                                     ${Service}  ${Ip_ver}   ${Primary DNS}      ${Second_DNS}
    ${Act_service}                                   SL.Get Selected List Label       //select[@id='Input_Service']
    ${Act_IP_version}                                SL.Get Selected List Label         //select[@id='Input_IPversion']
    ${Act_DNS1}=                                    Get Value       //input[@id='Input_DNS_DHCP_ipv4']
    ${Act_DNS2}=                                    Get Value       //input[@id='Input_DNS_SECOND_DHCP_ipv4']
    Log To Console                                  \n Service: ${Act_service}
    Log To Console                                  \n Ip_version: ${Act_IP_version}
    Log To Console                                  \n DNS1:  ${Act_DNS1}
    Log To Console                                  \n DNS2:  ${Act_DNS2}
    Should Match Regexp                             ${Act_service}       (${Service})
    Should Match Regexp                             ${Act_IP_version}       (${IP_ver})
    Should Be Equal                                 ${Primary DNS}   ${Act_DNS1}
    Should Be Equal                                 ${Second_DNS}    ${Act_DNS2}

Verify WWan1 DHCP in WebGUI
	[Arguments]                     ${service}      ${D_DNS1}     ${D_DNS2}     ${TypeV6}
	SL.Set Selenium Speed       0.5
    Access Setting Page
    Access WAN
    Edit WWAN1
    IF    $service == 'Dual'
        Verify config WAN DHCP Dual Stack_ IPv6 Type        ${TypeV6}
    END
    Verify config WAN DHCP IPv4         DHCP Client         ${service}            ${D_DNS1}         ${D_DNS2}
Verify Add WWan2 PPPoE Vlan 12 in WebGUI
	[Arguments]                     ${service}       ${User}      ${PW}          ${TypeV6}
	SL.Set Selenium Speed       0.5
    Access Setting Page
    Access Setting Page
    Access WAN
    Edit WWAN2
    Verify config WAN PPPoE    PPPoE    ${service}    ${User}   ${PW}

Verify Add WWan3 Static in WebGUI
	[Arguments]                      ${Service}      ${IPAddr}     ${Subnet}   ${IPGate}   ${S_DNS1}     ${S_DNS2}  ${ipv6_addr}        ${ipv6_Gateway}
    Access Setting Page
    Access WAN
    Edit WWAN3
    Verify config WAN Static Ipv4    ${IPAddr}    ${IPGate}    ${Subnet}    ${S_DNS1}    ${S_DNS2}
    IF  $Service=='Dual stack'
		Verify WAN Stactic IPv6 Address and Gateway      ${ipv6_addr}        ${ipv6_Gateway}
    END

Verify delete Wan123 successfull
	Page Should Contain     WAN 3
	Page Should Contain     WAN 1
	Page Should Contain     WAN 1

    ############### Test #######################
*** Test case ***
Delete All Wan If Present
	Set Selenium Speed                  0.5
	Login to ONE Mesh                  ${OM_User}    ${OM_PW}
	Access Device detail OM            ${Serial}
	Go to Config WAN OM
	Log to console                      \n Delete All Wan if present

	${Stt_w1}                           Run Keyword And Return Status           Page Should Contain     WAN 1
	IF      ${Stt_w1}
		SL.Click Element               //*[@id="device-wan-tab"]/div/form/div/div[2]/div/div[1]/div/ul/li[1]/button
		Click Button Update Wan
		SL.Click Element           //*[@id="device-wan-tab"]/div/div[1]/div/div/div[2]/button[1]
		Sleep    10
	END	


	${Stt_w2}                           Run Keyword And Return Status           Page Should Contain     WAN 2
	IF      ${Stt_w2}
		SL.Click Element               //*[@id="device-wan-tab"]/div/form/div/div[4]/div/div[1]/div/ul/li[1]/button
		Click Button Update Wan
		SL.Click Element           //*[@id="device-wan-tab"]/div/div[1]/div/div/div[2]/button[1]
		Sleep    10
	END

		${Stt_w3}                           Run Keyword And Return Status           Page Should Contain     WAN 3
	IF      ${Stt_w3}
		SL.Click Element               //*[@id="device-wan-tab"]/div/form/div/div[5]/div/div[1]/div/ul/li[1]/button
				Click Button Update Wan
		SL.Click Element           //*[@id="device-wan-tab"]/div/div[1]/div/div/div[2]/button[1]
		Sleep    10
	END

	Verify delete Wan123 successfull
