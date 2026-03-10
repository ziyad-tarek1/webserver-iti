# Lab 5.1 — Apache Load Balancer

Simple demo: Apache as load balancer (same idea as Lab 2, but Apache instead of Nginx).

## What it does

- 3 Apache backends (web1, web2, web3)
- 1 Apache proxy in front → round-robin across backends
- All traffic on port 80 → refresh to see different backends

## Structure

```
.
├── config/
│   └── httpd-proxy.conf   # Load balancer config
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
cd lab5.1-load-balancer
docker compose up -d
```

## Test

```bash
curl http://localhost
# Run several times — responses rotate among web1, web2, web3
```

## Stop

```bash
docker compose down
```

**Note:** Both lab5.1 and lab5.2 use port 80. Stop one before running the other.
