REM Run as: Logged On User
REM Max Script Time: 15 Minutes
REM Be careful, this wipes Chrome COMPLETELY like new install.

@echo off

set ChromeDir=%LOCALAPPDATA%\Google\Chrome\User Data

attrib +R +H +S "%ChromeDir%\Default\*Bookmarks*"
attrib +R +H +S "%ChromeDir%\Default\*Preferences*"
attrib +R +H +S "%ChromeDir%\Default\Extensions\*" /S /D
del /q /s "%ChromeDir%"
attrib -R -H -S "%ChromeDir%\Default\*Bookmarks*"
attrib -R -H -S "%ChromeDir%\Default\*Preferences*"
attrib -R -H -S "%ChromeDir%\Default\Extensions\*" /S /D
