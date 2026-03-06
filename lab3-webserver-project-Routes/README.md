# Lab 3 — Path-Based Routing

## Description

Three Apache web servers behind Nginx with path-based routing. No load balancing — each path maps to a single app.

- `/app1` → web1  
- `/app2` → web2  
- `/app3` → web3  

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

- **App 1**: http://localhost/app1  
- **App 2**: http://localhost/app2  
- **App 3**: http://localhost/app3  
- **Backends (direct)**: http://localhost:8081, 8082, 8083  

---

## Deploy

```bash
cd webserver-project-Routes
docker compose up -d
```

Verify: `curl http://localhost/app1` and `curl http://localhost/app2` and `curl http://localhost/app3`

---

## Delete / Teardown

```bash
cd webserver-project-Routes
docker compose down
```

To also remove volumes: `docker compose down -v`
