*** Settings ***
Library    SeleniumLibrary  WITH NAME   SL
Library    SSHLibrary   WITH NAME        SSHL
*** Variables ***
${Browser}                  chrome
${user_name}                root
${defaul_PW}                VNPT
${PassWord}                 ttcn@99CN
${WebGUI_IP}                192.168.99.1

${Mesh_SSID}                R1
${Mesh_PW}                  12345678

${New_SSID}                 Change5 SSID 999
${New_PW}                   12345678 9 c5

@{MRE_List}=                 EW_86af28

${CAP_Mac_Address}          A4:F4:C2:0B:52:DC
${CAP_Name_defautl}         EW_0b52dc

${MRE_Mac_Adress}           CC:71:90:86:AF:28
${MRE_Name_defautl}         EW_86af28

${CAP_Name}                 EW_0b52dc
${MRE_Name}                 EW_86af28

${ssh_server_IP}                192.168.88.200
${ssh_server_username}          ubuntu
${ssh_server_PW}                1

############# Guest SSID################
${2Guest_SSID}       R1_Guest24
${2Authen_Mode}      WPA-PSK/WPA2-PSK Mixed mode
${2Guest_PW}         12345678

${5Guest_SSID}       R1_Guest5g
${5Authen_Mode}      WPA-PSK/WPA2-PSK Mixed mode
${5Guest_PW}         12345678
####LAN####
#Basic
#IPv4 Only
${LAN_IPv4_Adr}     192.168.99.1
${LAN_Subnet_mark}  255.255.255.0
#LAN DHCP
${LAN_Start_IPAdr}      192.168.99.50
#${LAN_Num_IPAdr}        150
${LAN_LeaseTime}        4300
${mtu_sz}               1500

### Dual Stack
${DHCPv6 Mode}                  Statefull Only
${PriDNS_v6}                    2001:4860:4860::8888
${SeDNS_v6}                     2001:4860:4860::8844

*** Keywords ***
Get Alert Test
	${Text}             SL.Handle Alert
Acept Alert Reconnect Wifi If Present
	Wait Until Keyword Succeeds    120    10    SL.Handle Alert
#	IF    $Alert != None
#	     SL.Handle Alert

Open SSH Session Login To Local Machine
    SSHL.Open Connection        ${ssh_server_IP}
    ${login_output}             SSHL.Login                ${ssh_server_username}        ${ssh_server_PW}
    Should Contain              ${login_output}     ${ssh_server_username}
    SSHL.Execute Command         sudo su
    SSHL.Write    1

### WAN PPPoE #####