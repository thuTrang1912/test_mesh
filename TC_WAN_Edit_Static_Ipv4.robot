*** Settings ***
Library                      SeleniumLibrary         WITH NAME    SL
Library                      OperatingSystem
Library                      SSHLibrary
Library    AppiumLibrary
#Resource                     ../pythonProject/venv/lib/Selenium_lib/Setting_Wireless.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                     venv/lib/SSH_Lib/SSH_Connect_wifi.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_WAN.robot
Resource                     venv/lib/Variable.robot
*** Variables ***
${User_name}        root
${PW}               ttcn@99CN
${IP_ver}           Dual stack
${v6_addr}          2001:ee0:4102:878a:b0a2:eb58:f033:8d0
${v6_Gate}          fe80::561e:56ff:fe3b:3d3

*** Keywords ***
*** Test Cases ***
1. Open browser in local machine
    Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root                           ${PW}
2. Edit Wan default to PPoE
    SL.Set Selenium Speed   0.5
    Access Setting Page
    Access WAN
    Edit WWAN0
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
    SL.Click Button             //div[@id='button_apply_edit']//input[@type='button']
    Sleep    90
    Close Browser
3. Verify in webGUI
    SL.Set Selenium Speed   0.5
    Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root                           ${PW}
    Access Setting Page
    Access WAN
    Edit WWAN0
    Verify config WAN Static Ipv4    192.168.88.10    192.168.88.1    255.255.255.0    8.8.8.8    8.8.0.4
    IF  $IP_ver=='Dual stack'
		Verify WAN Stactic IPv6 Address and Gateway      ${v6_addr}      ${v6_Gate}
    END