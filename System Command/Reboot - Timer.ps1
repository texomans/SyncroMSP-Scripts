## Run as: SYSTEM
## Max Script Time: 2 Minutes
## Variable Needed: $Minutes
## Use this script to reboot a Windows device with a variable to submit how many minutes (not seconds) before the reboot happens with a custom notification to the end user.
## Too many users forgetting to submit "seconds" instead of minutes, causing 5-second reboots, for example. This script solves that easily made mistake.

$TimeInSeconds = [int]$Minutes*60

shutdown /r /t $TimeInSeconds /c "This computer is scheduled to reboot in $Minutes minutes. Please save ALL data before this time or it may be lost."

exit
