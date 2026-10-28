# DevilutionX 3D – Architekturentscheidungen

Dieses Dokument hält wichtige technische Entscheidungen, ihre Begründungen und mögliche spätere Änderungen fest.

## ADR-001: DevilutionX bleibt die Spielengine

**Status:** Beschlossen

DevilutionX übernimmt weiterhin die originale Spiellogik von Diablo und Hellfire.

Godot soll keine zweite, unabhängige Implementierung von Bewegung, Kollisionen, Gegnerverhalten oder Spielregeln erhalten.

**Begründung:** Wir wollen das ursprüngliche Spiel erhalten und seine Darstellung modernisieren, nicht seine Spielmechanik neu entwickeln.

## ADR-002: Godot übernimmt die 3D-Darstellung

**Status:** Beschlossen

Godot 4 wird als eigenständige Darstellungsschicht eingesetzt.

Die ersten Tests mit Dungeon-Geometrie, Spielerposition, Blickrichtung und Kamera funktionieren.

Die endgültige Gestaltung von Kamera, Modellen und Benutzeroberfläche ist noch offen.

## ADR-003: Kommunikation zwischen Engine und Darstellung

**Status:** Teilweise umgesetzt

Die aktuelle Live-Verbindung verwendet:

DevilutionX → Unix-Datagram-Socket → Python-Bridge → UDP → Godot.

Spielerposition, Blickrichtung, Levelnummer und Leveltyp werden übertragen.

Die Python-Bridge dient derzeit als Vermittler zwischen den beiden Anwendungen. Ob sie dauerhaft benötigt wird, bleibt offen.

## ADR-004: Vollständige Kartenübertragung

**Status:** In Planung

Der bisherige JSON-Dateiexport funktioniert und wird bei jedem Laden eines Dungeons ausgeführt.

Die geplante Architektur sieht vor, vollständige Karten künftig direkt zu übertragen, statt sie dauerhaft in Dateien abzulegen.

Der Empfänger soll die Karte zunächst vollständig sammeln und erst nach Abschluss der Übertragung die bisherige Darstellung ersetzen.

**Noch offen:** Transportprotokoll, Pufferverwaltung und Fehlerbehandlung.

## ADR-005: Gemeinsame Versionsverwaltung

**Status:** Umgesetzt

Die Entwicklung erfolgt in einem eigenen GitHub-Fork von DevilutionX.

Das offizielle Projekt bleibt als `upstream` eingebunden. Unser Fork ist `origin`.

Der Godot-Client und die Python-Bridge werden im selben Repository versioniert, damit zusammengehörige Änderungen gemeinsam gesichert werden können.

## ADR-006: Nachvollziehbarkeit der Entwicklung

**Status:** Begonnen

Neben dem Quellcode dokumentieren wir Architekturentscheidungen, Entwicklungsfortschritte und wichtige Testergebnisse.

Relevante Chatverläufe sollen zusätzlich archiviert werden.

Technische Dokumentation und Gesprächsarchiv bleiben getrennt, damit die Projektdokumentation auch unabhängig vom Chat verständlich ist.
