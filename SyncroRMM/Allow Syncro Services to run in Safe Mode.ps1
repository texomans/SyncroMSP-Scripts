## Run as: SYSTEM
## Max Script Time: 10 Minutes
## This adds the Syncro Services to Safe Mode "Start with Networking" so you can carry on a remote session when troubleshooting in Safe Mode.
## This is best being added to your onboarding scripts.

REG ADD HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\Syncro /f /ve /t REG_SZ /d Service
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\SyncroLive /f /ve /t REG_SZ /d Service
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\SyncroOvermind /f /ve /t REG_SZ /d Service
