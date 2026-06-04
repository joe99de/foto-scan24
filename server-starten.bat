@echo off
echo Starte lokalen Webserver fuer foto-scan24...
echo Browser: http://localhost:8080
echo Beenden: Strg+C
echo.
python -m http.server 8080
pause
