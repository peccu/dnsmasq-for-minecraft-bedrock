#!/bin/sh

cat dnsmasq.conf >> /etc/dnsmasq.conf

for i in geo.hivebedrock.network play.galaxite.net mco.mineplex.com mco.cubecraft.net play.pixelparadise.gg mco.lbsg.net play.inpvp.net
do
echo "$MINECRAFT_SERVER $i" >> /etc/hosts
done
exec dnsmasq -kdq
