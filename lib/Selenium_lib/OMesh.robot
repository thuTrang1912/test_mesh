*** Settings ***
Library                      SeleniumLibrary            WITH NAME    SL
#run_on_failure=SL.Capture Page Screenshot
Library    OperatingSystem

*** Variables ***
${User_N}       one
${PW}           one@2019

${Serial}               44ac

*** Keywords ***
######### Login ##############################
Input User Name OM
	[Arguments]                                 ${User_N}
	Wait Until Element Is Visible               //div[@class='form-group-login']//input[@type='text']
	Input Text                                  //div[@class='form-group-login']//input[@type='text']    ${User_N}
Input Password OM
	[Arguments]                                 ${PW}
	Wait Until Element Is Visible               //input[@type='password']
	Input Text                                  //input[@type='password']       ${PW}

Login to ONE Mesh
	[Arguments]                                 ${User_N}            ${PW}
	Open Browser                        http://mesh-staging.vnpt-technology.vn:9000/login?error=2       chrome
	Maximize Browser Window
    #Reload Page
    Input User Name OM                    ${User_N}
    Input Password OM                     ${PW}
    #Click element                       //span[@class='glyphicon glyphicon-eye-open']
    Sleep    4
    Wait Until Element Is Visible       //button[@id='login-submit']
    Click Element                       //button[@id='login-submit']
    Sleep                               4
    Page Should Contain                 Welcome to the ONE MESH system

Access Device detail OM
	[Arguments]                         ${Serial}
	Click Element                       //span[contains(text(),'Configuration')]
	#Wait Until Element Is Visible       //body[contains(@class,'pace-done')]/div[@class='page-container']/div[@class='page-content']/div[@class='content-wrapper']/div[@class='panel panel-flat']/div[@class='panel-body padding-panel-search']/form[@class='form-horizontal form-search row ng-pristine ng-valid ng-valid-maxlength']/div[@class='col-md-10']/div[2]/div[1]/div[1]/input[1]
	Wait Until Element Is Visible       //input[@name= 'serialNumber']
	Input Text                          //input[@name= 'serialNumber']    ${Serial}
	Click Element                       //button[contains(@type,'submit')]//i[contains(@class,'icon-search4')]
	Sleep                               5
	Click Element                       //span[contains(text(),'Online')]
	Sleep                               3
	Page Should Contain                 Device Information
	Page Should Contain                 ${Serial}

###### LAN ###########
Go to lan config OM
	Wait Until Element Is Visible       //a[@href='#device-lan-tab']
	Click Element                       //a[@href='#device-lan-tab']
	Sleep   5
	Page Should Contain                 LAN Configuration
Config Lan OM
	[Arguments]                         ${IP_ad}    ${SubNet}       ${StartIP}      ${NumIP}    ${Leasetime}
	Input Text                          //input[@name="ipAddress"]          ${IP_ad}
	Select From List by Value           //select[@name="subnetMask"]        ${SubNet}
	Input Text                          //input[@name="dhcpStartIp"]        ${StartIP}
	Input Text                          //input[@name="dhcpNumberIp"]       ${NumIP}
	Input Text                          //input[@name="dhcpLeasetime"]       ${Leasetime}
	Click Element                       //button[contains(@class,'btn btn-icon btn-primary btnSaveLan')]


######################## Config Wifi###########################
Go to Config Wifi OM
	Wait Until Element Is Visible       //a[@href='#device-wifi-tab']
	Click Element                       //a[@href='#device-wifi-tab']
	Sleep    5
	Page Should Contain                 Wifi Configuration

Config Wifi Radio 2.4Ghz OM
	[Documentation]                     Config  Standard: g/ng/ax
	...                                 bw: 20/40/ 20/40 MHz
	...                                 CHANEL:
	[Arguments]                         ${Standard}             ${Bandwidth}        ${Channel}
	Log To Console                      \n Config Wifi Radio 2.4Ghz OM
	Select From List By Value           //Select[@ng-change="radio24GhzUpdateBandwidth(1)"]     ${Standard}
	Select From List By Label           //select[@ng-model="wifiRadio24Ghz.bandwidth"]          ${Bandwidth}
	Select From List By Value           //select[@ng-model="wifiRadio24Ghz.channel"]            ${Channel}
	Click Element                       //button[@class="btn btn-icon btn-primary btnSaveWifi"]

