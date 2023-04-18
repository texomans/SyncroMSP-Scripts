#Import Syncro Function so we can create an RMM alert if out of date
Import-Module $env:SyncroModule

# Be sure to add a dropdown variable called $AddRemove and use the options "Add" and "Remove"
if ($AddRemove -eq "Add") {
cmd /c "c:\temp\3rdparty\usbmmidd_v2\deviceinstaller64.exe enableidd 1"
Exit 0
}

if ($AddRemove -eq "Remove") {
cmd /c "c:\temp\3rdparty\usbmmidd_v2\deviceinstaller64.exe enableidd 0"
Exit 0
}
