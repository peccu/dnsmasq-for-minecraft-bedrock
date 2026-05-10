FROM alpine:latest
RUN apk --no-cache add dnsmasq
COPY dnsmasq.conf /etc/dnsmasq.conf
COPY hosts /hosts
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENV MINECRAFT_SERVER=127.0.0.1
EXPOSE 53/udp 67/udp
ENTRYPOINT ["/entrypoint.sh"]
