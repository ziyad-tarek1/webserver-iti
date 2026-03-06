# Lab — Kong Gateway + Path-Based Routing

## Description

Kong API Gateway in **dbless mode** with declarative config, routing traffic to three Nginx apps by path:

- `/app1` → nginx-app1 (port 8081)
- `/app2` → nginx-app2 (port 8082)
- `/app3` → nginx-app3 (port 8083)

## Architecture

```
                    Kong (8000)
                         │
         ┌───────────────┼───────────────┐
         │               │               │
      /app1           /app2           /app3
         │               │               │
         ▼               ▼               ▼
    nginx-app1      nginx-app2      nginx-app3
      (8081)          (8082)          (8083)
```

## Project Structure

```
.
├── docker-compose.yaml
├── kong/
│   └── kong.yml       # Declarative config (dbless)
├── app1/
│   └── index.html
├── app2/
│   └── index.html
└── app3/
    └── index.html
```

## Ports

| Port | Service | Purpose |
|------|---------|---------|
| 8000 | Kong | Proxy (gateway entry) |
| 8001 | Kong | Admin API |
| 8081 | nginx-app1 | Direct access to app1 |
| 8082 | nginx-app2 | Direct access to app2 |
| 8083 | nginx-app3 | Direct access to app3 |

## Access Points

| Path | Via Kong | Direct |
|------|----------|--------|
| /app1 | http://localhost:8000/app1 | http://localhost:8081 |
| /app2 | http://localhost:8000/app2 | http://localhost:8082 |
| /app3 | http://localhost:8000/app3 | http://localhost:8083 |

## Deploy

```bash
cd webserver-project-kong
docker compose up -d
```

## Delete / Teardown

```bash
cd webserver-project-kong
docker compose down
```

## Verify

```bash
# Via Kong
curl http://localhost:8000/app1
curl http://localhost:8000/app2
curl http://localhost:8000/app3

# Direct to nginx
curl http://localhost:8081
curl http://localhost:8082
curl http://localhost:8083

# Kong config (dbless)
curl http://localhost:8001/
```
