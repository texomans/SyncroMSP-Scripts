## Run as: SYSTEM
## Max Script Time: 2 Minutes

Import-Module $env:SyncroModule

try {
    $volumes = "list volume" | diskpart | Where-Object { $_ -match "^  [^-]" } | Select-Object -skip 1
 
    $RAIDState = foreach ($row in $volumes) {
        if ($row -match "\s\s(Volume\s\d)\s+([A-Z])\s+(.*)\s\s(NTFS|FAT)\s+(Mirror|RAID-5|Stripe|Spanned)\s+(\d+)\s+(..)\s\s([A-Za-z]*\s?[A-Za-z]*)(\s\s)*.*") {
            $disk = $matches[2]         
            if ($row -match "OK|Healthy") { $status = "OK" }
            if ($row -match "Rebuild") { $Status = 'Rebuilding' }
            if ($row -match "Failed|At Risk") { $status = "CRITICAL" }
     
            [pscustomobject]@{
                Disk   = $Disk
                Status = $status
            }
        }
    }
    $RAIDState = $RAIDState | Where-Object { $_.Status -ne "OK" }
}
catch {
    write-output "Command has Failed: $($_.Exception.Message)"
 
}
 
if ($RAIDState) {
    write-ouput"Check Diagnostics. Possible RAID failure."
    write-ouput $RAIDState
}
else {
    write-output "Healthy - No RAID Mirror issues found"
}

if( -not($RAIDState -ne "OK")){
    Rmm-Alert -Category "RAID Status Failure" -Body "Warning: Check script output. Possible RAID failure."
}

Exit 0
