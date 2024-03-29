
## Images



#### Show images

`docker images`


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


---


## Containers


### Show running containers  (processes)
`docker ps`


### Show stoped containers
`docker ps -a`


### Run container from image
```
docker run ubuntu
docker run -d ubuntu (-d detach mode -in background)
docker run -d ubuntu --name my-ubuntu assign name for container
docker run -d ubuntu --name my-ubuntu -p <hostPort>:<containerPort> assign name for container

docker run -d ubuntu --name my-ubuntu -p <hostPort>:<containerPort> -v <vol-name>:/path/in/container/filesystem

docker run -d ubuntu --name my-ubuntu -p <hostPort>:<containerPort> -v $(pwd):/path/in/container/filesyste

docker run --name myApache1 -p 9090:80 -d httpd
```

### Run new container from image (-it interactive mode)
```
docker run -it ubuntu
docker run -it ubuntu bash  (run bash)
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
