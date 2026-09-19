param([Parameter(Mandatory=$true)][string]$OutputPath)
$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot 'index.html'
if ([IO.Path]::GetFullPath($OutputPath) -eq $source) { throw 'Quelldatei darf nicht ueberschrieben werden.' }
$html = [IO.File]::ReadAllText($source)
$matches = [regex]::Matches($html, "\{ id: '([^']+)',\s+file: '(sections/[^']+)' \}")
if ($matches.Count -ne 8) { throw 'Erwartet werden acht Section-Zuordnungen. Build bei Strukturwechsel anpassen.' }
foreach ($entry in $matches) {
  $placeholder = '<div id="' + $entry.Groups[1].Value + '"></div>'
  if (-not $html.Contains($placeholder)) { throw "Platzhalter fehlt: $placeholder" }
  $section = [IO.File]::ReadAllText((Join-Path $PSScriptRoot $entry.Groups[2].Value))
  $html = $html.Replace($placeholder, $section.TrimEnd())
}
$loader = '(?s)<script>\s*const sections = .*?</script>'
if ([regex]::Matches($html, $loader).Count -ne 1) { throw 'Section-Ladeskript nicht eindeutig gefunden.' }
$html = [regex]::Replace($html, $loader, '<script src="assets/js/preise.config.js"></script><script src="assets/js/preise-render.js"></script>')
$html = $html.Replace('<!-- Sections werden dynamisch geladen -->', '<!-- Sections beim Deployment eingebunden -->')
if ($html.Contains('fetch(file)') -or $html.Contains('<div id="s-')) { throw 'Unvollstaendige Startseite.' }
[IO.File]::WriteAllText([IO.Path]::GetFullPath($OutputPath), $html, (New-Object Text.UTF8Encoding($false)))
Write-Host "Statische Startseite erstellt: $OutputPath"
