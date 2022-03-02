## Run as SYSTEM

REG ADD HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\Syncro /f /ve /t REG_SZ /d Service
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\SyncroLive /f /ve /t REG_SZ /d Service
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\SyncroOvermind /f /ve /t REG_SZ /d Service
