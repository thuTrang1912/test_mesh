*** Settings ***
Library                      SeleniumLibrary            WITH NAME    SL
#run_on_failure=SL.Capture Page Screenshot
Library                  OperatingSystem
Library                  XML
Resource                 lib/Selenium_lib/OMesh.robot
#Resource                 MeshAP/venv/lib/Selenium_lib/OMesh.robot

*** Variables ***
${User_N}       one
${PW}           one@2019

${Serial}               52dc

*** Keywords ***

######### Login ##############################
*** Test Case ***
1. Config wifi
	Login to ONE Mesh                  ${User_N}    ${PW}
	Access Device detail OM            ${Serial}


