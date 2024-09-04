#!/bin/sh

cat <EOF >> /etc/dnsmasq.conf
domain-needed
bogus-priv
strict-order
bind-interfaces
EOF

for i in geo.hivebedrock.network play.galaxite.net mco.mineplex.com mco.cubecraft.net play.pixelparadise.gg mco.lbsg.net play.inpvp.net
do
echo "$MINECRAFT_SERVER $i" >> /etc/hosts
done
exec dnsmasq -k
