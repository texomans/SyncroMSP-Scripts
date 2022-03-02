## Run as SYSTEM

## This will disable the Control Panel and Windows Settings Module COMPLETELY. Run again changing variable to reenable them.
##
## Variable needed in RMM or script down below = $Enabled0Disabled1
## Disabled means Control Panel / Windows Settings module will be disabled.

# Get the RunAsUser Module if not installed
if (Get-Module -ListAvailable -Name RunAsUser) {
        
        Write-Host "RunAsUser Module is already installed. Continuing...."
        Import-Module RunAsUser 
    } else {
        Write-Host "RunAsUser was not installed. Installing it now."
    	Install-Module RunAsUser -Force
		Import-Module RunAsUser
	}

Update-Module RunAsUser

# Enable or Disable the Control Panel / Settings in Windows
if ($Enabled0Disabled1 -eq 1) {
    Write-Host "Setting the registy item to disable Control Panel & Settings...."
} else {
    Write-Host "Setting the registy item to enable Control Panel & Settings...."
}

New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel" -Value $Enabled0Disabled1 -PropertyType "DWord" -Force

Sleep 5

# Restart Windows Explorer to apply settings immediately
$scriptblock = {
    Stop-Process -processName: Explorer
}

Write-Host "Restarting Windows Explorer to make settings apply immediately...."
Invoke-ascurrentuser -scriptblock $scriptblock

Exit 0
