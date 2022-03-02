#Set NumLock ON at Windows login screen

$path = 'Registry::\HKEY_USERS\.DEFAULT\Control Panel\Keyboard\'
$name = 'InitialKeyboardIndicators'
$value = '2'
Set-Itemproperty -Path $path -Name $name -Value $value

 Write-Host "NumLock ON at Windows login screen"
