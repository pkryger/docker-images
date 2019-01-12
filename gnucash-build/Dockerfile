FROM ubuntu:devel as builder

ARG GNUCASH_SRC_CHECKOUT=master

ENV GNUCASH_SRC_CHECKOUT=${GNUCASH_SRC_CHECKOUT}
ENV DEBIAN_FRONTEND=noninteractive
ENV LINGUAS=en

RUN apt-get update \
    && apt-get install -y \
    cmake \
    git \
    google-mock \
    gtk+3.0 \
    guile-2.2 \
    guile-2.2-dev \
    icu-devtools \
    intltool \
    libboost-all-dev \
    libdbd-mysql \
    libdbi-dev \
    libglib2.0-dev \
    libgtest-dev \
    libgtk-3-dev \
    libicu-dev \
    libltdl-dev \
    libtool \
    libwebkit2gtk-4.0-37 \
    libwebkit2gtk-4.0-dev \
    libxml++2.6-dev \
    libxslt1-dev \
    make \
    swig \
    xsltproc

# TODO: likely will be needed when add ing aqbanking and ofx, merge to above list
#RUN apt-get install -y libaqbanking-dev
#RUN apt-get install -y libofx-dev

RUN git clone --verbose https://github.com/Gnucash/gnucash.git /gnucash-src \
    && cd /gnucash-src \
    && git checkout ${GNUCASH_SRC_CHECKOUT}

RUN mkdir /gnucash-build \
    && cd /gnucash-build \
    && cmake \
       -DCMAKE_INSTALL_PREFIX=/usr \
       -DWITH_AQBANKING=OFF \
       -DWITH_OFX=OFF ../gnucash-src \
    && make -j 8
RUN mkdir /gnucash-install \
    && cd /gnucash-build \
    && make -j 8 install DESTDIR=/gnucash-install

FROM ubuntu:devel

ARG ALPHAVANTAGE_API_KEY

RUN apt-get update \
    && apt-get install -y \
       daemontools \
       dbus-x11 \
       guile-2.2-libs \
       libboost-all-dev \
       libdbi1 \
       libfinance-quote-perl \
       libglib2.0-0 \
       libgtk-3.0 \
       libwebkit2gtk-4.0-37 \
       libxslt1.1 \
       make \
       openssh-server \
       perl

COPY --from=builder /gnucash-install /

# Gnucash fixups:
# - Add the AlphaVantage API key (use the legacy method, it seems to be OK in
#   gnucash 3.0),
# - Compile schemas to fix the
#   "Settings schema 'org.gtk.Settings.FileChooser' is not installed" issue,
#   as apparently schemas are recompiled during build.
# - Make sure the 'Finance::Quote' is up to date
ENV ALPHAVANTAGE_API_KEY ${ALPHAVANTAGE_API_KEY}
RUN echo "ALPHAVANTAGE_API_KEY=${ALPHAVANTAGE_API_KEY}" >> /etc/gnucash/environment \
    && glib-compile-schemas /usr/share/glib-2.0/schemas \
    && gnc-fq-update
ENTRYPOINT ["/usr/bin/gnucash"]
