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
Input User Name
	[Arguments]                                 ${User_N}
	Wait Until Element Is Visible               //div[@class='form-group-login']//input[@type='text']
	Input Text                                  //div[@class='form-group-login']//input[@type='text']    ${User_N}
Input Password
	[Arguments]                                 ${PW}
	Wait Until Element Is Visible               //input[@type='password']
	Input Text                                  //input[@type='password']       ${PW}

Login to ONE Mesh
	[Arguments]                                 ${User_N}            ${PW}
	Open Browser                        http://mesh-staging.vnpt-technology.vn:9000/login?error=2       chrome
    Reload Page
    Input User Name                     ${User_N}
    Input Password                      ${PW}
    #Click element                       //span[@class='glyphicon glyphicon-eye-open']
    Sleep    4
    Wait Until Element Is Visible       //button[@id='login-submit']
    Click Element                       //button[@id='login-submit']
    Sleep                               4
    Page Should Contain                 Welcome to the ONE MESH system

Access Device detail
	[Arguments]                         ${Serial}
	Click Element                       //span[contains(text(),'Configuration')]
	Wait Until Element Is Visible       //body[contains(@class,'pace-done')]/div[@class='page-container']/div[@class='page-content']/div[@class='content-wrapper']/div[@class='panel panel-flat']/div[@class='panel-body padding-panel-search']/form[@class='form-horizontal form-search row ng-pristine ng-valid ng-valid-maxlength']/div[@class='col-md-10']/div[2]/div[1]/div[1]/input[1]
	Input Text                          //input[@name= 'serialNumber']    ${Serial}
	Click Element                       //button[contains(@type,'submit')]//i[contains(@class,'icon-search4')]
	Sleep                               5
	Click Element                       //a[contains(text(),'EW_0b44ac')]
	Sleep                               3
	Page Should Contain                 Device Information
	Page Should Contain                 ${Serial}

###### LAN ###########
Go to lan config
	Wait Until Element Is Visible       //a[@href='#device-lan-tab']
	Click Element                       //a[@href='#device-lan-tab']
	Sleep   5
	Page Should Contain                 LAN Configuration
Config Lan
	[Arguments]                         ${IP_ad}    ${SubNet}       ${StartIP}      ${NumIP}    ${Leasetime}
	Input Text                          //input[@name="ipAddress"]          ${IP_ad}
	Select From List by Value           //select[@name="subnetMask"]        ${SubNet}
	Input Text                          //input[@name="dhcpStartIp"]        ${StartIP}
	Input Text                          //input[@name="dhcpNumberIp"]       ${NumIP}
	Input Text                          //input[@name="dhcpLeasetime"]       ${Leasetime}
	Click Element                       //button[contains(@class,'btn btn-icon btn-primary btnSaveLan')]


######################## Config Wifi###########################
Go to Config Wifi
	Wait Until Element Is Visible       //a[@href='#device-wifi-tab']
	Click Element                       //a[@href='#device-wifi-tab']
	Sleep    5
	Page Should Contain                 Wifi Configuration

Config Wifi Radio 2.4Ghz
	[Documentation]                     Config  Standard: g/ng/ax
	...                                 bw: 20/40/ 20/40 MHz
	...                                 CHANEL:
	[Arguments]                         ${Standard}             ${Bandwidth}        ${Channel}
	Select From List By Value           //Select[@ng-change="radio24GhzUpdateBandwidth(1)"]     ${Standard}
	Select From List By Value           //select[@ng-model="wifiRadio24Ghz.bandwidth"]          ${Bandwidth}
	Select From List By Value           //select[@ng-model="wifiRadio24Ghz.channel"]            ${Channel}

Config Wifi Radio 5Ghz
	[Documentation]                     Config  Standard: a/na/ac/ax
	...                                 bw: 20/40/80/160 MHz
	...                                 CHANEL:
	[Arguments]                         ${Standard}             ${Bandwidth}        ${Channel}
	Select From List By Value           //select[@ng-model="wifiRadio5Ghz.wlanStandard"]     ${Standard}
	Select From List By Value           //select[@ng-model="wifiRadio5Ghz.bandwidth"]        ${Bandwidth}
	Select From List By Value           //select[@ng-model="wifiRadio5Ghz.channel"]          ${Channel}

