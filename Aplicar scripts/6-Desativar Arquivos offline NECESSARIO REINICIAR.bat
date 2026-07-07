@echo off

:: Desinstalar OneDrive
taskkill /f /im OneDrive.exe 2>nul

set ONEDRIVE32=%SystemRoot%\System32\OneDriveSetup.exe
set ONEDRIVE64=%SystemRoot%\SysWOW64\OneDriveSetup.exe

if exist "%ONEDRIVE32%" (
    "%ONEDRIVE32%" /uninstall
) else if exist "%ONEDRIVE64%" (
    "%ONEDRIVE64%" /uninstall
) else (
    echo OneDrive nao encontrado, pulando...
)

:: Desativar Offline Files
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CSC" /v "Start" /t REG_DWORD /d 4 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CscService" /v "Start" /t REG_DWORD /d 4 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Backup\Client" /v DisableBackupUI /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Backup\Client" /v DisableBackupLauncher /t REG_DWORD /d 1 /f

echo.
echo Pronto! Reinicie a maquina para aplicar as alteracoes.
pause