# Wallpapers

Using `imagemagick` remove any metadata before uploading

Use: `strip-metadata` or the manual method below

View metadata for image

```bash
identify -verbose <image_name>.<ext>
```

Clear metadata from image

```bash
mogrify -strip <image_name>.<ext>
```