Edit Main SSID
	[Documentation]                     Edit SSID: PW: AuthenMode:
	[Arguments]                         ${New_ssid}     ${new_authen}       ${New_PW}
	Input Text                          //input[@ng-model="mainSSID.ssid"]    ${New_ssid}
	Select From List By Value           //select[@ng-model="mainSSID.securityMode"]     ${new_authen}
	Input Text                          //input[@ng-model="mainSSID.password"]    ${New_PW}
	Click Button                        //button[@class="btn btn-icon btn-primary btnSaveWifi"]
Enable Guest SSID 24G
	[Arguments]                         ${New_ssid}     ${new_authen}       ${New_PW}

	Log To Console                      \nAdd Guest SSID 24G
	Click Element                       //button[contains(@class,'btn-primary')]//span[contains(@class,'glyphicon glyphicon-plus-sign')]

	Log To Console                      \n Input SSID 2.4G: {New_ssid}
	Input Text                          //body[contains(@class,'pace-done')]/div[contains(@class,'page-container')]/div[contains(@class,'page-content')]/div[contains(@class,'content-wrapper')]/div[contains(@class,'panel-flat')]/div[contains(@class,'panel panel-flat panel-margin-footer')]/div[contains(@class,'panel-body')]/div[contains(@class,'tabbable')]/div[contains(@class,'tab-content')]/div[@id='device-wifi-tab']/div[contains(@class,'row ng-scope')]/form[contains(@class,'deviceProfileForm ng-valid-max ng-valid-pattern ng-valid-minlength ng-valid-maxlength ng-valid-min ng-dirty ng-valid-parse ng-invalid ng-invalid-required')]/div[7]/div[1]/div[2]/table[1]/tbody[1]/tr[1]/td[2]/input[1]     ${New_ssid}

	Log To Console                      \n Select security mode: ${new_authen}
	Select From List By Value            //select[contains(@class,'form-control ng-valid ng-not-empty ng-touched ng-dirty ng-valid-parse')]         ${new_authen}

	Log To Console                      \nInput PW: ${New_PW}
	Input Text                          //body[contains(@class,'pace-done')]/div[contains(@class,'page-container')]/div[contains(@class,'page-content')]/div[contains(@class,'content-wrapper')]/div[contains(@class,'panel-flat')]/div[contains(@class,'panel panel-flat panel-margin-footer')]/div[contains(@class,'panel-body')]/div[contains(@class,'tabbable')]/div[contains(@class,'tab-content')]/div[@id='device-wifi-tab']/div[contains(@class,'row ng-scope')]/form[contains(@class,'deviceProfileForm ng-valid-max ng-valid-pattern ng-valid-minlength ng-valid-maxlength ng-valid-min ng-dirty ng-valid-parse ng-invalid ng-invalid-required')]/div[7]/div[1]/div[2]/table[1]/tbody[1]/tr[3]/td[2]/input[1]    ${New_PW}
	Click Button                        //button[@class="btn btn-icon btn-primary btnSaveWifi"]

Enable Guest SSID 5G
	[Arguments]                         ${New_ssid}     ${new_authen}       ${New_PW}

	Log To Console                      \nAdd Guest SSID 24G
	Click Element                       //button[contains(@class,'btn-success')]//span[contains(@class,'glyphicon glyphicon-plus-sign')]

	Log To Console                      \n Input SSID 2.4G: {New_ssid}
	Input Text                          //body[contains(@class,'pace-done')]/div[contains(@class,'page-container')]/div[contains(@class,'page-content')]/div[contains(@class,'content-wrapper')]/div[contains(@class,'panel-flat')]/div[contains(@class,'panel panel-flat panel-margin-footer')]/div[contains(@class,'panel-body')]/div[contains(@class,'tabbable')]/div[contains(@class,'tab-content')]/div[@id='device-wifi-tab']/div[contains(@class,'row ng-scope')]/form[contains(@class,'deviceProfileForm ng-valid-max ng-valid-pattern ng-valid-minlength ng-valid-maxlength ng-valid-min ng-dirty ng-valid-parse ng-invalid ng-invalid-required')]/div[8]/div[1]/div[2]/table[1]/tbody[1]/tr[1]/td[2]/input[1]     ${New_ssid}

	Log To Console                      \n Select security mode: ${new_authen}
	Select From List By Value            //div[contains(@class,'panel panel-flat panelNgRepeat')]//div[contains(@class,'table-responsive')]//table[contains(@class,'table table-striped table-hover table-sm')]//tbody//tr//td[contains(@class,'ng-scope')]//select[contains(@class,'form-control ng-pristine ng-untouched ng-valid ng-not-empty')]         ${new_authen}

	Log To Console                      \nInput PW: ${New_PW}
	Input Text                          //body[contains(@class,'pace-done')]/div[contains(@class,'page-container')]/div[contains(@class,'page-content')]/div[contains(@class,'content-wrapper')]/div[contains(@class,'panel-flat')]/div[contains(@class,'panel panel-flat panel-margin-footer')]/div[contains(@class,'panel-body')]/div[contains(@class,'tabbable')]/div[contains(@class,'tab-content')]/div[@id='device-wifi-tab']/div[contains(@class,'row ng-scope')]/form[contains(@class,'deviceProfileForm ng-valid-max ng-valid-pattern ng-valid-minlength ng-valid-maxlength ng-valid-min ng-dirty ng-valid-parse ng-invalid ng-invalid-required')]/div[7]/div[1]/div[2]/table[1]/tbody[1]/tr[3]/td[2]/input[1]    ${New_PW}
	Click Button                        //button[@class="btn btn-icon btn-primary btnSaveWifi"]

