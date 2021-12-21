# trivy-image-checker

## Install trivy

```
./trivy-installer.sh
```

## Generate a new report

You have two options available

### Scan a single image

Generate the report running:

```
./generate-report.sh -i bitnami/wordpress
```

### Scan multiple images

You can provide a file with multiple image names using the flag -f:

```
./generate-report.sh -f multiple_images
```

This file should contain the images separated in new lines:

```
ubuntu
bitnami/wordpress
bitnami/mysql
```
