# Build development version of GnuCash

This is a `Dockerfile` that builds a [GnuCash](https://www.gnucash.org) from
the source as published in [GitHub repository](https://github.com/Gnucash/gnucash).
It was originally designed to serve as a basic image for other images, as in sibling
directories

It has been written using build instructions from
[GnuCash Wiki](https://wiki.gnucash.org/wiki/Building#Ubuntu_16.04_LTS_.28Xenial_Xerus.29).

The build requires following arguments:
- `GNUCASH_SRC_CHECKOUT` the name of the tag to be passed to checkout git
  source, i.e., `5.9`. Default: `master`.
- `ALPHAVANTAGE_API_KEY` the key to use to fetch quotes from
  [Alpha Vantage](https://www.alphavantage.co).
- `FINANCEAPI_API_KEY` the key to fetch quotes from [Yahoo! Finance](finance.yahoo.com).

Although it is possible to enter the key in GUI menu, specifying it when building image allows the GnuCash to be run in headless mode.

The image can be built with the following instruction:

```bash
docker build -t gnucash:5.9-devel --build-arg ALPHAVANTAGE_API_KEY=<YOUR_KEY> --build-arg FINANCEAPI_API_KEY=<YOUR_KEY> --build-arg GNUCASH_SRC_CHECKOUT=5.9 .
```

To run the container on macOS, the following dependencies are required:
- `socat`
- `XQuartz`

Both are available in [Homebrew](https://brew.sh). Then it can be run with:

```bash
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```
in any terminal (it blocks the console), followed by

```bash
docker run --rm -d -e DISPLAY=<YOUR_IP>:0 gnucash:5.9-devel
```

in XQaurtz's terminal. See the
[The Containerizers' video](https://www.youtube.com/watch?v=PKyj8sbZNYw) for details.
