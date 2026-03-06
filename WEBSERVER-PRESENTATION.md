# Web Servers, Reverse Proxy & Load Balancing

**Course: 2 Sessions × 2 Hours | Total: 4 Hours**

---

## Suggested Timeline

| Session | Parts | Duration |
|---------|-------|----------|
| **Session 1** | 1–9 + Lab 1 | 2 hours |
| **Session 2** | Load Balancing, Labs 2–4, Caching, Proxies, Security, API Gateway | 2 hours |

*Adjust based on audience level and Q&A.*

---

# Session 1 — Web Fundamentals & Web Servers (2 Hours)

---

## Part 1: Introduction — How the Web Works (30 min)

### Opening Question
**What actually happens when you type `https://google.com` in your browser?**

The process involves several layers working together.

### Basic Flow Diagram

```
Browser (Client)
        |
        v
DNS Resolution (domain → IP)
        |
        v
Internet (TCP/TLS)
        |
        v
Web Server (Nginx / Apache)
        |
        v
Application Server (optional)
        |
        v
Database (optional)
```

### Components Explained

| Component | Role | Examples |
|-----------|------|----------|
| **Client** | Sends requests, receives responses | Browser, mobile app, `curl`, Postman |
| **DNS** | Converts domain → IP address | `google.com` → `142.250.191.14` |
| **Web Server** | Receives HTTP(S), returns responses | Nginx, Apache, Caddy, IIS |
| **Application Server** | Executes business logic | Node.js, Django, Spring, PHP-FPM |
| **Database** | Stores persistent data | PostgreSQL, MySQL, MongoDB |

---

## Part 2: HTTP Fundamentals (25 min)

### HTTP = Hypertext Transfer Protocol

- Request-response model
- Stateless (each request is independent)
- Runs over TCP (default: port 80 for HTTP, 443 for HTTPS)

### HTTP Request Structure

```http
GET /users HTTP/1.1
Host: example.com
User-Agent: Mozilla/5.0 (Chrome)
Accept: application/json
Authorization: Bearer eyJhbGc...
```

| Part | Purpose |
|------|---------|
| **Method** | Action to perform |
| **Path** | Resource location |
| **Headers** | Metadata (auth, content type, cookies, etc.) |

### HTTP Methods

| Method | Purpose |
|--------|---------|
| GET | Retrieve data (idempotent) |
| POST | Create new resource |
| PUT | Full update |
| PATCH | Partial update |
| DELETE | Remove resource |

### HTTP Response

```http
HTTP/1.1 200 OK
Content-Type: application/json
Cache-Control: max-age=3600

{"name": "John"}
```

### Common Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 301 | Permanent redirect |
| 400 | Bad request |
| 401 | Unauthorized (missing/invalid auth) |
| 403 | Forbidden |
| 404 | Not found |
| 429 | Too many requests (rate limited) |
| 500 | Server error |

---

## Part 3: URL vs URI (5 min)

**Example:** `https://example.com/users?id=5`

| Part | Name | Example |
|------|------|---------|
| `https` | Protocol | HTTP over TLS |
| `example.com` | Host/Domain | Server address |
| `/users` | Path | Resource path |
| `?id=5` | Query string | Parameters |

- **URI** = Uniform Resource Identifier (identifies a resource)
- **URL** = Uniform Resource Locator (subset of URI; includes location)

---

## Part 4: HTTP vs HTTPS (10 min)

| | HTTP | HTTPS |
|---|------|-------|
| Port | 80 | 443 |
| Encryption | Plain text | TLS/SSL |
| Protects | Nothing | Passwords, cookies, tokens, private data |

**HTTPS protects:**
- Authentication tokens
- Cookies (e.g., session IDs)
- Form data (passwords, credit cards)
- API responses

**Certificates:** Let's Encrypt (free), DigiCert, GlobalSign — use **certbot** for automation.

---

## Part 5: Static vs Dynamic Content (10 min)

| Type | Served by | Examples |
|------|-----------|----------|
| **Static** | Web server directly | HTML, CSS, JS, images, PDFs |
| **Dynamic** | Application server | APIs, user dashboards, forms |

**Typical architecture:**

```
User → Nginx (static + reverse proxy) → App Server (Node/Python/PHP) → Database
```

---

## Part 6: Apache vs Nginx (10 min)

### Apache

- Process/thread per request
- Flexible (.htaccess per-directory config)
- Widely used, mature

### Nginx

- Event-driven, asynchronous
- Better concurrency, lower memory
- Ideal for reverse proxy, load balancing, high traffic

