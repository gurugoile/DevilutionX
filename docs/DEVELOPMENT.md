# DevilutionX 3D – Entwicklungsprotokoll

## Stand: 28. Oktober 2026

### Projektgrundlage

- DevilutionX als ursprüngliche Spielengine
- Eigener GitHub-Fork: `gurugoile/DevilutionX`
- Entwicklungsbranch: `feature/dungeon-export`
- Godot 4 als 3D-Client
- Python als vorläufige Kommunikationsbrücke

### Bereits umgesetzt und getestet

**Dungeon-Export**

- Export von Dungeon-Geometrie in JSON-Dateien
- Übertragung von Boden-, Wand- und Türinformationen
- Neuer Export bei jedem Laden eines Dungeons, auch bei erneutem Besuch
- Fortlaufende Dateinummerierung

**Godot-Client**

- Aufbau einer einfachen dreidimensionalen Dungeon-Darstellung
- Anzeige der Spielerposition durch einen Marker
- Anzeige der Bewegungsrichtung durch einen Richtungspfeil
- Kamera folgt der Spielerposition
- Laden der Dungeon-Daten aus `dungeon_current.json`

**Live-Kommunikation**

- DevilutionX sendet Spielerposition und Richtung über einen Unix-Datagram-Socket
- Python-Bridge leitet Nachrichten über UDP an Godot weiter
- Live-Nachrichten enthalten zusätzlich Levelnummer und Leveltyp
- Spielerposition und Blickrichtung wurden erfolgreich getestet

**Versionsverwaltung**

- Eigener GitHub-Fork eingerichtet
- Originalprojekt als `upstream` eingebunden
- Godot-Projekt und Python-Bridge in das gemeinsame Repository übernommen
- Funktionierender Entwicklungsstand getestet und versioniert

### Bekannte Einschränkungen

- Die Karte wird noch nicht automatisch an Godot übertragen
- Der JSON-Dateiexport ist derzeit ein Zwischenschritt
- Tristram wird noch nicht als vollständige 3D-Karte exportiert
- Türen und andere dynamische Objekte sind noch nicht vollständig synchronisiert
- Die Kamera- und Zoomsteuerung ist noch nicht endgültig festgelegt
- Godot ist noch kein eigenständig bedienbarer Spielclient

### Geplante nächste Entwicklungsschritte

1. Vollständige Kartenübertragung ohne temporäre Dateien
2. Automatischer Neuaufbau der Godot-Karte bei Levelwechsel
3. Unterstützung für Tristram
4. Synchronisation dynamischer Spielobjekte
5. Steuerung des Spiels über den Godot-Client
6. Ausbau der 3D-Darstellung mit geeigneten Modellen und Animationen

### Technische Grundregel

DevilutionX bleibt die maßgebliche Instanz für den Spielzustand. Godot stellt diesen Zustand dar und soll später Benutzereingaben an DevilutionX weitergeben.

Neue Funktionen werden schrittweise entwickelt, getestet und anschließend in Git gesichert.
