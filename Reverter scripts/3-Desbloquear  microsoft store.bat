@echo off

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v NoConnectedUser /f

reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v NoConnectedUser /f

reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /f

reg delete "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v RequirePrivateStoreOnly /f

reg delete "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /f

timeout /t 5 >nul

shutdown /l