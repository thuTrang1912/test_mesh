*** Settings ***
Library                      SeleniumLibrary         WITH NAME    SL
#run_on_failure=SL.Capture Page Screenshot
Library                      OperatingSystem
Library                      SshLibrary
Library    Collections
Resource                    venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                    venv/lib/Selenium_lib/Lib_Selenium_Meshpage.robot
Resource                    venv/lib/SSH_Lib/SSH_Connect_wifi.robot
Resource                    venv/lib/SSH_Lib/SSH_ping.robot
Resource                    venv/lib/Variable.robot

*** Keywords ***

*** Test Cases ***
*** Test Cases ***
### test cam lan vao IP can Join
1. Dang nhap WebGui
    Open Browser            https://192.168.88.1            ${Browser}
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         ${user_name}                  ${defaul_PW}
    Verify first Login Should contain Password change notifycation
    Change Administator Password            ${PassWord}
    Reload Page
    Login To WebGUI on local machine         ${user_name}                  ${PassWord}
    Verify login WebGUI Successfully
2. Join Mesh Manual
	Set Selenium Speed   0.5
    Access Mesh Page
	Click Button Join Mesh NetWork
	Join Mesh by Search            ${Mesh_SSID}        ${Mesh_PW}
	Sleep       90
	Close Browser

3. Reconnect wifi and check MRE info
	Sleep   60
	SL.Set Selenium Speed    0.5
	Open Browser            https://192.168.88.1            ${Browser}
	Chrome Pass Certificate google if present
	Login To WebGUI on local machine         ${user_name}                  ${PassWord}
	Verify in Topology have MRE Info        ${MRE_Name_defautl}         ${MRE_Mac_Adress}