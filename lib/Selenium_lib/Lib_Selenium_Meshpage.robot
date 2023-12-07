*** Settings ***
Library                      SeleniumLibrary             WITH NAME    SL
#run_on_failure=SL.Capture Page Screenshot
#Resource                     ../../SeleniumCommonLib.txt

*** Variables ***

*** Keywords ***
Access Mesh Page
    SL.Wait Until Element Is Visible           xpath= //a[@id='titleHome']
    SL.Click Element                           xpath= //a[@title='Mesh']
    Sleep    5
    SL.Page Should Contain                     Mesh Network Configuration


#################################### Add Node###################################
Get the dafaul Mesh Name
	${Name_Defaul}                  Get Text    //label[@id="SHOW_DEVICE"]
	[Return]                        ${Name_Defaul}

Get the Mesh Mac
	SL.Wait Until Element Is Visible                    //img[@title = 'Detail Information']        10
    SL.Click Element                                    //img[@title = 'Detail Information']
	${MAC_Defaul}                    Get Text    //td[@class='hdContent02 hdContent01_clickable']//following::td[3]
	[Return]                         ${MAC_Defaul}

Click Button Create Mesh NetWork
    [Arguments]                             ${Mesh_Name}
    Wait Until Element Is Visible           xpath= //input[@id='createmesh']
    Click Button                            xpath= //input[@id='createmesh']
    Page Should Contain                     ${Mesh_Name}
Select Mesh Mode
    [Documentation]                         Select Mesh Mode
    [Arguments]                             ${Mode}

    Run Keyword If    "${Mode}"== "Router Mode"
    ...    Select From List By Label    //select[@id='Input_Enable_Bridge']          ${Mode}
    ...  ELSE IF    "${Mode}"== "Bridge Mode"
    ...    Select From List By Label    //select[@id='Input_Enable_Bridge']          ${Mode}
    ...    Select Checkbox                         xpath= //input[@id='Input_Mesh_Over_Eth']

Click Button Add Node
    [Arguments]                             ${Mac_Mesh_MRE}
    SL.Click Element                        //tbody/tr[1]/td[1]/div[1]/img[1]
    SL.Click Element                        //input[@value= "Next"]
    Page Should Contain                     2. Wait to finish booting up the new nodes: The System led is green bright
    SL.Wait Until Element Is Visible        //input[@onclick= "AddNode(2)"]
    SL.Click Element                        //input[@onclick= "AddNode(2)"]
    Page Should Contain                     3. Make sure that the new nodes are FACTORY state. If not, factory reset devices
    SL.Wait Until Element Is Visible        //input[@value="Scan New Nodes"]
    Sl.Click Element                        //input[@value="Scan New Nodes"]
    Wait Until Page Contains                New Mesh nodes are trying to join your network
    Click Element                           //td[contains(text(),'${Mac_Mesh_MRE}')]//following-Sibling::td


Input Mesh SSID
    [Arguments]                             ${SSID}
    Input Text                              xpath= //input[@id='Input_SSID']          ${SSID}
Input WPA Passphrase
     [Arguments]                             ${PW}
     Input Text                              xpath= //input[@id='Input_WPA_passphrase']          ${PW}
Click Button Create(Apply)
    Wait Until Element Is Visible            xpath= //input[@id='applynew']
    Click Button                             xpath= //input[@id='applynew']


#################################Join Mesh ##################################3
Click Button Join Mesh NetWork
    Wait Until Element Is Visible            xpath= //input[@value='Join Mesh Network']
    Click Button                             xpath= //input[@value='Join Mesh Network']
Join Mesh Manual
    [Documentation]                          Join Mesh Network by Manually Connect
    [Arguments]                              ${SSID2join}     ${PW}
    Wait Until Element Is Visible            //input[@value="Manually Connect"]
    Click Element                            //input[@value="Manually Connect"]
    Wait Until Element Is Visible            xpath= //input[@id='Input_SSID']
    Wait Until Element Is Visible            xpath= //input[@id='Input_WPA_passphrase']
    Input Text                               xpath= //input[@id='Input_SSID']    ${SSID2join}
    Input Text                               xpath= //input[@id='Input_WPA_passphrase']    ${PW}
    Click Button                             //input[@value='Join']
    SL.Handle Alert

Join Mesh by Search
    [Documentation]                          Join Mesh Network by search
    [Arguments]                              ${SSID2join}     ${PW}
    Wait Until Element Is Visible            xpath= //input[@value='Search']
    Click Button                             xpath= //input[@value='Search']
    Wait Until Page Contains                 Scanned SSID Table             10
    Wait until Page contains                 SSID : ${SSID2join}            60
    #FInd ${SSID2join}and click join button
    Click Element                            xpath= //td[contains(text(),'${SSID2join}')]//following-sibling::td//child::input
    # Xpath goc //td[contains(text(),'SpaceY')]//following-sibbling::td//child::input
    Log To Console                           Enter Password
    Wait Until Element Is Visible            xpath = //input[@id='Input_WPA_passphrase']
    Input Text                               xpath = //input[@id='Input_WPA_passphrase']    ${PW}
    Click Button                             xpath = //input[@value='Join']
    ${Alert}                                 SL.Handle Alert
    Should Match                             ${Alert}       The device will join to chosen mesh network and current config will be remove


Verify in Topology have MRE Info
	[Arguments]                                         ${MRE_Name_defautl}
	...                                                 ${MRE_Mac_Adress}

    SL.Wait Until Element Is Visible                    //img[@title = 'Detail Information']        10
    SL.Click Element                                    //img[@title = 'Detail Information']
    SL.Page Should Contain                              Mesh Devices Information
    Log To Console                                      \Check the list of Mesh devices that have the information of the MRE just added
    ...                                                 ${MRE_Mac_Adress}
    SL.Page Should Contain                              ${MRE_Mac_Adress}
    SL.Click Element                                    //td[contains(text(),'${MRE_Name_defautl}')]
    ${Eth_MAC_Addr}                                     SL.Get Text    //label[@id='LB_ETHERNET_MAC']
	Log To Console                                     \nMRE ${MRE_Name_defautl} sync successfully
#    Log To Console                                      \Ethernet MAC Address: ${Eth_MAC_Addr}
#    Should Match                                        ${Eth_MAC_Addr}            ${MRE_Mac_Adress}