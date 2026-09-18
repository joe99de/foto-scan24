param(
  [switch]$CreateBackup,
  [switch]$ListBackups,
  [switch]$CleanupInternal,
  [string]$RestoreBackup,
  [string]$HostName = "foto-scan24.de",
  [string]$User = "179932f143511",
  [string]$RemoteDir = "/htdocs",
  [switch]$Insecure
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$WinScp = "C:\Program Files (x86)\WinSCP\WinSCP.com"
if (-not (Test-Path $WinScp)) { $WinScp = (Get-Command WinSCP.com -ErrorAction Stop).Source }

$localConfig = Join-Path $ScriptDir "goneo.local.ps1"
if (-not (Test-Path $localConfig)) { throw "Lokale Config fehlt: $localConfig" }
. $localConfig
if (-not $GoneoPassword) { throw "GoneoPassword fehlt in $localConfig" }

$backupRoot = Join-Path $env:TEMP "fs24-remote-backups"
New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null

function Invoke-WinScp([string]$Mode, [string]$Path) {
  $script = Join-Path $env:TEMP ("fs24-winscp-" + [guid]::NewGuid().ToString("N") + ".txt")
  $certificateOption = if ($Insecure) { ' -certificate="*"' } else { '' }
  $batchOption = if ($Mode -eq "cleanup") { "option batch continue" } else { "option batch abort" }
  $lines = @(
    $batchOption,
    "option confirm off",
    ("open ftps://" + $User + ":" + $GoneoPassword + "@" + $HostName + "/ -explicit -passive=on" + $certificateOption),
    "option transfer binary"
  )
  if ($Mode -eq "backup") {
    $lines += ("get " + $RemoteDir + "/* " + [char]34 + $Path + "\" + [char]34)
  } elseif ($Mode -eq "cleanup") {
    $lines += "rm $RemoteDir/goneo.local.ps1"
    $lines += "rm $RemoteDir/goneo-upload.ps1"
    $lines += "rm $RemoteDir/goneo-rollback.ps1"
    $lines += "rm $RemoteDir/video-sandbox.html"
  } else {
    $lines += ("put " + [char]34 + $Path + "\* " + [char]34 + " " + $RemoteDir + "/")
  }
  $lines += "exit"
  Set-Content -Path $script -Value $lines -Encoding ascii
  try {
    & $WinScp /ini=nul /script=$script
    if ($LASTEXITCODE -ne 0 -and $Mode -ne "cleanup") { throw "WinSCP fehlgeschlagen (Exit $LASTEXITCODE)." }
  } finally {
    if (Test-Path $script) { Remove-Item $script -Force }
  }
}

if ($CleanupInternal) {
  Write-Host "Entferne interne Dateien vom Webspace ..." -ForegroundColor Yellow
  Invoke-WinScp "cleanup" $backupRoot
  Write-Host "Bereinigung abgeschlossen." -ForegroundColor Green
  exit 0
}

if ($ListBackups) {
  Get-ChildItem $backupRoot -Directory | Sort-Object Name -Descending | Select-Object FullName,LastWriteTime
  exit 0
}

if ($CreateBackup) {
  $backupPath = Join-Path $backupRoot (Get-Date -Format "yyyyMMdd-HHmmss")
  New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
  Write-Host "Sichere aktuellen Remote-Stand nach $backupPath ..." -ForegroundColor Cyan
  Invoke-WinScp "backup" $backupPath
  Write-Host "Backup erstellt: $backupPath" -ForegroundColor Green
  exit 0
}

if ($RestoreBackup) {
  $resolved = (Resolve-Path $RestoreBackup -ErrorAction Stop).Path
  if (-not (Test-Path (Join-Path $resolved "index.html"))) {
    throw "Backup enthaelt keine index.html: $resolved"
  }
  $answer = Read-Host "Backup nach Goneo zurueckspielen? Tippe RESTORE"
  if ($answer -cne "RESTORE") { throw "Rollback abgebrochen." }
  Write-Host "Stelle Backup $resolved nach $RemoteDir wieder her ..." -ForegroundColor Yellow
  Invoke-WinScp "restore" $resolved
  Write-Host "Rollback abgeschlossen." -ForegroundColor Green
  exit 0
}

throw "Bitte -CreateBackup, -ListBackups oder -RestoreBackup <Pfad> angeben."
