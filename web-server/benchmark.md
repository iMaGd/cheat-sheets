# Benchmark tools

## Apache Benchmark

Install Apache Benchmark on Debian/Ubuntu
```bash
sudo apt install apache2-utils
```

Send 100 requests with 10 concurrent connections
```bash
ab -n 100 -c 10 http://yournginxsite.com/
```
