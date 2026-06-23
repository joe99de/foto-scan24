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

## Deployment
- Hosting bei Goneo, Web-Root `htdocs/`, Zugang nur per FTPS (kein SFTP)
- Upload per `deploy.ps1 -Insecure` (Goneo-Zertifikat lautet auf *.goneo.de,
  daher `-Insecure`; Verbindung bleibt TLS-verschlüsselt)
- Live: https://foto-scan24.de
