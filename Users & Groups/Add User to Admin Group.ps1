$group = "Administrators"

Write-Host "Adding local user $Username to $group."
& NET LOCALGROUP $group $Username /add