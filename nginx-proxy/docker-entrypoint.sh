#!/usr/bin/sh 

if $SSL; then
  echo "
    worker_processes 1;
 
    events { 
        worker_connections 1024; 
    }

    http {
        server {
            listen 80;
            server_name ${DOMAIN};
            return 301 https://${DOMAIN}\$request_uri;
        }

        server {
            listen 443 ssl;
            server_name ${DOMAIN};

            client_max_body_size 100M;
            large_client_header_buffers 4 100M;

            ssl_certificate ${SSL_CERTIFICATE};
            ssl_certificate_key ${SSL_CERTIFICATE_KEY};

            ssl_protocols TLSv1.2;
            ssl_prefer_server_ciphers on;

            ssl_ciphers 'ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS';

            location / {
                resolver 127.0.0.11;
                proxy_set_header Host \$host:\$server_port;
                proxy_redirect off;
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_pass  http://geoengine-frontend\$request_uri;
            }

            location /platform {
                resolver 127.0.0.11;
                proxy_set_header Host \$host:\$server_port;
                proxy_redirect off;
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_pass  http://geoengine-backend\$request_uri;
            }

            location /static {
                resolver 127.0.0.11;
                proxy_set_header Host \$host:\$server_port;
                proxy_redirect off;
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_pass  http://geoengine-backend\$request_uri;
            }

        }
    }
  " > /etc/nginx/nginx.conf
else
  echo "
    worker_processes 1;
     
    events { 
        worker_connections 1024; 
    }
    
    http {
 
        sendfile on;
        client_max_body_size 2000M;

        server {
            listen 80 default_server;
            server_name ${DOMAIN};

            location / {
                resolver 127.0.0.11;
                proxy_set_header Host \$host:\$server_port;
                proxy_redirect off;
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_pass  http://geoengine-frontend\$request_uri;
            }

            location /platform {
                resolver 127.0.0.11;
                proxy_set_header Host \$host:\$server_port;
                proxy_redirect off;
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_pass  http://geoengine-backend\$request_uri;
            }

            location /static {
                resolver 127.0.0.11;
                proxy_set_header Host \$host:\$server_port;
                proxy_redirect off;
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_pass  http://geoengine-backend\$request_uri;
            }
        }
    }
  " > /etc/nginx/nginx.conf
fi

cat /etc/nginx/nginx.conf

nginx -g 'daemon off;'
