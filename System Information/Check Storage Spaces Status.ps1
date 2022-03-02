Import-Module $env:SyncroModule

try {
    $RAIDState = Get-VirtualDisk | where-object { $_.OperationalStatus -ne "OK"}
    }
    catch {
        write-output "Command has Failed: $($_.Exception.Message)"
        exit 1
    }
     
    if ($RAIDState) {
        write-output "Check Diagnostics. Possible RAID failure."
        write-output $RAIDState
        exit 1
    }
    else {
        write-output "Healthy - No StorageSpace issues found"
    }
    
if( -not($_.OperationalStatus -ne "OK")){
    Rmm-Alert -Category "RAID Status Failure" -Body "Warning: Check script output. Possible Storage Space failure."
}
