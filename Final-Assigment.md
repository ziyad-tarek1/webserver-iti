Final Assignment

Lab: Microservice Routing with Caddy Reverse Proxy

Scenario

Your company platform is composed of multiple microservices:
	•	Shop Service
	•	Cart Service
	•	Admin Service

The services are currently deployed using Apache-based Docker images.

The engineering team has decided to migrate the platform to Nginx-based images using a Blue-Green Deployment Strategy.

Your task is to configure Caddy as a reverse proxy to manage the migration and route traffic correctly between the old and new services.

⸻

Infrastructure

Each service must have two versions:

Version 1 (Current – Apache)

/v1/shop
/v1/cart
/v1/admin

Version 2 (New – Nginx)

/v2/shop
/v2/cart
/v2/admin

All services must run as Docker containers.

⸻

Domain

All traffic must go through:

https://local.iti.eg

Example requests:

https://local.iti.eg/v1/shop
https://local.iti.eg/v1/cart
https://local.iti.eg/v1/admin

https://local.iti.eg/v2/shop
https://local.iti.eg/v2/cart
https://local.iti.eg/v2/admin


⸻

Requirements

1 — Path-Based Routing

Caddy must route traffic based on the request path to the correct service container.

Example:

Path	Destination
/v1/shop	Apache Shop
/v1/cart	Apache Cart
/v1/admin	Apache Admin
/v2/shop	Nginx Shop
/v2/cart	Nginx Cart
/v2/admin	Nginx Admin


⸻

2 — HTTPS Enforcement

All traffic must be served over HTTPS only.

Requirements:
	•	Requests to:

http://local.iti.eg

must automatically redirect to:

https://local.iti.eg

TLS certificates should be handled automatically by Caddy.

⸻

3 — Security Headers

All responses must include the following security headers:

X-Frame-Options: DENY
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block

These headers help protect the application against:
	•	Clickjacking
	•	MIME sniffing attacks
	•	Basic XSS attacks

⸻

4 — Authentication for Admin Service

The Admin service must be protected using Basic Authentication.

Protected routes:

/v1/admin
/v2/admin

Requirements:
	•	Unauthenticated requests must return:

401 Unauthorized

Example credentials:

username: admin
password: admin123


⸻

5 — Health Checks & Failover

Caddy must periodically check service health.

Each service must expose a health endpoint:

/health

Behavior:

If a service instance becomes unhealthy:
	•	Caddy must stop routing traffic to it.
	•	Users must be redirected to a maintenance page.

⸻

6 — Default Routing

The following default routes must be configured:

/v1 → /v1/shop
/v2 → /v2/shop

This ensures a default entry point for each version.

⸻

7 — Rate Limiting

Implement rate limiting:

10 requests per second per client

This protects the application from traffic spikes or abuse.

⸻

8 — Logging

Caddy must log all incoming requests.

Logs should include:
	•	Client IP
	•	Request path
	•	Response status
	•	Timestamp

The logs will help developers debug routing issues or service failures.

⸻

9 — Retry Policy

If a request to a service fails:
	•	Caddy should retry the request automatically on another healthy instance.

This improves reliability.

⸻

10 — Circuit Breaker

Implement a circuit breaker mechanism to prevent sending traffic to failing services.

Behavior:

If a service repeatedly fails:
	•	Caddy temporarily stops sending traffic to that service
	•	traffic is redirected to the maintenance page

⸻

Expected Architecture

Users
   |
   |
HTTPS
   |
  Caddy
(TLS + Auth + Routing + Rate Limit + Logging)
   |
   |---- /v1 → Apache Services
   |
   |---- /v2 → Nginx Services


⸻

Submission Requirements

Students must submit:
	•	docker-compose.yml
	•	Caddyfile
	•	Dockerfiles for Apache and Nginx services
	•	A short document explaining their architecture

⸻

نصيحتي الصغيرة (تحسن اللاب من غير ما تفترى)

ضيف requirement صغيرة:

Service Identification

Each service page must display:

Service Name
Version
Container Instance

Example:

Shop Service
Version: v1
Server: apache-shop-1

V1 Services must be using blue colloers
V2 Services must be using green colloers

⸻

Bonus Challenge — Canary Deployment

Implement a Canary Deployment Strategy to gradually migrate traffic from the Apache-based services (v1) to the Nginx-based services (v2).

When a user accesses:

https://local.iti.eg/shop
https://local.iti.eg/cart
https://local.iti.eg/admin

Caddy must distribute traffic between service versions as follows:

90% → v1 services (Apache)
10% → v2 services (Nginx)

Example:

https://local.iti.eg/cart

Traffic should be routed internally to:

90% → /v1/cart
10% → /v2/cart

The user should not see /v1 or /v2 in the URL.
Traffic splitting must be handled internally by the reverse proxy.

Goal:

Safely test the new Nginx deployment with a small percentage of production traffic before completing the migration.