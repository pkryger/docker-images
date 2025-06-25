arg EMACS_VERSION=30.1
from silex/emacs:${EMACS_VERSION}

label com.centurylinklabs.watchtower.enable="false"
run apt-get update                              \
    && apt-get install -y                       \
        shellcheck                              \
        curl                                    \
        python3                                 \
        apt-file                                \
        g++                                     \
        gcc                                     \
        git                                     \
        libtree-sitter-dev                      \
        man                                     \
    && apt-get clean autoclean                  \
    && apt-get autoremove --yes                 \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

copy xterm-24bit.terminfo /tmp
run tic -x /tmp/xterm-24bit.terminfo \
    && rm /tmp/xterm-24bit.terminfo

env TERM=xterm-24bit
env TERMINFO=/etc/terminfo

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
