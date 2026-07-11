# --- Verifica ADM ---
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host ""
    Write-Host "  ERRO: Execute como Administrador." -ForegroundColor Red
    Write-Host ""
    Pause
    exit
}

# --- Menu ---
Write-Host ""
Write-Host "Escolha um tema:"
Write-Host ""
Write-Host "   1 - NGV"
Write-Host "   2 - GRUPOABV"
Write-Host "   3 - ABEVE"
Write-Host "   4 - LEVEMAX"
Write-Host "   5 - VILUVI"
Write-Host "   0 - Sair"
Write-Host ""
$Opcao = Read-Host "Escolha o Numero: "

switch ($Opcao) {
    "1" { $Empresa = "NGV"      }
    "2" { $Empresa = "GRUPOABV" }
    "3" { $Empresa = "ABEVE"    }
    "4" { $Empresa = "LEVEMAX"  }
    "5" { $Empresa = "VILUVI"   }
    "0" { exit }
    default {
        Write-Host "  Opcao invalida." 
        Pause
        exit
    }
}

# --- Localiza imagem ---
$ScriptDir = $PSScriptRoot
$Imagem    = $null
$Extensao  = $null
foreach ($ext in @("png", "jpg")) {
    $candidato = Join-Path $ScriptDir "$Empresa.$ext"
    if (Test-Path $candidato) {
        $Imagem   = $candidato
        $Extensao = $ext
        break
    }
}

if (-not $Imagem) {
    Write-Host ""
    Write-Host "  ERRO: Imagem '$Empresa.png' ou '$Empresa.jpg' nao encontrada em: $ScriptDir" -ForegroundColor Red
    Pause
    exit
}

Write-Host ""
Write-Host "  Imagem encontrada: $Imagem" 

# --- Copia imagem para C:\wallpaper ---
$WallpaperDir = "C:\wallpaper"
if (-not (Test-Path $WallpaperDir)) { New-Item -ItemType Directory -Path $WallpaperDir | Out-Null }
$Destino = "$WallpaperDir\$Empresa.$Extensao"
Copy-Item -Path $Imagem -Destination $Destino -Force
Write-Host "  Imagem copiada para: $Destino" 

# --- Cria o arquivo .theme ---
$ThemeDir = "$env:LOCALAPPDATA\Microsoft\Windows\Themes"
if (-not (Test-Path $ThemeDir)) { New-Item -ItemType Directory -Path $ThemeDir | Out-Null }

$ThemeFile = "$ThemeDir\$Empresa.theme"

$ThemeContent = @"
[Theme]
DisplayName=$Empresa

[Control Panel\Desktop]
Wallpaper=$Destino
TileWallpaper=0
WallpaperStyle=10
Pattern=

[VisualStyles]
Path=%SystemRoot%\resources\Themes\Aero\Aero.msstyles
ColorStyle=NormalColor
Size=NormalSize
ColorizationColor=0X6B74B8FC
Transparency=1

[MasterThemeSelector]
MTSM=DABJDKT

[Sounds]
SchemeName=

[Control Panel\Cursors]
DefaultValue=
"@

Set-Content -Path $ThemeFile -Value $ThemeContent -Encoding Unicode
Write-Host "  Tema criado: $ThemeFile" 

# --- Aplica o tema ---
Start-Process -FilePath $ThemeFile
Start-Sleep -Seconds 4

# Fecha a janela de Personalizacao que abre junto
Get-Process -Name "SystemSettings" -ErrorAction SilentlyContinue | Stop-Process -Force

Write-Host "  Tema aplicado." 
Write-Host ""
Write-Host "  ================================" 
Write-Host "   Empresa : $Empresa"              
Write-Host "   Tema    : $ThemeFile"            
Write-Host "   Imagem  : $Destino"              
Write-Host "   Concluido." 
Write-Host "  ================================" 
Write-Host ""
Pause