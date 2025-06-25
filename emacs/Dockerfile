arg EMACS_VERSION=30.1
from silex/emacs:${EMACS_VERSION}

label com.centurylinklabs.watchtower.enable="false"
run apt-get update                              \
    && apt-get install -y                       \
        g++                                     \
        gcc                                     \
        git                                     \
        libtree-sitter-dev                      \
        man                                     \
    && apt-get clean autoclean                  \
    && apt-get autoremove --yes                 \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

arg SYNO_GID
arg SYNO_UID
arg SYNO_BASE
arg SYNO_USER
run if [ ! "$(grep -e "[^:]\+:[^:]\+:${SYNO_GID}:.*" /etc/group)" ];    \
    then                                                                \
        groupadd --gid ${SYNO_GID} syno_users;                          \
    fi                                                                  \
    && useradd                                                          \
        --base-dir ${SYNO_BASE}                                         \
        --gid ${SYNO_GID}                                               \
        --uid ${SYNO_UID}                                               \
        ${SYNO_USER}
