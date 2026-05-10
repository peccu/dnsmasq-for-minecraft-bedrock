# dnsmasq-for-minecraft-bedrock

Alpine + dnsmasq image that

- overrides public Minecraft Bedrock realm/server hostnames so they
  resolve to a server you control, and
- optionally acts as the DHCP server for your LAN, distributing
  itself as the DNS so the override actually reaches every client.

The DNS override and DHCP service are independent — run either or
both depending on what you mount into `dnsmasq.d/`.

## Quickstart

The committed `docker-compose.yml` pulls a prebuilt image from
`ghcr.io/peccu/dnsmasq-for-minecraft-bedrock:latest`, so cloning the
repo is optional — you only need the compose file plus a couple of
local config files:

```
your-deploy-dir/
├── docker-compose.yml
├── dnsmasq.d/
│   └── local.conf      # DHCP / static leases (gitignored if checked in)
└── dnsmasq.leases      # touch'd empty file
```

Bootstrap:

```sh
cp dnsmasq.d/local.conf.example dnsmasq.d/local.conf  # if cloned
$EDITOR dnsmasq.d/local.conf       # interface, dhcp-range, dhcp-host, etc.
touch dnsmasq.leases               # bind-mount target for DHCP leases
docker compose up -d
```

Update the image with `docker compose pull && docker compose up -d`.
To build locally instead of pulling, swap the `image:` line for
`build: .` (a comment in the compose file shows where).

Point your router (or the affected clients) at this host as their
DNS server, or let this container serve DHCP for the segment.

## Configuration

### `MINECRAFT_SERVER`

The destination every Minecraft hostname in `hosts` is rewritten to.
Set in `docker-compose.yml` (`environment:`) or via `-e`.

- IPv4 literal (e.g. `192.168.0.20`): entries are appended to
  `/etc/hosts` inside the container.
- Hostname (e.g. `mc.lan`): entries are emitted as dnsmasq `cname=`
  rules, resolved against the upstream chain.

### `hosts`

Public Minecraft hostnames to override. Edit freely — anything
listed gets pointed at `MINECRAFT_SERVER`.

### `dnsmasq.d/local.conf`

Site-local dnsmasq directives — DHCP range, gateway, static leases,
private host overrides. Gitignored so MAC addresses and internal IPs
stay out of the public repo. Start from `local.conf.example`.

To make the Minecraft override reach DHCP clients, advertise this
host as their DNS:

```
dhcp-option=6,<this host's LAN IP>
```

### `dnsmasq.leases`

DHCP lease state. Gitignored. Must exist as a file before
`docker compose up` (otherwise Docker creates it as a directory).

## Files

```
Dockerfile                   alpine + dnsmasq
dnsmasq.conf                 public DNS defaults + conf-dir include
hosts                        Minecraft hostnames to override
entrypoint.sh                rewrites hosts/cnames from MINECRAFT_SERVER
docker-compose.yml           host network, NET_ADMIN, log rotation
dnsmasq.d/local.conf.example template for site-local overrides
```

## Notes

- `network_mode: host` and `cap_add: NET_ADMIN` are required for
  DHCP to bind to the LAN interface and answer broadcasts.
- The container exposes 53/udp (DNS) and 67/udp (DHCP). Anything
  already bound to those ports on the host (systemd-resolved, etc.)
  must be stopped or reconfigured.
- Upstream resolvers default to Cloudflare (`1.1.1.1`, `1.0.0.1`);
  override in `dnsmasq.d/local.conf` with additional `server=` lines
  if needed.
