# Emacs to be runnable as a container process on Synology

```bash
docker build -t pkryger/emacs:30.1 \
    --build-arg EMACS_VERSION=30.1 \
    --build-arg SYNO_UID=$(grep -e "^${USER}:" /etc/passwd | cut -f 3 -d ':') \
    --build-arg SYNO_GID=$(grep -e "^${USER}:" /etc/passwd | cut -f 4 -d ':') \
    --build-arg SYNO_BASE="$(dirname "$(grep -e "^${USER}:" /etc/passwd | cut -f 6 -d ':')")" \
    --build-arg SYNO_USER=${USER}
```

Then run something along the lines:
```bash
docker run --rm -it \
    --volume "${HOME}:${HOME}" \
    --volume /volume1:/volume1 \
    --workdir "$(if [[ "$(pwd)/" ==  "${HOME}/"* ]] \
                    || [[ "$(pwd)/" == "/volume1/"* ]]; then 
                     pwd
                 else
                     echo ${HOME}
                 fi)" \
    --user "${USER}" \
    pkryger/emacs:30.1 emacs
```
