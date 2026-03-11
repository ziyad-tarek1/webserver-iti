# Architecture: Microservice Routing with Caddy

## Overview

This setup implements a **Blue-Green Deployment** for migrating from Apache (v1) to Nginx (v2) microservices. Caddy acts as the reverse proxy, handling TLS, authentication, routing, rate limiting, and failover.

## Prerequisites

Add to `/etc/hosts` (or `C:\Windows\System32\drivers\etc\hosts` on Windows):

```
127.0.0.1 local.iti.eg
```

## Architecture Diagram

```
                    Users
                       │
                       │ HTTPS (local.iti.eg:443)
                       ▼
                    Caddy
     (TLS + Auth + Routing + Rate Limit + Logging)
                       │
         ┌─────────────┼─────────────┐
         │             │             │
         ▼             │             ▼
    /v1 routes        │        /v2 routes
    (Apache)          │        (Nginx)
         │             │             │
    ┌────┼────┐        │        ┌────┼────┐
    │    │    │        │        │    │    │
  shop cart admin      │      shop cart admin
```

## Components

| Component | Technology | Purpose |
|-----------|------------|---------|
| Reverse Proxy | Caddy 2 (with rate_limit module) | TLS, routing, auth, health checks, circuit breaker |
| v1 Backends | Apache (httpd) | Current production (Blue) |
| v2 Backends | Nginx | New deployment (Green) |

## Implemented Requirements

### 1. Path-Based Routing
- `/v1/shop` → Apache Shop
- `/v1/cart` → Apache Cart
- `/v1/admin` → Apache Admin (Basic Auth)
- `/v2/shop` → Nginx Shop
- `/v2/cart` → Nginx Cart
- `/v2/admin` → Nginx Admin (Basic Auth)

### 2. HTTPS Enforcement
- HTTP (port 80) redirects to HTTPS (port 443)
- `tls internal` for automatic self-signed cert (local dev)

### 3. Security Headers
- `X-Frame-Options: DENY`
- `X-Content-Type-Options: nosniff`
- `X-XSS-Protection: 1; mode=block`

### 4. Basic Authentication (Admin)
- Routes: `/v1/admin`, `/v2/admin`
- Credentials: `admin` / `admin123`

### 5. Health Checks & Failover
- Each service exposes `/health`
- Active health checks every 10s
- Unhealthy backends: traffic stopped, maintenance page on 502/503

### 6. Default Routing
- `/v1` → `/v1/shop`
- `/v2` → `/v2/shop`

### 7. Rate Limiting
- 10 requests/second per client IP
- Uses `mholt/caddy-ratelimit` module

### 8. Logging
- Console logging, INFO level
- All requests logged

### 9. Retry Policy
- `lb_retries 2`, `lb_try_duration 5s`
- Automatic retry on backend failure

### 10. Circuit Breaker
- `fail_duration 30s`, `max_fails 3`
- Backend marked unhealthy after 3 failures in 30s
- Maintenance page served when all backends down

### 11. Service Identification
- Each HTML page shows: Service Name, Version, Container Instance
- v1: Blue theme | v2: Green theme

## Running

```bash
docker compose build
docker compose up -d
```

Access: `https://local.iti.eg/v1/shop` (accept the self-signed certificate in the browser)
