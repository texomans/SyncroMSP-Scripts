REM  -Run as SYSTEM
REM  -Max Script Time: 10 Minutes
REM  -This allows you to reboot the machine back out of safe mode.

bcdedit /deletevalue {current} safeboot
shutdown -r -f -t 0
