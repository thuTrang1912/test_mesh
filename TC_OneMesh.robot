*** Settings ***
Library                      SeleniumLibrary            WITH NAME    SL
#run_on_failure=SL.Capture Page Screenshot
Library                  OperatingSystem
Library                  XML
Resource                 venv/lib/Selenium_lib/OMesh.robot
#Resource                 MeshAP/venv/lib/Selenium_lib/OMesh.robot

*** Variables ***
${User_N}       one
${PW}           one@2019

${Serial}               52dc

*** Keywords ***
Login to ONE Mesh
	[Arguments]                                 ${User_N}            ${PW}
	Open Browser                        http://mesh-staging.vnpt-technology.vn:9000/login?error=2       chrome
    Reload Page
    Input User Name                      ${User_N}
    Input User Name OM                   ${User_N}
    Input Password OM                    ${PW}
    #Click element                       //span[@class='glyphicon glyphicon-eye-open']
    Sleep    4
    Wait Until Element Is Visible       //button[@id='login-submit']
    Click Element                       //button[@id='login-submit']
    Sleep                               4
    Page Should Contain                 Welcome to the ONE MESH system
######### Login ##############################
*** Test Case ***
1. Config Lan
	Login to ONE Mesh                   ${User_N}    ${PW}
	Access Device detail Ap Mesh OM    ${Serial}

