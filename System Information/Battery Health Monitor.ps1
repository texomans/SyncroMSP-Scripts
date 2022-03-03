## Run as: SYSTEM
## Max Script Time: 10 Minutes
## Monitors battery health by comparing the reported last charge value to the maximum charge value.
## Set your own percentage as an acceptable failure rate. E.g. "50" is 50% health.

$BatteryReport = "C:\temp\batteryreport.xml"
Import-Module $env:SyncroModule
& powercfg /batteryreport /XML /OUTPUT $BatteryReport
start-sleep 3
[xml]$Report = Get-Content "$BatteryReport"
    
$BatteryStatus = $Report.BatteryReport.Batteries |
ForEach-Object {
    [PSCustomObject]@{
        DesignCapacity     = $_.Battery.DesignCapacity
        FullChargeCapacity = $_.Battery.FullChargeCapacity
        CycleCount         = $_.Battery.CycleCount
        Id                 = $_.Battery.id
    }
}

$AlertPercent = "50"

if (!$BatteryStatus.DesignCapacity) {
    Write-Host "This device does not have batteries, or we could not find the status of the batteries."
    Exit 0
}

foreach ($Battery in $BatteryStatus) {
    if ([int64]$Battery.FullChargeCapacity * 100 / [int64]$Battery.DesignCapacity -lt $AlertPercent) {
        $LifeLeft = ([int64]$Battery.FullChargeCapacity * 100 / [int64]$Battery.DesignCapacity)
        $LifeLeftRounded = ([math]::Round($LifeLeft,2))
        Rmm-Alert -Category 'Battery_Health' -Body "The battery health is less than expected. The battery was designed for $($battery.DesignCapacity)mAh but the maximum charge is $($Battery.FullChargeCapacity)mAh. The remaining life of the battery is $LifeLeftRounded%. The battery info is $($Battery.id)"
    }else  {
        $LifeLeft = ([int64]$Battery.FullChargeCapacity * 100 / [int64]$Battery.DesignCapacity)
        $LifeLeftRounded = ([math]::Round($LifeLeft,2))
        Write-Host "The remaining life of the battery is $LifeLeftRounded%."
}
}
