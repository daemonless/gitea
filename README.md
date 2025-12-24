# gitea

Self-hosted Git service.

**Note:** Gitea dropped FreeBSD binary releases in v1.25.x. This image uses the FreeBSD package (`pkg install gitea`).

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PUID` | User ID for the application process | `1000` |
| `PGID` | Group ID for the application process | `1000` |
| `TZ` | Timezone for the container | `UTC` |
| `S6_LOG_ENABLE` | Enable/Disable file logging | `1` |
| `S6_LOG_MAX_SIZE` | Max size per log file (bytes) | `1048576` |
| `S6_LOG_MAX_FILES` | Number of rotated log files to keep | `10` |

## Logging

This image uses `s6-log` for internal log rotation.
- **System Logs**: Captured from console and stored at `/config/logs/daemonless/gitea/`.
- **Application Logs**: Managed by the app and typically found in `/config/logs/`.
- **Podman Logs**: Output is mirrored to the console, so `podman logs` still works.

## Quick Start

```bash
podman run -d --name gitea \
  --network none \
  --annotation 'org.freebsd.jail.vnet=new' \
  -v /containers/gitea:/gitea \
  --restart unless-stopped \
  ghcr.io/daemonless/gitea:latest
```

Access at: http://localhost:3000

## podman-compose

```yaml
services:
  gitea:
    image: ghcr.io/daemonless/gitea:latest
    container_name: gitea
    annotations:
      org.freebsd.jail.vnet: "new"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - /data/gitea:/gitea
    restart: unless-stopped
```

## Tags

| Tag | Source | Description |
|-----|--------|-------------|
| `:latest` | `devel/gitea` | FreeBSD packages (latest branch) |
| `:pkg` | `devel/gitea` | FreeBSD quarterly packages |

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | 1000 | User ID for app |
| `PGID` | 1000 | Group ID for app |
| `TZ` | UTC | Timezone |

## Volumes

| Path | Description |
|------|-------------|
| `/gitea` | Configuration, repositories, and data |

### Directory Structure
- `/gitea/custom/conf/app.ini` - Configuration
- `/gitea/repos` - Git repositories
- `/gitea/data` - Data (avatars, etc.)
- `/gitea/log` - Logs

## Ports

| Port | Description |
|------|-------------|
| 3000 | Web UI |
| 22 | SSH |

## Notes

- **User:** `bsd` (UID/GID set via PUID/PGID, default 1000)
- **Base:** Built on `ghcr.io/daemonless/base-image` (FreeBSD)

### Specific Requirements
- **VNET Required:** Must use `--annotation 'org.freebsd.jail.vnet=new'` due to complex networking needs.

## Links

- [Website](https://about.gitea.com/)
- [FreshPorts](https://www.freshports.org/devel/gitea/)
