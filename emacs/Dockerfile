from nixos/nix as builder

# Emacs build like in in https://github.com/Silex/docker-emacs/blob/3e24a9a/dockerfiles/debian/Dockerfile#L1-L6
# But then used a method as described in https://mitchellh.com/writing/nix-with-dockerfiles
arg EMACS_VERSION=emacs-30-1
run nix build                                           \
    --extra-experimental-features "nix-command flakes"  \
    --impure                                            \
    nixpkgs#cacert                                      \
    nixpkgs#cmake                                       \
    nixpkgs#curl                                        \
    nixpkgs#difftastic                                  \
    nixpkgs#direnv                                      \
    nixpkgs#findutils                                   \
    nixpkgs#gcc                                         \
    nixpkgs#git                                         \
    nixpkgs#gnumake                                     \
    nixpkgs#iconv                                       \
    nixpkgs#jq                                          \
    nixpkgs#less                                        \
    nixpkgs#man                                         \
    nixpkgs#nix-zsh-completions                         \
    nixpkgs#oh-my-zsh                                   \
    nixpkgs#openssh                                     \
    nixpkgs#perl                                        \
    nixpkgs#python313                                   \
    nixpkgs#python313Packages.pip                       \
    nixpkgs#ripgrep                                     \
    nixpkgs#ruby                                        \
    nixpkgs#ruff                                        \
    nixpkgs#shellcheck                                  \
    nixpkgs#silver-searcher                             \
    nixpkgs#wget                                        \
    nixpkgs#which                                       \
    nixpkgs#zsh                                         \
    nixpkgs#zsh-autopair                                \
    nixpkgs#zsh-autosuggestions                         \
    nixpkgs#zsh-fast-syntax-highlighting                \
    nixpkgs#zsh-powerlevel10k                           \
    nixpkgs#emacs-nox

run mkdir /tmp/nix-store-closure && \
    cp -uR $(nix-store -qR result*/) /tmp/nix-store-closure

run mkdir /tmp/nix-result && \
    cp -uR result*/* /tmp/nix-result

from debian

label com.centurylinklabs.watchtower.enable="false"

copy --from=builder /tmp/nix-store-closure /nix/store
copy --from=builder /tmp/nix-result /opt/nix
env PATH="/opt/nix/bin${PATH:+:${PATH}}"
env MANPATH="/opt/nix/man${MANPATH:+:${MANPATH}}"

# Link certificates from nixpkgs#cacert to system root and export environment
# variables
run ln -s /opt/nix/etc/ssl /etc/
env SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
env GIT_SSL_CAINFO=${SSL_CERT_FILE}
env CURL_CA_BUNDLE=${SSL_CERT_FILE}
env NIX_SSL_CERT_FILE=${SSL_CERT_FILE}

# Ensure Emacs can display plenty of colours
copy xterm-24bit.terminfo /tmp
run tic -x /tmp/xterm-24bit.terminfo \
    && rm /tmp/xterm-24bit.terminfo
env TERMINFO=/etc/terminfo
env TERM=xterm-24bit

# Replicate the same user and group as in Synology
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

# Install fancy ZSH configuration
env ZSH=/opt/nix/share/oh-my-zsh
run mkdir -p ${SYNO_BASE}/${SYNO_USER} &&                                                   \
    ln -s /opt/nix/share/zsh-powerlevel10k /opt/nix/share/powerlevel10k &&                  \
    ln -s /opt/nix/share/zsh/zsh-autopair /opt/nix/share/zsh-autopair &&                    \
    curl -L https://iterm2.com/shell_integration/zsh                                        \
        -o ${SYNO_BASE}/${SYNO_USER}/.iterm2_shell_integration.zsh &&                       \
    curl -L https://raw.githubusercontent.com/pkryger/dotfiles/refs/heads/main/.p10k.zsh    \
        -o ${SYNO_BASE}/${SYNO_USER}/.p10k.zsh &&                                           \
    curl -L https://raw.githubusercontent.com/pkryger/dotfiles/refs/heads/main/.zshrc       \
        -o ${SYNO_BASE}/${SYNO_USER}/.zshrc &&                                              \
    chown -R ${SYNO_USER}:${SYNO_GID} ${SYNO_BASE}/${SYNO_USER}

cmd [ "/opt/nix/bin/zsh" ]
