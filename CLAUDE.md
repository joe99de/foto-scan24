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
| `assets/images/family_gold_02.png` | Eyecatcher-Bild (Großeltern mit Enkel) |

## Abschnitte / Seiten
| Datei | Beschreibung |
|-------|--------------|
| `sections/eyecatcher.html` | Hero-Bild, volle Breite, schwarzer Rand auf breiten Screens |
| `datenschutz.html` | Datenschutzerklärung (standalone Seite) |
| `impressum.html` | Impressum (standalone Seite) |

## Offene Todos
- Google Business Abschnitt in datenschutz.html ergänzen, sobald Account aktiv ist
  (Kommentar im HTML bereits als Platzhalter vorhanden)
