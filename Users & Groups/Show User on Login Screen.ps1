## Run as: SYSTEM
## Max Script Time: 2 Minutes
## Variable Needed: $UserName
 
$registryPath1 = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts"
$registryPath2 = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList"
$registryPath3 = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList\$UserName"
IF(!(Test-Path $registryPath1)){
  New-Item -Path $registryPath1 -Force
}
IF(!(Test-Path $registryPath2)){
  New-Item -Path $registryPath2 -Force
}
IF(!(Test-Path $registryPath3)){
  New-ItemProperty -Path $registryPath2 -Name $UserName -Value '1' -PropertyType DWORD -Force 
}
