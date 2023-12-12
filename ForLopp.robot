*** Settings ***
Library                String     WITH NAME    STR
*** Variables ***
@{ROBOTS}=      Bender    Johnny5    Terminator    Robocop
@{test}=    11      12      60
${a}        WPA-PSK/ WPA2-PSK Mixed Mode

*** Tasks ***
Execute a for loop only three times
    FOR    ${robot}    IN   @{test}
#        IF    $robot == 'Terminator'    CONTINUE
        Log To Console    ${robot}
    END
#${a}        Set variable        WPA-PSK/ WPA2-PSK Mixed Mode
	${a1}        Replace String    ${a}    ${a[9]}   ${EMPTY}

	Log To Console    ${a1}
