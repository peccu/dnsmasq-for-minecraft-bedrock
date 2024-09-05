#!/bin/sh

cat /dnsmasq.conf >> /etc/dnsmasq.conf
awk "{print \"$MINECRAFT_SERVER \" \$0}" </hosts >>/etc/hosts

nohup dnsmasq -kdq | cat -

/usr/local/bin/entrypoint-demoter --match /data --debug --stdin-on-term stop /opt/bedrock-entry.sh

