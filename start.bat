@echo off
start "" pythonw -m http.server 8080
timeout /t 1 /nobreak >nul
start http://localhost:8080