Verify config Radio 2.4Ghz OM
	[Arguments]                         ${Standard}             ${Bandwidth}        ${Channel}
	Log To Console                      \n Verify config Radio 2.4Ghz OM
	${Standard_value}                   Get Selected List Value     //Select[@ng-change="radio24GhzUpdateBandwidth(1)"]
	${BW_value}                         Get Selected List Label      //select[@ng-model="wifiRadio24Ghz.bandwidth"]
	${Channel_value}                    Get Selected List Value      //select[@ng-model="wifiRadio24Ghz.channel"]
	Should Match                        ${Standard}         ${Standard_value}
	Should Match                        ${Bandwidth}        ${BW_value}
	Should Match                        ${Channel}          ${Channel_value}
	Log To Console                      \n Config radio 2.4g Successfully

	
Config Wifi Radio 5Ghz OM
	[Documentation]                     Config  Standard: a/na/ac/ax
	...                                 bw: 20/40/80/160 MHz
	...                                 CHANEL:
	[Arguments]                         ${Standard}             ${Bandwidth}        ${Channel}
	Select From List By Value           //select[@ng-model="wifiRadio5Ghz.wlanStandard"]     ${Standard}
	Select From List By Label           //select[@ng-model="wifiRadio5Ghz.bandwidth"]        ${Bandwidth}
	Select From List By Value           //select[@ng-model="wifiRadio5Ghz.channel"]          ${Channel}
	Click Element                       //button[@class="btn btn-icon btn-primary btnSaveWifi"]

Verify config Radio 5Ghz OM
	[Arguments]                         ${Standard}             ${Bandwidth}        ${Channel}
	Log To Console                      \n Verify config Radio 5Ghz OM
	${Standard_value}                   Get Selected List Value     //select[@ng-model="wifiRadio5Ghz.wlanStandard"]
	${BW_value}                         Get Selected List Label      //select[@ng-model="wifiRadio5Ghz.bandwidth"]
	${Channel_value}                    Get Selected List Value      //select[@ng-model="wifiRadio5Ghz.channel"]
	Should Match                        ${Standard}         ${Standard_value}
	Should Match                        ${Bandwidth}        ${BW_value}
	Should Match                        ${Channel}          ${Channel_value}
	Log To Console                      \n Config radio 5g Successfully

################ SSID##############
Edit Main SSID OM
	[Documentation]                     Edit SSID: PW: AuthenMode:
	[Arguments]                         ${New_ssid}     ${new_authen}       ${New_PW}
	Input Text                          //input[@ng-model="mainSSID.ssid"]    ${New_ssid}
	Select From List By Label           //select[@ng-model="mainSSID.securityMode"]     ${new_authen}
	Input Text                          //input[@ng-model="mainSSID.password"]    ${New_PW}
	Click Button                        //button[@class="btn btn-icon btn-primary btnSaveWifi"]

Verify Edit Main SSID OM
	[Arguments]                         ${New_ssid}     ${new_authen}       ${New_PW}
	Log To Console                      \nVerify Edit Main SSID OM
	${value_ssid}                       Get value       //input[@ng-model="mainSSID.ssid"]
	${value_mode}                       Get Selected List Label       //select[@ng-model="mainSSID.securityMode"]
	${value_PW}                         Get Value       //input[@ng-model="mainSSID.password"]
	Should Match                        ${value_ssid}       ${New_ssid}
	Should Match                        ${new_authen}       ${value_mode}
	Should Match                        ${New_PW}           ${value_PW}
	Log to console                      \nConfig Main SSID successfully

####### Guest ##############
Enable Guest SSID 24G OM
	[Arguments]                         ${New_ssid}     ${new_authen}       ${New_PW}

	Log To Console                      \nAdd Guest SSID 24G
	Click Element                       //button[contains(@class,'btn-primary')]//span[contains(@class,'glyphicon glyphicon-plus-sign')]

	Log To Console                      \n Input SSID 2.4G: {New_ssid}
	Input Text                          //*[@id="device-wifi-tab"]/div/form/div[7]/div/div[2]/table/tbody/tr[1]/td[2]/input     ${New_ssid}

	Log To Console                      \n Select security mode: ${new_authen}
	Select From List By Label            //*[@id="device-wifi-tab"]/div/form/div[7]/div/div[2]/table/tbody/tr[2]/td[2]/select         ${new_authen}

	Log To Console                      \nInput PW: ${New_PW}
	Input Text                          //*[@id="device-wifi-tab"]/div/form/div[7]/div/div[2]/table/tbody/tr[3]/td[2]/input    ${New_PW}
	#Click Button                        //button[@class="btn btn-icon btn-primary btnSaveWifi"]

