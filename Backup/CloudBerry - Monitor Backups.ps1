## Run as: SYSTEM
## Max Script Time: 10 Minutes
## This script will make sure CloudBerry is there and optionally;
## - Alert if not found
## - Alert if backup failed
## - Alert if no backups scheduled
## Schedule this at a similar schedule to your backups, if you have a daily backup, you should probably run this daily. 

Import-Module $env:SyncroModule

# Get these 2 values from this page; https://mbs.cloudberrylab.com/Admin/Settings.aspx
$whitelabelCompanyName = "COMPANY_NAME"
$whitelabelProductName = "SOFTWARE NAME"

$alertIfCloudBerryNotFound = "Yes"
$alertIfNothingScheduled = "Yes"
$alertIfLastBackupFailed = "Yes"

# Create temp file if it does not already exist
$path = "c:\temp"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

$tmpFile = "C:\temp\cbboutput.txt"

############################### NO NEED TO EDIT BELOW THIS LINE ########################################
$pathToExe = "C:\Program Files\$whitelabelCompanyName\$whitelabelProductName\cbb.exe"

#### Find cbb.exe ##### FIXME
#$cbbDir = (Get-Childitem –Path "C:\Program Files" -Include "cbb.exe" -File -Recurse -ErrorAction SilentlyContinue).directoryname
#write-host "CloudBerry Detected at $cloudberryDirectory"
if (Test-Path -Path $pathToExe) {
    Write-Host "cbb.exe found - continuing"
}
else {
    Write-Host "cbb.exe NOT FOUND - bailing out!"
    if ($alertIfCloudBerryNotFound -eq 'Yes'){
        Rmm-Alert -Category 'cloudberry:_not_installed' -Body "CloudBerry was not found on this computer in $pathToExe"
    }
    exit
}

& cmd /c $pathToExe plan -l > $tmpFile 2>&1
gc $tmpFile
$output = gc $tmpFile

############ SAMPLE OUTPUT ################
# YOUR WHITELABEL COMPANY Desktop/Server (File Backup) Edition Command Line Interface started
# Existing plans list:
# 1. Name: 'My Documents Backup - predefined plan (includes My Pictures)'
#    ID: 2279323b-a82a-4892-b785-eb847b1c161f
#    Last result: Success
# 2. Name: 'My Internet Bookmarks backup - predefined plan'
#    ID: c41df043-79ff-4943-94d6-8a8ad3920603
#    Last result: Never started
# 3. Name: 'My Pictures Backup - predefined plan'
#    ID: 3be466bc-3c3c-4c61-a038-1583724c7bb9
#    Last result: Never started

## Write out details of all defined plans to our logfiles here ##
[regex]$regex = '\w+-\w+-\w+-\w+-\w+'
$regex.Matches($output) | foreach-object {
    # these are the plan IDs ^
    #cbb.exe getBackupPlanDetails -id planID
    $planDetails = (& cmd /c $pathToExe getBackupPlanDetails -id $_.Value 2>&1)
    write-host $_.Value
}

## Try to get Success and Fails - ignore Never Started
$plans = ($output | select-string  -pattern "Last result" -Context 2,0)
$scheduledPlans = 0

ForEach ($plan in $plans){
    write-host "PLAN FOUND: $plan"
    $neverRan = $plan | select-string  -pattern "Last result:" | select-string -pattern "Never"
    $succeeded = $plan | select-string  -pattern "Last result:" | select-string -pattern "Success"
    $failed = $plan | select-string  -pattern "Last result:" | select-string -pattern "Fail"
    
    if ($neverRan){
        write-host "PLAN NEVER RAN"       
    }
    elseif ($succeeded) {
        $scheduledPlans = $scheduledPlans+1
        write-host "SUCCEEDED!!"
    }
    elseif ($failed) {
        $scheduledPlans = $scheduledPlans+1
        write-host "FAILED!!!!@#" 
        if ($alertIfLastBackupFailed -eq "Yes"){
            Rmm-Alert -Category 'cloudberry:_backup_failure' -Body "CloudBerry Plan Last Status: Failed - $plan"
        }

    }
}

if ($scheduledPlans -eq 0 -And $alertIfNothingScheduled -eq 'Yes'){
    Rmm-Alert -Category 'cloudberry:_no_tasks' -Body "CloudBerry is here but has no scheduled Backups!" 
}


## CLEANUP ##
remove-item -path $tmpFile

exit
