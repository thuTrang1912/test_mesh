*** Settings ***
Library                      SeleniumLibrary      WITH NAME    SL
Resource                     ../Selenium_lib/Login.robot
Resource                     ../Selenium_lib/Setting.robot

*** Variables ***
${User_N}
${PW}
*** Keywords ***
#Please reconnect wifi!
Access WAN
    SL.Wait Until Element Is Visible                   //*[@id="sub51"]
    SL.Click Element                                   //*[@id="sub51"]
    Sleep   5
    SL.Page Should Contain                             WAN Overview

Click Button Add Wan
	[Documentation]                                   Add Wan
	SL.Wait Until Element Is Visible            //input[@id='button_add_wan']
	SL.Click Element                            //input[@id='button_add_wan']

Select interface with VLAN ID
	[Arguments]                                 ${VlanID}
	Click Element                               //input[@id='check_interface_eth1.${VlanID}']
	Checkbox Should Be Selected                 //input[@id='check_interface_eth1.${VlanID}']


Edit WWAN0
    [Documentation]                                 Edit WAN Defaut
    SL.Wait Until Element Is Visible                   //img[@id='image_EditWan0']
    SL.Click Element                                   //img[@id='image_EditWan0']

Edit WWAN1
    [Documentation]                                 Edit WAN index 1
    SL.Wait Until Element Is Visible                   //img[@id='image_EditWan1']
    SL.Click Element                                   //img[@id='image_EditWan1']

Edit WWAN2
    [Documentation]                                 Edit WAN index 2
    SL.Wait Until Element Is Visible                  //img[@id='image_EditWan2']
    SL.Click Element                                   //img[@id='image_EditWan2']

Edit WWAN3
    [Documentation]                                 Edit WAN index 3
    SL.Wait Until Element Is Visible                   //img[@id='image_EditWan3']
    SL.Click Element                                   //img[@id='image_EditWan3']

##### Delete WAN
Click Button delete Wan
	[Arguments]                         ${index}
	SL.Click Element                    //img[@id='image_DeleteWan${index}']
	SL.Handle Alert
Delete Wan Index 
	[Documentation]                     Delete Wan Index i
	[Arguments]                         ${index}
	${stt}          Run Keyword And Return Status    Wait Until Element Is Visible    	//img[@id='image_DeleteWan${index}']
	Run Keyword If                      ${stt}
	...    Click Button delete Wan      ${index}



###########3 CONFIG WAN DHCP Clients ######################
Select Service
    [Documentation]                                 Select service for Wan
    ...                                             DHCP Client
    ...                                             Static
    ...                                             PPPoE
    [Arguments]                                     ${Servive_wan}
    Log To Console                  \nChoese Service WAN: ${Servive_wan}
    SL.Wait Until Element Is Visible                   //select[@id='Input_Service']
    ${value}            SL.Get Value   //option[contains(text(),"${Servive_wan}")]
    SL.Select From List By Value    //select[@id='Input_Service']          ${value}
    SL.Select From List By Label                       Input_Service                     ${Servive_wan}

Select IP version
    [Documentation]                                 Select IP version
    ...                                             IPv4
    ...                                             IPv6
    ...                                             Dual stack
   [Arguments]                                      ${IP_ver}
   Log To Console   \n Select IP Version: ${IP_ver}
   SL.Wait Until Element Is Visible                    //select[@id='Input_IPversion']
   ${value}             SL.Get Value                   //option[contains(text(),"${IP_ver}")]
   SL.Select From List By Value                        //select[@id='Input_IPversion']     ${value}

Select IPv6 Type
	[Documentation]                     Select IP version
	...                                 Auto
	...                                 Stateless Only
	...                                 Statefull Only
	[Arguments]                         ${IPv6_Type}
	${value}                            Get Value   //option[contains(text(),"${IPv6_Type}")]
	SL.Select From List By Value 	    //select[@id='ipv6_type']       ${value}

Input Primary DNS
   [Documentation]                                 Input Primary DNS
   [Arguments]                                      ${DNS1}= 1.1.1.1
   Log To Console                                   \nInput Pri DNS: ${DNS1}
   SL.Wait Until Element Is Visible                    //input[@id='Input_DNS_DHCP_ipv4']   5
   SL.Input Text                                       //input[@id='Input_DNS_DHCP_ipv4']         ${DNS1}

