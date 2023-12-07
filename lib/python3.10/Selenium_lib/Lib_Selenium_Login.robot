*** Settings ***
Library                      SeleniumLibrary            WITH NAME    SL
#run_on_failure=SL.Capture Page Screenshot
Library    OperatingSystem

*** Variables ***
@{Invalid_PW}

*** Keywords ***
###Login

Open Browser in local machine
    [Arguments]
    ...                                       ${url}
    ...                                       ${browser}
    SL.Open browser                           ${url}
    ...                                       ${browser}
Firefox Pass Certificate google if present
    ${Status1} =               Run Keyword And Return Status             SL.Wait Until Element Is Visible      id:\advanced_button     5
    Run Keyword If    ${Status1}
    ...    SL.Click Element        id:\advanced_button
    Sleep    2s

    ${Status2}=                Run Keyword And Return Status             SL.Wait Until Element Is Visible         id:\exception_button        5
    Run Keyword If    ${Status2}
    ...    SL.Click Element            id:\exception_button

Input User Name
    [Arguments]                               ${username}
    SL.Wait Until Element Is Visible          xpath=//input[@id='LOGIN_USER']
    SL.Input Text                             xpath=//input[@id='LOGIN_USER']      ${username}

Input password
    [Arguments]                               ${password}
    SL.Wait Until Element Is Visible          xpath=//input[@id='LOGIN_PWD']
    SL.Input Password                         xpath=//input[@id='LOGIN_PWD']    ${password}

SubMit Credentials
    SL.Wait Until Element Is Visible          xpath=//input[@id='BTN_Login']
    SL.Click Button                           xpath=//input[@id='BTN_Login']

Verify first Login Should contain Password change notifycation
    ${notify}=                                SL.Handle Alert
    Log To Console                             ${notify}
    Should Contain                             ${notify}    First time Login: Please update password



Page should contain Message for first time Login
    ${popup_message}=                         SL.Handle Alert         timeout=20s
    Should Contain                            ${popup_message}        First time Login: Please update password
    Log To Console                            Popup message: ${popup_message}

Verify login WebGUI Successfully
    Sleep  10
    SL.Page Should Contain Element               xpath= //a[@id='titleHome']

Logout WebGUI
    Wait Until Element Is Visible             //a[contains(text(),'Logout')]
    Click Element                             //a[contains(text(),'Logout')]
    Handle Alert

######### Verify
###Verify###

Login To WebGUI on local machine
    [Arguments]                               ${username}                             ${password}
    Input Username                            username=${username}
    Input Password                            password=${password}
    Submit Credentials
    Sleep                                     3s


Input New Password
    [Arguments]                               ${password}
    SL.Wait Until Element Is Visible          xpath=//input[@id='Text_NEW_PWD']
    SL.Input Password                         xpath=//input[@id='Text_NEW_PWD']    ${password}

Input CFM NewPassword
    [Arguments]                               ${CF_PW}
    SL.Wait Until Element Is Visible          xpath=//input[@id='Text_CFM_NEW_PWD']
    SL.Input Password                         xpath=//input[@id='Text_CFM_NEW_PWD']    ${CF_PW}

Change Password First time login
	[Documentation]					Change Password Login Of The First Login
    [Arguments]                               ${newPassword}   ${confirmPass}
    Sleep       10
    SL.Wait Until Element is visible          xpath=//input[@id='BTN_UpdatePWD']
    Clear Element Text                        xpath=//input[@id='Text_NEW_PWD']
    SL.Handle Alert
    Clear Element Text                        //input[@id='Text_CFM_NEW_PWD']
    SL.Handle Alert
    Input New Password                        ${newPassword}
    Input CFM NewPassword                     ${confirmPass}
    Click Element                             xpath=//input[@id='BTN_UpdatePWD']
    ${Alert}=                                 SL.Handle Alert
    Should Contain Any                        ${Alert}        Are you sure to change password ?
#    Run keyword                              Page should contain Message for first time Login



