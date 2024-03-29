#Import Syncro Function so we can create an RMM alert if out of date
Import-Module $env:SyncroModule

Function Getusbmmidd_v2 {
# Define 'maintenance' directory - if it doesn't exist, create it
$TARGETDIR = "c:\temp\3rdparty"
$filelocation = "c:\temp\3rdparty\usbmmidd_v2.zip"
if(!(Test-Path -Path $TARGETDIR )){
    New-Item -ItemType directory -Path $TARGETDIR
    write-output "Folder didn't exist, created folder"
     # Hide Folder
     $h=get-item "c:\temp" -Force
     $h.attributes="Hidden"
} 
# Check for executable - if it doesn't exist, download it and then extract it
$thisfile = "c:\temp\3rdparty\usbmmidd_v2.zip"
if(!(Test-Path $thisfile)){
        write-output "File doesn't exist yet, downloading file now"
        # Download the zip file
        # File is currently located at "https://www.amyuni.com/downloads/usbmmidd_v2.zip", but may not always be there. It is recommended to host the file yourself.
        $url = "WHEREVER YOU ARE HOSTING THE 'usbmmidd_v2.zip' FILE"
        (new-object System.Net.WebClient).DownloadFile($url,$thisfile)
        #Extract Files
        Expand-Archive $thisfile -destination $TARGETDIR -f
    }

}

Getusbmmidd_v2
Start-Sleep -s 5
cmd /c "c:\temp\3rdparty\usbmmidd_v2\deviceinstaller64 install usbmmidd.inf usbmmidd"
Exit 0
