*** Settings ***
Library         SSHLibrary
Resource        venv/lib/SSH_Lib/SSH_Connect_wifi.robot
*** Variables ***
${ssh_server_IP}                192.168.88.200
${ssh_server_username}          ubuntu
${ssh_server_PW}                1
*** Keywords ***

*** Test Cases ***
test
    SSHL.Open Connection   ${ssh_server_IP}
    ${login_output}     SSHL.Login             ubuntu    1
    Should Contain          ${login_output}     ${ssh_server_username}
#    Log To Console    SU
#    SSHL.Execute Command    su
#    Log To Console    1
#    SSHL.Write    1
#    ${written}= 	SSHL.Execute Command 	su
#    Should Contain 	${written} 	su 	# Returns the consumed output
#    ${output}= 	SSHL.Read
#    Should Not Contain 	${output} 	${written} 	# Was consumed from the output
#    Should Contain 	${output} 	Password:
#    SSHL.Write 	1


    ${log}  SSHL.Write      su
    ${OP}           SSHL.Read
    Log   ${OP}
    Should Contain    ${OP}    Password:
    SSHL.Write    1
    Log To Console    ${log}
    Should Contain           ${log}         root@ubuntu


#    Wait Until Keyword Succeeds    120    5    Wifi Rescan Contain   Phong 201