### Thay đổi mật khẩu đúng lần đầu
Change Administator Password
	[Arguments]                               ${newPassword}
	Input New Password                        ${newPassword}
    Input CFM NewPassword                     ${newPassword}
    Click Element                             xpath=//input[@id='BTN_UpdatePWD']
    ${Alert}=                                 SL.Handle Alert
    Should Contain Any                        ${Alert}        Are you sure to change password ?


Verify Massage when login Wrong password
    [Arguments]
    ...                                       ${username}
    ...                                       ${password_1}
    ...                                       ${password_2}
    ...                                       ${password_3}

    SL.Wait Until Element Is Visible          xpath=//input[@id='BTN_Login']
    ...                                       timeout=20s
    ...                                       error=\nLogin Page Does Not Found!
    Input Username                            username=${username}
    Input Password                            password=${password_1}
    Submit Credentials
    ${Alert1}=                                SL.Handle Alert
    Should Contain Any                        ${Alert1}                 Login Fail: Please enter correct password.
#    SL.Handle Alert

    #The second time
    Log To Console                            Input Wrong Password the second time
    SL.Wait Until Element Is Visible          xpath=//input[@id='BTN_Login']
    ...                                       timeout=20s
    ...                                       error=\nLogin Page Does Not Found!
    Input Username                            username=${username}
    Input Password                            password=${password_2}
    Submit Credentials
    ${Alert2}=                                SL.Handle Alert
    Should Contain Any                        ${Alert2}                 Login Fail: Please enter correct password.
#    SL.Handle Alert

    #The third time
    Log To Console                            Input Wrong Password the third time
    SL.Wait Until Element Is Visible          xpath=//input[@id='BTN_Login']
    ...                                       timeout=20s
    ...                                       error=\nLogin Page Does Not Found!
    Input Username                            username=${username}
    Input Password                            password=${password_3}
    Submit Credentials
    ${Alert3}=                                SL.Handle Alert
    Should Contain Any                        ${Alert3}                 Login Fail: Please enter correct password.
#    SL.Handle Alert
    ${Alert4}=                                SL.Handle Alert
    Should Contain Any                        ${Alert4}         Login disabled: Please wait 3 minutes then re-login !!
#    SL.Handle Alert
    #Check input text be disable
    Log To Console                            \nCheck the login button after logging in incorrectly 3 times
    SL.Element Should Be Disabled             xpath=//input[@id='BTN_Login']

    Sleep                                     180
    Log To Console                            \nCheck the login button after being Locked for 180s
    SL.Element Should Be Enabled              xpath=//input[@id='BTN_Login']

Should contain notification when changing invalid password
	[Documentation]					Change Password Login Of The First Login
    ${Notify}=                      SL.Handle Alert
    Log To Console                  ${Notify}
    Should Contain                  ${Notify}              Invalid password!


Chrome Pass Certificate google if present
    ${Status1} =               Run Keyword And Return Status             SL.Wait Until Element Is Visible      //button[@id="details-button"]    5
    Run Keyword If    ${Status1}
    ...    SL.Click Element        //button[@id="details-button"]
    Sleep    2s

    ${Status2}=                Run Keyword And Return Status             SL.Wait Until Element Is Visible         //a[@id="proceed-link"]      5
    Run Keyword If    ${Status2}
    ...    SL.Click Element            //a[@id="proceed-link"]

Login WebGUI
	[Arguments]                 ${Browser}      ${user_name}        ${Pw}
    SL.Open Browser            https://192.168.88.1            ${Browser}
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         ${user_name}                           ${Pw}

ReLogin WebGUI If Session Timeout
	[Arguments]                 ${Browser}      ${user_name}        ${Pw}
	${Stt}=              Run Keyword And Return Status        Wait Until Element Is Visible         xpath=//input[@id='LOGIN_USER']
	Run Keyword If     ${Stt}
	... 	Login WebGUI    ${Browser}      ${user_name}        ${Pw}