### Default Document Roots (where files live)

| Server | Default document root | Config location |
|--------|----------------------|-----------------|
| **Apache** | `/var/www/html` | `/etc/apache2/sites-available/` |
| **Apache (Docker)** | `/usr/local/apache2/htdocs/` | `/usr/local/apache2/conf/httpd.conf` |
| **Nginx** | `/usr/share/nginx/html` | `/etc/nginx/nginx.conf` or `/etc/nginx/conf.d/` |
| **Nginx (custom)** | Often `/var/www/html` | Defined in `server { root /path; }` |

**Key point:** The `root` or `DocumentRoot` directive tells the server where to find static files. Requests for `/` map to `index.html` in that directory.

---

## Part 7: Web Server Configuration & File Locations (20 min)

### Nginx Configuration Structure

```
/etc/nginx/
├── nginx.conf          # Main config (worker_processes, http block)
├── mime.types          # Maps extensions to Content-Type
├── conf.d/             # Additional server blocks (*.conf)
└── sites-available/    # Site configs (Ubuntu/Debian)
sites-enabled/          # Symlinks to enabled sites
```

### Nginx Main Components

| Directive | Purpose | Example |
|-----------|---------|---------|
| `worker_processes` | Number of worker processes | `worker_processes 1;` |
| `events { worker_connections }` | Max connections per worker | `worker_connections 1024;` |
| `http { }` | HTTP-level settings | Includes mime types, upstreams |
| `server { }` | Virtual host (site) | `listen 80; server_name localhost;` |
| `location /` | Request path matching | `root /var/www/html;` or `proxy_pass` |
| `root` | Document root for static files | `root /usr/share/nginx/html;` |
| `proxy_pass` | Forward to backend | `proxy_pass http://backend:3000;` |
| `include` | Include another config file | `include /etc/nginx/mime.types;` |

### Where Are Pages Located?

| Scenario | Path | When to Use |
|----------|------|-------------|
| **Default Nginx (container/package)** | `/usr/share/nginx/html` | Quick test, default landing |
| **Production Nginx** | `/var/www/html` or `/var/www/mysite` | Custom apps, standard Linux layout |
| **Apache default** | `/var/www/html` | Ubuntu/Debian default |
| **Apache (Docker httpd)** | `/usr/local/apache2/htdocs/` | Official Apache image |
| **Docker volume mount** | `./web1:/usr/local/apache2/htdocs/` | Local dev, our labs |

**How it works:** When a request comes for `/`, the server looks for `index.html` in the document root. For `/about`, it looks for `about` or `about/index.html`.

---

### Apache .htaccess

**.htaccess** = per-directory configuration for Apache.

| Aspect | Details |
|--------|---------|
| **Location** | Placed inside the directory it affects (e.g. `/var/www/html/.htaccess`) |
| **Purpose** | Override main config without editing `httpd.conf` |
| **Use cases** | URL rewriting, auth, redirects, custom error pages, CORS |
| **Performance** | Apache checks every request — can slow down under high load |
| **Nginx equivalent** | Nginx has *no .htaccess*. Use `location` blocks in main config. |

**Example .htaccess:**

```apache
# Redirect HTTP to HTTPS
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Protect a directory
AuthType Basic
AuthName "Restricted"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user

# Custom error page
ErrorDocument 404 /404.html
```

**When to use .htaccess:**
- Shared hosting (no root access)
- Quick per-folder tweaks
- When you can't touch main Apache config

**When to avoid:** High-traffic sites — move rules to main `httpd.conf` or use Nginx.

---

## Part 8: Reverse Proxy (15 min)

A **reverse proxy** sits between clients and backend servers.

```
Client  →  Reverse Proxy (Nginx)  →  Backend Servers
```

**Responsibilities:**
- Request routing
- SSL termination (handle HTTPS, talk HTTP to backend)
- Load balancing
- Caching
- Security (hide backend, filter requests)

**Basic Nginx reverse proxy example:**

```nginx
location /api {
    proxy_pass http://backend:3000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
```

---

## Part 9: Inspecting Real HTTP Requests (15 min)

### Simple Inspection

```bash
curl -v https://google.com
```

Shows: TLS handshake, request/response headers, status code.

### Real-World Example 1: Rabbitmart Metabase Embed API

This is a real embedding API call (token expired in the example):

