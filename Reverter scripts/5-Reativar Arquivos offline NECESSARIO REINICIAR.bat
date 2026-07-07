@echo off

:: Reativar Offline Files
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CSC" /v "Start" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CscService" /v "Start" /t REG_DWORD /d 2 /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Backup\Client" /v DisableBackupUI /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Backup\Client" /v DisableBackupLauncher /f


echo.
echo Pronto! Reinicie a maquina para aplicar as alteracoes.
pause