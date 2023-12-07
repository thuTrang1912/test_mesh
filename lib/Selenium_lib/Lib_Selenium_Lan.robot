*** Settings ***
Library                      SeleniumLibrary         WITH NAME    SL
Library                      OperatingSystem
Library                      SSHLibrary
#Library    AppiumLibrary
#Resource                     ../pythonProject/venv/lib/Selenium_lib/Setting_Wireless.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                     venv/lib/SSH_Lib/SSH_Connect_wifi.robot
Resource                     venv/lib/Variable.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_LAN.robot
*** Variables ***
${LAN_IP_version}                       IPv4 Only

*** Keyword ***
Open LAN Setting
    Access Setting Page
    SL.Wait Until Element Is Visible               //a[@id='sub52']
    SL.Click Element                               //a[@id='sub52']
    Sleep   5
    SL.Page Should Contain                         LAN Overview

Config IP_version
	[Arguments]                                 ${IP_version}
    SL.Wait Until Element Is Visible                //select[@id='Input_IPversion']
    Log To Console                               \nConfig Ip version ${IP_version} for AP Mesh
    SL.Select From List By Label                    //select[@id='Input_IPversion']         ${IP_version}

Config IPv4 Adress
	[Arguments]                                      ${IPv4_Adr}
    SL.Wait Until Element Is Visible                //input[@id='Input_IPv4_Address']
    Log To Console                                \n Config Ipv4 Address ${IPv4_Adr} for AP Mesh
    SL.Clear Element text                                       //input[@id='Input_IPv4_Address']
    SL.Handle Alert
    SL.Input Text                                    //input[@id='Input_IPv4_Address']     ${IPv4_Adr}

Config Subnet Mark Ipv4
	[Arguments]                                    ${Subnet_mark}
    Log To Console                               \n Config Subnetmark ${Subnet_mark} for Ap Mesh
    SL.Wait Until Element Is Visible                 //select[@id='Input_IPv4_Netmask']
    SL.Select From List By Value                     //select[@id='Input_IPv4_Netmask']    ${Subnet_mark}

Click Button Next Basic
    Log To Console                                \n Next
    SL.Wait Until Element Is Visible            //input[@value='Next']
    SL.Click Element                            //input[@value='Next']

##### dhcp###########
Config IPv4 start Address
   [Arguments]                                      ${Start_IPAdr}
   SL.Wait Until Element Is Visible                 //input[@id='Input_Start_IP']
   SL.Clear Element Text                            //input[@id='Input_Start_IP']
   SL.Handle Alert
   SL.Input Text                                    //input[@id='Input_Start_IP']    ${Start_IPAdr}

Config Number IP Address
	[Arguments]                                     ${Num_IPAdr}
   SL.Wait Until Element Is Visible                 //input[@id='Input_Number_IP']
   SL.Clear Element Text                            //input[@id='Input_Number_IP']
   SL.Handle Alert
   Sleep   3
   SL.Input Text                                    //input[@id='Input_Number_IP']      ${Num_IPAdr}

Config Lease Time
	[Arguments]                                      ${LeaseTime}
   SL.Wait Until Element Is Visible                  //input[@id='Input_Lease_Time']
   SL.Clear Element Text                             //input[@id='Input_Lease_Time']
   SL.Handle Alert
   SL.Input Text                                     //input[@id='Input_Lease_Time']     ${LeaseTime}

Click Button DHCP Next
	Log To Console                                \n Next
    SL.Wait Until Element Is Visible            //div[@id='button_setting_dhcp']//input[@type='button']
    SL.Click Element                            //div[@id='button_setting_dhcp']//input[@type='button']
###################  CONFIG BASIC LAN SETTING ####################
Config basic LAN IPv4 Only
    [Arguments]                                 ${IP_version}= IPv4 Only
    ...                                         ${IPv4_Adr}= 192.168.99.1
    ...                                         ${Subnet_mark}= 255.255.255.0
    Log To Console                              Setup ipv4 dhcp    console=true

	Config IP_version                               ${IP_version}
	Config IPv4 Adress                              ${IPv4_Adr}
	Config Subnet Mark Ipv4                         ${Subnet_mark}
	Click Button Next Basic

Verify Config Basic LAN IPv4
	[Arguments]                                 ${IP_version}
    ...                                         ${IPv4_Adr}
    ...                                         ${Subnet_mark}

    ${IP_ver}                                   SL.Get Selected List Label              //select[@id='Input_IPversion']
    ${Ip_add}                                   SL.Get Value           //input[@id='Input_IPv4_Address']
    ${NetMark}                                  SL.Get Selected List Value         //select[@id='Input_IPv4_Netmask']
    Log To Console                              \n IP version: ${IP_ver}
    Log To Console                              \n IP Address: ${Ip_add}
    Log To Console                              \n SubNet Mark: ${NetMark}
    Should Match                                ${IP_ver}       ${IP_version}
    Should Match                                ${Ip_add}       ${IPv4_Adr}
    Should Match                                ${NetMark}      ${Subnet_mark}