```bash
curl 'https://report.rabbitmart.com/api/embed/card/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.../query/xlsx?parameters=%7B%7D&format_rows=true&pivot_results=false' \
  -H 'accept: application/json' \
  -H 'content-type: application/json' \
  -b '_ga=GA1.2.208401538.1751285360; metabase.DEVICE=20d91ff-ec0c-4e44-a86f-2dd13a00fc78' \
  -H 'referer: https://report.rabbitmart.com/embed/question/...' \
  -H 'x-metabase-client: embedding-iframe' \
  -H 'x-metabase-embedded: true'
```

**Response:** `Token is expired (1772116142)`

**What this teaches:**

| Header / Part | Purpose |
|---------------|---------|
| `-H 'accept: application/json'` | Client wants JSON |
| `-H 'content-type: application/json'` | Request body is JSON |
| `-b 'cookie=value'` | Sends cookies (auth, analytics) |
| `referer` | Where the request came from (embedding context) |
| `x-metabase-client`, `x-metabase-embedded` | Custom headers for embedded dashboards |
| JWT in URL | Auth token for embedded resources |

**Real-world takeaway:** Embedding APIs often use JWT in the URL + cookies. Expired tokens cause `401`/`403` or custom messages like "Token is expired".

---

### Real-World Example 2: KodeKloud.com Headers

```bash
curl -I https://kodekloud.com/
```

**Response (simplified):**

```http
HTTP/2 200
date: Fri, 06 Mar 2026 02:40:03 GMT
content-type: text/html; charset=utf-8
cf-ray: 9d7dfe58bf6718ab-MRS
cf-cache-status: HIT
age: 58916
last-modified: Thu, 05 Mar 2026 10:18:07 GMT
server: cloudflare
content-security-policy: frame-ancestors 'self' https://*.webflow.com ...
surrogate-control: max-age=432000
strict-transport-security: max-age=31536000
x-content-type-options: nosniff
x-frame-options: DENY
referrer-policy: same-origin
permissions-policy: geolocation=()
```

**What each header does:**

| Header | Purpose |
|--------|---------|
| `cf-cache-status: HIT` | Response served from Cloudflare cache (CDN) |
| `age: 58916` | How long the object has been in cache (seconds) |
| `server: cloudflare` | Proxy/CDN in front of origin |
| `x-frame-options: DENY` | Prevents embedding in iframes (clickjacking protection) |
| `content-security-policy: frame-ancestors` | Limits who can embed the page |
| `strict-transport-security` | Force HTTPS (HSTS) |
| `x-content-type-options: nosniff` | Prevent MIME sniffing |
| `referrer-policy: same-origin` | Control referrer information |

**Real-world takeaway:** Production sites use CDNs (Cloudflare), caching, and security headers. Inspecting headers helps debug caching, CORS, embedding, and security issues.

---

## Lab 1 — Basic Web Servers (15 min)

**Goal:** Run three Apache servers serving static content.

**Deploy:**
```bash
cd webserver-project
docker compose up -d
```

**What happens:** Each container maps `./web1`, `./web2`, `./web3` to Apache’s document root (`/usr/local/apache2/htdocs/`).

**Test:**
```bash
curl http://localhost:8081
curl http://localhost:8082
curl http://localhost:8083
```

**Teardown:** `docker compose down`

---

# Session 2 — Load Balancing, Caching, Security & API Gateways (2 Hours)

---

## Part 1: Load Balancing (25 min)

**Load balancing** distributes traffic across multiple servers.

```
        Load Balancer
       /      |      \
      v       v       v
   Server1  Server2  Server3
```

**Benefits:**
- Higher availability
- Better performance
- Fault tolerance

### Load Balancing Algorithms

| Algorithm | Behavior | Use Case |
|-----------|----------|----------|
| **Round Robin** | Sequential distribution | General purpose |
| **Least Connections** | To server with fewest active connections | Long-lived connections, APIs |
| **IP Hash** | Same client IP → same server | Session persistence |
| **Weighted** | Some servers get more traffic | Different capacity servers |

---

## Lab 2 — Load Balancer (20 min)

**Goal:** Nginx as reverse proxy + round-robin load balancer in front of 3 Apache backends.

**Nginx config excerpt:**
```nginx
upstream web_cluster {
    server web1:80;
    server web2:80;
    server web3:80;
}

location / {
    proxy_pass http://web_cluster;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

**Deploy:**
```bash
cd webserver-project-LB
docker compose up -d
```

**Test:** Run `curl http://localhost` repeatedly — responses rotate between web1, web2, web3.

---

## Part 2: Path-Based Routing (15 min)

Route different paths to different backends (no load balancing in this lab).

```
/app1 → web1
/app2 → web2
/app3 → web3
```

