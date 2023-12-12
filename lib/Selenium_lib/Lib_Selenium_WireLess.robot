*** Settings ***
Library                      SeleniumLibrary    WITH NAME    SL
Library    XML
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Login.robot

*** Variables ***
${User_N}
${PW}
*** Keywords ***
Access Setting Page
    SL.Click Element                       xpath= //a[@id='titleSettingCap']

################# Radio ###########################
Click Button Edit Radio 2.4
	Wait Until Element Is Visible           //input[@id='EditRadio2']
	Click Element                           //input[@id='EditRadio2']
Click Button Edit Radio 5G
	Wait Until Element Is Visible           //input[@id='EditRadio5']
	Click Element                           //input[@id='EditRadio5']

############## CHANNLEL ###################
Config Chanel 2.4G
   [Arguments]                              ${chanel}= AUTO
   Wait Until Element Is Visible            //select[@id='2G_Select_Channel']
   ${Chanel2_value}=                        Get Value           xpath= //option[@value= "${chanel}"]
   Select From List By Value                //select[@id='2G_Select_Channel']           ${Chanel2_value}

Get Chanel 2.4
    ${chanel_value}=                        Get Value       //select[@id='2G_Select_Channel']
    ${chanel_text}=                         Get Text        //option[@value="${chanel_value}"]
    Return From Keyword                     ${chanel_text}


Config Chanel 5G
    [Arguments]                             ${chanel}= AUTO
   Wait Until Element Is Visible            //select[@id='5G_Select_Channel']
   ${Chanel5_value}=                        Get Value           xpath= //option[@value= "${chanel}"]
   Select From List By Value                //select[@id='5G_Select_Channel']           ${Chanel5_value}

Get Chanel 5G

    ${chanel_value}=                    Get Value       //select[@id='5G_Select_Channel']
    ${chanel_text}=                     Get Text        //option[@value="${chanel_value}"]
    Return From Keyword                 ${chanel_text}


####### ####### WIRELESS MODE ###################
Config Wifi Standard 2G
	[Documentation]                     11g
	...                                 11ng
	...                                 11ax
    [Arguments]                         ${SD_2}= ax
    Wait Until Element Is Visible       //select[@id='2G_Select_WLAN_Mode']
    ${ST_value}                         Get Value           //option[contains(text(),"${SD_2}")]
    Select From List By Value           //select[@id='2G_Select_WLAN_Mode']      ${ST_value}
#    Select From List By Label/VALUE    id, hoac clas,..          GIA TRI

Get wifi standard 2G
    ${WL_Mode}                          Get Selected List Label             //select[@id='2G_Select_WLAN_Mode']
#    ${WL_Mode}=                         Get Value       //select[@id='2G_Select_WLAN_Mode']
#    ${WL_text}=                         Get Text        //option[@value="${WL_Mode}"]
    Return From Keyword                 ${WL_Mode}

Config Wifi Standard 5G
    [Arguments]                         ${SD_5}= ax
    Wait Until Element Is Visible       //select[@id='5G_Select_WLAN_Mode']
#    ${ST_value}=                         Get Element Attributes           //option[contains(text(),"${SD_5}")][1]       id
#    Select From List By Value           //select[@id='5G_Select_WLAN_Mode']      ${ST_value}
    Select From List By Label            //select[@id='5G_Select_WLAN_Mode']         ${SD_5}

Get wifi standard 5G
    ${WL5_Mode}=                        Get Value       //select[@id='5G_Select_WLAN_Mode']
    ${WL5_text}=                        Get Text        //option[@value="${WL5_Mode}"]
    Return From Keyword                 ${WL5_text}

####### BANDWIDH ###################
Config BW Radio 2G
	[Documentation]                     20 MHz
    ...                                 40 MHz
    ...                                 20/40 MHz

    [Arguments]                         ${BW_2}
    SL.Wait Until Element Is Visible       xpath= //select[@id='2G_Select_Bandwidth']
    ${BW2_value}=                        Get Value           xpath= //option[contains(text(),"${BW_2}")]
    SL.Select From List By Value           xpath= //select[@id='2G_Select_Bandwidth']      ${BW2_value}

Get BW Radio 2.4
    ${BW_value}=                        Get Value       //select[@id='2G_Select_Bandwidth']
    ${BW_text}=                         Get Text        //option[@value="${BW_value}"]
    Return From Keyword                 ${BW_text}

Config BW Radio 5G
    [Arguments]                         ${BW_5}
    Wait Until Element Is Visible       xpath= //select[@id='5G_Select_Bandwidth']
    ${BW5_value}                         Get Value           xpath= //option[contains(text(),"${BW_5}")]
    Select From List By Value           xpath= //select[@id='5G_Select_Bandwidth']      ${BW5_value}

Get BW Radio 5G
    ${BW5_text}                         Get Selected List Label    	//select[@id='5G_Select_Bandwidth']
    Return From Keyword                 ${BW5_text}

