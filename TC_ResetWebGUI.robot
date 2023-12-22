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

*** Test case ***
0.Get MRE's IP address
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root   ${PassWord}
    Verify login WebGUI Successfully
    ${MRE_IP}                       Get MRE IP Address      ${MRE_Name_defautl}
    Set Global Variable             ${MRE_IP}
1. Reset CAP
	Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         root   ${PassWord}
    Verify login WebGUI Successfully
    Access Management
    Factory Reset
2. Verify reset should successfully on WebGUI
	Sleep     180
    Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Verify first Login Should contain Password change notifycation