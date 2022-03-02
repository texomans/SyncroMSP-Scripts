Import-Module $env:SyncroModule

(get-wmiobject -namespace root\CIMv2\Security\MicrosoftVolumeEncryption -class Win32_EncryptableVolume -filter "DriveLetter = `"$env:SystemDrive`"").ProtectionStatus -eq 1 | Tee-Object -Variable Encrypt_Status

Set-Asset-Field -Name "Bitlocker Encrypted" -Value $Encrypt_Status
