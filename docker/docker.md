
## Images



#### Show images

`docker images`
or
`docker image ls`

#### Pull an image
Usually pulls from docker hub

`docker image pull <image-name>`
or
`docker pull <image-name>`

### Build an image

`docker build -t <image-name> .`


### Build an image with tag

```
docker build -t <image-name>:1.2.3 .
docker build -t crm-api:1.2.3 .
```


### Change tag for an image
`docker image tag <image-name>:latest <image-name>:1.2.4`


### Remove an image
`docker image rm <id>`


### Remove all containers!!
`docker image rm -f $(docker image ls -aq)`


### Remove all dangling images
`docker image prune`

### Check the history of an image
`docker image history <image-name>`


---


## Containers


### Show running containers  (processes)
`docker ps`


### Show stoped containers
`docker ps -a`


### Run container from image

```
docker container run ubuntu
```
or shorter syntax:
```
docker run ubuntu
```

### How `run` works?

It runs three commands behind the scene:

```bash
docker [image] pull
docker [container] create
docker [container] start
```


### Run container from image in detach mode (process in background `-d`)
```bash
# Use -d to run container in detach mode (process in background)
docker run -d ubuntu
# assign name for container
docker run -d ubuntu --name my-ubuntu
```

### Map a port on your host to a port on the container

```bash
docker run -d ubuntu --publish <hostPort>:<containerPort>
```
or
```bash
docker run -d ubuntu -p <hostPort>:<containerPort>
```

```bash
docker run -d ubuntu --name my-ubuntu -p <hostPort>:<containerPort>

docker run -d ubuntu --name my-ubuntu -p <hostPort>:<containerPort> -v <vol-name>:/path/in/container/filesystem

docker run -d ubuntu --name my-ubuntu -p <hostPort>:<containerPort> -v $(pwd):/path/in/container/filesyste

docker run --name myApache1 -p 9090:80 -d httpd
```

### Run container from image in interactive mode (`-it`)
```
docker run -it ubuntu
docker run -it ubuntu bash  (run bash)
```
### Show usage and stats about containers
```
docker container stats
```

### Stop a container
```
docker stop <container-name-id>
docker stop $(docker container ls -aq) stop all containers
```

### Run a stopped container
`docker start <contaner-name-id>`


### Remove a container
```
docker container rm <container-name>
docker container rm -f <container-name> remove a running container
docker rm -f <container-name> shorter syntax
```


### Remove all containers!!
`docker container rm -f $(docker container ls -aq)`


### Remove all dangling containers
`docker container prune`


### Restart containers
```
docker restart $(docker container ls -aq)
docker restart $(docker ps -aq)
docker restart <container-name-or-id>
```

### Log Container Output
```
docker logs <container-name-or-id>
docker logs -f <container-name-or-id> continuously show the outputs
```

### Execute command in running container
```
docker exec -it <container-name-id> <command>
docker exec -it <container-name-id> /bin/bash
docker exec -it <container-name-id> ls -a
docker exec -it <container-name-id> -u root <command> Set login user
```

### Image vs Container

Docker image is like a class in programming and container is an instantiated class.

---


## Volumes


### Create volume
`docker volume create <volume-name>`


### Copy file from container to host
`docker cp <container-name>:/app/log.txt .`


### Copy file from host to container
`docker cp version.txt <container-name>:/app`


---


## Networks


### list networks
`docker network ls`


---


## Docker Compose


### Build application from images
```
docker-compose build`
docker-compose build --no-cache Rebuild from fresh images
```

### Start the application
```
docker-compose up
docker-compose up -d (detach mode -n background)
docker-compose up -d --build rebuilds each image and starts application
```

### Stop application
`docker-compose down`
