## Run as: SYSTEM
## Max Script Time: 10 Minutes
## Needed variable is $computername

:CheckOS
IF("%PROGRAMFILES(X86)%")
{
    GOTO 64BIT
} 
    else 
{
    GOTO 32BIT
}

# IF EXIST "%PROGRAMFILES(X86)%" (GOTO 64BIT) ELSE (GOTO 32BIT)


:32BIT

reg add "HKLM\SOFTWARE\Splashtop Inc.\Splashtop Remote Server" /f /v CloudComputerName /t REG_SZ /d $computername

GOTO END


:64BIT

reg add "HKLM\SOFTWARE\WOW6432Node\Splashtop Inc.\Splashtop Remote Server" /f /v CloudComputerName /t REG_SZ /d $computername

GOTO END


:END
net stop splashtopremoteservice
net start splashtopremoteservice
