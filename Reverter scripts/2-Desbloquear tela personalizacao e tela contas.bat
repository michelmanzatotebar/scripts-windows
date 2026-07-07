@echo off

:: Verifica se está sendo executado como Administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ==========================================
    echo   ERRO: Execute este script como ADMINISTRADOR
    echo ==========================================
    echo.
    pause
    exit /b
)

:: Desbloqueia papel de parede
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v NoChangingWallPaper /f

:: Desbloqueia abas de personalização
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoThemesTab /f

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDispBackgroundPage /f

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDispAppearancePage /f

:: Reexibe páginas de Personalização e Contas
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v SettingsPageVisibility /f

:: Restaura opção Personalizar
reg delete "HKCR\DesktopBackground\Shell\Personalize" /v LegacyDisable /f

:: Fecha Configurações
taskkill /f /im SystemSettings.exe >nul 2>&1

:: Faz logoff para aplicar
timeout /t 5 >nul

shutdown /l