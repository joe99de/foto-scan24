<#
  deploy.ps1 — foto-scan24 per SFTP zu Goneo hochladen
  ====================================================
  Laedt NUR die Web-Dateien hoch; interne Dateien werden ausgelassen.
  Das Passwort wird beim Ausfuehren abgefragt und NICHT gespeichert.

  Verwendung:
    1) Web-Root finden (einmalig):
         .\deploy.ps1 -ListRemote
    2) Hochladen (RemoteDir = Web-Root vom Server, z. B. "." oder "html"):
         .\deploy.ps1 -RemoteDir "."
#>
param(
  [string]$HostName  = "foto-scan24.de",
  [string]$User      = "179932f143511",
  [int]   $Port      = 22,
  [string]$RemoteDir = "",
  [switch]$ListRemote
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$pscp  = "C:\Program Files\PuTTY\pscp.exe"
$plink = "C:\Program Files\PuTTY\plink.exe"
foreach ($exe in @($pscp, $plink)) {
  if (-not (Test-Path $exe)) { throw "Nicht gefunden: $exe (PuTTY installiert?)" }
}

# --- Passwort sicher abfragen ---
$sec  = Read-Host "Goneo-Passwort fuer $User" -AsSecureString
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
$pw   = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

# --- Modus: Server auflisten (Web-Root finden) ---
if ($ListRemote) {
  Write-Host "Verbinde und liste Remote-Verzeichnis..." -ForegroundColor Cyan
  & $plink -ssh -P $Port -pw $pw "$User@$HostName" "echo '== pwd =='; pwd; echo '== ls =='; ls -la"
  return
}

if (-not $RemoteDir) {
  Write-Error "Bitte -RemoteDir angeben (Web-Root). Vorher mit -ListRemote den Pfad ermitteln."
  return
}

# --- Staging: nur Web-Dateien kopieren ---
$exclude = @('.git', '.gitignore', '.claude', 'print', 'CLAUDE.md', 'server-starten.bat', 'deploy.ps1')
$stage = Join-Path $env:TEMP "fs24-deploy"
if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
New-Item -ItemType Directory -Path $stage | Out-Null

Get-ChildItem -Path $ScriptDir -Force |
  Where-Object { $exclude -notcontains $_.Name } |
  ForEach-Object { Copy-Item $_.FullName -Destination $stage -Recurse -Force }

Write-Host "Lade folgende Eintraege nach ${HostName}:$RemoteDir hoch:" -ForegroundColor Cyan
Get-ChildItem $stage -Force | ForEach-Object { Write-Host "  - $($_.Name)" }

# --- Upload (jedes Top-Level-Element rekursiv) ---
Get-ChildItem $stage -Force | ForEach-Object {
  & $pscp -P $Port -pw $pw -r $_.FullName "$User@${HostName}:$RemoteDir"
  if ($LASTEXITCODE -ne 0) { throw "Upload fehlgeschlagen bei: $($_.Name)" }
}

Remove-Item $stage -Recurse -Force
Write-Host "Deploy abgeschlossen." -ForegroundColor Green
