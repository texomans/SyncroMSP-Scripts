## Run as SYSTEM
## 1 Variable is required. Add $TargetVersion as the limit of upgrades. We have a dropdown with both "21H1" and "21H2" depending on the client.

reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /f /v TargetReleaseVersion /t REG_DWORD /d 1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /f /v TargetReleaseVersionInfo /t REG_SZ /d $TargetVersion