Input Second DNS
   [Documentation]                                 Input Primary DNS
   [Arguments]                                      ${DNS2}= 1.1.0.1
   Log To Console                                   \nInput Second DNS: ${DNS2}
   SL.Wait Until Element Is Visible                    //input[@id='Input_DNS_SECOND_DHCP_ipv4']    5
   SL.Input Text                                       //input[@id='Input_DNS_SECOND_DHCP_ipv4']         ${DNS2}

# //input[@id='Input_MTU']

 Input MTU size
   [Documentation]                                 Input MTU size
   [Arguments]                                      ${MTU}= 1500
   SL.Wait Until Element Is Visible                    //input[@id='Input_MTU']
   SL.Input Text                                       //input[@id='Input_MTU']        ${MTU}


Click button Edit Wan Defaul
    SL.Wait Until Element Is Visible                   Service : DHCP Client
    #click edit wan defaut
    SL.Click Element                                   //td[contains(text(),"br-wan" )]//following-sibling::td

Click button Edit WAN 123
    [Arguments]                                     ${Index_WAN}
    SL.Wait Until Element Is Visible                   //img[@id= 'image_EditWan${Index_WAN}']
    SL.Click Element                                   //img[@id= 'image_EditWan${Index_WAN}']

Click Button Delete WAN 123
    [Arguments]                                     ${Index_WAN}
    SL.Wait Until Element Is Visible                   //img[@id='image_DeleteWan${Index_WAN}']
    SL.Click Element                                   //img[@id='image_DeleteWan${Index_WAN}']

######################## CONFIG WAN PPPOE ###########################
Input PPPoE User Name
    [Arguments]                                     ${User_name}
    Log To Console    \n Input PPPoE User Name: ${User_name}
    SL.Wait Until Element Is Visible                   //input[@id='Input_Username']
    SL.Input Text                                      //input[@id='Input_Username']       ${User_name}

Input PPPoE Password
    [Arguments]                                     ${PW}
    Log To Console    \n Input PPPoE User Name: ${PW}
    SL.Wait Until Element Is Visible                //input[@id='Input_Password']
    SL.Input Text                                   //input[@id='Input_Password']       ${PW}
# ÌF IPversion = dual stack
Enable Defaul Route
	${stt}              Run Keyword And Return Status           SL.Checkbox Should Not Be Selected    //input[@id='Enable_Default_Route']
	  IF    ${stt}
	       Select Check box                         //input[@id='Enable_Default_Route']
	  END


######################## 3CONFIG WAN Static ###########################
# select Ip version
input IPv4 adress
    [Arguments]                                      ${IP_Adr}
    Log To Console           \n Input IPv4 Address:  ${IP_Adr}
    SL.Wait Until Element Is Visible                 //input[@id='Input_IPv4_Address']
    SL.Input Text                                    //input[@id='Input_IPv4_Address']           ${IP_Adr}

Input IPv4 Gateway
    [Arguments]                                      ${IP_Gategay}
    Log To Console           \n Input IPv4 Gateway:  ${IP_Gategay}
    SL.Wait Until Element Is Visible                //input[@id='Input_IPv4_Gateway']
    SL.Input Text                                   //input[@id='Input_IPv4_Gateway']           ${IP_Gategay}

Select Ipv4 Subnet Mark
    [Documentation]                                 Select Subnetmark
    ...                                             255.255.255.0
    ...                                             255.255.0.0
    ...                                             255.0.0.0
    [Arguments]                                     ${Subnetmark}
    Log To Console           \n Input Ipv4 SubNet Mark:  ${Subnetmark}
    SL.Wait Until Element Is Visible                //select[@id='Input_IPv4_Netmask']
    SL.Select From List By Value                    //select[@id='Input_IPv4_Netmask']      ${Subnetmark}
Input Primary DNS Ipv4
    [Arguments]                                     ${Pri_DNS}
    Log To Console           \n Input Ipv4 Pri DNS: ${Pri_DNS}
    SL.Input Text                      //input[@id='Input_DNS']    ${Pri_DNS}

