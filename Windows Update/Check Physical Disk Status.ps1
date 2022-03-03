## Run as: SYSTEM
## Max Script Time: 2 Minutes

Import-Module $env:SyncroModule

try {
    $Disks = get-physicaldisk | Where-Object { $_.HealthStatus -ne "Healthy" }
}
catch {
    write-output "Command has Failed: $($_.Exception.Message)"
    exit 1
}
 
if ($disks) {
    write-output "Check Diagnostics. Possible disk failure."
    write-output $disks
    exit 1
}
else {
    write-output "Healthy"
}

if( -not($_.HealthStatus -ne "Healthy")){
  Rmm-Alert -Category "Physical Disk Failure" -Body "Warning: Check script output. Possible disk failure."
}
