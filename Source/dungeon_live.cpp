#include "dungeon_live.hpp"

#include <cstdio>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include "levels/dun_tile_data.hpp"
#include "player.h"

namespace devilution {

void UpdateDungeonLive()
{
if (MyPlayer == nullptr)
return;

static int sock = socket(AF_UNIX, SOCK_DGRAM | SOCK_NONBLOCK, 0);
if (sock < 0)
return;

sockaddr_un address {};
address.sun_family = AF_UNIX;

std::snprintf(address.sun_path, sizeof(address.sun_path),
"/tmp/devilutionx-3d.sock");

char message[128];
int length = std::snprintf(message, sizeof(message),
    "{\"x\":%d,\"y\":%d,\"direction\":%d,\"level\":%u,\"leveltype\":%d}",
    MyPlayer->position.tile.x,
    MyPlayer->position.tile.y,
    static_cast<int>(MyPlayer->_pdir),
    static_cast<unsigned int>(currlevel),
    static_cast<int>(leveltype));

sendto(sock, message, length, MSG_DONTWAIT,
reinterpret_cast<const sockaddr *>(&address),
sizeof(address));
}

}