Disable Guest 2.4
	Click Button                        //button[contains(@class,'btn btn-link padding-zero')]//i[contains(@class,'icon-trash')]
	Click Button                        //button[@class="btn btn-icon btn-primary btnSaveWifi"]

Disable Guest 5g
	Click Button                        //body[contains(@class,'pace-done')]/div[contains(@class,'page-container')]/div[contains(@class,'page-content')]/div[contains(@class,'content-wrapper')]/div[contains(@class,'panel-flat')]/div[contains(@class,'panel panel-flat panel-margin-footer')]/div[contains(@class,'panel-body')]/div[contains(@class,'tabbable')]/div[contains(@class,'tab-content')]/div[@id='device-wifi-tab']/div[contains(@class,'row ng-scope')]/form[contains(@class,'deviceProfileForm ng-valid-max ng-valid-pattern ng-valid-minlength ng-valid-maxlength ng-valid-min ng-dirty ng-valid-parse ng-invalid ng-invalid-required')]/div[7]/div[1]/div[2]/table[1]/tbody[1]/tr[1]/td[2]/input[1]
	Click Button                        //button[@class="btn btn-icon btn-primary btnSaveWifi"]

##################### VLAN ###########################
Go to Config Vlan
	Click Element                       //a[contains(text(),'VLAN')]

Add Vlan
	FOR    ${i}    IN RANGE    1    3    1
		Click Element       //button[@ng-click="addNewVlan()"]
	END
	Input Text    //body[contains(@class,'pace-done')]/div[contains(@class,'page-container')]/div[contains(@class,'page-content')]/div[contains(@class,'content-wrapper')]/div[contains(@class,'panel-flat')]/div[contains(@class,'panel panel-flat panel-margin-footer')]/div[contains(@class,'panel-body')]/div[contains(@class,'tabbable')]/div[contains(@class,'tab-content')]/div[@id='device-vlan-tab']/div[contains(@class,'ng-scope')]/form[contains(@class,'deviceProfileForm ng-pristine ng-valid ng-valid-min ng-valid-max ng-valid-required ng-valid-pattern')]/div[1]/div[1]/div[2]/table[1]/tbody[1]/tr[2]/td[2]/input[1]     11
	Input Text    //body[contains(@class,'pace-done')]/div[contains(@class,'page-container')]/div[contains(@class,'page-content')]/div[contains(@class,'content-wrapper')]/div[contains(@class,'panel-flat')]/div[contains(@class,'panel panel-flat panel-margin-footer')]/div[contains(@class,'panel-body')]/div[contains(@class,'tabbable')]/div[contains(@class,'tab-content')]/div[@id='device-vlan-tab']/div[contains(@class,'ng-scope')]/form[contains(@class,'deviceProfileForm ng-pristine ng-valid ng-valid-min ng-valid-max ng-valid-required ng-valid-pattern')]/div[2]/div[1]/div[2]/table[1]/tbody[1]/tr[2]/td[2]/input[1]    12
	Input Text    //body[contains(@class,'pace-done')]/div[contains(@class,'page-container')]/div[contains(@class,'page-content')]/div[contains(@class,'content-wrapper')]/div[contains(@class,'panel-flat')]/div[contains(@class,'panel panel-flat panel-margin-footer')]/div[contains(@class,'panel-body')]/div[contains(@class,'tabbable')]/div[contains(@class,'tab-content')]/div[@id='device-vlan-tab']/div[contains(@class,'ng-scope')]/form[contains(@class,'deviceProfileForm ng-pristine ng-valid ng-valid-min ng-valid-max ng-valid-required ng-valid-pattern')]/div[3]/div[1]/div[2]/table[1]/tbody[1]/tr[2]/td[2]/input[1]    60
	Click element   //button[@class="btn btn-icon btn-primary btnSaveVlan"]