Input Second DNS Ipv4
    [Arguments]                                     ${Sec_DNS}
    Log To Console                  \n Input Ipv4 Second DNS: ${Sec_DNS}
    SL.Input Text                      //input[@id='Input_DNS_SECOND']    ${Sec_DNS}

#Dual Stack or IPv6
Input IPv6 Address and Gateway
	[Arguments]                                 ${v6_Addr}      ${v6_Gate}
	SL.Wait Until Element Is Visible           	//input[@id='Input_IPv6_Address']
	SL.Input Text                               //input[@id='Input_IPv6_Address']    ${v6_Addr}
	SL.Wait Until Element Is Visible            //input[@id='Input_IPv6_Gateway']
	SL.Input Text                               //input[@id='Input_IPv6_Gateway']       ${v6_Gate}


##################### VERIFY AFTER CONFIG WAN #######################
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
    Should Match Regexp                             ${Act_service}       ${Service}
    Should Be Equal                                  ${IP_ver}       ${Act_IP_version}
    Should Be Equal                                 ${Primary DNS}   ${Act_DNS1}
    Should Be Equal                                 ${Second_DNS}    ${Act_DNS2}
Verify config WAN DHCP Dual Stack_ IPv6 Type
	[Arguments]                                     ${v6_type}
	${value}                                        SL.Get Selected List Label      //select[@id='ipv6_type']
	Log To Console                                  \nIPv6 Type:  ${value}
	Should Match                                    ${v6_type}    ${value}

Verify config WAN PPPoE
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
   Should Be Equal                                  ${IP_version}       ${Act_IP_version}
   Should Be Equal                                  ${User_name}       ${Act_User_name}
   Should Be Equal                                  ${PW}       ${Act_PW}
   Log To Console                                  \nConfig Wan PPPoE succesfully

Verify config WAN Static Ipv4
    [Arguments]                                     ${IPv4_adr}
    ...                                             ${Ipv4_GG}
    ...                                             ${Subnetmark}
    ...                                             ${DNS1}
    ...                                             ${DNS2}
    ${IPv4_adr_value}                               SL.Get Element Attribute          //input[@id='Input_IPv4_Address']     value
    ${IPv4_GG_value}                                SL.Get Element Attribute            //input[@id='Input_IPv4_Gateway']    value
    ${Subnetmark_value}                             SL.Get Selected List Label          //select[@id='Input_IPv4_Netmask']
    ${DNS1_value}                                   SL.Get Element Attribute            //input[@id='Input_DNS']      value
    ${DNS2_value}                                   SL.Get Value                        //input[@id='Input_DNS_SECOND']
    Log To Console                                  \nIPv4 Adr: ${IPv4_adr_value}
    Log To Console                                  \nIPv4 Gategay Adr: ${IPv4_GG_value}
    Log To Console                                  \nSubnetmark: ${Subnetmark_value}
    Log To Console                                  \nPrimary DNS: ${DNS1_value}
    Log To Console                                  \nSecond DNS: ${DNS2_value}
    Should Be Equal                                 ${IPv4_adr_value}    ${IPv4_adr}
    Should Be Equal                                 ${IPv4_GG_value}    ${Ipv4_GG}
    Should Be Equal                                 ${Subnetmark_value}    ${Subnetmark}
    Should Be Equal                                 ${DNS1_value}    ${DNS1}
    Should Be Equal                                 ${DNS2_value}    ${DNS2}
    Log To Console                                  \nConfig Wan Static Ipv4 succesfully


Verify WAN Stactic IPv6 Address and Gateway
	[Arguments]                                 ${v6_Addr}      ${v6_Gate}
	SL.Wait Until Element Is Visible           	//input[@id='Input_IPv6_Address']
	${Adr}                                      SL.Get Element Attribute    //input[@id='Input_IPv6_Address']    value
	SL.Wait Until Element Is Visible               //input[@id='Input_IPv6_Gateway']
	${Gate}                                     SL.Get Element Attribute     //input[@id='Input_IPv6_Gateway']   value
	Should Match    ${Adr}    ${v6_Addr}
	Should Match    ${Gate}     ${v6_Gate}
	Log To Console                              \n Config IPv6 successfully

