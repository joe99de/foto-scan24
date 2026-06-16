/**
 * Preiskonfiguration foto-scan24.de
 * ===================================
 * Hier alle Preise und Produkte pflegen.
 * Gruppen und Produkte können frei hinzugefügt, geändert oder entfernt werden.
 *
 * Felder pro Produkt:
 *   name   — Bezeichnung (linke Spalte)
 *   preis  — Preisangabe (rechte Spalte), z. B. "0,30 €", "ab 12,00 €", "auf Anfrage"
 *
 * Felder pro Gruppe:
 *   titel   — Überschrift inkl. Emoji
 *   produkte — Array der Produkte
 *   hinweis  — (optional) kleiner Hinweistext unter der Produktliste
 */

window.PREISE_CONFIG = {

  /** Einleitungstext unter der Hauptüberschrift */
  intro: "Alle Preise inkl. Rückgabe der Originale. Keine Umsatzsteuer (Kleinunternehmer gem. § 19 UStG).",

  /** Hinweistext unter dem gesamten Preisgitter */
  abschlusshinweis: "Bei größeren Mengen oder besonderen Formaten erstellen wir gerne ein individuelles Angebot.\nGemäß § 19 UStG wird keine Mehrwertsteuer ausgewiesen.",

  /** Hervorgehobener Hinweisblock "Preisbremse" unterhalb der Preiskarten */
  preisbremse: {
    titel: "🛡️ Unsere Preisbremse",
    text: "Sollte sich bei Ihrem Material ein Problemfall zeigen – etwa wenn mehrfache Reparaturen nötig würden –, melden wir uns vorher bei Ihnen. So vermeiden wir unnötige Mehrfachreparaturen und Sie behalten jederzeit die volle Kostenkontrolle."
  },

  gruppen: [
    {
      titel: "📷 Dias",
      teaserName: "Dias",
      teaserPreis: "ab 0,30 €",
      produkte: [
        { name: "pro Dia",                           preis: "0,30 €"  },
        { name: "Mindestmenge (1 Magazin / 50 Dias)", preis: "15,00 €" }
      ],
      hinweis: "Magazine: Universalmagazin DIN 108, CS-Magazin, LKM-Magazin"
    },
    {
      titel: "🎞️ Super 8 / 8mm Film",
      teaserName: "Super 8",
      teaserPreis: "ab 10,00 €",
      produkte: [
        { name: "Kleine Spule (3:20 Minuten)", preis: "10,00 €"   },
        { name: "Super-8-Filmrolle",           preis: "3,00 € / Minute" },
        { name: "Normal-8-Filmrolle",          preis: "3,00 € / Minute" },
        { name: "Film flicken (Reparatur)",    preis: "5,00 €"    }
      ]
    },
    {
      titel: "📼 Videokassetten",
      teaserName: "VHS",
      teaserPreis: "ab 15,00 €",
      produkte: [
        { name: "VHS 180 Min.",               preis: "15,00 €"  },
        { name: "VHS 240 Min.",               preis: "20,00 €"  },
        { name: "Camcorder (VHS-C, Hi8 u.a.)", preis: "je 15,00 €" },
        { name: "Kassettenreparatur",          preis: "10,00 €"  },
        { name: "Problemkassette (Aufschlag)", preis: "+ 10,00 €" }
      ]
    },
    {
      titel: "🖼️ Fotos &amp; Negative",
      teaserName: "Fotos",
      teaserPreis: "0,30 €",
      produkte: [
        { name: "Fotos digitalisieren",    preis: "0,30 €/Stück"    },
        { name: "Mindestmenge (50 Fotos)", preis: "15,00 €"          },
        { name: "Einzelscans",             preis: "nach Vereinbarung" },
        { name: "Negative (Streifen)",     preis: "auf Anfrage"       },
        { name: "Fotoalben",               preis: "auf Anfrage"       }
      ]
    }
  ]

};
