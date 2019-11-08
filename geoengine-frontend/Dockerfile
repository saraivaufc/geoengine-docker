FROM ubuntu:16.04

MAINTAINER Agrosátelite <www.agrosatelite.com.br>

############## INSTALL GIT, SSH, Open SSL, SSL Dev and curl ######################

RUN apt-get clean && apt-get update && apt-get install -y git ssh libcurl4-openssl-dev libssl-dev curl

############## INSTALL NPM and NodeJS ##########################

RUN curl -sL https://deb.nodesource.com/setup_10.x  | bash -

RUN apt-get install -y nodejs

RUN npm install npm@6.9.0 -g

# ############ INSTALL AND CONFIGURE NGINX ##############################

RUN apt-get install -y nginx

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

############## CONFIGURE SSH KEY ########################

ARG SSH_PRIVATE_KEY

ADD ${SSH_PRIVATE_KEY} /root/.ssh/id_rsa

RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/id_rsa

RUN cat /root/.ssh/id_rsa

RUN touch /root/.ssh/known_hosts

RUN ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts

# ############ INSTALL GEOENGINE ########################

WORKDIR /var/www

RUN echo "7"

RUN git clone git@github.com:saraivaufc/geoengine-frontend.git

WORKDIR geoengine-frontend

ARG BRANCH

RUN git checkout ${BRANCH}

ARG GEOENGINE_BACKEND_HOST

RUN npm install

RUN echo "export const environment = {\
    production: false,\
    auth: {\
        client_id: 'TgfzKnuv17whL1M45KIQym0jF1lAqXgtty2Sfw3c',\
        redirectUrl: '${GEOENGINE_BACKEND_HOST}',\
    },\
    items_per_page: 10,\
    base_endpoint: '${GEOENGINE_BACKEND_HOST}',\
    endpoints: {\
        token: 'oauth2Provider:token',\
        fields: 'monitor:fields_create_list',\
        regions_details: 'monitor:fields_retrieve_update_destroy',\
        products: 'monitor:products_list',\
        tasks: 'services:tasks_list',\
        tasks_details: 'services:tasks_details'\
    },\
};" > src/environments/environment.prod.ts

RUN cat src/environments/environment.prod.ts

RUN npm run build -- --prod

################ INITIALIZE CONTAINER ##############################

# Expose Nginx port 
EXPOSE 80

ARG ENTRY_POINT

ADD ${ENTRY_POINT} docker-entrypoint.sh

ENTRYPOINT ["/bin/bash", "docker-entrypoint.sh"]