# DevilutionX 3D – Architektur

## Projektziel

Ziel ist eine dreidimensionale Darstellung von Diablo und Hellfire auf Basis von DevilutionX und Godot 4.

Die originale Spiellogik von DevilutionX soll erhalten bleiben. Godot übernimmt die grafische Darstellung und perspektivisch die Benutzerinteraktion.

Das Projekt wird als eigenständige Erweiterung eines DevilutionX-Forks entwickelt.

## Komponenten

### DevilutionX (C++)

DevilutionX bleibt für die Spiellogik verantwortlich, insbesondere:

- Dungeon-Generierung und Levelverwaltung
- Spielerposition und Bewegungsrichtung
- Kollisionen und Spielobjekte
- Monster, Gegenstände und Spielregeln

Die bisherigen Erweiterungen exportieren Dungeon-Geometrie und übertragen Live-Positionsdaten.

### Godot 4

Godot übernimmt derzeit:

- Einlesen der exportierten Dungeon-Daten
- Erzeugen einer einfachen dreidimensionalen Darstellung
- Anzeigen der Spielerposition und Blickrichtung
- Kameradarstellung

Godot besitzt derzeit keine eigenständige Spiellogik.

### Python-Bridge

`godot-client/live_bridge.py` vermittelt zwischen DevilutionX und Godot.

Aktueller Datenweg:

DevilutionX → Unix-Datagram-Socket → Python-Bridge → UDP → Godot

Die Live-Nachrichten enthalten Spielerkoordinaten, Blickrichtung, Levelnummer und Leveltyp.

## Kartenübertragung

Aktuell exportiert DevilutionX Dungeon-Daten als JSON-Dateien. Godot liest eine lokale Datei `dungeon_current.json`.

Bei jedem Laden eines Dungeons wird ein neuer Export erstellt, auch wenn der Dungeon bereits besucht wurde.

**Geplante Änderung:** Die vollständige Karte soll künftig direkt aus dem Speicher übertragen werden. Godot soll die neue Darstellung erst aufbauen, nachdem die Übertragung vollständig abgeschlossen ist.

Das genaue Übertragungsprotokoll ist noch nicht entschieden.

## Entwicklungsumgebung

- Debian Testing
- DevilutionX, Branch `feature/dungeon-export`
- Godot 4
- Python 3
- GitHub-Fork `gurugoile/DevilutionX`

Der Godot-Client und die Python-Bridge befinden sich im Verzeichnis `godot-client/`.

## Grundprinzipien

1. Die originale Spiellogik bleibt maßgeblich.
2. Godot visualisiert den von DevilutionX bereitgestellten Zustand.
3. Änderungen sollen nachvollziehbar und reproduzierbar sein.
4. Funktionierende Entwicklungsstände werden durch Git-Commits gesichert.
5. Neue Funktionen werden schrittweise implementiert und getestet.
