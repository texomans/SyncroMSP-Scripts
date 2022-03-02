## Run as SYSTEM
# Add variable $TimeNumberAMPM. Named it that so that we would remember how to input it.

# Use this script to reboot a Windows device at a specified time. Use Time+AM/PM such as 8PM or 8:15PM

[datetime]$RestartTime = $TimeNumberAMPM
[datetime]$CurrentTime = Get-Date
[int]$WaitSeconds = ( $RestartTime - $CurrentTime ).TotalSeconds
shutdown -r -f -t $WaitSeconds

Write-Host "Restart Time: [datetime]$RestartTime"
Write-Host "Seconds to Reboot: $WaitSeconds"
