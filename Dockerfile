FROM itzg/minecraft-bedrock-server
RUN apt-get update && apt-get install -y dnsmasq
ADD dnsmasq.conf /
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENV MINECRAFT_SERVER 127.0.0.1
EXPOSE 53
ENTRYPOINT /entrypoint.sh
