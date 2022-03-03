## Run as: SYSTEM
## Max Script Time: 1 Minutes
## Variable Needed: $Username

$group = "Administrators"

Write-Host "Adding local user $Username to $group."
& NET LOCALGROUP $group $Username /add
