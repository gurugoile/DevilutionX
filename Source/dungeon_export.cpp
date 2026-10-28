#include "dungeon_export.hpp"

#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <string>

#include "levels/dun_tile_data.hpp"
#include "objects.h"
#include "levels/gendung_defs.hpp"

namespace devilution {

void ExportDungeon(uint32_t seed)
{
    const char *home = std::getenv("HOME");
    if (home == nullptr)
        return;

    const std::filesystem::path dir =
        std::filesystem::path(home) / "Diablo3D_exports";

    std::error_code error;
    std::filesystem::create_directories(dir, error);
    if (error)
        return;

    FILE *file = nullptr;

    for (unsigned number = 1; number <= 999999; ++number) {
        char name[64];
        std::snprintf(name, sizeof(name),
            "dungeon_%06u.json", number);

        const auto path = dir / name;

        // "x" verhindert das Überschreiben vorhandener Dateien.
        file = std::fopen(path.string().c_str(), "wx");
        if (file != nullptr)
            break;
    }

    if (file == nullptr)
        return;

    std::fprintf(file, "{\n  \"seed\": %u,\n", seed);

    std::fprintf(file, "  \"dungeon\": [\n");
    for (int y = 0; y < DMAXY; ++y) {
        std::fprintf(file, "    [");
        for (int x = 0; x < DMAXX; ++x)
            std::fprintf(file, "%s%u",
                x ? "," : "", dungeon[x][y]);

        std::fprintf(file, "]%s\n",
            y + 1 < DMAXY ? "," : "");
    }

    std::fprintf(file, "  ],\n  \"dPiece\": [\n");
    for (int y = 0; y < MAXDUNY; ++y) {
        std::fprintf(file, "    [");
        for (int x = 0; x < MAXDUNX; ++x)
            std::fprintf(file, "%s%u",
                x ? "," : "", dPiece[x][y]);

        std::fprintf(file, "]%s\n",
            y + 1 < MAXDUNY ? "," : "");
    }
std::fprintf(file, "  ],\n  \"tileProperties\": [\n");

for (int y = 0; y < MAXDUNY; ++y) {
    std::fprintf(file, "    [");

    for (int x = 0; x < MAXDUNX; ++x) {
	const unsigned tileId = dPiece[x][y];

	const unsigned properties = tileId < MAXTILES
    ? static_cast<unsigned>(SOLData[tileId])
    : 0;

        std::fprintf(file, "%s%u",
            x ? "," : "", properties);
    }

    std::fprintf(file, "]%s\n",
        y + 1 < MAXDUNY ? "," : "");
}

std::fprintf(file, "  ],\n  \"doors\": [\n");

bool firstDoor = true;

for (int i = 0; i < ActiveObjectCount; ++i) {
    const Object &object = Objects[ActiveObjects[i]];

    if (!object.isDoor())
        continue;

std::fprintf(file,
    "%s    {\"x\": %d, \"y\": %d, \"type\": %d, \"solid\": %s, \"state\": %d}",
    firstDoor ? "" : ",\n",
    object.position.x,
    object.position.y,
    static_cast<int>(object._otype),
    object._oSolidFlag ? "true" : "false",
    object._oVar4);
    firstDoor = false;
}

std::fprintf(file, "\n  ]\n}\n");
    std::fclose(file);
}

}
