## Run as SYSTEM

#Script will fail if machine hasn't been rebooted since the Syncro agent was installed

Import-Module $env:SyncroModule

$packages = choco list -l -r --idonly

Write-Output $packages

#It is necessary to create a custom asset field that maches the 'Name' in the next line
Set-Asset-Field -Name "Installed Choco Packages" -Value $packages
