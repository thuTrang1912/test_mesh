*** Settings ***
Library                      SeleniumLibrary   run_on_failure=SL.Capture Page Screenshot      WITH NAME    SL
Library                      OperatingSystem
Library                      SSHLibrary
Library    AppiumLibrary
#Resource                     ../pythonProject/venv/lib/Selenium_lib/Setting_Wireless.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_Login.robot
Resource                     venv/lib/Selenium_lib/Lib_Selenium_WireLess.robot
Resource                     venv/lib/SSH_Lib/SSH_Connect_wifi.robot
Resource    venv/lib/Selenium_lib/Lib_Selenium_WAN.robot
Resource    venv/lib/Variable.robot
*** Variables ***
${User_name}        root
${PW}               ttcn@99CN

${IP_ver}           Dual stack
${Ipv6_Type}        Auto
@{VLANID}=           11  12  16

*** Keywords ***
Access VLAN
	SL.Wait Until Element Is Visible             //a[@id='titleAdances']
    SL.Click Element                             //a[@id='titleAdances']
    SL.Click Element                             //a[@id='sub41']
    SL.Page Should contain                        VLAN Settings

Add VLAN ID
	[Arguments]                                  ${VLAN}
    SL.Click Element                             //center[@id='addnew']//input[@type='button']
    SL.Input Text                                //input[@id='input_id_New_Edit']      ${VLAN}
    SL.Click Element                             //input[@value='Apply']

Delete Vlan ID
	[Arguments]                                  ${Vlan}
	SL.Click Element                             //label[contains(text(),'${Vlan}')]//following::td//img[1]
	SL.Handle Alert
	Sleep   5
	#//label[contains(text(),'eth1.16')]//following::td//img[1]
*** Test Cases ***
#testOK nha:
#	FOR     ${i}    IN   @{VLANID}
#		Log To Console    ${i}
#	END
1. Open browser in local machine
    Open Browser                https://192.168.88.1            ${Browser}
    Chrome Pass Certificate google if present
    Login To WebGUI on local machine         ${user_name}     ${PassWord}
2. Addd VLan ID
#	Create List     ${VLANID}=      11  12  60
	Set Global Variable     ${VLANID}
    SL.Set Selenium Speed       0.5
	Access VLAN
	FOR     ${I}    IN      @{VLANID}
		Add VLAN ID       ${I}
		Log To Console    \n Add Vlan: ${I}
		Sleep    10
	END

3. Verify in WebGUI
	FOR     ${I}    IN      @{VLANID}
		Page Should Contain       ${I}
	END

4.Check the maximum number of vlans that can be added
	SL.Click Element                //center[@id='addnew']//input[@type='button']
	${Alert}                        SL.Handle Alert
	Log To Console                  ${Alert}
	Should Match                    ${Alert}   The number VLAN is maximum, can not add new VLAN

5. Delete VLAN
	SL.Set Selenium Speed       0.5
#	FOR     ${I}    IN      @{VLANID}
#		Delete Vlan ID       ${I}
#	END
	Log To Console   \n Verify Delete WAN Sussesfully

	FOR     ${I}    IN      @{VLANID}
		SL.Page Should Not Contain      eth1.${I}
	END



