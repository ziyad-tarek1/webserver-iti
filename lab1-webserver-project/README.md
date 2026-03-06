# Lab 1 — Basic Web Servers

## Description

Three Apache HTTP Server instances serving static content, each on its own port. No load balancer or rate limiting.

## Project Structure

```
.
├── docker-compose.yaml
├── web1/
│   └── index.html
├── web2/
│   └── index.html
└── web3/
    └── index.html
```

## Access Points

- **Web 1**: http://localhost:8081
- **Web 2**: http://localhost:8082
- **Web 3**: http://localhost:8083

---

## Deploy

```bash
cd webserver-project
docker compose up -d
```

Verify: `curl http://localhost:8081` (or 8082, 8083)

---

## Delete / Teardown

```bash
cd webserver-project
docker compose down
```

To also remove volumes (if any): `docker compose down -v`
