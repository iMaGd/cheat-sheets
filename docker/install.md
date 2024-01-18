
## Install docker
```bash
# remove defaults ubuntu 22
apt remove docker docker-engine docker.io

curl -o- https://get.docker.com | bash +x
```

## Install docker composer
```bash
curl -L https://github.com/docker/compose/releases/download/$(curl -s "https://api.github.com/repos/docker/compose/releases/latest" | awk -F '"' '/tag_name/{print $4}')/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
```
