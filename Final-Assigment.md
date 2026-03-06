# Final Assignment: Microservice Routing with Caddy Reverse Proxy

## Overview

Your company platform is composed of multiple microservices:

- **Shop Service**
- **Cart Service**
- **Admin Service**

The services are currently deployed using Apache-based Docker images. The engineering team has decided to migrate the platform to Nginx-based images using a **Blue-Green Deployment Strategy**.

**Your task:** Configure Caddy as a reverse proxy to manage the migration and route traffic correctly between the old and new services.

---

## Table of Contents

1. [Infrastructure](#infrastructure)
2. [Domain & Routing](#domain--routing)
3. [Requirements](#requirements)
4. [Expected Architecture](#expected-architecture)
5. [Submission Requirements](#submission-requirements)
6. [Bonus Challenge](#bonus-challenge)

---

## Infrastructure

Each service must have two versions:

| Version | Stack | Paths |
|---------|-------|-------|
| **v1** (Current) | Apache | `/v1/shop`, `/v1/cart`, `/v1/admin` |
| **v2** (New) | Nginx | `/v2/shop`, `/v2/cart`, `/v2/admin` |

**Constraint:** All services must run as Docker containers.

---

## Domain & Routing

All traffic must go through:

```
https://local.iti.eg
```

### Example Requests

| Path | Version | Service |
|------|---------|---------|
| `https://local.iti.eg/v1/shop` | v1 | Apache Shop |
| `https://local.iti.eg/v1/cart` | v1 | Apache Cart |
| `https://local.iti.eg/v1/admin` | v1 | Apache Admin |
| `https://local.iti.eg/v2/shop` | v2 | Nginx Shop |
| `https://local.iti.eg/v2/cart` | v2 | Nginx Cart |
| `https://local.iti.eg/v2/admin` | v2 | Nginx Admin |

---

## Requirements

### 1. Path-Based Routing

Caddy must route traffic based on the request path to the correct service container.

| Path | Destination |
|------|-------------|
| `/v1/shop` | Apache Shop |
| `/v1/cart` | Apache Cart |
| `/v1/admin` | Apache Admin |
| `/v2/shop` | Nginx Shop |
| `/v2/cart` | Nginx Cart |
| `/v2/admin` | Nginx Admin |

---

### 2. HTTPS Enforcement

- All traffic must be served over **HTTPS only**
- Requests to `http://local.iti.eg` must automatically redirect to `https://local.iti.eg`
- TLS certificates should be handled **automatically by Caddy**

---

### 3. Security Headers

All responses must include:

| Header | Value |
|--------|-------|
| `X-Frame-Options` | `DENY` |
| `X-Content-Type-Options` | `nosniff` |
| `X-XSS-Protection` | `1; mode=block` |

**Purpose:** Protect against clickjacking, MIME sniffing, and basic XSS attacks.

---

### 4. Authentication for Admin Service

The Admin service must be protected using **Basic Authentication**.

**Protected routes:**
- `/v1/admin`
- `/v2/admin`

**Requirements:**
- Unauthenticated requests must return `401 Unauthorized`
- **Credentials:** `admin` / `admin123`

---

### 5. Health Checks & Failover

- Caddy must periodically check service health
- Each service must expose a health endpoint: `/health`

**Behavior when a service is unhealthy:**
- Caddy must stop routing traffic to it
- Users must be redirected to a maintenance page

---

### 6. Default Routing

| Path | Redirect To |
|------|-------------|
| `/v1` | `/v1/shop` |
| `/v2` | `/v2/shop` |

This ensures a default entry point for each version.

---

### 7. Rate Limiting

- **Limit:** 10 requests per second per client
- **Purpose:** Protect against traffic spikes or abuse

---

### 8. Logging

Caddy must log all incoming requests. Logs should include:


**Purpose:** Debug routing issues and service failures.

---

### 9. Retry Policy

If a request to a service fails:
- Caddy should **retry** the request automatically on another healthy instance
- **Purpose:** Improve reliability

---

### 10. Circuit Breaker

If a service repeatedly fails:
- Caddy temporarily stops sending traffic to that service
- Traffic is redirected to the maintenance page

**Purpose:** Prevent cascading failures and protect the system.

---

### 11. Service Identification & Design

Each service page must display:

- **Service Name**
- **Version** (v1 or v2)
- **Container Instance** (e.g. `apache-shop-1`, `nginx-cart-2`)

**Example:**

> **Shop Service**  
> Version: v1  
> Server: apache-shop-1

**Color coding (Blue-Green):**

- **v1 services (Apache):** Use blue colors
- **v2 services (Nginx):** Use green colors

---

## Expected Architecture

```
                    Users
                       │
                       │ HTTPS
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

---

## Submission Requirements

Students must submit:

| Item | Description |
|------|-------------|
| `docker-compose.yml` | Service definitions and networking |
| `Caddyfile` | Caddy reverse proxy configuration |
| Dockerfiles | For Apache and Nginx services |
| Architecture document | Short explanation of the design |

---

## Bonus Challenge: Canary Deployment

Implement a **Canary Deployment Strategy** to gradually migrate traffic from Apache (v1) to Nginx (v2).

### Traffic Split

When a user accesses:

- `https://local.iti.eg/shop`
- `https://local.iti.eg/cart`
- `https://local.iti.eg/admin`

Caddy must distribute traffic internally as follows:

| Version | Traffic % |
|---------|-----------|
| v1 (Apache) | 90% |
| v2 (Nginx)  | 10% |

### Example

Request: `https://local.iti.eg/cart`

- 90% → routed internally to `/v1/cart`
- 10% → routed internally to `/v2/cart`

**Important:** The user should **not** see `/v1` or `/v2` in the URL. Traffic splitting must be handled internally by the reverse proxy.

### Goal

Safely test the new Nginx deployment with a small percentage of production traffic before completing the migration.