Click button Save Wifi
	Click Button                        //button[@class="btn btn-icon btn-primary btnSaveWifi"]

Verify Enable Guest SSID 24G OM
	[Arguments]                         ${New_ssid}     ${new_authen}       ${New_PW}
	Log To Console                      \nVerify Edit Guest SSID 2.4g OM
	${value_ssid}                       Get value       //*[@id="device-wifi-tab"]/div/form/div[7]/div/div[2]/table/tbody/tr[1]/td[2]/input
	${value_mode}                       Get Selected List Label        //*[@id="device-wifi-tab"]/div/form/div[7]/div/div[2]/table/tbody/tr[2]/td[2]/select
	${value_PW}                         Get Value       //*[@id="device-wifi-tab"]/div/form/div[7]/div/div[2]/table/tbody/tr[3]/td[2]/input
	Should Match                        ${value_ssid}       ${New_ssid}
	Should Match                        ${new_authen}       ${value_mode}
	Should Match                        ${New_PW}           ${value_PW}
	Log to console                      \nConfig Guest 2.4g SSID successfully

Enable Guest SSID 5G OM
	[Arguments]                         ${New_ssid}     ${new_authen}       ${New_PW}

	Log To Console                      \nAdd Guest SSID 5G
	Click Element                       //button[contains(@class,'btn-success')]//span[contains(@class,'glyphicon glyphicon-plus-sign')]

	Log To Console                      \n Input SSID 5G: ${New_ssid}
	Input Text                          //*[@id="device-wifi-tab"]/div/form/div[8]/div/div[2]/table/tbody/tr[1]/td[2]/input     ${New_ssid}

	Log To Console                      \n Select security mode: ${new_authen}
	Select From List By Label            //*[@id="device-wifi-tab"]/div/form/div[8]/div/div[2]/table/tbody/tr[2]/td[2]/select         ${new_authen}

	Log To Console                      \nInput PW: ${New_PW}
	Input Text                          //*[@id="device-wifi-tab"]/div/form/div[8]/div/div[2]/table/tbody/tr[3]/td[2]/input    ${New_PW}
	#Click Button                        //button[@class="btn btn-icon btn-primary btnSaveWifi"]

Verify Edit Guest SSID 5G OM
	[Arguments]                         ${New_ssid}     ${new_authen}       ${New_PW}
	Log To Console                      \nVerify Edit Guest SSID 5g OM
	${value_ssid}                       Get value       //*[@id="device-wifi-tab"]/div/form/div[8]/div/div[2]/table/tbody/tr[1]/td[2]/input
	${value_mode}                       Get Selected List Label       //*[@id="device-wifi-tab"]/div/form/div[8]/div/div[2]/table/tbody/tr[2]/td[2]/select
	${value_PW}                         Get Value       //*[@id="device-wifi-tab"]/div/form/div[8]/div/div[2]/table/tbody/tr[3]/td[2]/input
	Should Match                        ${value_ssid}       ${New_ssid}
	Should Match                        ${new_authen}       ${value_mode}
	Should Match                        ${New_PW}           ${value_PW}
	Log to console                      \nConfig Guest SSID 5g successfully

Disable Guest 2.4 OM
	Click Element                        //*[@id="device-wifi-tab"]/div/form/div[7]/div/div[1]/div/ul/li[1]/button/i
	#Click Button                        //button[@class="btn btn-icon btn-primary btnSaveWifi"]

Disable Guest 5g OM
	Click Element                        //a[@class='btn btn-link padding-zero']//i[@class='icon-trash']
	#Click Button                        //button[@class="btn btn-icon btn-primary btnSaveWifi"]
	#//*[@id="device-wifi-tab"]/div/form/div[7]/div/div[1]/div/ul/li[1]/button/i

Click button Delete Guest SSID
	Click Button                        //button[@class="btn btn-icon btn-primary btnSaveWifi"]
	Sleep    2
	Page Should Contain                 You have just deleted guest SSID. Are you sure to save this configuration?
	Click Element                      //*[@id="device-wifi-tab"]/div/div[1]/div/div/div[2]/button[1]
	#Should Match                        ${Alert}        You have just deleted guest SSID. Are you sure to save this configuration?

