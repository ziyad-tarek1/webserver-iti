# Final Assignment: Microservice Routing with Caddy

Blue-Green deployment with Caddy reverse proxy for Apache (v1) and Nginx (v2) microservices.

## Quick Start

1. **Add to `/etc/hosts`:**
   ```
   127.0.0.1 local.iti.eg
   ```

2. **Build and run:**
   ```bash
   docker compose build
   docker compose up -d
   ```

3. **Access:**
   - https://local.iti.eg/v1/shop (Apache, blue theme)
   - https://local.iti.eg/v2/shop (Nginx, green theme)
   - https://local.iti.eg/v1/admin (Basic Auth: admin / admin123)

## Files

| File | Description |
|------|-------------|
| `Caddyfile` | Caddy reverse proxy config |
| `docker-compose.yaml` | Service definitions |
| `Dockerfile.caddy` | Caddy with rate_limit module |
| `ARCHITECTURE.md` | Design documentation |

## Fallback (No Rate Limiting)

If the Caddy build fails (rate_limit module), use standard Caddy:

1. In `docker-compose.yaml`, change the caddy service:
   ```yaml
   caddy:
     image: caddy:latest
     # Remove: build: ...
   ```

2. In `Caddyfile`, remove the `rate_limit { ... }` block.
