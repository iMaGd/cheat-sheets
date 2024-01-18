

### Force SSL + WWW
```htaccess
RewriteEngine On
RewriteCond %{HTTP_HOST} !^www\. [NC]
RewriteRule ^(.*)$ https://www.%{HTTP_HOST}/$1 [R=301,L]
```
```htaccess
RewriteCond %{HTTP_HOST} !^www\. [NC]
RewriteRule ^(.*)$ https://www.%{HTTP_HOST}/$1 [R=301,L]
```

### Cache-Control header
```htaccess
<IfModule mod_headers.c>
    # WEEK
    <FilesMatch "\.(jpg|jpeg|png|gif|ico|pdf|mp4|mp3|svg)$">
        Header set Cache-Control "max-age=604800, public"
    </FilesMatch>

    # WEEK
    <FilesMatch "\.(js|css)$">
        Header set Cache-Control "max-age=604800"
    </FilesMatch>

    # Hour
    <FilesMatch "\.(html|htm|xml|txt|xsl)$">
        Header set Cache-Control "public, max-age=3600, must-revalidate"
    </FilesMatch>
</IfModule>
```

```htaccess
<IfModule mod_deflate.c>
# Insert filters / compress text, html, javascript, css, xml:
# mod_deflate can be used for Apache v2 and later and is the recommended GZip mechanism to use
AddOutputFilterByType DEFLATE text/plain
AddOutputFilterByType DEFLATE text/javascript
AddOutputFilterByType DEFLATE text/html
AddOutputFilterByType DEFLATE text/xml
AddOutputFilterByType DEFLATE text/css
AddOutputFilterByType DEFLATE text/vtt
AddOutputFilterByType DEFLATE text/x-component
AddOutputFilterByType DEFLATE application/xml
AddOutputFilterByType DEFLATE application/xhtml+xml
AddOutputFilterByType DEFLATE application/rss+xml
AddOutputFilterByType DEFLATE application/js
AddOutputFilterByType DEFLATE application/javascript
AddOutputFilterByType DEFLATE application/x-javascript
AddOutputFilterByType DEFLATE application/x-httpd-php
AddOutputFilterByType DEFLATE application/x-httpd-fastphp
AddOutputFilterByType DEFLATE application/atom+xml
AddOutputFilterByType DEFLATE application/json
AddOutputFilterByType DEFLATE application/ld+json
AddOutputFilterByType DEFLATE application/vnd.ms-fontobject
AddOutputFilterByType DEFLATE application/x-font-ttf
AddOutputFilterByType DEFLATE application/font-sfnt
AddOutputFilterByType DEFLATE application/x-web-app-manifest+json
AddOutputFilterByType DEFLATE font/opentype
AddOutputFilterByType DEFLATE font/otf
AddOutputFilterByType DEFLATE font/ttf
AddOutputFilterByType DEFLATE font/sfnt
AddOutputFilterByType DEFLATE image/svg+xml
AddOutputFilterByType DEFLATE image/x-icon

# Exception: Images
SetEnvIfNoCase REQUEST_URI \.(?:gif|jpg|jpeg|png)$ no-gzip dont-vary

# Drop problematic browsers
BrowserMatch ^Mozilla/4 gzip-only-text/html
BrowserMatch ^Mozilla/4\.0[678] no-gzip
BrowserMatch \bMSI[E] !no-gzip !gzip-only-text/html

# Make sure proxies don't deliver the wrong content
<IfModule mod_headers.c>
Header append Vary User-Agent env=!dont-vary
</IfModule>

</IfModule>

# mod_gzip is an external extension and last updated 2015, so
# if available please use mod_deflate instead
# If you are stuck on Apache v1.3 you can use mod_zip to enable Gzip
# as mod_deflate is available for Apache v2 or later only.
<IfModule mod_gzip.c>
  mod_gzip_on Yes
  mod_gzip_dechunk Yes
  mod_gzip_item_include file \.(html?|txt|css|js|php|pl)$
  mod_gzip_item_include handler ^cgi-script$
  mod_gzip_item_include mime ^text/.*
  mod_gzip_item_include mime ^application/x-javascript.*
  mod_gzip_item_exclude mime ^image/.*
  mod_gzip_item_exclude rspheader ^Content-Encoding:.*gzip.*
</IfModule>


## EXPIRES CACHING ##
<IfModule mod_expires.c>
ExpiresActive On
ExpiresDefault "access plus 1 week"

ExpiresByType text/css "access plus 3 months"

ExpiresByType application/atom+xml "access plus 1 hour"
ExpiresByType application/rdf+xml "access plus 1 hour"
ExpiresByType application/rss+xml "access plus 1 hour"

ExpiresByType application/json "access plus 0 seconds"
ExpiresByType application/ld+json "access plus 0 seconds"
ExpiresByType application/schema+json "access plus 0 seconds"
ExpiresByType application/vnd.geo+json "access plus 0 seconds"
ExpiresByType application/xml "access plus 0 seconds"
ExpiresByType text/xml "access plus 0 seconds"

ExpiresByType image/x-icon "access plus 1 month"
ExpiresByType image/vnd.microsoft.icon "access plus 1 month"

ExpiresByType text/html "access plus 1 minute"

ExpiresByType text/javascript "access plus 3 months"
ExpiresByType text/x-javascript "access plus 3 months"
ExpiresByType application/javascript "access plus 3 months"
ExpiresByType application/x-javascript "access plus 3 months"

ExpiresByType image/jpg "access plus 4 months"
ExpiresByType image/jpeg "access plus 4 months"
ExpiresByType image/gif "access plus 4 months"
ExpiresByType image/png "access plus 4 months"
ExpiresByType image/svg+xml "access plus 4 months"
ExpiresByType image/bmp "access plus 4 months"
ExpiresByType image/webp "access plus 4 months"

ExpiresByType audio/ogg "access plus 4 months"

ExpiresByType video/mp4 "access plus 4 months"
ExpiresByType video/ogg "access plus 4 months"
ExpiresByType video/webm "access plus 4 months"

ExpiresByType text/plain "access plus 1 month"
ExpiresByType text/x-component "access plus 1 month"

ExpiresByType application/manifest+json "access plus 1 week"
ExpiresByType application/x-web-app-manifest+json "access plus 0 seconds"
ExpiresByType text/cache-manifest "access plus 0 seconds"

ExpiresByType application/pdf "access plus 1 month"

ExpiresByType application/x-shockwave-flash "access plus 1 month"

ExpiresByType application/vnd.ms-fontobject "access plus 1 month"
ExpiresByType font/eot "access plus 1 month"
ExpiresByType font/opentype "access plus 1 month"
ExpiresByType application/x-font-ttf "access plus 1 month"
ExpiresByType application/font-woff "access plus 3 months"
ExpiresByType application/font-woff2 "access plus 3 months"
ExpiresByType application/x-font-woff "access plus 1 month"
ExpiresByType font/woff "access plus 1 month"

</IfModule>
## EXPIRES CACHING ##
```
