#!/bin/bash
set -e

echo "[+] Starting OpenVPN as root..."

/usr/sbin/openvpn --config /client.conf --log /openvpn.log --daemon

# Wait for tun0 to be ready
for i in {1..30}; do
    if [ -d /sys/class/net/tun0 ]; then
	echo "tun0 is up"
        break
    else
        echo "tun0 not found"
    fi
    sleep 1
done

echo "[+] Switching to UID 3001 and executing user entrypoint..."
exec gosu shinobi /entrypoint-shinobi.sh
