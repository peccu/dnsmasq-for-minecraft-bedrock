#!/bin/bash

cat /dnsmasq.conf >> /etc/dnsmasq.conf

ipv4_pattern='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
if [[ $MINECRAFT_SERVER =~ $ipv4_pattern ]]
then
  awk "{print \"$MINECRAFT_SERVER \" \$0}" </hosts >>/etc/hosts
else
  awk "{printf(\"cname=%s,$MINECRAFT_SERVER\n\", \$0);}" </hosts >> /etc/dnsmasq.conf
fi

# nohup dnsmasq -kd | cat -
# /usr/local/bin/entrypoint-demoter --match /data --debug --stdin-on-term stop /opt/bedrock-entry.sh

# only dnsmasq
dnsmasq -k