---

## Lab 3 — Path-Based Routing (15 min)

**Deploy:**
```bash
cd webserver-project-Routes
docker compose up -d
```

**Test:**
```bash
curl http://localhost/app1
curl http://localhost/app2
curl http://localhost/app3
```

**Nginx concept:** Each `location` block maps a path to a backend. `proxy_pass http://web1:80/;` — trailing `/` strips `/app1` before forwarding.

---

## Part 3: Rate Limiting (15 min)

**Problem:** APIs and web servers can be abused (DDoS, scraping).

**Solution:** Limit requests per client (e.g. per IP).

**Nginx example:**
```nginx
limit_req_zone $binary_remote_addr zone=req_limit:10m rate=5r/s;

location / {
    limit_req zone=req_limit burst=3 nodelay;
    limit_req_status 429;
    proxy_pass http://web_cluster;
}
```

**Result:** Exceeding the limit returns **429 Too Many Requests**.

---

## Lab 4 — Rate Limiting (15 min)

**Deploy:**
```bash
cd webserver-project-RL
docker compose up -d
```

**Test:**
- Normal: `curl http://localhost`
- Trigger rate limit: `for i in {1..15}; do curl -s -o /dev/null -w "%{http_code}\n" http://localhost; done` — expect mix of 200 and 429.

---

## Part 4: Caching (10 min)

**Problem:** Many users requesting the same data → overloaded backend/DB.

**Solution:** Cache responses at the reverse proxy (or CDN).

**Nginx proxy cache concept:**
```nginx
proxy_cache_path /tmp/nginx_cache keys_zone=my_cache:10m;

location /api {
    proxy_cache my_cache;
    proxy_pass http://backend;
}
```

**Benefits:** Faster responses, less backend load, better scalability.

---

## Part 5: Forward vs Reverse Proxy (10 min)

| | Reverse Proxy | Forward Proxy |
|---|---------------|----------------|
| **Position** | In front of servers | In front of clients |
| **Protects** | Servers | Clients |
| **Visibility** | Clients don’t see backend | Internet doesn’t see client |
| **Examples** | Nginx, Cloudflare | Corporate proxy, VPN |

---

## Part 6: Security Headers (10 min)

| Header | Purpose |
|--------|---------|
| `X-Frame-Options: DENY` | Prevent clickjacking |
| `Content-Security-Policy` | Control script/source loading |
| `X-XSS-Protection` | Legacy XSS mitigation |
| `Strict-Transport-Security` | Force HTTPS |
| `X-Content-Type-Options: nosniff` | Prevent MIME sniffing |

---

## Part 7: API Gateway (15 min)

When systems grow into microservices, an **API Gateway** centralizes cross-cutting concerns.

```
Client
  |
  v
API Gateway
  |
  +---- User Service
  +---- Order Service
  +---- Payment Service
```

**Responsibilities:**
- Authentication (JWT, API keys)
- Routing
- Rate limiting
- Logging & monitoring
- Request/response transformation

**Tools:** Kong, AWS API Gateway, Traefik, Nginx.

---

## Part 8: Kong API Gateway (5 min)

- Built on Nginx + Lua
- JWT auth, rate limiting, plugins
- Often used in Kubernetes, Docker, cloud

---

## Part 9: Real Production Architecture (10 min)

```
Internet
   |
Cloud Load Balancer (e.g. AWS ALB)
   |
Reverse Proxy / API Gateway
   |
Microservices (K8s, ECS, etc.)
   |
Databases + Redis (caching)
```

**Components:** AWS ALB, Nginx, Kong, Kubernetes, Redis, PostgreSQL/MySQL.

---

## Final Discussion Questions (5 min)

1. Web server vs application server — what’s the difference?
2. Reverse proxy vs forward proxy — how do they differ?
3. Why use load balancing?
4. What problems does caching solve?
5. When do you need an API Gateway?

---

# Real-World Scenarios

### Scenario 1: E-Commerce During Black Friday

**Setup:** Nginx load balancer + 5 app servers + Redis cache.

**Flow:** User → Nginx (cache hit for product catalog) → return instantly. Cache miss → route to least busy app server → DB → cache result → return.

**Concepts:** Load balancing, caching, rate limiting to prevent bots.

---

### Scenario 2: Embedded Dashboard (Metabase/Rabbitmart-Style)

**Setup:** Dashboard embedded in another site via iframe. API uses JWT in URL + session cookies.

**Flow:** Parent site loads iframe → iframe requests `report.example.com/api/embed/...` with JWT → server validates token → returns data or "Token expired".

