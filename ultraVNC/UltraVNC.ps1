param(
    [Parameter(Mandatory = $true)]
    [string]$InstallerPath
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $InstallerPath)) {
    Write-Host "ERRO: Instalador nao encontrado"
    Write-Host $InstallerPath
    exit 1
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$InfPath = Join-Path $ScriptDir "UltraVNC.inf"
$ConfigPath = Join-Path $ScriptDir "ultravnc.ini"
$UltraVNCPath = "C:\Program Files\UltraVNC"

if (-not (Test-Path $InfPath)) {
    Write-Host "ERRO: UltraVNC.inf nao encontrado"
    exit 1
}

Write-Host "Instalando UltraVNC..."

$Arguments = @(
    "/VERYSILENT"
    "/NORESTART"
    "/SP-"
    "/SUPPRESSMSGBOXES"
    "/LOADINF=`"$InfPath`""
)

try {
    Start-Process `
        -FilePath $InstallerPath `
        -ArgumentList $Arguments `
        -Wait `
        -NoNewWindow

    Write-Host "OK - Instalacao concluida"
}
catch {
    Write-Host "ERRO: Falha na instalacao"
    Write-Host $_
    exit 1
}

Start-Sleep -Seconds 5

Write-Host "Aplicando configuracao..."

if (Test-Path $ConfigPath) {

    Copy-Item `
        -Path $ConfigPath `
        -Destination "$UltraVNCPath\ultravnc.ini" `
        -Force

    Write-Host "OK - ultravnc.ini"
}
else {
    Write-Host "AVISO - ultravnc.ini nao encontrado"
}

Write-Host "Configurando firewall..."

Start-Sleep -Seconds 3

$UltraVNCRules = @(
    "winvnc.exe",
    "vncviewer.exe",
    "vnc5900",
    "vnc5800"
)

foreach ($Rule in $UltraVNCRules) {

    $FirewallRules = Get-NetFirewallRule `
        -DisplayName $Rule `
        -ErrorAction SilentlyContinue

    if ($FirewallRules) {

        foreach ($FirewallRule in $FirewallRules) {

            try {
                Set-NetFirewallRule `
                    -Name $FirewallRule.Name `
                    -Enabled True `
                    -Profile Any `
                    -Action Allow `
                    -ErrorAction Stop
            }
            catch {}
        }

        $Count = ($FirewallRules | Measure-Object).Count
        Write-Host "OK - $Rule ($Count)"
    }
    else {
        Write-Host "AVISO - $Rule"
    }
}

Write-Host "Verificando servico..."

$Service = Get-Service `
    -Name "uvnc_service" `
    -ErrorAction SilentlyContinue

if ($Service) {

    try {

        if ($Service.Status -eq "Running") {
            Restart-Service `
                -Name "uvnc_service" `
                -Force `
                -ErrorAction SilentlyContinue
        }
        else {
            Start-Service `
                -Name "uvnc_service" `
                -ErrorAction SilentlyContinue
        }

        Start-Sleep -Seconds 3
        $Service.Refresh()

    }
    catch {}

    Write-Host "Servico: $($Service.Name)"
    Write-Host "Status : $($Service.Status)"
}
else {
    Write-Host "AVISO - Servico uvnc_service nao encontrado"
}

Write-Host ""
Write-Host "Resumo firewall:"

Get-NetFirewallRule |
Where-Object {
    $_.DisplayName -in @(
        "winvnc.exe",
        "vncviewer.exe",
        "vnc5900",
        "vnc5800"
    )
} |
Select-Object DisplayName, Enabled |
Format-Table -AutoSize

Write-Host ""
Write-Host "Instalacao finalizada."