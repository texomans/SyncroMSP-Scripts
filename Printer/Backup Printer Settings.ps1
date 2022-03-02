# Backup current settings of the specified printer to C:\temp\Configs\Printers\"Computer Name" - "Printer Name" - PrinterSettings.dat

$ComputerName = [Environment]::MachineName
$Path = "C:\temp\Configs\"
$FolderName = "Printers"


if (!(Test-Path $Path$FolderName))
{
New-Item -itemType Directory -Path $Path -Name $FolderName
}
else
{
write-host "Folder already exists"
}

RUNDLL32.EXE PRINTUI.DLL,PrintUIEntry /Ss /n $PrinterName /a "$Path$FolderName\$ComputerName - $PrinterName - PrinterSettings.dat"
