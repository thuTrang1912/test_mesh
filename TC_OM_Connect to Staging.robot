*** Settings ***
Library                      SeleniumLibrary            WITH NAME    SL
Library                SSHLibrary     WITH NAME    SSHL
Library                String     WITH NAME    STR

Resource                venv/lib/Variable.robot
Resource                lib/Selenium_lib/OMesh.robot

#run_on_failure=SL.Capture Page Screenshot
Library                 OperatingSystem

*** Variables ***
${User_N}       one
${PW}           one@2019

${Config_path}             /etc/config/easycwmp
${SSH_ip}                  192.168.88.1
${SSH_PW}                  VNPT@88Tech

${OM_User}                  one
${OM_PW}                    one@2019
${Mesh_defaul}              EW_0b52dc



*** Keywords ***
SSH to Mesh Ap
	[Arguments]                     ${SSH_ip}           ${SSH_PW}
	Log To Console                  \nSSH to Mesh AP
    ${Output}                       SSHL.write          sudo ssh ${SSH_ip}
    Sleep   5
    ${Out0}             Read
    SSHL.Write          1
    Sleep               3
    SSHL.Write          ${SSH_PW}
    Sleep    5
    ${out}              SSHL.read
    Sleep    7
    Should Contain       ${out}       root@VNPT:
    Log To Console                  \n SSH to Mesh AP succesfully



Connect Mesh AP to Staging
	Open SSH Session Login To Local Machine
	SSH to Mesh Ap              ${SSH_ip}           ${SSH_PW}
    Sleep    5
    Log To Console              \n change config ACS
    SSHL.Write                  cat /etc/config/easycwmp
    Sleep       10
    ${Log}                      SSHL.Read
    Log                         ${Log}
    ${New_Log}                  STR.Replace String        ${Log}        mesh    mesh-staging
    log                         ${New_Log}
    #### Oevr rwite to file config: >
    #SSHL.Execute Command        Remove ${Config_path}
    Remove file                 ${Config_path}
    Append To File              ${New_Log}  ${Config_path}
    ${2}                        SSHL.Read
	#SSHL.Write           reboot
	${1}                 Read
Check connect to staging successfully
	[Arguments]                 ${Mesh_name_default}
#	${Serial}            Split String        ${Mesh_defaul[-5:]}        _
#	Log             ${Serial}
	Wait Until Element Is Visible       //span[contains(text(),'Configuration')]        10
	Click Element                       //span[contains(text(),'Configuration')]
	Wait Until Element Is Visible       //body[contains(@class,'pace-done')]/div[@class='page-container']/div[@class='page-content']/div[@class='content-wrapper']/div[@class='panel panel-flat']/div[@class='panel-body padding-panel-search']/form[@class='form-horizontal form-search row ng-pristine ng-valid ng-valid-maxlength']/div[@class='col-md-10']/div[2]/div[1]/div[1]/input[1]
	Input Text                          //input[@name= 'serialNumber']    af28
	Click Element                       //button[contains(@type,'submit')]//i[contains(@class,'icon-search4')]
	Sleep                               5
	Page Should Contain Element         //a[contains(text(),'${Mesh_name_default}')]
	${Mesh_stt}                         Get Text         //a[contains(text(),'${Mesh_name_default}')]//preceding::td[1]
	Should Match                        ${Mesh_stt}         ONLINE

	    #Should Be Equal As Strings    ${result}    ${EMPTY}    # Kiểm tra xem quá trình ghi đã thành công hay không
*** Test Cases ***
Test config
	Connect Mesh AP to Staging
	Sleep       160
	Login to ONE Mesh               ${OM_User}            ${OM_PW}
	Check connect to staging successfully        EW_86af28
	@{s}            Split String        ${Mesh_defaul[-5:]}        _
	Log             @{s}