Verify Disable Guest 2.4 OM should successfully
	Log To Console                          \n Verify Disable Guest 2.4 OM: Should not contain Guest SSID 2.4 Ghz
	Element Should Not Be Visible           //h6[@class='panel-title text-semibold']//span[contains(text(),'Guest SSID 2.4 Ghz')]

Verify Disable Guest 5g OM should successfully
	Log to Console                          \n Verify Disable Guest 5 OM: Should not contain Guest SSID 5 Ghz
	Element Should Not Be Visible           //h6[@class='panel-title text-semibold']//span[contains(text(),'Guest SSID 5 Ghz')]

##################### VLAN ###########################
Go to Config Vlan OM
	Click Element                       //a[contains(text(),'VLAN')]

Add Vlan OM
	FOR    ${i}    IN RANGE    1    3    1
		Click Element       //button[@ng-click="addNewVlan()"]
	END
	Input Text              //*[@id="device-vlan-tab"]/div/form/div[1]/div/div[2]/table/tbody/tr[2]/td[2]/input     11
	input text              //*[@id="device-vlan-tab"]/div/form/div[2]/div/div[2]/table/tbody/tr[2]/td[2]/input     12
	Input Text              //*[@id="device-vlan-tab"]/div/form/div[3]/div/div[2]/table/tbody/tr[2]/td[2]/input     60
	Click element           //button[@class="btn btn-icon btn-primary btnSaveVlan"]

Delete Vlan OM
	Click Element           //i[@class="icon-trash"][1]
	Click Element           //div[@class='modal fade modalDeleteVlan in']//div[@class='modal-dialog modal-sm']//div[@class='modal-content text-center']//div[@class='modal-footer text-center']//button[@class='btn btn-icon btn-warning btnSubmit']
########################## Config Wan ############################
Go to Config WAN OM
	Wait Until Element Is Visible       //a[contains(text(),'WAN')]
	Click Element                       //a[contains(text(),'WAN')]
	Sleep    5
	Page Should Contain                 WAN configuration

Edit WWan0 DHCP OM
	[Documentation]                     Edit WWAN0
	...                                 Connection Type: dhcp, pppoe, static
	...                                 Wan service: Ipv4, Ipv6, Dual
	...                                 WAN Preferred DNS
	...                                 WAN Second DNS
	...                                 IPv6 Type
	[Arguments]                         ${service}      ${DNS1}     ${DNS2}     ${TypeV6}
	Select From List By Value           //select[@name="connection_type"][1]       dhcp
	Select From List By Value           //*[@id="device-wan-tab"]/div/form/div/div[1]/div/div[2]/table/tbody/tr[5]/td[2]/select        ${service}
	Input Text                          //input[@ng-model="wan.preferredDns"][1]    ${DNS1}
	Input Text                          //input[@ng-model="wan.alternateDns"][1]    ${DNS2}
	${stt}                              Run Keyword And Return Status    Wait Until Element Is Visible    //select[@ng-model="wan.ipv6Type"][1]         5
	IF    ${stt}
	     Select From List By Label      //select[@ng-model="wan.ipv6Type"][1]       ${TypeV6}
	END
	Click Element                       //button[@ng-click="updateWan()"]

Verify Edit WWan0 DHCP OM Should Successfully
	[Arguments]                         ${service}      ${DNS1}     ${DNS2}     ${TypeV6}
	Log To Console                      \n Verify Edit WWan0 DHCP OM:
	${service_v}                        Get Selected List Value    //*[@id="device-wan-tab"]/div/form/div/div[1]/div/div[2]/table/tbody/tr[5]/td[2]/select
	${DNS1_v}                           Get Value                   //input[@ng-model="wan.preferredDns"][1]
	${DNS2_v}                           Get Value                   //input[@ng-model="wan.alternateDns"][1]

	${stt}                              Run Keyword And Return Status    Wait Until Element Is Visible    //select[@ng-model="wan.ipv6Type"][1]         5
	IF    ${stt}
	     ${TypeV6_v}                    Get Selected List Label      //select[@ng-model="wan.ipv6Type"][1]
	     Should Match                        ${TypeV6_v}   ${TypeV6}
	END
	Should Match                        ${service_v}    ${service}
	Should Match                        ${DNS1_v}    ${DNS1}
	Should Match                        ${DNS2_v}    ${DNS2}

	Log To Console                      \t Successfully

