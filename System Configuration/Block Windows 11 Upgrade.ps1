## Run as SYSTEM
## Max Script Time: 10 Minutes
## 1 Variable is required. Add $TargetVersion as the limit of upgrades. We have a dropdown with both "21H1" and "21H2" depending on the client.
## This script blocks the upgrade to Windows 11 by setting the maximum version of Windows 10 to the latest Windows 10 update.
## This prevents Windows Update from offering a Windows 11 upgrade.


reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /f /v TargetReleaseVersion /t REG_DWORD /d 1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /f /v TargetReleaseVersionInfo /t REG_SZ /d $TargetVersion
