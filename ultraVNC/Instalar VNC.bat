@echo off
setlocal

:: Verifica se está executando como Administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando privilegios administrativos...

    powershell -Command ^
    "Start-Process '%~f0' -Verb RunAs"

    exit /b
)


:: Vai para a pasta onde está o BAT
cd /d "%~dp0"

:: Executa o PowerShell como administrador
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0UltraVNC.ps1" -InstallerPath "%~dp0UltraVNC_1_2_1_7_X64_Setup.exe"

echo.
echo Processo finalizado.
pause