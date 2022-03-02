REM  -Run as SYSTEM
REM  -This allows you to reboot the machine into safe mode and still be able to remotely access the machine.
REM  -NOTE: This script is set up to use Spashtop as the remote access tool. I believe the Backgrouding tool access will work as well.

REG ADD HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\Syncro /f /ve /t REG_SZ /d Service
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\SyncroLive /f /ve /t REG_SZ /d Service
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\SyncroOvermind /f /ve /t REG_SZ /d Service
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\Splashtop Inc." /f
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\SplashtopRemoteService" /f
bcdedit /set {current} safeboot network
shutdown -r -f -t 0
