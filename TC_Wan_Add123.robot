*** Settings ***
Library                      SeleniumLibrary         WITH NAME    SL
Library                      OperatingSystem
Library                      SSHLibrary
#Library    AppiumLibrary
#Resource                     ../pythonProject/venv/lib/Selenium_lib/Setting_Wireless.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                     venv/lib/SSH_Lib/SSH_Connect_wifi.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_WAN.robot
Resource                     venv/lib/Variable.robot
*** Variables ***
${IP_ver}                       IPv4
${Ipv6_Type}                    Auto
${v6_addr}                      2001:ee0:4102:878a:b0a2:eb58:f033:8d0
${v6_Gate}                      fe80::561e:56ff:fe3b:3d3
*** Keywords ***
##########
Add Wan DHCP Client
	[Arguments]                 ${IP_ver}
	...                         ${Ipv6_Type}= Auto
    Select Service              DHCP Client
    Select IP version           ${IP_ver}
    Input Primary DNS           1.1.1.1
    Input Second DNS            1.1.0.1
    IF    $IP_ver == 'Dual stack'
        Select IPv6 Type    ${Ipv6_Type}
    END
    SL.Click Button         //input[@value='Next']
    Sleep    3
    SL.Click Button         //div[@id='button_apply_add']//input[@type='button']


########
Add Wan PPPoE Vlan 11
	[Arguments]             ${IP_ver}
    Select Service      PPPoE
    Select IP version   ${IP_ver}
    Input PPPoE User Name       ansv
    Input PPPoE Password    nsi2
	IF    $IP_ver == 'Dual stack'
	    Enable Defaul Route
	END
    Sleep    5
    SL.Click Button         //input[@value='Next']
    SL.Click Button         //div[@id='button_apply_add']//input[@type='button']

#########
Add Wan Static Vlan 60
	[Arguments]         ${IP_ver}
	Select Service      Static
    Select IP version   ${IP_ver}
    input IPv4 adress           192.168.88.10
    Input IPv4 Gateway          192.168.88.1
    Select Ipv4 Subnet Mark     255.255.255.0
    Input Primary DNS Ipv4      8.8.8.8
    Input Second DNS Ipv4       8.8.0.4

    IF  $IP_ver=='Dual stack'
		Input IPv6 Address and Gateway      ${v6_addr}      ${v6_Gate}
    END

    Sl.Click Element            //div[@id='button_setting_basic']//input[@type='button']
    SL.Click Button             //div[@id='button_apply_add']//input[@type='button']


*** Test Cases ***
1. Open browser in local machine
    Open Browser                https://192.168.88.1            ${Browser}
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root   ${PassWord}
2. Add Wan DHCP Client IPv4
    SL.Set Selenium Speed       0.5
    Access Setting Page
    Access WAN
	Click Button Add Wan
	Select interface with VLAN ID    11
	Add Wan DHCP Client              ${IP_ver}
    Log To Console          \nConfig succesfully
    Sleep   90
    Close Browser
2.1 Verify Wan DHCP in WebGUI
	SL.Set Selenium Speed       0.5
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root                           ${PassWord}
    Access Setting Page
    Access WAN
    Edit WWAN1
    IF    $IP_ver == 'Dual stack'
        Verify config WAN DHCP Dual Stack_ IPv6 Type        ${Ipv6_Type}
    END
    Verify config WAN DHCP IPv4         DHCP Client         ${IP_ver}            1.1.1.1         1.1.0.1

3. Add Wan PPPoE Vlan 12
	SL.Set Selenium Speed       0.5
    Access Setting Page
    Sleep   10
    Access WAN
    Click Button Add Wan
    Select interface with VLAN ID    12
    Add Wan PPPoE Vlan 11       ${IP_ver}
    Log To Console          \nConfig succesfully
    Sleep   90
    Close Browser
3.1 Verify Add Wan PPPoE In WebGui
	Sleep   10
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root                    ${PassWord}
    Access Setting Page
    Access WAN
    Edit WWAN2
#    Verify config WAN PPPoE    PPPoE    ${IP_ver}    ansv    nsi2
4. Add Wan Static
	SL.Set Selenium Speed   0.5
	Access Setting Page
    Access WAN
    Click Button Add Wan
    Select interface with VLAN ID    160
    Add Wan Static Vlan 60    ${IP_ver}
    Sleep    90
    Close Browser
4.1 Verify Add Wan Static
	SL.Set Selenium Speed   0.5
    Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root                           ${PassWord}
    Access Setting Page
    Access WAN
    Edit WWAN3
    Verify config WAN Static Ipv4    192.168.88.10    192.168.88.1    255.255.255.0    8.8.8.8    8.8.0.4
    IF  $IP_ver=='Dual stack'
		Verify WAN Stactic IPv6 Address and Gateway      ${v6_addr}      ${v6_Gate}
    END

5. Delete Wan
	SL.Set Selenium Speed   0.5
	Access Setting Page
    Access WAN

    Delete Wan Index    3
    Wait Until Keyword Succeeds    120    10    SL.Handle Alert
    Access WAN

    Delete Wan Index    2
    Wait Until Keyword Succeeds    120    10    SL.Handle Alert
    Access WAN

    Delete Wan Index    1
    Sleep    10
    Wait Until Keyword Succeeds    120    10    SL.Handle Alert
    Access WAN

    SL.Page Should Contain    wan3
    SL.Page Should Contain    wan2
    SL.Page Should Contain    wan1
