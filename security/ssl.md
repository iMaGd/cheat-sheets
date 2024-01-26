### Enable SSL
```bash
sudo apt install -y openssl certbot python3-certbot-apache
sudo certbot --apache --agree-tos --redirect --hsts --staple-ocsp --must-staple -d pma.example.com --email you@example.com

sudo certbot --apache --agree-tos --redirect --hsts --staple-ocsp --must-staple -d sub.domain.com --email admin@domain.com
sudo certbot --apache --agree-tos --redirect --hsts --staple-ocsp --must-staple -d domain.com --email admin@domain.com

sudo certbot renew --dry-run # best
sudo certbot certificates
sudo certbot delete # will prompt certificate selection
```
