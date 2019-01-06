FROM ubuntu:devel

ARG ALPHAVANTAGE_API_KEY

RUN apt-get update \
    && apt-get install -y \
    gnucash

# Gnucash fixups:
# - Add the AlphaVantage API key (use the legacy method, it seems to be OK in
#   gnucash 3.0),
# - Make sure the 'Finance::Quote' is up to date
ENV ALPHAVANTAGE_API_KEY ${ALPHAVANTAGE_API_KEY}
RUN echo "ALPHAVANTAGE_API_KEY=${ALPHAVANTAGE_API_KEY}" >> /etc/gnucash/environment \
    && gnc-fq-update
ENTRYPOINT ["/usr/bin/gnucash"]