Edit WAN PPPoE for Wan OM
	[Arguments]                         ${Service}          ${User}         ${PW}
	Select From List By Value           //select[@name="connection_type"][1]     pppoe
	Select From List By Value           //*[@id="device-wan-tab"]/div/form/div/div[1]/div/div[2]/table/tbody/tr[5]/td[2]/select     ${Service}
	Input Text                          //input[@name="pppoeUsername"][1]    ${User}
	Input Text                          //input[@name="pppoePassword"][1]    ${PW}

	IF  $Service=='Dual'
		Click element                   //tbody/tr[21]/td[2]/label[1]/span[1]
	END
	Click Element                       //button[@ng-click="updateWan()"]

Verify Edit WWAN0 PPPoE for Wan OM Should Successfully
	[Arguments]                         ${Service}          ${User}         ${PW}
	Log To Console                      \n Verify Edit WWAN0 PPPoE for Wan OM:
	#${Connection_v}                     Get Selected List Value         //select[@name="connection_type"][1]
	${Service_v}                        Get Selected List Value           //*[@id="device-wan-tab"]/div/form/div/div[1]/div/div[2]/table/tbody/tr[5]/td[2]/select
	${User_v}                           Get Value               //input[@name="pppoeUsername"][1]
	${PW_v}                             Get Value               //input[@name="pppoePassword"][1]
	Should Match                        ${Service_v}        ${Service}
	Should Match                        ${User_v}           ${User}
	Should Match                        ${PW_v}             ${PW}
	Log To Console                      \Successfully

Edit WAN Static for Wan index OM
	[Arguments]                         ${Service}      ${Addr}     ${Subnet}   ${IPGate}   ${DNS1}     ${DNS2}
	Select From List By Value           //select[@name="connection_type"][1]    static
	Select From List By Value           //*[@id="device-wan-tab"]/div/form/div/div[1]/div/div[2]/table/tbody/tr[5]/td[2]/select     ${Service}
	Input Text                          //input[@name="ipAddress"][1]    ${Addr}
	Select From List By Value           //select[@ng-model="wan.subnetMask"][1]         ${Subnet}
	Input Text                          //input[@name="gateway"][1]         ${IPGate}
	Input Text                          //input[@ng-model="wan.preferredDns"][1]        ${DNS1}
	Input Text                          //input[@ng-model="wan.alternateDns"][1]    ${DNS2}
	Click Element                       //button[@ng-click="updateWan()"]

Verify Config WWAN0 Static for Wan index OM
	[Arguments]                         ${Service}      ${Addr}     ${Subnet}   ${IPGate}   ${DNS1}     ${DNS2}
	Log To Console                      \n Verify Config WWAN0 Static for Wan index OM:
	${Service_v}                        Get Selected List Value    //*[@id="device-wan-tab"]/div/form/div/div[1]/div/div[2]/table/tbody/tr[5]/td[2]/select
	${Addr_V}                           Get Value                 //input[@name="ipAddress"][1]
	${Subnet_v}                         Get Selected List Value     //select[@ng-model="wan.subnetMask"][1]
	${IPGate_v}                         Get Value      //input[@name="gateway"][1]
	${DNS1_v}                           Get Value      //input[@ng-model="wan.preferredDns"][1]
	${DNS2_v}                           Get Value      //input[@ng-model="wan.alternateDns"][1]
	Should Match                        ${Service_v}        ${Service}
	Should Match                        ${Addr_V}        ${Addr}
	Should Match                        ${Subnet_v}        ${Subnet}
	Should Match                        ${IPGate_v}        ${IPGate}
	Should Match                        ${DNS1_v}        ${DNS1}
	Should Match                        ${DNS2_v}        ${DNS2}
	Log To Console                      \ Successfully

################## add wan ######################
Click button Add Wan OM
	Wait Until Element Is Visible          //i[@class="glyphicon glyphicon-plus-sign"]
	Click Element                           //i[@class="glyphicon glyphicon-plus-sign"]

