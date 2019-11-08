### Docker

### Install Docker (Ubuntu 16.04):

```shell
$ sudo apt-get remove docker docker-engine docker.io
$ sudo apt-get update
$ sudo apt-get install apt-transport-https ca-certificates  curl software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo apt-key fingerprint 0EBFCD88
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
$ sudo apt-get update
$ sudo apt-get install docker-ce
$ sudo docker run hello-world
```

## Configurations

```shell
$ vim /etc/hosts
127.0.0.1       admin.simfaz.com.br www.admin.simfaz.com.br
127.0.0.1       consultas.simfaz.com.br www.consultas.simfaz.com.br
127.0.0.1       api.simfaz.com.br www.api.simfaz.com.br
127.0.0.1       site.simfaz.com.br www.site.simfaz.com.br
127.0.0.1       mapserver.simfaz.com.br www.mapserver.simfaz.com.br
```

## Deploy via Docker Compose

```shell
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

docker-compose build 

docker-compose up -d


## Deploy via Docker Swarm

Start Cluster

```shell
$ docker swarm init

# create link to join managers
$ docker swarm join-token manager

# create link to join workers
$ docker swarm join-token worker

$ docker stack deploy -c docker-compose.yml simfaz
```


```shell
$ docker swarm init 
# OR 
$ docker swarm init --advertise-addr 172.16.238.0

$ docker network create -d overlay --subnet=172.16.238.0/24 simfaz_default

$ docker stack deploy --compose-file docker-compose.yml simfaz

$  docker stack ps simfaz
$ docker stack rm simfaz

# create volume with rexray
$ curl -sSL https://rexray.io/install | sh -s -- stable

```

```shell
docker run -d --name portainer_container --restart always  -p 9010:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
```
