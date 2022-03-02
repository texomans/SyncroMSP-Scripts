$group = "Remote Desktop Users"

Write-Host "Adding local user $Username to $group."
& NET LOCALGROUP $group $Username /add
