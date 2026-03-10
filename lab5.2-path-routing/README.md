# Lab 5.2 — Apache Path-Based Routing

Simple demo: Apache as reverse proxy with path-based routing (same idea as Lab 3, but Apache instead of Nginx).

## What it does

- 3 Apache backends (web1, web2, web3)
- 1 Apache proxy in front → routes by path:
  - `/app1` → web1
  - `/app2` → web2
  - `/app3` → web3

## Structure

```
.
├── config/
│   └── httpd-proxy.conf   # Path routing config
├── web1/
│   └── index.html
├── web2/
│   └── index.html
├── web3/
│   └── index.html
├── docker-compose.yaml
└── README.md
```

## Run

```bash
cd lab5.2-path-routing
docker compose up -d
```

## Test

```bash
curl http://localhost/app1   # → App 1
curl http://localhost/app2   # → App 2
curl http://localhost/app3   # → App 3
```

## Stop

```bash
docker compose down
```

**Note:** Both lab5.1 and lab5.2 use port 80. Stop one before running the other.