Add Wan 1 DHCP OM
	[Documentation]                     Edit WWAN0
	...                                 Connection Type: dhcp, pppoe, static
	...                                 Wan service: Ipv4, Ipv6, Dual
	...                                 WAN Preferred DNS
	...                                 WAN Second DNS
	...                                 IPv6 Type
	[Arguments]                         ${VLanID}       ${service}      ${DNS1}     ${DNS2}     ${TypeV6}
	# Select Vlan ID
	#${VL_vlue}                          Get Value
	Select From List By Value           //*[@id="device-wan-tab"]/div/form/div/div[2]/div/div[2]/table/tbody/tr[2]/td[2]/select     eth1.${VLanID}
	Select From List By Value           //*[@id="device-wan-tab"]/div/form/div/div[2]/div/div[2]/table/tbody/tr[3]/td[2]/select       dhcp
	Select From List By Value           //*[@id="device-wan-tab"]/div/form/div/div[2]/div/div[2]/table/tbody/tr[4]/td[2]/select        ${service}
	Input Text                          //*[@id="device-wan-tab"]/div/form/div/div[2]/div/div[2]/table/tbody/tr[8]/td[2]/input    ${DNS1}
	Input Text                          //*[@id="device-wan-tab"]/div/form/div/div[2]/div/div[2]/table/tbody/tr[9]/td[2]/input    ${DNS2}
	${stt}                              Run Keyword And Return Status    Wait Until Element Is Visible    //*[@id="device-wan-tab"]/div/form/div/div[2]/div/div[2]/table/tbody/tr[12]/td[2]/select         5
	IF    ${stt}
	     Select From List By Label      //*[@id="device-wan-tab"]/div/form/div/div[2]/div/div[2]/table/tbody/tr[12]/td[2]/select       ${TypeV6}
	END
	Click Element                       //button[@ng-click="updateWan()"]

Add Wan 2 PPPoE OM
	[Arguments]                         ${VLanID}  ${User}         ${PW}
	Select From List By Value           //*[@id="device-wan-tab"]/div/form/div/div[4]/div/div[2]/table/tbody/tr[2]/td[2]/select     eth1.${VLanID}
	Select From List By Value           //*[@id="device-wan-tab"]/div/form/div/div[4]/div/div[2]/table/tbody/tr[3]/td[2]/select     pppoe
	Input Text                          //*[@id="device-wan-tab"]/div/form/div/div[4]/div/div[2]/table/tbody/tr[13]/td[2]/input    ${User}
	Input Text                          //*[@id="device-wan-tab"]/div/form/div/div[4]/div/div[2]/table/tbody/tr[14]/td[2]/input    ${PW}
	Click Element                       //button[@ng-click="updateWan()"]

Add Wan 3 Static OM
	[Arguments]                         ${VlanID}       ${Service}      ${Addr}     ${Subnet}   ${IPGate}   ${DNS1}     ${DNS2}
	Select From List By Value           //*[@id="device-wan-tab"]/div/form/div/div[5]/div/div[2]/table/tbody/tr[2]/td[2]/select     eth1.${VlanID}
	Select From List By Value           //*[@id="device-wan-tab"]/div/form/div/div[5]/div/div[2]/table/tbody/tr[3]/td[2]/select     static
	Select From List By Value           //*[@id="device-wan-tab"]/div/form/div/div[5]/div/div[2]/table/tbody/tr[4]/td[2]/select    ${Service}
	Input Text                          //*[@id="device-wan-tab"]/div/form/div/div[5]/div/div[2]/table/tbody/tr[5]/td[2]/input    ${Addr}
	Select From List By Value           //*[@id="device-wan-tab"]/div/form/div/div[5]/div/div[2]/table/tbody/tr[6]/td[2]/select         ${Subnet}
	Input Text                          //*[@id="device-wan-tab"]/div/form/div/div[5]/div/div[2]/table/tbody/tr[7]/td[2]/input         ${IPGate}
	Input Text                          //*[@id="device-wan-tab"]/div/form/div/div[5]/div/div[2]/table/tbody/tr[8]/td[2]/input        ${DNS1}
	Input Text                          //*[@id="device-wan-tab"]/div/form/div/div[5]/div/div[2]/table/tbody/tr[9]/td[2]/input    ${DNS2}
	Click Element                       //button[@ng-click="updateWan()"]
######################## Backup Config ####################
Backup config OM
	[Arguments]                         ${Backup_Name}
	Click element                       //span[contains(text(),'BACKUP')]
	Input Text                          //input[@name="desciptionBackup"]       ${Backup_Name}
	Click Element                       //button[@class="btn btn-primary btnBackupDevice"]


