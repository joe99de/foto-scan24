param(
  [Parameter(Mandatory=$true)][string]$LocalDir,
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

$script = Join-Path $env:TEMP ("fs24-upload-" + [guid]::NewGuid().ToString("N") + ".txt")
$certificateOption = if ($Insecure) { ' -certificate="*"' } else { '' }
$lines = @(
  "option batch abort",
  "option confirm off",
  ("open ftps://" + $User + ":" + $GoneoPassword + "@" + $HostName + "/ -explicit -passive=on" + $certificateOption),
  "option transfer binary",
  ("put " + [char]34 + $LocalDir + "\*" + [char]34 + " " + $RemoteDir + "/"),
  "exit"
)
Set-Content -Path $script -Value $lines -Encoding ascii
try {
  & $WinScp /ini=nul /script=$script
  if ($LASTEXITCODE -ne 0) { throw "WinSCP-Upload fehlgeschlagen (Exit $LASTEXITCODE)." }
} finally {
  if (Test-Path $script) { Remove-Item $script -Force }
}
