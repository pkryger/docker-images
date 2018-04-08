ARG GNUCASH_IMAGE_VERSION=latest

FROM gnucash:${GNUCASH_IMAGE_VERSION}
RUN apt-get update \
    && apt-get install -y \
       daemontools \
       openssh-server
RUN mkdir -p /etc/myservices/sshd /var/run/sshd \
    && echo "#!/bin/bash\nexec /usr/sbin/sshd" > /etc/myservices/sshd/run \
    && chmod +x /etc/myservices/sshd/run \
    && sed -i -e 's/.\?X11UseLocalhost.*/X11UseLocalhost no/' /etc/ssh/sshd_config
RUN useradd -m -s /usr/bin/gnucash gnucash \
    && echo 'gnucash:gnucash' | chpasswd
EXPOSE 22
ENTRYPOINT ["/usr/bin/svscan", "/etc/myservices/"]
