FROM nginx:alpine

EXPOSE 80

EXPOSE 443

COPY docker-entrypoint.sh docker-entrypoint.sh

ENTRYPOINT ["/bin/sh", "docker-entrypoint.sh"]