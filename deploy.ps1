<#
  deploy.ps1 — foto-scan24 per FTPS zu Goneo hochladen
  ====================================================
  Laedt NUR die Web-Dateien hoch; interne Dateien werden ausgelassen.
  Das Passwort wird beim Ausfuehren abgefragt und NICHT gespeichert
  (Uebergabe per temporaerer curl-Config, danach geloescht).

  Verwendung:
    1) Web-Root pruefen (Inhalt von htdocs auflisten):
         .\deploy.ps1 -ListRemote
    2) Hochladen:
         .\deploy.ps1
    3) Falls Zertifikatsfehler: TLS-Pruefung lockern
         .\deploy.ps1 -Insecure
    4) Falls FTPS gar nicht geht: unverschluesseltes FTP (Notnagel)
         .\deploy.ps1 -NoTLS
#>
param(
  [string]$HostName  = "foto-scan24.de",
  [string]$User      = "179932f143511",
  [string]$RemoteDir = "htdocs",
  [switch]$ListRemote,
  [switch]$Insecure,
  [switch]$NoTLS
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$curl = "C:\Windows\System32\curl.exe"
if (-not (Test-Path $curl)) { $curl = (Get-Command curl.exe).Source }

# --- Passwort sicher abfragen ---
$sec  = Read-Host "Goneo-Passwort fuer $User" -AsSecureString
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
$pw   = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

# --- curl-Config mit Zugangsdaten (temporaer) ---
$cfg = Join-Path $env:TEMP ("fs24-curl-" + [guid]::NewGuid().ToString("N") + ".cfg")
$cfgLines = @("user = `"$User`:$pw`"")
if (-not $NoTLS)   { $cfgLines += "ssl-reqd" }   # FTPS erzwingen (AUTH TLS)
if ($Insecure)     { $cfgLines += "insecure" }   # Zertifikat nicht pruefen
Set-Content -Path $cfg -Value $cfgLines -Encoding ascii

# Basis-URL (FTP-Schema; ssl-reqd macht daraus FTPS)
$base = "ftp://$HostName/$RemoteDir/"

try {
  # --- Modus: Remote-Verzeichnis auflisten ---
  if ($ListRemote) {
    Write-Host "Liste $base ..." -ForegroundColor Cyan
    & $curl -K $cfg $base
    if ($LASTEXITCODE -ne 0) { throw "curl-Listing fehlgeschlagen (Exit $LASTEXITCODE)." }
    return
  }

  # --- Staging: nur Web-Dateien kopieren ---
  $exclude = @('.git', '.gitignore', '.claude', '.idea', '.vscode', 'print', 'CLAUDE.md', 'server-starten.bat', 'deploy.ps1')
  $stage = Join-Path $env:TEMP "fs24-deploy"
  if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
  New-Item -ItemType Directory -Path $stage | Out-Null

  Get-ChildItem -Path $ScriptDir -Force |
    Where-Object { $exclude -notcontains $_.Name } |
    ForEach-Object { Copy-Item $_.FullName -Destination $stage -Recurse -Force }

  $files = Get-ChildItem -Path $stage -Recurse -File -Force
  Write-Host ("Lade {0} Dateien nach {1} hoch ..." -f $files.Count, $base) -ForegroundColor Cyan

  foreach ($f in $files) {
    $rel = $f.FullName.Substring($stage.Length + 1) -replace '\\', '/'
    $url = "$base$rel"
    & $curl -s -S --ftp-create-dirs -T $f.FullName -K $cfg $url
    if ($LASTEXITCODE -ne 0) { throw "Upload fehlgeschlagen bei: $rel (Exit $LASTEXITCODE)" }
    Write-Host "  hochgeladen: $rel"
  }

  if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
  Write-Host "Deploy abgeschlossen." -ForegroundColor Green
}
finally {
  if (Test-Path $cfg) { Remove-Item $cfg -Force }
}
