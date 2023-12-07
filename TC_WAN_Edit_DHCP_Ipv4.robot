*** Settings ***
Library                      SeleniumLibrary         WITH NAME    SL
Library                      OperatingSystem
Library                      SSHLibrary
#Library    AppiumLibrary
#Resource                     ../pythonProject/venv/lib/Selenium_lib/Setting_Wireless.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                     venv/lib/SSH_Lib/SSH_Connect_wifi.robot
Resource    venv/lib/Selenium_lib/Lib_Selenium_WAN.robot
Resource    venv/lib/Variable.robot
*** Variables ***
${User_name}        root
${PW}               ttcn@99CN

${IP_ver}           Dual stack
${Ipv6_Type}        Auto
*** Keywords ***
*** Test Cases ***
1. Open browser in local machine
    Open Browser                https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root                           ${PW}
2. Edit Wan default to DHCP Client
    SL.Set Selenium Speed       0.5
    Access Setting Page
    Access WAN
    Edit WWAN0
    Select Service              DHCP Client
    Select IP version           ${IP_ver}
    Input Primary DNS           1.1.1.1
    Input Second DNS            1.1.0.1
    IF    $IP_ver == 'Dual stack'
        Select IPv6 Type    ${Ipv6_Type}
    END
    SL.Click Button         //input[@value='Next']
    SL.Click Button         //div[@id='button_apply_edit']//input[@type='button']
    Log To Console          \nConfig succesfully
    Sleep   90
    Close Browser
3 Verify in webGUI
    Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root                           ${PW}
    Access Setting Page
    Access WAN
    Edit WWAN0
    IF    $IP_ver == 'Dual stack'
        Verify config WAN DHCP Dual Stack_ IPv6 Type        ${Ipv6_Type}
    END
    Verify config WAN DHCP IPv4         DHCP Client         ${IP_ver}            1.1.1.1         1.1.0.1
4. Check the Mesh topo should has enough nodes
    Log To Console                         \Check whether the Mesh topology has enough nodes or not
    SL.Click Element                          //a[@id='titleHome']
    Sleep    5
    Page Should Contain                     ${CAP_Name}
#    ${Stt}                  Run Keyword And Return Status           Page Should Contain    ${MRE_Name}
#    IF    ${Stt}
#        Log To Console    \n MRE mat dong bo
#    ELSE
#         Log To Console   \n MRE dong bo thanh cong
#    END