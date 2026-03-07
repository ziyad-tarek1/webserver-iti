# Lab — Apache & .htaccess

> **For Students:** Want to build this lab from scratch? See **[STEP_BY_STEP.md](STEP_BY_STEP.md)** for a detailed, commented walkthrough with explanations for every file.

---

## Description

Apache HTTP Server with `.htaccess` enabled. Demonstrates:

- **Basic Auth** — `/secure/` requires login (admin / secret)
- **URL Redirect** — `/old-page` → `/public/` (301)
- **Per-directory config** — each directory can have its own `.htaccess`

---

## Project Structure

```
.
├── config/
│   └── httpd-custom.conf    # AllowOverride, security headers, error pages
├── htdocs/
│   ├── .htaccess            # Redirect /old-page → /public/
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
│       ├── .htpasswd        # Password file (admin/secret)
│       └── index.html
├── .dockerignore
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

```bash
cd lab5-webserver-project-htaccess
docker compose up -d --build
```

Credentials are in `htdocs/secure/.htpasswd` — username `admin`, password `secret`.

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

## Changing Credentials

To add or change users, generate a new `.htpasswd`:

```bash
docker run --rm httpd:2.4-alpine htpasswd -nbB username password
```

Save the output to `htdocs/secure/.htpasswd`, then restart:

```bash
docker compose down && docker compose up -d
```
