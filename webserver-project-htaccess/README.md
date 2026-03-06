# Lab — Apache & .htaccess

## Description

Apache HTTP Server with `.htaccess` enabled. Demonstrates:

- **Basic Auth** — `/secure/` requires login (admin / secret)
- **URL Redirect** — `/old-page` → `/public/` (301)
- **Per-directory config** — each directory can have its own `.htaccess`

---

## Production Improvements Summary

| Area | Improvement | Why |
|------|-------------|-----|
| **Security** | Credentials via env vars, `.htpasswd` in `.gitignore` | No secrets in image or repo |
| **Security** | Custom security headers | Mitigate XSS, clickjacking, MIME sniffing |
| **Security** | Custom error pages | Better UX, avoid leaking stack traces |
| **Docker** | Pinned base `httpd:2.4-alpine` | Reproducible, smaller image |
| **Docker** | Healthcheck | Orchestrators can detect unhealthy containers |
| **Docker** | `.dockerignore` | Faster builds, smaller context |
| **Config** | Layered Apache config (`config/httpd-custom.conf`) | No sed hacks; easier to maintain |
| **Scripts** | Entrypoint generates `.htpasswd` at runtime | Credentials from env/secrets, not baked in |
| **Docs** | `docs/ARCHITECTURE.md` | Documents design decisions |

---

## Project Structure

```
.
├── config/
│   └── httpd-custom.conf    # AllowOverride, security headers, error pages
├── docs/
│   └── ARCHITECTURE.md      # Design decisions
├── htdocs/
│   ├── .htaccess           # Redirect /old-page → /public/
│   ├── index.html
│   ├── errors/              # Custom 401, 403, 404, 500 pages
│   │   ├── 401.html
│   │   ├── 403.html
│   │   ├── 404.html
│   │   └── 500.html
│   ├── public/
│   │   └── index.html
│   └── secure/
│       ├── .htaccess        # Basic Auth
│       ├── .htpasswd.example
│       └── index.html
├── scripts/
│   └── docker-entrypoint.sh # Generates .htpasswd from env vars
├── .dockerignore
├── .env.example
├── .gitignore
├── Dockerfile
├── docker-compose.yaml
└── README.md
```

## Access Points

| Path | Behavior |
|------|----------|
| http://localhost | Homepage with links |
| http://localhost/public/ | Open |
| http://localhost/secure/ | **Password required** — `admin` / `secret` |
| http://localhost/old-page | Redirects to `/public/` |

---

## Deploy

### Lab (default credentials)

```bash
cd webserver-project-htaccess
docker compose up -d --build
```

Uses `.htpasswd.example` → credentials `admin` / `secret`.

### Production (env-based credentials)

```bash
cp .env.example .env
# Edit .env: set HTACCESS_USERNAME and HTACCESS_PASSWORD
docker compose up -d --build
```

Compose loads `.env` for variable substitution. The entrypoint generates `.htpasswd` from these env vars at container start.

### Verify

```bash
curl http://localhost
curl -u admin:secret http://localhost/secure/
curl -I http://localhost/old-page   # expect 301
```

---

## Custom Error Pages — When Each Triggers

This lab serves custom HTML for 401, 403, 404, and 500. Examples to hit each:

| Code | When | Example |
|------|------|---------|
| **401** | Access restricted area without (or with wrong) credentials | `curl http://localhost/secure/` or `curl -u wrong:wrong http://localhost/secure/` |
| **403** | Access denied — e.g. Apache-protected files like `.htaccess` | `curl http://localhost/secure/.htaccess` |
| **404** | Path does not exist | `curl http://localhost/nonexistent` or `curl http://localhost/foo/bar` |
| **500** | Server-side error (config, script, or permission issue) | In this lab, 500 occurred when `.htpasswd` had wrong permissions; fixed by `chown www-data`. Not easily triggerable when healthy. |

**Quick test (lab running on port 80):**

```bash
# 401 — no auth or bad auth
curl -sI http://localhost/secure/ | head -1
# HTTP/1.1 401 Unauthorized

# 403 — protected file
curl -sI http://localhost/secure/.htaccess | head -1
# HTTP/1.1 403 Forbidden

# 404 — missing path
curl -sI http://localhost/no-such-page | head -1
# HTTP/1.1 404 Not Found
```

## Delete / Teardown

```bash
cd webserver-project-htaccess
docker compose down
```

---

## Step-by-Step: How to Create This Lab

### Step 1: Enable .htaccess in Apache

Create a custom config instead of patching `httpd.conf` with `sed`:

**config/httpd-custom.conf**:
```apache
<Directory "/usr/local/apache2/htdocs">
    AllowOverride All
    Require all granted
</Directory>
```

Include it from the main config. Enable `mod_rewrite` for `RewriteRule`.

### Step 2: Docker Compose

Use env vars for credentials, add healthcheck and restart policy. See `docker-compose.yaml`.

### Step 3: Document root and content

Create `htdocs/`, `htdocs/public/`, `htdocs/secure/`, and `htdocs/errors/` with HTML files.

### Step 4: Root .htaccess — redirect

```apache
RewriteEngine On
RewriteRule ^old-page$ /public/ [R=301,L]
```

### Step 5: Secure directory — Basic Auth

```apache
AuthType Basic
AuthName "Restricted Area"
AuthUserFile /tmp/.htpasswd
Require valid-user
```

(Entrypoint writes to `/tmp/.htpasswd` so it works when htdocs is mounted read-only.)

### Step 6: Credentials

- **Lab**: Use `.htpasswd.example` (entrypoint copies it if no env vars set).
- **Production**: Set `HTACCESS_USERNAME` and `HTACCESS_PASSWORD` in `.env`; entrypoint generates `.htpasswd` at start.

### Step 7: Deploy and verify

```bash
docker compose up -d --build
```

---

## Changing Credentials

### Via env (production)

Edit `.env` and restart:

```bash
docker compose down && docker compose up -d
```

### Via .htpasswd (manual)

```bash
docker run --rm httpd:2.4-alpine htpasswd -nbB username password
```

Save output to `htdocs/secure/.htpasswd`. Ensure `.htpasswd` is in `.gitignore`.