Config DHCP LAN Ipv4 only
##${Num_IPAdr}
    [Arguments]                                  ${Start_IPAdr}      ${LeaseTime}
    Log To Console                               \n Config LAN DHCP Ipv4 Only
    Log to console                             \n Config Start IP Address: ${Start_IPAdr}
	Config IPv4 start Address                    ${Start_IPAdr}
	#Config Number IP Address                        ${Num_IPAdr}
	Log to console                             \n Config Start Lease Time: ${LeaseTime}
	Config Lease Time                           ${LeaseTime}
	Click Button DHCP Next

Verify config DHCP LAN IPv4
	[Arguments]                                  ${Start_IPAdr}              ${LeaseTime}
	#${Num_IPAdr}

    ${Start}                                    SL.Get Element Attribute          //input[@id='Input_Start_IP']     value
    #${Num}                                      SL.Get Element Attribute           //input[@id='Input_Number_IP']    value
    ${Time}                                     SL.Get Element Attribute           //input[@id='Input_Lease_Time']  value
    Log To Console                              \n Start IP: ${Start}
    #Log To Console                              \n Number IP: ${Num}
    Log To Console                              \n Lease: ${Time}
    Should Match                               ${Start}       ${Start_IPAdr}
    #Should Match                               ${Num}       ${Num_IPAdr}
    Should Match                               ${Time}      ${LeaseTime}




Config Advance LAN IPv4 Only
    [Arguments]                                     ${mtu_sz}= 1500
    SL.Wait Until Element Is Visible                   //input[@id='Input_MTU']
    SL.Clear Element Text                              //input[@id='Input_MTU']
    SL.Handle Alert
    SL.Input Text                                      //input[@id='Input_MTU']            ${mtu_sz}

    Log To Console                                \n Next
    SL.Wait Until Element Is Visible            //div[@id='button_edit_dhcp']//input[@type='button']
    SL.Click Element                            //div[@id='button_edit_dhcp']//input[@type='button']


##################### CONFIG LAN IPV6 ######################################
Config basic LAN IPv6 Only
    [Arguments]                                     ${Ipversion}= IPv6 Only
    Wait Until Element Is Visible                   //select[@id='Input_IPversion']
    Select From List By Label                       //select[@id='Input_IPversion']     ${Ipversion}

Config DHCP LAN Ipv6 only
   [Documentation]                              DHCP mode
   ...                                          Stateless Only
   ...                                          Statefull Only
   ...                                          Stateless + Statefull
   [Arguments]                                  ${DHCP_Mode}      ${Pri_DNS}        ${Sec_DNS}
   Log To Console                               \n Config LAN DHCP Ipv6 Only

   Log To Console                               \n Config DHCPv6 mode
   Wait Until Element Is Visible                //select[@id='Input_DHCP_Mode_v6']
   Select From List By Label                    //select[@id='Input_DHCP_Mode_v6']      ${DHCP_Mode}

   Run Keyword If Test Passed                   Element Should Be Visible       //input[@id='Input_Pri_V6']
            Input Text                          //input[@id='Input_Pri_V6']             ${Pri_DNS}
            Input Text                          //input[@id='Input_Second_V6']          ${Sec_DNS}

##################### CONFIG LAN Dualstack ######################################
Config basic LAN DuaL Stack
    [Arguments]                                     ${Ipversion}=Dual Stack
    ...                                             ${IPv4_Adr}= 192.168.99.1
    ...                                             ${Subnet_mark}= 255.255.255.0
    Wait Until Element Is Visible                   //select[@id='Input_IPversion']
    Select From List By Label                       //select[@id='Input_IPversion']     ${Ipversion}

    Wait Until Element Is Visible                //input[@id='Input_IPv4_Address']
    Log To Console                               \n Config Ipv4 Address ${IPv4_Adr} for AP Mesh
    Input Text                                    //input[@id='Input_IPv4_Address']     ${IPv4_Adr}

    Log To Console                               \n Confif Subnetmark ${Subnet_mark} for Ap Mesh
    Wait Until Element Is Visible                 //select[@id='Input_IPv4_Netmask']
    Select From List By Value                     //select[@id='Input_IPv4_Netmask']    ${Subnet_mark}

Config DHCP server LAN DuaL Stack
    [Arguments]                                       ${Start_IPAdr}      ${Num_IPAdr}        ${LeaseTime}
    ...                                               ${DHCP_Mode}      ${Pri_DNS}        ${Sec_DNS}
    Config DHCP LAN Ipv4 only                         ${Start_IPAdr}              ${LeaseTime}
    #${Num_IPAdr}
    Config DHCP LAN Ipv6 only                         ${DHCP_Mode}      ${Pri_DNS}        ${Sec_DNS}


######################### Te