#!/usr/bin/bash

while ! pg_isready -h ${GEOENGINE_DB_HOST} -p ${GEOENGINE_DB_PORT} > /dev/null 2> /dev/null; do
  echo "Connecting to ${GEOENGINE_DB_HOST} Failed"
  sleep 1
done


echo "
server {
    listen 80 default_server;
    server_name 172.16.240.16;

    client_max_body_size 100M;
    large_client_header_buffers 4 100M;

    location / {
        include proxy_params;
        proxy_pass http://unix:/var/www/geoengine-backend/geoengine.sock;
    }

    location /static/  {
    	alias /var/www/geoengine-backend/static/;                                                                                       
    }

}
" > /etc/nginx/sites-enabled/default

cat /etc/nginx/sites-enabled/default

mkdir -p /root/.config/earthengine

echo "{\"refresh_token\": \"${GEE_REFRESH_TOKEN}\"}" > /root/.config/earthengine/credentials

cat /root/.config/earthengine/credentials

python3 manage.py makemigrations authentication
python3 manage.py makemigrations accounts
python3 manage.py makemigrations data
python3 manage.py makemigrations monitor
python3 manage.py makemigrations services
python3 manage.py makemigrations
python3 manage.py migrate

echo "Collectstatic"

python3 manage.py collectstatic --noinput

echo "Starting gunicorn..."

chmod +x gunicorn.sh && ./gunicorn.sh &

echo "Starting rabbitmq-server"

rabbitmq-server &

echo "Starting Celery..."

chmod +x worker.sh && ./worker.sh &

echo "Starting nginx..."

/etc/init.d/nginx start

echo "services initialized!"
