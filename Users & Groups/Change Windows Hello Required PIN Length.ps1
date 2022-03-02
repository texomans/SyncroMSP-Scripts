## Run as SYSTEM
## VAriable needed: PIN_Length

reg add "HKLM\SOFTWARE\Policies\Microsoft\PassportForWork\PINComplexity" /V MinimumPINLength /T REG_dWORD /D $PIN_Length /F