**Concepts:** Headers (`referer`, `x-metabase-embedded`), JWT auth, CORS, `Content-Security-Policy: frame-ancestors`.

---

### Scenario 3: CDN + Origin (KodeKloud/Cloudflare-Style)

**Setup:** Cloudflare in front of origin. Static assets cached at edge.

**Flow:** User → Cloudflare (HIT → return from cache) or (MISS → fetch from origin → cache → return).

**Concepts:** `cf-cache-status`, `age`, security headers (`x-frame-options`, HSTS).

---

### Scenario 4: Multi-Tenant SaaS (Path-Based Routing)

**Setup:** `/tenant-a/*` → app A, `/tenant-b/*` → app B, `/api/*` → API gateway.

**Flow:** Same domain, different backends by path. Nginx routes without client knowing.

**Concepts:** Path-based routing (Lab 3).

---

### Scenario 5: API Protection (Rate Limiting)

**Setup:** Public API with 100 req/min per IP. Malicious client sends 1000 req/s.

**Flow:** Nginx rate limiter → first 100 pass → rest get 429 → backend stays healthy.

**Concepts:** `limit_req_zone`, `limit_req`, HTTP 429 (Lab 4).

---

### Scenario 6: Corporate Proxy (Forward Proxy)

**Setup:** All employees browse through company proxy. Proxy logs traffic, blocks sites, enforces policy.

**Flow:** Employee → Proxy → Internet. External servers see proxy IP, not employee IP.

**Concepts:** Forward proxy, corporate networks.

---

# Appendix: Lab Summary

| Lab | Project | What It Does |
|-----|---------|--------------|
| 1 | webserver-project | 3 Apache servers, direct ports |
| 2 | webserver-project-LB | Nginx load balancer in front of 3 Apache |
| 3 | webserver-project-Routes | Nginx path-based routing (/app1, /app2, /app3) |
| 4 | webserver-project-RL | Same as Lab 2 + rate limiting (429 when exceeded) |

---

# Quick Reference

### Document Roots

| Server | Path |
|--------|------|
| Nginx default | `/usr/share/nginx/html` |
| Nginx custom | `root /var/www/html;` in config |
| Apache default | `/var/www/html` |
| Apache (httpd Docker) | `/usr/local/apache2/htdocs/` |

### curl Cheat Sheet

| Command | Purpose |
|---------|---------|
| `curl -v URL` | Verbose (headers, TLS) |
| `curl -I URL` | Headers only |
| `curl -H "Header: value" URL` | Add header |
| `curl -b "cookie=value" URL` | Send cookies |
| `curl -X POST -d '{"key":"val"}' URL` | POST JSON |

---

# Appendix: Nginx Config Walkthrough by Lab

### Lab 2 — Load Balancer (webserver-project-LB/nginx.conf)

```nginx
worker_processes 1;                    # 1 worker (fine for demo)
events { worker_connections 1024; }     # Max connections per worker

http {
    include /etc/nginx/mime.types;      # Content-Type for .html, .css, etc.
    default_type application/octet-stream;

    upstream web_cluster {              # Define backend pool
        server web1:80;                 # Docker service names
        server web2:80;
        server web3:80;
    }

    server {
        listen 80;
        server_name localhost;

        location / {
            proxy_pass http://web_cluster;  # Forward to upstream
            proxy_set_header Host $host;    # Pass original Host
            proxy_set_header X-Real-IP $remote_addr;   # Client IP
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
```

### Lab 3 — Path-Based Routing (webserver-project-Routes/nginx.conf)

```nginx
location /app1 {
    proxy_pass http://web1:80/;   # Trailing / strips /app1, forwards /
}
location /app2 {
    proxy_pass http://web2:80/;
}
location /app3 {
    proxy_pass http://web3:80/;
}
```

**Note:** `proxy_pass http://web1:80/` with trailing `/` rewrites `/app1/foo` → `/foo`. Without `/`, it would forward `/app1/foo` as-is.

### Lab 4 — Rate Limiting (webserver-project-RL/nginx.conf)

```nginx
limit_req_zone $binary_remote_addr zone=req_limit:10m rate=5r/s;
# Key: client IP | Zone name:size (10m≈160k IPs) | 5 requests/sec

location / {
    limit_req zone=req_limit burst=3 nodelay;  # 5/s + burst of 3
    limit_req_status 429;                       # Return 429 when exceeded
    proxy_pass http://web_cluster;
    # ... headers ...
}
```
