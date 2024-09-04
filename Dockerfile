FROM alpine:latest
RUN apk add dnsmasq
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENV MINECRAFT_SERVER 127.0.0.1
EXPOSE 53
ENTRYPOINT /entrypoint.sh
