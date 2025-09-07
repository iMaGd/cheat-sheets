# Checking Ports

### Checking from inside the server:

If you want to see what the server is listening on (not blocked by firewall, just locally open):

```bash
ss -tuln
```
or
```bash
netstat -tuln
```
Check if a local port on host is accessible:
```bash
nc -vz 127.0.0.1 3306
```
---

### Checking from outside the server:

If you want to check if a port is open from outside the server, you can use a tool like `telnet` or `nc` (netcat).

```bash
telnet example.com 80
```
or
```bash
telnet ip 80
```
or

```bash
nc -zv ip 80
```
