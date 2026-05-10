#!/bin/sh
set -e

if echo "$MINECRAFT_SERVER" | grep -qE '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
  awk -v ip="$MINECRAFT_SERVER" '{print ip" "$0}' /hosts >> /etc/hosts
else
  awk -v target="$MINECRAFT_SERVER" '{printf("cname=%s,%s\n", $0, target)}' /hosts >> /etc/dnsmasq.conf
fi

exec dnsmasq -k --log-facility=-
