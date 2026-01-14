#!/bin/bash
set -e

# Create a simple web page and start nginx
mkdir -p /var/www/html
echo "<html><body><h1>DMZ Web Server</h1><p>IP: $(hostname -I)</p></body></html>" > /var/www/html/index.html

service nginx start

# Keep container alive
tail -f /var/log/nginx/error.log
