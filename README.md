# Webserver ITI Labs

Three demo labs for learning web servers, load balancing, and path-based routing.

| Lab | Directory | Description |
|-----|-----------|-------------|
| **1. Basic** | `webserver-project` | 3 Apache web servers (no load balancer) |
| **2. Load Balancer** | `webserver-project-LB` | Nginx reverse proxy + round-robin LB |
| **3. Path Routing** | `webserver-project-Routes` | Nginx routes /app1, /app2, /app3 to separate backends |

## Quick Reference

### Deploy

```bash
# Lab 1
cd /Users/ziyadtarek/Desktop/webserver-iti/webserver-project && docker compose up -d

# Lab 2
cd /Users/ziyadtarek/Desktop/webserver-iti/webserver-project-LB && docker compose up -d

# Lab 3
cd /Users/ziyadtarek/Desktop/webserver-iti/webserver-project-RL && docker compose up -d

# Lab 4
cd /Users/ziyadtarek/Desktop/webserver-iti/webserver-project-Routes && docker compose up -d
```

### Delete / Teardown

```bash
# Lab 1
cd /Users/ziyadtarek/Desktop/webserver-iti/webserver-project && docker compose down -v

# Lab 2
cd /Users/ziyadtarek/Desktop/webserver-iti/webserver-project-LB && docker compose down -v

# Lab 3
cd /Users/ziyadtarek/Desktop/webserver-iti/webserver-project-RL && docker compose down -v

# Lab 4
cd /Users/ziyadtarek/Desktop/webserver-iti/webserver-project-Routes && docker compose down -v
```

See each lab's `README.md` for details.

---

### Build slides PDF (with logos)

Images (e.g. in `images/`) are **local files**. Marp blocks them unless you allow local file access:

```bash
npx @marp-team/marp-cli WEBSERVER-SLIDES.md -o webserver-slides.pdf --allow-local-files
```

Without `--allow-local-files`, the PDF is built but logos and the ITI footer image will not appear.
