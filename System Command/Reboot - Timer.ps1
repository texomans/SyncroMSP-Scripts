## Run as SYSTEM
# Add variable $Minutes

$TimeInSeconds = [int]$Minutes*60

shutdown /r /t $TimeInSeconds /c "This computer is scheduled to reboot in $Minutes minutes. Please save ALL data before this time or it may be lost."

exit