Delete Vlan
	Click Element           //i[@class="icon-trash"][1]
	Click Element           //div[@class='modal fade modalDeleteVlan in']//div[@class='modal-dialog modal-sm']//div[@class='modal-content text-center']//div[@class='modal-footer text-center']//button[@class='btn btn-icon btn-warning btnSubmit']
########################## Config Wan ############################
Go to Config WAN
	Wait Until Element Is Visible       //a[contains(text(),'WAN')]
	Click Element                       //a[contains(text(),'WAN')]
	Sleep    5
	Page Should Contain                 WAN configuration

Edit WWan DHCP for wan index
	[Documentation]                     Edit WWAN0
	...                                 Connection Type: dhcp, pppoe, static
	...                                 Wan service: Ipv4, Ipv6, Dual
	...                                 WAN Preferred DNS
	...                                 WAN Second DNS
	...                                 IPv6 Type
	[Arguments]                         ${Type}         ${service}      ${DNS1}     ${DNS2}     ${TypeV6}
	Select From List By Value           //select[@name="connection_type"][1]       ${Type}
	Select From List By Value           //td[@class='my_space_td']//select[@class='form-control ng-valid ng-not-empty ng-valid-required ng-dirty ng-valid-parse ng-touched']        ${service}
	Input Text                          //input[@ng-model="wan.preferredDns"][1]    ${DNS1}
	Input Text                          //input[@ng-model="wan.alternateDns"][1]    ${DNS2}
	${stt}                              Run Keyword And Return Status    Wait Until Element Is Visible    //select[@ng-model="wan.ipv6Type"][1]         5
	IF    ${stt}
	     Select From List By Label      //select[@ng-model="wan.ipv6Type"][1]       ${TypeV6}
	END
	Click Element                       //button[@ng-click="updateWan()"]

Edit WAN PPPoE for Wan Index
	[Arguments]                         ${User}         ${PW}
	Select From List By Value           //select[@name="connection_type"][2]     pppoe
	Input Text                          //input[@name="pppoeUsername"][2]    ${User}
	Input Text                          //input[@name="pppoePassword"][2]    ${PW}
	Click Element                       //button[@ng-click="updateWan()"]

Edit WAN Static for Wan index
	[Arguments]                         ${Service}      ${Addr}     ${Subnet}   ${IPGate}   ${DNS1}     ${DNS2}
	Select From List By Value           //select[@name="connection_type"][1]    ${Service}
	Input Text                          //input[@name="ipAddress"][1]    ${Addr}
	Select From List By Value           //select[@ng-model="wan.subnetMask"][1]         ${Subnet}
	Input Text                          //input[@name="gateway"][1]         ${IPGate}
	Input Text                          //input[@ng-model="wan.preferredDns"][1]        ${DNS1}
	Input Text                          //input[@ng-model="wan.alternateDns"][1]    ${DNS2}
	Click Element                       //button[@ng-click="updateWan()"]

######################## Backup Config ####################
Backup config
	[Arguments]                         ${Backup_Name}
	Click element                       //span[contains(text(),'BACKUP')]
	Input Text                          //input[@name="desciptionBackup"]       ${Backup_Name}
	Click Element                       //button[@class="btn btn-primary btnBackupDevice"]


*** Test case ***
test
	Set Selenium Speed                  0.5
	Login to ONE Mesh                   one            one@2019
	Access Device detail                ${Serial}
	Go to Config WAN
	Edit WAN PPPoE for Wan Index        nsi2        ansv
