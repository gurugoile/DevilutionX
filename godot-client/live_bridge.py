import socket
import os

SOCKET_PATH = "/tmp/devilutionx-3d.sock"
UDP_HOST = "127.0.0.1"
UDP_PORT = 45678

if os.path.exists(SOCKET_PATH):
    os.unlink(SOCKET_PATH)

source = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
source.bind(SOCKET_PATH)

target = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

print("Live-Brücke aktiv: DevilutionX -> Godot UDP 45678")

try:
    while True:
        data = source.recv(4096)
        target.sendto(data, (UDP_HOST, UDP_PORT))
except KeyboardInterrupt:
    pass
finally:
    source.close()
    target.close()
    os.unlink(SOCKET_PATH)
