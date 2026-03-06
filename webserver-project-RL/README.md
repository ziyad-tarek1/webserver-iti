# Lab 3 — Rate Limiting

## Description

Same setup as Lab 2 (Nginx + 3 web servers) with request rate limiting enabled. Limits each client IP to 5 requests/second with a burst of 3. Excess requests receive HTTP 429 (Too Many Requests).

## Project Structure

```
.
├── docker-compose.yaml
├── nginx.conf
├── web1/
│   └── index.html
├── web2/
│   └── index.html
└── web3/
    └── index.html
```

## Access Points

- **Rate-limited entry**: http://localhost:80
- **Backends (direct, no rate limit)**: http://localhost:8081, 8082, 8083

## Rate Limit Configuration

- **Rate**: 5 requests/second per IP
- **Burst**: 3 additional requests allowed
- **Response when exceeded**: HTTP 429

---

## Deploy

```bash
cd webserver-project-RL
docker compose up -d
```

Verify:  
- Normal: `curl http://localhost`  
- Trigger rate limit: `for i in {1..15}; do curl -s -o /dev/null -w "%{http_code}\n" http://localhost; done` — expect mix of 200 and 429.

---

## Delete / Teardown

```bash
cd webserver-project-RL
docker compose down
```

To also remove volumes: `docker compose down -v`
