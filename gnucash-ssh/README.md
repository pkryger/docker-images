# GnuCash over SSH

This image enables running [GnuCash](https://www.gnucash.org) over SSH. It Requires
`XQuartz` to be installed on macOS.

Build arguments:
- `GNUCASH_IMAGE_VERSION`, the `gnucash` image version, i.e. `3.0-devel`.

The image can be build with the following command:
```bash
docker build -t gnucash-ssh:3.0-devel --build-arg GNUCASH_IMAGE_VERSION=3.0-devel .
```

The image uses `gnucash` user to run `GnuCash` and in case it will need access to
data outside of the container some host accessible volume should be mounted.
Such a volume can be created with:
```bash
docker volume create --driver local --name gnucash-data --opt type=none --opt device=/my/gnucash/files/are/here --opt o=uid=root,gid=root --opt o=bind
```

Then the container can be created and run with:
```bash
docker run -d --name gnucash-ssh1 -p <HOST_PORT>:22 -v gnucash-data:/home/gnucash/data gnucash-ssh:3.0-devel
```

When the container is running, `GnuCash` can be started with:
```bash
ssh -l gnucash -o "ForwardX11=yes" -p <HOST_PORT> -Y <HOST_IP>
```
