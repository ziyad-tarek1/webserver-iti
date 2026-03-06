# Webserver ITI Labs

Demo labs for web servers, load balancing, path routing, and Apache .htaccess.

| Lab | Directory | Description |
|-----|-----------|-------------|
| **1. Basic** | `webserver-project` | 3 Apache web servers (no load balancer) |
| **2. Load Balancer** | `webserver-project-LB` | Nginx reverse proxy + round-robin LB |
| **3. Path Routing** | `webserver-project-Routes` | Nginx routes /app1, /app2, /app3 to separate backends |
| **4. Rate lIMITING** | `webserver-project-RL` | Nginx used to rate limit request  |
| **5. Apache .htaccess** | `webserver-project-htaccess` | Apache with Basic Auth, redirects, per-dir config |
| **6. Kong Gateway** | `webserver-project-kong` | Kong dbless + 3 Nginx apps, path-based routing |

## Quick Reference

### Deploy

```bash
# Lab 1
cd webserver-project && docker compose up -d

# Lab 2
cd webserver-project-LB && docker compose up -d

# Lab 3
cd webserver-project-Routes && docker compose up -d

# Lab 4
cd webserver-project-RL && docker compose up -d 
# Lab 5 (requires --build)
cd webserver-project-htaccess && docker compose up -d --build

# Lab 5
cd webserver-project-kong && docker compose up -d
```

### Delete / Teardown

```bash
# Lab 1
cd webserver-project && docker compose down -v

# Lab 2
cd webserver-project-LB && docker compose down -v

# Lab 3
cd webserver-project-Routes && docker compose down -v

# Lab 4
cd webserver-project-RL && docker compose down -v

# Lab 5
cd webserver-project-htaccess && docker compose down -v

# Lab 6
cd webserver-project-kong && docker compose down -v
```

See each lab's `README.md` for details.

---

### Build slides PDF (with logos)

Images (e.g. in `images/`) are **local files**. Marp blocks them unless you allow local file access:

```bash
npx @marp-team/marp-cli WEBSERVER-SLIDES.md -o webserver-slides.pdf --allow-local-files
```

Without `--allow-local-files`, the PDF is built but logos and the ITI footer image will not appear.
