# Foto-scan24.de — Projektdokumentation

## Firma
Mediendigitalisierung, Website: Foto-scan24.de

## Arbeitsweise
- Quellmaterial liegt auf: `C:\diskstation\H und H\Digitalisierung\website\`
- Nur Dateien übernehmen, die **explizit genannt** werden — keine Varianten oder ähnliche Dateien eigenständig kopieren
- Lange HTML-Seiten werden in einzelne Abschnitte aufgeteilt (je eine Datei unter `sections/`)
- Alle Änderungen kommen ins Git

## Projektstruktur
```
foto-scan24/
├── index.html              — Einstiegspunkt, bindet sections ein
├── CLAUDE.md               — diese Datei
├── assets/
│   ├── css/style.css       — Haupt-Stylesheet (Markenfarben)
│   ├── images/             — nur explizit freigegebene Bilder
│   └── js/
└── sections/               — ein Abschnitt = eine HTML-Datei
```

## Markenfarben
- Rot: `#FF0000`
- Schwarz: `#000000`
- Weiß: `#FFFFFF`

## Assets (explizit freigegeben)
| Datei | Zweck |
|-------|-------|
| `assets/images/foto-scan24-logo.svg` | Logo |
| `assets/images/family_gold_02.png` | Eyecatcher-Bild (Großeltern mit Enkel), KI-generiert — Kennzeichnung "Dieses Bild wurde von einer KI generiert." direkt unter dem Bild |

## Abschnitte (sections/)
| Datei | Beschreibung |
|-------|--------------|
| `eyecatcher.html` | Hero-Bild, volle Breite, schwarzer Rand auf breiten Screens |
| `hero.html` | "Wir digitalisieren Ihre analogen Schätze" + Buttons |
| `warum.html` | "Warum digitalisieren?" mit 5 Icon-Karten |
| `leistungen.html` | "Unsere Digitalisierungsleistungen" mit 9 Service-Karten |
| `übergabe.html` | "Nur persönliche Übergabe" Hinweis-Block |
| `preise.html` | Preisübersicht (4 Kategorien) |
| `ablauf.html` | "So einfach geht's" – 4 Schritte |
| `kontakt.html` | Kontakt & Anfrage + CTA "Retten Sie Ihre Erinnerungen!" |

## Standalone Seiten
| Datei | Beschreibung |
|-------|--------------|
| `datenschutz.html` | Datenschutzerklärung |
| `impressum.html` | Impressum |
| `dias.html` | Medien-Unterseite: Dias |
| `super8.html` | Medien-Unterseite: Super 8 & Normal 8 |
| `video.html` | Medien-Unterseite: VHS / Hi8 / MiniDV |
| `fotos.html` | Medien-Unterseite: Fotos & Negative |
| `fotoalben.html` | Medien-Unterseite: Fotoalben |

## CSS-Dateien
| Datei | Zweck |
|-------|-------|
| `assets/css/style.css` | Globale Styles, Header, alle Section-Styles |
| `assets/css/legal.css` | Datenschutz & Impressum |
| `assets/css/media.css` | Medien-Unterseiten (unterseite-hero, content-block) |

## Kontaktdaten
- E-Mail: kontakt@foto-scan24.de
- Telefon: 06252 787417

## Teilprojekte: Print-Materialien
Flyer und Visitenkarte werden als separate Dateien unter `print/` gepflegt.

**Führungsprinzip:**
- Die **Webseite ist führend** für Inhalt und Design
- Änderungen an der Webseite wirken sich auch auf Flyer und Visitenkarte aus
- Änderungen an Visitenkarte/Flyer wirken sich **nur nach ausdrücklicher Anweisung** auf die Webseite aus

## Offene Todos
- (erledigt) Google-Unternehmensprofil-Abschnitt in datenschutz.html ergänzt
- (erledigt) KI-Bildkennzeichnung am Eyecatcher (seit Aug. 2026 gesetzlich vorgeschrieben, EU AI Act Art. 50)
  + Hinweis-Abschnitt "Hinweis zu KI-generierten Bildern" in impressum.html

## Deployment
- Hosting bei Goneo, Web-Root `htdocs/`, Zugang nur per FTPS (kein SFTP)
- Upload per `deploy.ps1 -Insecure` (Goneo-Zertifikat lautet auf *.goneo.de,
  daher `-Insecure`; Verbindung bleibt TLS-verschlüsselt)
- Live: https://foto-scan24.de

## Deployment- und Rollback-Workflow

### Grundprinzip
Der lokale Git-Stand ist die Quelle der Wahrheit. Eine Veröffentlichung nach Goneo
erfolgt erst nach lokaler Prüfung und wird anschließend in Git dokumentiert und nach
`origin/master` gepusht. Die Website wird nicht durch eine bidirektionale
Synchronisierung aus dem Webspace gepflegt.

### Lokale Zugangsdaten
- `goneo.local.ps1` enthält das lokale Goneo-Passwort und ist in `.gitignore` eingetragen.
- Diese Datei darf niemals committet oder auf den Webspace hochgeladen werden.
- Fehlt die Datei, fragen die Skripte das Passwort alternativ interaktiv ab.

### Veröffentlichung
`deploy.ps1 -Insecure` führt diese Schritte aus:
1. aktuellen Inhalt von `htdocs/` in ein zeitgestempeltes lokales Backup unter
   `%TEMP%\fs24-remote-backups\` laden;
2. einen temporären Staging-Ordner mit ausschließlich veröffentlichbaren Web-Dateien
   erstellen;
3. den Staging-Ordner rekursiv per WinSCP/FTPS nach `htdocs/` hochladen;
4. den temporären Staging-Ordner entfernen.

Der Upload wurde von curl auf WinSCP umgestellt, weil Goneo beim Upload einzelner
Dateien per curl mit HTTP/FTP-Fehler `426` abbrach. WinSCP konnte denselben FTPS-Zugang
rekursiv und einschließlich `.htaccess` erfolgreich verwenden.

### Ausgeschlossene Dateien
Nicht veröffentlicht werden unter anderem `.git`, `.idea`, `.claude`, `print`,
`CLAUDE.md`, lokale Deploy-Skripte, `goneo.local.ps1`, `deploy.ps1` und
`video-sandbox.html`. `video-sandbox.html` ist ein zurückgestellter Entwurf und bleibt
lokal erhalten.

### Rollback
Backups anzeigen:
```powershell
.\goneo-rollback.ps1 -ListBackups
```

Ein Backup wiederherstellen:
```powershell
.\goneo-rollback.ps1 -RestoreBackup "C:\Pfad\zum\Backup" -Insecure
```

Der Restore verlangt die explizite Eingabe `RESTORE`. Vor jedem Upload muss ein Backup
erfolgreich erstellt worden sein; schlägt das Backup fehl, wird der Upload abgebrochen.

### Git-Regel für KI-Arbeit
Nach jedem abgeschlossenen Arbeitsschritt sollen die Änderungen geprüft, mit einer
verständlichen Commit-Nachricht committed und nach `origin/master` gepusht werden.
Passwortdateien und temporäre Backups bleiben lokal und dürfen nicht in Git landen.
