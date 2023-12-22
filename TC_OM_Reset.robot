*** Settings ***
Library                      SeleniumLibrary            WITH NAME    SL
#run_on_failure=SL.Capture Page Screenshot
Library                 OperatingSystem
Library                  XML
Library                  String     WITH NAME    STR
Library                  Collections
Library    AppiumLibrary
Resource                 lib/Selenium_lib/OMesh.robot
#Resource                 MeshAP/venv/lib/Selenium_lib/OMesh.robot
Resource                 lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                 lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                 lib/Variable.robot
Resource                 lib/Selenium_lib/Lib_Selenium_WAN.robot
Resource    lib/SSH_Lib/SSH_Connect_wifi.robot

*** Variables ***
${OM_User}          one
${OM_PW}                one@2019
${Serial}               52dc

*** Test Cases ***
Reset Factory
	Set Selenium Speed                  0.5
	Login to ONE Mesh                  ${OM_User}    ${OM_PW}
	Access Device detail OM            ${Serial}
	SL.Click Element                       //span[contains(text(),'Reset Factory')]
	SL.Click Element                    //body[contains(@class,'pace-done modal-open')]/div[contains(@class,'page-header page-header-xs')]/div[contains(@class,'page-header-content')]/div[contains(@class,'modal fade modalResetFactory in')]/div[contains(@class,'modal-dialog modal-sm')]/div[contains(@class,'modal-content')]/div[contains(@class,'modal-footer text-center')]/button[1]

Verify on WebGUI
	Sleep     180
    Open Browser            https://192.168.88.1            chrome
    Chrome Pass Certificate google if present
    Verify first Login Should contain Password change notifycation

