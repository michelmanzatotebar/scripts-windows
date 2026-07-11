@echo off

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ==========================================
    echo   ERRO: Execute como ADMINISTRADOR
    echo ==========================================
    echo.
    pause
    exit
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0\wallpaper\scriptWallpaper.ps1"