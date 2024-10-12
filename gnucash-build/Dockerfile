FROM debian:unstable as builder

ARG GNUCASH_SRC_CHECKOUT=master

ENV GNUCASH_SRC_CHECKOUT=${GNUCASH_SRC_CHECKOUT}
ENV DEBIAN_FRONTEND=noninteractive
ENV LINGUAS=en

RUN apt-get update \
    && apt-get upgrade -y

# Workaround systemd installation failure on Synology. Error:
# Setting up systemd (256.7-1) ...
# Created symlink '/etc/systemd/system/getty.target.wants/getty@tty1.service' → '/usr/lib/systemd/system/getty@.service'.
# Created symlink '/etc/systemd/system/multi-user.target.wants/remote-fs.target' → '/usr/lib/systemd/system/remote-fs.target'.
# Created symlink '/etc/systemd/system/sysinit.target.wants/systemd-pstore.service' → '/usr/lib/systemd/system/systemd-pstore.service'.
# Initializing machine ID from random generator.
# Failed to take /etc/passwd lock: Invalid argument
# dpkg: error processing package systemd (--configure):
#  installed systemd package post-installation script subprocess returned error exit status 1
RUN apt-get install -y systemd \
    || (rm /var/lib/dpkg/info/systemd.postinst /var/lib/dpkg/info/systemd-timesyncd.postinst \
       && dpkg --configure -a)

RUN apt-get install -y \
    cmake \
    git \
    gettext \
    googletest \
    gtk+3.0 \
    guile-3.0 \
    guile-3.0-dev \
    g++ \
    icu-devtools \
    intltool \
    libboost-all-dev \
    libglib2.0-dev \
    libgtest-dev \
    libgmock-dev \
    libgtk-3-dev \
    libicu-dev \
    libpango1.0-dev \
    libsecret-1-dev \
    libwebkit2gtk-4.1 \
    libwebkit2gtk-4.1-dev \
    libxml++2-dev \
    libxslt1-dev \
    ninja-build \
    swig \
    xsltproc \
    zlib1g-dev

RUN git clone --verbose https://github.com/Gnucash/gnucash.git /gnucash-src \
    && cd /gnucash-src \
    && git checkout ${GNUCASH_SRC_CHECKOUT}

RUN mkdir /gnucash-build \
    && cd /gnucash-build \
    && cmake \
       -GNinja \
       -DWITH_SQL=OFF \
       -DWITH_AQBANKING=OFF \
       -DWITH_OFX=OFF \
       -DGTEST_ROOT=/usr/src/googletest \
       -DCMAKE_CXX_FLAGS="-DBOOST_UUID_RANDOM_PROVIDER_FORCE_POSIX" \
       -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
       ../gnucash-src \
    && ninja -j 1
RUN mkdir /gnucash-install \
    && cd /gnucash-build \
    && DESTDIR=/gnucash-install ninja -j 1 install

FROM debian:unstable

ARG ALPHAVANTAGE_API_KEY
ARG FINANCEAPI_API_KEY

RUN apt-get update \
    && apt-get upgrade -y

# Repeat systemd workaround on Synology
RUN apt-get install -y systemd \
    || (rm /var/lib/dpkg/info/systemd.postinst /var/lib/dpkg/info/systemd-timesyncd.postinst \
       && dpkg --configure -a)
RUN apt-get install -y \
      daemontools \
      dbus-x11 \
      g++ \
      gcc \
      guile-3.0-libs \
      libboost-all-dev \
      libfinance-quote-perl \
      libglib2.0-0t64 \
      libgtk-3.0t64 \
      libpango1.0 \
      libsecret-1-0 \
      libssl-dev \
      libwebkit2gtk-4.1 \
      libxml2 \
      libxml2-dev \
      libxslt1.1 \
      make \
      ninja-build \
      openssh-server \
      openssl \
      perl \
      zlib1g \
      zlib1g-dev

COPY --from=builder /gnucash-install /

# Configure environment for Finance::Quote by adding environment variables
ENV ALPHAVANTAGE_API_KEY ${ALPHAVANTAGE_API_KEY}
ENV FINANCEAPI_API_KEY ${FINANCEAPI_API_KEY}

# Install Finance::Quote
RUN echo yes | cpan App::cpanminus
RUN cpanm Finance::Quote JSON::Parse


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/gnucash"]
