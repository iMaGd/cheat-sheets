## Commands for WordPress Media

## Remove WordPress Generated (Cropped) Images
```bash
find -type f -regex '.*-[0-9]+x[0-9]+.\(jpg\|png\|jpeg\)$'
find -type f -regex '.*-[0-9]+x[0-9]+.\(jpg\|png\|jpeg\)$' -delete
```

### Find and compress only cropped images
```bash
apt install -y pngquant jpegoptim

find -type f -regex '.*-[0-9]+x[0-9]+.\(jpg\|jpeg\)$' -exec jpegoptim -m83 -t '{}' \;
find -type f -regex '.*-[0-9]+x[0-9]+.\(png\)$' -exec pngquant --quality=70-85 --ext .png -f '{}' \;
```


## Compress All Images in a Directory Recursively
```bash
jpegoptim -m83 -t wp-content/uploads/**/**/*.jpg
pngquant --quality=70-85 --ext .png -f wp-content/uploads/**/**/*.png
```
