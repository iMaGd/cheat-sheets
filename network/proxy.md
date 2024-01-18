
## Install MTProxy

```bash
mkdir -p /var/docker/volumes/mtproxy-data
docker run -d -p1322:443 -v /var/docker/volumes/mtproxy-data:/data --name=mtproto-proxy telegrammessenger/proxy:latest
# Get Secret
docker logs mtproto-proxy
```