################# Wireless ##########################
Go to Wireless
    SL.Wait Until Element Is Visible       xpath= //a[@id='titlewlancap']              20
    SL.Click Element                       xpath= //a[@id='titlewlancap']
    SL.Page Should Contain                 SSID
#    //a[@title='Wireless']
#    //a[@id='titlewlancap']
Access Wireless Radio 2.4G
    Go to Wireless

Access Wireless Radio 5G
    Go to Wireless
    Click Element                       //a[contains(text(),'Radio 5 GHz')]

Open SSID Configuration
    SL.Scroll Element Into View            //a[@id='sub62']
    SL.Click Element                       //a[@id='sub62']
    SL.Page Should Contain                 SSID Configuration

Change SSID and PW to
    [Documentation]                     Change SSID and PW to
    [Arguments]                         ${New_SSID}             ${New_PW}

    log To Console                      Change SSID to: ${New_SSID}
    Wait Until Element Is Visible       xpath= //input[@id='Input_SSID']
    Clear Element Text                  //input[@id='Input_SSID']
    SL.Handle Alert
    Input Text                          //input[@id='Input_SSID']     ${New_SSID}

    Log To Console                      Change Pw to : ${New_PW}
    Clear Element Text                  //input[@id='Input_WPA_passphrase']
    SL.Handle Alert
    Input Text                          //input[@id='Input_WPA_passphrase']    ${New_PW}
    Click Button                        //input[@id='button_ApplySSID']
    Log To Console                      \Changing SSID and Password

Get SSID from webUI
   ${SSID_value}=                      Get Element Attribute               //input[@id='Input_SSID']           value
   Return From Keyword                  ${SSID_value}

Get PW from webUI
   ${PW_value}=                         Get Element Attribute     //input[@id='Input_WPA_passphrase']       value
   Return From Keyword                  ${PW_value}

Select Wireless Security
    [Documentation]                     Select Wireless Security
    ...                                 WPA-PSK
    ...                                 WPA2-PSK
    ...                                 WPA-PSK/WPA2-PSK Mixed Mode
    ...                                 WPA3-SAE
    ...                                 WPA3-SAE/WPA2-PSK Mixed Mode
    [Arguments]                         ${Mode}
    SL.Wait Until Element Is Visible       xpath= //select[@id='Select_Security_Mode']
    ${Mode_value}=                      SL.Get Value   //option[contains(text(), "${Mode}")][1]
    SL.Select From List By Value           xpath= //select[@id='Select_Security_Mode']        ${Mode_value}

Get Wireless Security Mode
    ${Mode}                              SL.Get Selected List Label             //select[@id='Select_Security_Mode']
    Return From Keyword                  ${Mode}

Open Wireless Guest SSID 2.4G Setting
    Go to Wireless
    Wait Until Element Is Visible        xpath = //a[@title='Guest SSID']
    Click Element                        xpath = //a[@title='Guest SSID']

Open Wireless Guest SSID 5G Setting
    Go to Wireless
    Wait Until Element Is Visible        xpath = //a[@title='Guest SSID']
    Click Element                        xpath = //a[@title='Guest SSID']
    Log To Console                       \n Go to Guest 5g setting
    Wait Until Element Is Visible        xpath= //a[contains(text(),'Guest 5 GHz')]
    Click Element                        xpath =//a[contains(text(),'Guest 5 GHz')]

Enable Guest SSID 2.4G
    Select Checkbox               //input[@id='enable_guest_2g']
    Page Should Contain Element          //input[@id='Input_SSID']
    Page Should Contain Element         //select[@id='Select_Network_Authen']

Enable Guest SSID 5G
    Select Checkbox               xpath= //input[@id='5G_Enable_Guest']
    Page Should Contain Element          xpath= //input[@id='5G_Input_SSID']

#Create Guest 2.4g
#    [Documentation]                     Create Guest 2.4g
#    ...                                 OPEN
#    ...                                 WPA-PSK
#    ...                                 WPA2-PSK
#    ...                                 WPA-PSK/WPA2-PSK Mixed Mode
#    ...                                 WPA3-SAE
#    ...                                 WPA3-SAE/WPA2-PSK Mixed Mode
#    ...                                 WPA3-OWE
#    [Arguments]                          ${Guest_SSID}     ${Authen_mode}     ${Guest_PW}
#    Input Text                            //input[@id='Input_SSID']       ${Guest_SSID}
#    Wait Until Element Is Visible       xpath= //select[@id='Select_Network_Authen']
#    IF      '${Authen_mode}'=='OPEN'
#        Select From List By Value    xpath= //select[@id='Select_Network_Authen']         0
#
#    ELSE IF     '${Authen_mode}'=='WPA-PSK'
#        Select From List By Value    xpath= //select[@id='Select_Network_Authen']         1
#
#    ELSE IF     '${Authen_mode}'=='WPA2-PSK'
#         Select From List By Value    xpath= //select[@id='Select_Network_Authen']        2
#
#    ELSE IF     '${Authen_mode}'=='WPA-PSK/WPA2-PSK Mixed Mode'
#        Select From List By Value    xpath= //select[@id='Select_Network_Authen']         3
#
#    ELSE IF     '${Authen_mode}'=='WPA3-SAE'
#        Select From List By Value    xpath= //select[@id='Select_Network_Authen']         4
#
#    ELSE IF     '${Authen_mode}'=='WPA3-SAE/WPA2-PSK Mixed Mode'
#        Select From List By Value    xpath= //select[@id='Select_Network_Authen']         5
#
#    ELSE IF     '${Authen_mode}'=='WPA3-OWE'
#        Select From List By Value    xpath= //select[@id='Select_Network_Authen']         6
#    END
#
##    Select From List By Value           xpath= //select[@id='Select_Network_Authen']         1
##    ${Authen_value}=                      Get Value   //option[contains(text(), "${Authen_mode}")][1]
##    Select From List By Label           xpath= //select[@id='Select_Network_Authen']        ${Authen_value}
#    ${Check_authenmode} =   Run Keyword And Return Status           Element Should Be Visible    //input[@id='Input_WPA_passphrase']
#
#    Run Keyword If    ${Check_authenmode}
#    ...    Input Text   //input[@id='Input_WPA_passphrase']    ${Guest_PW}
#    Click Button                        //input[@id='button_ApplyGuest2G']

