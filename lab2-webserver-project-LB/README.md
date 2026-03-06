# Lab 2 — Load Balancer

## Description

Three Apache web servers behind an Nginx reverse proxy with round-robin load balancing. All traffic enters through port 80.

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

- **Load balancer**: http://localhost:80 — distributes requests across web1, web2, web3
- **Backends (direct)**: http://localhost:8081, 8082, 8083

---

## Deploy

```bash
cd webserver-project-LB
docker compose up -d
```

Verify: `curl http://localhost` — refresh a few times and responses will rotate between web1, web2, web3.

---

## Delete / Teardown

```bash
cd webserver-project-LB
docker compose down
```

To also remove volumes: `docker compose down -v`
