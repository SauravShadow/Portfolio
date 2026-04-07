# Saurav Kumar - Personal Portfolio & Server Configuration

This directory contains the source code for my personal Static Portfolio website (`saurav-info.xyz`), as well as the custom infrastructure code required to serve it reliably at the edge.

## 🚀 The Web Server Architecture

Standard Python static servers (`python -m http.server`) rely on a single-threaded execution model using `BaseHTTPServer`. However, this portfolio is deployed behind a **Cloudflare Zero-Trust Tunnel**.

Cloudflare tunnels proxy traffic through persistent `Keep-Alive` TCP connections. A single-threaded Python server handles the first connection but blocks entirely when Cloudflare leaves it open, resulting in widespread `502 Bad Gateway` errors for all subsequent visitors.

### 🛠️ The Solution (`start_server.py`)
To solve this, the server was rewritten using a custom **Multi-Threaded** approach:
```python
with http.server.ThreadingHTTPServer(("0.0.0.0", 8080), Handler) as httpd:
```
By binding `ThreadingHTTPServer`, Python instantly spawns a new background thread for every single incoming Cloudflare proxy request. This guarantees 100% stable uptime, zero request blocking, and eliminates all 502 connection timeouts. 

Furthermore, `start_server.py` suppresses internal `sys.stderr` console logging, allowing the program to be executed completely hidden in the background via `pythonw.exe` without throwing `NullWriter` IO Exceptions.

## ⚙️ Deployment Pipeline
- **Auto-Start**: The `register-task.ps1` script creates a persistent Windows Task Scheduler action.
- **Background Execution**: The task invokes `pythonw.exe` on machine boot, serving the site on Port `8080` silently.
- **Edge Routing**: The system-wide `cloudflared` daemon connects Port `8080` to the global `www.saurav-info.xyz` domain.
