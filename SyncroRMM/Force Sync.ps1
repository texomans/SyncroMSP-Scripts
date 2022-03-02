<#
.Synopsis
  Forces the Syncro agent to perform a Full Sync.
 
.DESCRIPTION
  Take note that this script will restart the Syncro service. This is done on a delay so the script is reported as successful on the dashboard.
 
  The script also adds an Activity Log on the asset if the full sync was successful.
 
  USE AT YOUR OWN RISK.
 
.NOTES
  Version:        1.0
  Author:         Alexandre-Jacques St-Jacques
  Creation Date:  15-05-2021
  Purpose/Change: Initial script development
 
.LINK 
  https://github.com/Maelstrom96/SyncroMSP-Scripts/blob/main/scripts/syncro-force-fullsync.ps1
#>
 
$UpdateTime = (Get-Date).ToUniversalTime().AddMinutes(5).ToString("yyyy-MM-ddTHH:mm:ss.0000000Z")
#Update Syncro last_sync registry value
Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\RepairTech\Syncro" -Name "last_sync" -Value "$UpdateTime"
 
function Run-InNewProcess{
  param([String] $code)
  $code = "function Run{ $code }; Run $args"
  $encoded = [Convert]::ToBase64String( [Text.Encoding]::Unicode.GetBytes($code))
 
  start-process -WindowStyle hidden PowerShell.exe -argumentlist '-windowstyle','hidden','-noExit','-encodedCommand',$encoded
}
 
$script = {
    $CurrentDateString = (Get-Date).ToString("yyyyMMdd")
    $LogLocation = "C:\ProgramData\Syncro\logs\$CurrentDateString-Syncro.Service.Runner.log"
    
    try {
        Import-Module $env:SyncroModule -erroraction stop 
    }
    catch {
        $env:RepairTechUUID = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\RepairTech\Syncro" -Name "uuid").uuid
        $env:RepairTechApiBaseURL = "syncromsp.com"
        $env:RepairTechApiSubDomain = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\RepairTech\Syncro" -Name "shop_subdomain").shop_subdomain
        $env:RepairTechFilePusherPath = "$($env:PROGRAMDATA)\Syncro\bin\FilePusher.exe"
 
        Import-Module "$($env:PROGRAMDATA)\Syncro\bin\module.psm1" 3>$null
    }
    
    Start-Sleep -s 10; 
    Restart-Service -Name "Syncro" -Force
    
    Log-Activity -Message "Restarted Syncro Service for Full Sync" -EventName "SyncroRestart"
 
    # Hack to get Get-Content -wait to work properly
    $hackJob = Start-Job {
      $f=Get-Item $LogLocation
      while (1) {
        $f.LastWriteTime = Get-Date
        Start-Sleep -Seconds 1
      }
    }
    
    # Job that confirms if the sync happened
    $job = Start-Job { param($LogLocation)
            try {
                Import-Module $env:SyncroModule -erroraction stop 
            }
            catch {
                $env:RepairTechUUID = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\RepairTech\Syncro" -Name "uuid").uuid
                $env:RepairTechApiBaseURL = "syncromsp.com"
                $env:RepairTechApiSubDomain = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\RepairTech\Syncro" -Name "shop_subdomain").shop_subdomain
                $env:RepairTechFilePusherPath = "$($env:PROGRAMDATA)\Syncro\bin\FilePusher.exe"
 
                Import-Module "$($env:PROGRAMDATA)\Syncro\bin\module.psm1" 3>$null
            }
        
        Get-Content $LogLocation -tail 0 -wait | where { $_ -match "Large sync complete" } |% { Log-Activity -Message "Full Sync Successful" -EventName "SyncroFullSync"; break }
    } -Arg $LogLocation
    
    # Wait for the Activity-Log job to complete or to timeout
    Wait-Job $job -Timeout 60
    
    # Cleanup jobs
    Get-Job | Stop-Job
    Get-Job | Remove-Job
}
 
Run-InNewProcess $script | Out-Null
 
Exit 0
