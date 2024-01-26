### Enable SSL

Install certbot if `apache` is web server
```bash
sudo apt install -y openssl certbot python3-certbot-apache
```

Install certbot if `nginx` is web server
```bash
sudo apt install -y openssl certbot python3-certbot-nginx
```

Get a SSL certificate for a domain
```bash
sudo certbot --apache --agree-tos --redirect --hsts --staple-ocsp --must-staple -d sub.domain.com --email admin@domain.com
```

```bash
# Dry test
sudo certbot renew --dry-run # best

# List certificates
sudo certbot certificates

# Prompts a certificate selection to delete
sudo certbot delete
```
