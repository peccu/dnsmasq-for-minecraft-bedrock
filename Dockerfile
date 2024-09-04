FROM alpine:latest
RUN apk add dnsmasq
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENV MINECRAFT_SERVER
ENTRYPOINT /entrypoint.sh
