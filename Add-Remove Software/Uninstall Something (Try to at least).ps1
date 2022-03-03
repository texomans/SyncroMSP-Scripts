## Run as: SYSTEM
## Max Script Time: 10 Minutes
## Be sure to add a variable for $uninstallProg. We usually are able to just copy and paste the program name from the list of "Installed Apps" on the asset.
## You can also use what you know about the name, but that may lead to the wroing application being uninstalled. Example would be "Continuum" for the RMM, but
## in fact could uninstall "Boris FX Continuum Plug-ins 11 for Corel VideoStudio 2018". So, USE WITH CAUTION!

$uninstallProg = "SOME_PROGRAM_NAME"

Import-Module $env:SyncroModule
#attempt to uninstall an application via powershell
$GetApps = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -Contains $uninstallProg }
$GetPackages = Get-Package -Provider Programs -IncludeWindowsInstaller -Name "$uninstallProg"
$GetProducts = wmic product where "name like '%%$uninstallProg%%'"

if ($GetApps -eq $uninstallProg) {
    Write-Host "Attempting to uninstall $uninstallProg based on WMI info:`n $removeApp"
    $GetAppsUnInstall.Uninstall()
}
elseif ($GetPackages -eq $uninstallProg) {    
    Write-Host "Attempting to uninstall $uninstallProg based on Get-Package method."
    Uninstall-Package -Name $uninstallProg
}
elseif ($GetProducts -contains $uninstallProg) {
    Write-Host "Attempting to uninstall $uninstallProg based on WMIC method"
    wmic product where "name like '%%$uninstallProg%%'" call uninstall /nointeractive
}
else {
    Write-Host "Could not uninstall using above methods. Try using one of the below programs with the Get-Package method."
    $WMIPrograms = Get-WmiObject -Class Win32_Product
    $GetPackagesPrograms = Get-Package -Provider Programs -IncludeWindowsInstaller
    # $WMICPrograms = wmic product list
    Rmm-Alert -Category 'Failed Uninstall' -Body 'Could not uninstall using automated methods. Check the listed programs file that has been attached to the asset.'
    $filename = "C:\.texomans\SyncroRMM\Installed Programs.txt"
    $WMIPrograms | Select-Object IdentifyingNumber, Name, Vendor, Version, Caption | Sort-Object Name | Out-File $filename -append
    $GetPackagesPrograms | Select-Object Name, Version, Source, ProviderName | Sort-Object Name | Out-File $filename -append
    Upload-File -FilePath "C:\.texomans\SyncroRMM\Installed Programs.txt"
    Remove-Item "C:\.texomans\SyncroRMM\Installed Programs.txt"
}
Exit 0
