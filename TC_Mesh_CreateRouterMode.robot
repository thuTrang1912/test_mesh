*** Settings ***
Library                      SeleniumLibrary         WITH NAME    SL
#run_on_failure=SL.Capture Page Screenshot
Library                      OperatingSystem
Library                      SshLibrary
Library                     Collections
Resource                    venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                    venv/lib/Selenium_lib/Lib_Selenium_Meshpage.robot
Resource                    venv/lib/SSH_Lib/SSH_Connect_wifi.robot
Resource                    venv/lib/SSH_Lib/SSH_ping.robot
Resource                    venv/lib/Variable.robot
*** Variables ***

*** Keywords ***
Handle Alert If Present
    ${alert_text}=    SL.Handle Alert    DISMISS    2s
    Run Keyword If    '${alert_text}' != ''    Log    Dismissed user prompt dialog: ${alert_text}

*** Test Cases ***
1. Dang nhap WebGui
    SL.Open Browser          https://192.168.88.1            ${Browser}
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine                 ${User_name}           ${PassWord}
    Verify login WebGUI Successfully

#2.0 Get Info Mac
#	${CAP_Name_defautl}                    Get the dafaul Mesh Name
#	${CAP_Mac_Address}                     Get the Mesh Mac
#	Set Global Variable                    ${CAP_Name_defautl}
#	Set Global Variable                    ${CAP_Mac_Address}
2.1 Create Mesh Router Mode
	Set Selenium Speed   0.5
    Access Mesh Page
    Click Button Create Mesh NetWork        ${CAP_Name_defautl}
    Select Mesh Mode                        Router Mode
    Input Mesh SSID                         ${Mesh_SSID}
    Input WPA Passphrase                    ${Mesh_PW}
    Click Button Create(Apply)
    SL.Handle Alert
    Sleep                                   60s
    Chrome Pass Certificate google if present
    ReLogin WebGUI If Session Timeout    ${Browser}    ${user_name}    ${PassWord}
    SL.Reload Page
    Log To Console                           \n Reload page

    Log To Console                              \n Relogin WebGui and check Mesh Mode
    #Login To WebGUI on local machine            ${User_name}           ${PW}
2.2 Create Mesh Should Success
    Log To Console                              \nShould contain Network Name and Setting page
    Wait Until Element Is Visible                //label[@id='SHOW_DEVICE']
    Page Should Contain                          R1
    SL.Page Should Contain Element               //a[@id='titleSettingCap']
    Log To Console                              \n Kiem tra trang thai hoat dong mesh
    SL.Click Element                             //a[@id='titleSystem']
    SL.Wait Until Page Contains                  Mesh Central Access Point - CAP
    SL.Scroll Element Into View                  //label[@id='LB_WAN_IP']
    SL.Click Element                             //label[@id='LB_WAN_IP']
    SL.Wait Until Page Contains                  WAN Information

    ${Wan_status}=                              SL.Get Text        //label[@id='LB_WAN_STATUS']
    Log To Console                              \nWan Status :${Wan_status}
    Should Be Equal                             ${Wan_status}             Connected

    ${Wan_Intf}=                                SL.Get Text   //label[@id='LB_WAN_INTERFACE']
    Log To Console                              \nWan interface: ${Wan_Intf}
    Should Be Equal                              ${Wan_Intf}            br-wan

#3.1 Mesh add node
#	SL.Set Selenium Speed    0.5
#    Access Mesh Page
#    Run Keyword And Ignore Error        SL.Wait Until Element Is Visible               //tbody/tr[1]/td[1]/div[1]/img[1]
#    SL.Wait Until Element Is Visible               //tbody/tr[1]/td[1]/div[1]/img[1]
#    SL.Click Element                               //tbody/tr[1]/td[1]/div[1]/img[1]
#
#    #SL.Wait Until Page Contains                     1.Power on all new nodes
#    SL.Click Element                                //input[@onclick= 'AddNode(1)']
#
#    SL.Wait Until Page Contains                     2. Wait to finish booting up the new nodes: The System led is green bright
#    SL.Click Element                                //input[@onclick= 'AddNode(2)']
#
#    SL.Wait Until Page Contains                      3. Make sure that the new nodes are FACTORY state. If not, factory reset devices
#    SL.Click Element                                 //input[@value= 'Scan New Nodes']
#
#    SL.Wait Until Page Contains                       New Mesh nodes are trying to join your network            50
#    #${Status}=                                        Run Keyword And Return Status
#    SL.Wait Until Page Contains                       ${MRE_Mac_Adress}
#
#    Log To Console                                    \Add MRE have MAC Address is: ${MRE_Mac_Adress}
#    SL.Click Element                                  //td[contains(text(),'${MRE_Mac_Adress}')]//following-sibling::td//child::input
#    SL.Click Element                                  //input[@value='Add Node']
#
#3.2 Check info MRE in Topology After Add Node
#    Sleep      120s
#    Log To Console                                     \Check List Node should have MRE added
##    SL.Reload Page
##    Pass Certificate google
##    Login To WebGUI on local machine                    ${User_name}           ${PW}
#
#    SL.Wait Until Element Is Visible                    //img[@title = 'Detail Information']        10
#    SL.Click Element                                    //img[@title = 'Detail Information']
#    SL.Page Should Contain                              Mesh Devices Information
#    Log To Console                                      \Check the list of Mesh devices that have the information of the MRE just added
#    ...                                                 ${MRE_Mac_Adress}
#    SL.Page Should Contain                              CC:71:90:86:AF:28
#    SL.Page Should Contain                              ${MRE_Mac_Adress}
#    SL.Click Element                                    //td[contains(text(),'${MRE_Name_defautl}')]
#    ${Eth_MAC_Addr}                                     SL.Get Text    //label[@id='LB_ETHERNET_MAC']
#    Log To Console                                      \Ethernet MAC Address: ${Eth_MAC_Addr}
#    Should Match                                        ${Eth_MAC_Addr}            ${MRE_Mac_Adress}


4. Reconnect to Wifi With Correct Password and Check ping to Internet
	Sleep    50
    Open SSH Session Login To Local Machine
    Sleep    5
    SSH_Connect_wifi.Enable Wifi
    SSH_Connect_wifi.Delete All Wireless
    Wait Until Keyword Succeeds    180    5    SSH_Connect_wifi.Wifi Rescan Contain   ${Mesh_SSID}
    # Connect control PC to wifi
    ${wlan_interface}=                             	SSHL.Execute Command    nmcli --fields Device,Type device status | grep 'wifi' | awk '{print $1}'
    SSH_Connect_wifi.Connect To Wifi                                	${wlan_interface}    ${Mesh_SSID}    ${Mesh_PW}
    #check internet by Ping comment
    Ping From PC To         ${wlan_interface}               8.8.8.8
    SSH_ping.Ping Should Succeed    8.8.8.8   ${wlan_interface}












