FROM ubuntu:18.04

MAINTAINER Saraiva <saraiva.ufc@gmail.com>

############## INSTALL GIT, SSH, Python Dev, Open SSL, SSL Dev, rabbitmq-server, pip, gdal and nginx

RUN apt-get update && \
  apt-get install -y wget

RUN apt-get install -y aria2 && \
  wget https://raw.githubusercontent.com/ilikenwf/apt-fast/master/apt-fast -O /usr/local/sbin/apt-fast && \
  chmod +x /usr/local/sbin/apt-fast && \
  wget https://raw.githubusercontent.com/ilikenwf/apt-fast/master/apt-fast.conf -O /etc/apt-fast.conf
	
RUN apt-fast install -y postgresql-client \
	git \
	openssh-client \
	libcurl4-openssl-dev libssl-dev \
	python3-pip \
	rabbitmq-server \
	unrar \
	software-properties-common \
	nginx

############## INSTALL GDAL ##############################


RUN apt-add-repository ppa:ubuntugis/ubuntugis-unstable -y && apt-get update && apt-fast install -y libgdal-dev gdal-bin

############## INSTALL REDIS ##############################

RUN apt-fast install -y redis-server

# ############ CONFIGURE NGINX ##############################

RUN ln -sf /dev/stdout /var/log/nginx/access.log

RUN ln -sf /dev/stderr /var/log/nginx/error.log

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

RUN echo "11"

ARG BRANCH

RUN git clone --depth 1 git@github.com:saraivaufc/geoengine-backend.git -b "${BRANCH}"

WORKDIR geoengine-backend

RUN pip3 install --upgrade pip

RUN pip3 install numpy 

RUN pip3 install GDAL==$(gdal-config --version) --global-option=build_ext --global-option="-I/usr/include/gdal"

RUN echo "assdasd"

RUN pip3 install git+ssh://git@github.com/saraivaufc/geoengine.git@master

RUN pip3 install -r requirements.txt

################ INITIALIZE CONTAINER ##############################

# Expose Nginx port 
EXPOSE 8080

ARG ENTRY_POINT

ADD ${ENTRY_POINT} docker-entrypoint.sh

ENTRYPOINT ["/bin/bash", "docker-entrypoint.sh"]