Add-Type @"
using System.Runtime.InteropServices;

public class Wallpaper
{
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(
        int uAction,
        int uParam,
        string lpvParam,
        int fuWinIni);
}
"@

$wallpaperFolder = Split-Path -Parent $MyInvocation.MyCommand.Path

Clear-Host

Write-Host ""
Write-Host "Defina o papel de parede padrao"
Write-Host ""
Write-Host "1 - NGV"
Write-Host "2 - GRUPO ABV"
Write-Host "3 - ABEVE"
Write-Host "4 - LEVEMAX"
Write-Host "5 - VILUVI"
Write-Host "0 - Sair"
Write-Host ""

$opcao = Read-Host "Escolha o numero da opcao"

switch ($opcao)
{
    "1" {$empresa="NGV"}
    "2" {$empresa="GRUPOABV"}
    "3" {$empresa="ABEVE"}
    "4" {$empresa="LEVEMAX"}
    "5" {$empresa="VILUVI"}
    "0" {exit}
    default {
        Write-Host "Opcao invalida."
        Pause
        exit
    }
}

$imagem = Get-ChildItem $wallpaperFolder -Filter "$empresa.*" |
Where-Object {$_.Extension -match "\.(png|jpg|jpeg)$"} |
Select-Object -First 1

if(!$imagem)
{
    Write-Host ""
    Write-Host "Imagem nao encontrada."
    Pause
    exit
}


# Aplica o papel de parede escolhido
[Wallpaper]::SystemParametersInfo(20,0,$imagem.FullName,3)

Write-Host ""
Write-Host "Papel de parede aplicado com sucesso."
Write-Host "Reinicie o computador para aplicar o novo padrão."
Pause