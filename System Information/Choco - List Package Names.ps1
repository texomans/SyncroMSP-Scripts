## Run as: SYSTEM
## Max Script Time: 10 Minutes
## Add a custom asset field with a list package names for software that was installed by 3rd Party Patch Management.
## This script uses the Choco commands to return the list of installed package names.

#Script will fail if machine hasn't been rebooted since the Syncro agent was installed

Import-Module $env:SyncroModule

$packages = choco list -l -r --idonly

Write-Output $packages

#It is necessary to create a custom asset field that maches the 'Name' in the next line
Set-Asset-Field -Name "Installed Choco Packages" -Value $packages