# get SSID Guest Name
Get 2.4g SSID Guest
    ${SSID_G}                               Get Element Attribute    //input[@id='Input_SSID']    value
    Return From Keyword                     ${SSID_G}
Get 5g SSID Guest
    ${SSID_5}                               Get Element Attribute    //input[@id='5G_Input_SSID']    value
    Return From Keyword                     ${SSID_5}

# get SSID Guest Sercu Mod
Get 2.4g Guest Serverity Mode
    ${Ser_mod}                              Get Selected List Label     //select[@id='Select_Network_Authen']
    Return From Keyword                     ${Ser_mod}
Get 5g Guest Serverity Mode
    ${Ser_mod}                              Get Selected List Label     //select[@id='5G_Select_Network_Authen']
    Return From Keyword                     ${Ser_mod}

# get SSID Guest PW
Get 2.4 Guest PW
    ${PW2}                               Get Element Attribute    //input[@id='Input_WPA_passphrase']    value
    Return From Keyword                     ${PW2}
Get 5 Guest PW
    ${PW5}                               Get Element Attribute    //input[@id='5G_Input_WPA_passphrase']    value
    Return From Keyword                     ${PW5}


Create Guest 5g
    [Documentation]                     Create Guest 5g
    ...                                 OPEN
    ...                                 WPA-PSK
    ...                                 WPA2-PSK
    ...                                 WPA-PSK/WPA2-PSK Mixed mode
    ...                                 WPA3-SAE
    ...                                 WPA3-SAE/WPA2-PSK Mixed Mode
    ...                                 WPA3-OWE
    [Arguments]                         ${Guest_SSID}     ${Authen_mode}     ${Guest_PW}
    Input Text                          xpath= //input[@id='5G_Input_SSID']      ${Guest_SSID}
    Wait Until Element Is Visible       xpath= //select[@id='5G_Select_Network_Authen']
    ${Authen_value}=                    Get Value   //option[contains(text(), "${Authen_mode}")][1]
    Select From List By Value           xpath= //select[@id='5G_Select_Network_Authen']        ${Authen_value}
    #Select From List By Value           xpath= //select[@id='5G_Select_Network_Authen']         1
    ${Check_authenmode}=                Run Keyword And Return Status        Element Should Be Visible    //input[@id='5G_Input_WPA_passphrase']
    Run Keyword If    ${Check_authenmode}
    ...    Input Text                   xpath = //input[@id='5G_Input_WPA_passphrase']    ${Guest_PW}
    Click Button                        //input[@id='button_ApplyGuest5G']

Create Guest 24g
    [Documentation]                     Create Guest 5g
    ...                                 OPEN
    ...                                 WPA-PSK
    ...                                 WPA2-PSK
    ...                                 WPA-PSK/WPA2-PSK Mixed mode
    ...                                 WPA3-SAE
    ...                                 WPA3-SAE/WPA2-PSK Mixed Mode
    ...                                 WPA3-OWE
    [Arguments]                         ${Guest_SSID}     ${Authen_mode}     ${Guest_PW}
    Input Text                          xpath= //input[@id='Input_SSID']      ${Guest_SSID}
    Wait Until Element Is Visible       xpath= //select[@id='Select_Network_Authen']
    ${Authen_value}=                    Get Value   //option[contains(text(), "${Authen_mode}")][1]
    Select From List By Value           xpath= //select[@id='Select_Network_Authen']        ${Authen_value}
    #Select From List By Value           xpath= //select[@id='5G_Select_Network_Authen']         1
    ${Check_authenmode}=                Run Keyword And Return Status        Element Should Be Visible    //input[@id='Input_WPA_passphrase']
    Run Keyword If    ${Check_authenmode}
    ...    Input Text                   xpath = //input[@id='Input_WPA_passphrase']    ${Guest_PW}
    Click Button                        //input[@id='button_ApplyGuest2G']
