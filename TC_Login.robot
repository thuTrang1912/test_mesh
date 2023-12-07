
*** Settings ***
Library                      SeleniumLibrary   run_on_failure=SL.Capture Page Screenshot    WITH NAME    SL
Library    OperatingSystem
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                     venv/lib/Variable.robot

*** Variables ***
@{Invalid_PW}=      12345    addfg12  #   12345abc    12345ABC    12345@@@    12345a@A&   12345a@A|   12345a@A;   12345a@A$   12345a@A>   12345a@A<   12345a@A`   12345a@A\   12345a@A!   12345a@A'   12345a@A"


*** Keywords ***
###Login

*** Test Cases ***
1. First Time Login WebGUI Shoud contain notify change PW
    Open Browser            https://192.168.88.1            ${Browser}
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         ${user_name}                  ${defaul_PW}
    Verify first Login Should contain Password change notifycation
2. Kiem tra thong bao khi doi mat khau moi sai dinh dang
	SL.Set Selenium Speed      0.3
    Log To Console                             \n Change PW invalid
	#Create List         @{Invalid_PW}= 12345    addfg12     12345abc    12345ABC    12345@@@    12345a@A&   12345a@A|   12345a@A;   12345a@A$   12345a@A>   12345a@A<   12345a@A`   12345a@A\   12345a@A!   12345a@A'   12345a@A"
    FOR    ${PW}    IN    @{Invalid_PW}
        #### Kiem tra neu o input text trong thi nhap thang, neu Khong thi clear text va handle Alert
        ${value}        Get Value              //input[@id='Text_NEW_PWD']
        ${Stt}          Run Keyword And Return Status           Should Not Be Empty        ${value}
        IF      ${Stt}
            Clear Element Text    xpath=//input[@id='Text_NEW_PWD']
            Handle Alert
        END
        Input New Password    $password= ${PW}
        SL.Click Button                           //input[@id='BTN_UpdatePWD']
        Should contain notification when changing invalid password
        SL.Handle Alert
    END
#    ${value}        Get Value              //input[@id='Text_NEW_PWD']
#    ${Stt}          Run Keyword And Return Status           Should Not Be Empty        ${value}
#    IF      ${Stt}
#            Clear Element Text    xpath=//input[@id='Text_NEW_PWD']
#            Handle Alert
#    END
    #Handle Alert
    #vong for khong co dau : nhe

    #### Kiem tra nhap CFM Password khi co majt khau khong hojp le
    FOR    ${PW}    IN    @{Invalid_PW}
        ${value}        Get Value              //input[@id='Text_CFM_NEW_PWD']
        ${Stt}          Run Keyword And Return Status           Should Not Be Empty        ${value}
        IF      ${Stt}
            Clear Element Text    //input[@id='Text_CFM_NEW_PWD']
            Handle Alert
        END
        Log To Console      \n Input Comfirm PW: ${PW}
        Input CFM NewPassword    $password= ${PW}
        SL.Click Button                           //input[@id='BTN_UpdatePWD']
        Should contain notification when changing invalid password
        SL.Handle Alert
    END
3. Kiem tra thay doi mat khau hop le
    Change Password First time login            ${PassWord}        ${PassWord}

4. Kiểm tra đăng nhập vào page bằng mật khẩu mới
    Open Browser in local machine             https://192.168.88.1            ${Browser}
	Chrome Pass Certificate google if present
    Login To WebGUI on local machine                 ${user_name}           ${PassWord}
    Verify login WebGUI Successfully
    Logout WebGUI
5. Kiểm tra đăng nhập WebGUi sai 3 lần
	SL.Set Selenium Speed        0.5
    Verify Massage when login Wrong password                ${user_name}        12345a2a        12345678        12345A@a


