*** Settings ***
Library                      SeleniumLibrary   run_on_failure=SL.Capture Page Screenshot    WITH NAME    SL
#Resource                     ../../SeleniumCommonLib.txt

*** Variables ***

*** Keywords ***
Open System Page
    log to console                          \nAccess to System Page
    SL.click element                         //*[@id="titleSystem"]
    SL.Wait Until Page Contains              Device Infomation

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
    SL.Click element                           //a[@title = "Adminstrator"]
    SL.Wait Until Page Contains                Administrator

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
*** Test Case ***
Thay doi mat khau dang nhap webGUI
    Open Browser                   https://192.168.88.1        firefox
    Run Keyword                                Open System Page
    Run Keyword                                Access Management
    Run Keyword                                Access Administrator
    Run Keyword                                Change Administrator Password        12345a@A    VNPT299Tech   VNPT299Tech
    Run Keyword                                Open System Page
