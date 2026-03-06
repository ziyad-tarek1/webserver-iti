# Architecture

## Design Decisions

### Credentials via Environment

Credentials are not baked into the image. The entrypoint reads `HTACCESS_USERNAME` and `HTACCESS_PASSWORD` and generates `.htpasswd` at container start. This allows:

- Docker secrets or env vars in production
- No credentials in image layers or Git history
- Different credentials per environment without rebuilding

### Fallback for Local/Lab Use

If env vars are unset and no `.htpasswd` exists, the entrypoint copies `.htpasswd.example` so the lab works out of the box. For production, always set credentials via env or secrets.

### Configuration Layering

- **Base**: Official `httpd` config (unchanged)
- **Custom**: `config/httpd-custom.conf` — AllowOverride, security headers, error pages
- **Per-dir**: `.htaccess` in htdocs for redirects and auth

### Security Headers

Custom config adds:

- `X-Content-Type-Options: nosniff` — prevents MIME sniffing
- `X-Frame-Options: SAMEORIGIN` — mitigates clickjacking
- `X-XSS-Protection: 1; mode=block` — legacy XSS filter
- `Referrer-Policy: strict-origin-when-cross-origin` — limits referrer leakage

### Scalability

- Single-container design for simplicity.
- For horizontal scaling, use an external auth provider (LDAP, OAuth) instead of file-based `.htpasswd`.
- Consider Nginx/Envoy in front for TLS termination and caching if needed.
