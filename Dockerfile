FROM alpine:latest
RUN apk add dnsmasq
ADD entrypoint.sh /
ENV MINECRAFT_SERVER
ENTRYPOINT /entrypoint.sh
