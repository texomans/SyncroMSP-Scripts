net stop "AutoPrintr Service"
Taskkill /IM AutoPrintr.exe /F
net start "AutoPrintr Service"
start "" "C:\Program Files (x86)\RepairShopr\AutoPrintr\AutoPrintr.exe" --new-window/min

exit
