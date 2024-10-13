#!/bin/sh

cat /dnsmasq.conf >> /etc/dnsmasq.conf
awk "{print \"$MINECRAFT_SERVER \" \$0}" </hosts >>/etc/hosts
awk "{printf(\"cname=%s,$MINECRAFT_SERVER\n\", \$0);}" </hosts >> /etc/dnsmasq.conf

nohup dnsmasq -kd | cat -

/usr/local/bin/entrypoint-demoter --match /data --debug --stdin-on-term stop /opt/bedrock-entry.sh

