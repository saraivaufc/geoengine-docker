#!/usr/bin/bash

sleep 5

echo "
server {
    listen 80;
    
    root /var/www/geoengine-frontend/dist/geoengine-frontend;

    index index.html;

    gzip on;
    gzip_comp_level 6;
    gzip_vary on;
    gzip_min_length  1000;
    gzip_proxied any;
    gzip_types text/plain text/html text/css application/json application/x-javascript application/javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_buffers 16 8k;

    location / { 
      include proxy_params;
      try_files \$uri \$uri/ /index.html;
    }
    
}
" > /etc/nginx/sites-enabled/default

cat /etc/nginx/sites-enabled/default

/etc/init.d/nginx start

echo "services initialized!"
