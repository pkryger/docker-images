# GnuCash over SSH

This image enables running [GnuCash](https://www.gnucash.org) over SSH. It Requires
`XQuartz` to be installed on macOS.

Build arguments:
- `GNUCASH_IMAGE_VERSION`, the `gnucash` image version, i.e. `3.0-devel`.

The image can be build with the following command:
```bash
docker build -t gnucash-ssh:3.0-devel --build-arg GNUCASH_IMAGE_VERSION=3.0-devel .
```

When the container is running, GnuCash can be started with:
```bash
ssh -l gnucash -o "ForwardX11=yes" -p <CONTAINER_PORT> <CONTAINER_IP>
```
