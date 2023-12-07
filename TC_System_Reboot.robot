*** Settings ***
Library                      SeleniumLibrary         WITH NAME    SL
Library                      OperatingSystem
Library                      SSHLibrary
#Resource                     ../pythonProject/venv/lib/Selenium_lib/Setting_Wireless.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Login.robot
#Resource                     venv/lib/Selenium_lib/Lib_Selenium_WireLess.robot
#Resource                     venv/lib/SSH_Lib/SSH_Connect_wifi.robot
Resource                     venv/lib/Variable.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_SystemPage.robot
Resource                     venv/lib/Selenium_lib/SystemPage.robot


*** Variables ***
${New_PW_WebGUI}                    ttcn@99CN
*** Keywords ***
Open System Page
    log to console                           \nAccess to System Page
    SL.click element                         //*[@id="titleSystem"]
    #SL.Wait Until Page Contains              Device Infomation

Access Client Monitoring
    Log to console                            \nAccess Client Monitoring
    #Run Key word                               Open System Page
    SL.Click element                           //a[@title="Clients Monitoring"]
    SL.Wait Until Page Contains                 Connected Devices

Access Data Statistics
    Log to console                            \nData Satistics
    SL.Click element                           //a[@tille = "Data Statistics"]
    SL.Wait Until Page Contains                Statistic Tables

Access Management
    Log to console                            \nAccess System > Managerment
    SL.Click element                           //a[@id='titlemanagement']
    SL.Wait Until Page Contains                Reboot

Reboot Mesh
    Log to console                            \nAccess System > Managerment > rebot
    SL.Click element                           //a[@id='sub31']
    SL.Wait Until Page Contains                Reboot
    SL.Click Element                           //input[@id='reboot_device']
    SL.Handle Alert

Factory Reset
    Log to console                            \nAccess System > Managerment > Factory Reset
    SL.Click element                           //a[@title = "Factory Reset"]
    SL.Wait Until Page Contains                Factory Reset
    SL.Click Element                           //input[@id='reset_factory']
    SL.Wait Until Page Contains                WARNING: This will return all  settings to a default state. Any custom rules will be lost
    Sl.Handle Alert

Access Firmware Update
    Log to console                            \nAccess System > Managerment > Firmware Update
    SL.Click element                           //a[@title = "Firmware Upgrade"]
    SL.Wait Until Page Contains                Firmware Update


Access Backup and Restore
    Log to console                            \nAccess System > Managerment > Backup and Restore
    SL.Click element                           //a[@title = "Backup / Restore"]
    SL.Wait Until Page Contains                Backup and Restore
######Administrator
Access Administrator
    Log to console                            \nAccess System > Managerment > Asministrator
    SL.Click element                           //a[@id='sub35']
    SL.Wait Until Page Contains                Change Administrator Password

Change Administrator Password
     [Arguments]                               ${Old PW}          ${New_PW}     ${Confirm_PW}
     Log to console                            \nAccess Change Administrator Password
     SL.Click Element                          //input[@id='Text_OLD_PWD']
     SL.input Text                             //input[@id='Text_OLD_PWD']          ${Old PW}
     SL.input Text                             //input[@id='Text_NEW_PWD']          ${New_PW}
     SL.input Text                             //input[@id='Text_CFM_NEW_PWD']       ${Confirm_PW}
     SL.Click Element                          //input[@id='BTN_UpdatePWD']
     SL.Handle Alert
     ${Stt}                                     SL.Handle Alert
     Should Match                               ${Stt}    Successfully updated Password./re-login
Should Return to the login page After change PW
	Sleep    10
	Element Should Be Visible                   //input[@id='LOGIN_USER']

Get MRE IP Address
	[Arguments]                                         ${MRE_Name_defautl}

    SL.Wait Until Element Is Visible                    //img[@title = 'Detail Information']        10
    SL.Click Element                                    //img[@title = 'Detail Information']
    SL.Page Should Contain                              Mesh Devices Information
    Log To Console                                      \Check the list of Mesh devices that have the information of the MRE just added
    ...                                                 ${MRE_Mac_Adress}
    SL.Page Should Contain                              ${MRE_Name_defautl}
    SL.Click Element                                    //td[contains(text(),'${MRE_Name_defautl}')]
    Page Should Contain                                 Operation Mode
    ${MRE_IP}                                           SL.Get Text        //label[@id='LB_IP_ADDRESS']
    [Return]                                            ${MRE_IP}

*** Test Cases ***
0.Get MRE's IP address
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root   ${PassWord}
    Verify login WebGUI Successfully
    ${MRE_IP}                       Get MRE IP Address      ${MRE_Name_defautl}
    Set Global Variable             ${MRE_IP}

2. Reboot Cap
	Set selenium Speed              0.5
	Open System Page
	Access Management
	Reboot Mesh
	Close Browser
	
3. Reboot MRE
	Set Selenium Speed                      0.5
	Open Browser                            https://${MRE_IP}          chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root   ${PassWord}
    SL.Handle Alert
    Login To WebGUI on local machine         root   ${PassWord}
    Verify login WebGUI Successfully
    Set selenium Speed                       0.5
	Open System Page
	Access Management
	Reboot Mesh
	Close Browser


	
