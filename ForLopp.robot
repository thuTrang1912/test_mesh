*** Variables ***
@{ROBOTS}=      Bender    Johnny5    Terminator    Robocop
@{test}=    11      12      60

*** Tasks ***
Execute a for loop only three times
    FOR    ${robot}    IN   @{test}
#        IF    $robot == 'Terminator'    CONTINUE
        Log To Console    ${robot}
    END
