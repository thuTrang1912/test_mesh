*** Settings ***
Library                      SeleniumLibrary         WITH NAME    SL
Library                      OperatingSystem
Library                      SSHLibrary
Library    AppiumLibrary
#Resource                    ../pythonProject/venv/lib/Selenium_lib/Setting_Wireless.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                     venv/lib/SSH_Lib/SSH_Connect_wifi.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_WAN.robot
Resource                     venv/lib/Variable.robot
*** Variables ***
${User_name}        root
${PW}               ttcn@99CN

${IP_ver}           Dual stack
*** Keywords ***
Open SSH Session Login To Local Machine
    SSHL.Open Connection        ${ssh_server_IP}
    ${login_output}             SSHL.Login                ${ssh_server_username}        ${ssh_server_PW}
    Should Contain              ${login_output}     ${ssh_server_username}
    SSHL.Execute Command         sudo su
    SSHL.Write    1

Ping From PC To
    [Documentation]         SSH to remote machine to ping to an address. Return True if ping succeed, else return False
    ...                     Input:
    ...                     1. ping_address
    ...                     Return:
    ...                     1. True or False

    [Arguments]             ${ping_address}    ${network_interface}
    ${ping_output}     ${ping_error}      ${ping_rc}=         SSHL.Execute Command    ping -i 0.3 ${ping_address} -c 5 -I ${network_interface}    return_rc=True    return_stderr=True
    Log To Console    Ping output: ${ping_output}
    Log To Console    Ping error: ${ping_error}
    ${isPingFailed}=        Run Keyword And Return Status     Should Contain    ${ping_output}    100% packet loss
    Return From Keyword If    '${isPingFailed}' == 'True' or '${ping_rc}' != '0'    False
    [Return]   True

Check Connected To Interface
    [Documentation]         Verify connect successfully to Mesh via LAN connection.
    ...                     Input:
    ...                     1. network_interface

    [Arguments]             ${network_interface}

    ${ifconfigOut}=         SSHL.Execute Command    ifconfig ${network_interface} | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'
    ${return}=              Should Match Regexp     ${ifconfigOut}    [0-9]{1,3}\\.+[0-9]{1,3}\\.+[0-9]{1,3}\\.+[0-9]{1,3}

    Log To Console          PC Get IP Address on interface ${network_interface}: ${return}
Verifi config wan PPPoE has IP
    ${name}     SL.Get Text         //label[@id='LB_WAN_INTF']
    Should Match    ${name}    pppoe-wan
    ${service_name}         SL.Get Text             	//label[@id='LB_WAN_SERIVCE']
    Should Match    ${service_name}    PPPoE   
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
    Select Service      PPPoE
    Select IP version   ${IP_ver}
    Input PPPoE User Name       ansv
    Input PPPoE Password    nsi2
	IF    $IP_ver == 'Dual stack'
	    Enable Defaul Route
	END
    Sleep    5
    SL.Click Button         //input[@value='Next']
    SL.Click Button         //div[@id='button_apply_edit']//input[@type='button']
    Sleep    90
    Close Browser
3. Verify in webGUI
    Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root                           ${PW}
    Access Setting Page
    Access WAN
    Edit WWAN0
    Verify config WAN PPPoE    PPPoE    ${IP_ver}    ansv    nsi2
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


