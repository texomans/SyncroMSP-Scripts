Import-Module $env:SyncroModule
$SaveLocation = "C:\temp"
$FolderLocation = "Bluescreenview"
$ExecLocation = "C:\.texomans\Bluescreenview"

try {
    Invoke-WebRequest -Uri "https://www.nirsoft.net/utils/bluescreenview.zip" -OutFile "$SaveLocation\Bluescreeview.zip"
    Expand-Archive "$SaveLocation\Bluescreeview.zip" -DestinationPath "$SaveLocation\$FolderLocation" -Force
    Start-Process -FilePath "$ExecLocation\Bluescreenview.exe" -ArgumentList "/stext $ExecLocation\Bluescreens.txt"
    Start-Process -FilePath "$ExecLocation\Bluescreenview.exe" -ArgumentList "/scomma $ExecLocation\Export.csv" -Wait
 
}
catch {
    Write-Host "BSODView Command has Failed: $($_.Exception.Message)"
    exit 1
}
 
$BSODs = get-content $ExecLocation\Export.csv | ConvertFrom-Csv -Delimiter ',' -Header Dumpfile, Timestamp, Reason, Errorcode, Parameter1, Parameter2, Parameter3, Parameter4, CausedByDriver | foreach-object { $_.Timestamp = [datetime]::Parse($_.timestamp, [System.Globalization.CultureInfo]::CurrentCulture); $_ }
Remove-item $ExecLocation\Export.csv -Force
 
$BSODFilter = $BSODs | where-object { $_.Timestamp -gt ((get-date).addhours(-24)) }
 
if (!$BSODFilter) {
    write-host "Healthy - No BSODs found in the last 24 hours"
}
else {
    write-host "Unhealthy - BSOD found. Check Diagnostics"
Rmm-Alert -Category 'BSOD' -Body "BSOD Found. Error was $($BSODFilter.Reason), caused by driver $($BSODFilter.CausedByDriver) with errorcode $($BSODFilter.Errorcode). The full TXT file can be found on the asset's attachments."
}

Upload-File -FilePath "$ExecLocation\Bluescreens.txt"

exit 0
