# Build development version of GnuCash

This is a `Dockerfile` that builds a [GnuCash](https://www.gnucash.org) from
the source as published in [GitHub repository](https://github.com/Gnucash/gnucash).
It was originally designed to serve as a basic image for other images, as in sibling
directories

It has been written using build instructions from
[GnuCash Wiki](https://wiki.gnucash.org/wiki/Building#Ubuntu_16.04_LTS_.28Xenial_Xerus.29).

The build requires two arguments:
- `GNUCASH_SRC_CHECKOUT` the name of the tag to be passed to checkout git
  source, i.e., `3.0`. Default: `master`.
- `ALPHAVANTAGE_API_KEY` the key to use to connect to
  [Alpha Vantage](https://www.alphavantage.co) to get finance quotes. Although it is
  possible to enter the key in GUI menu, specifying it when building image allows
  the GnuCash to be run in headless mode.

The image can be built with the following instruction:

```bash
docker build -t gnucash:3.0-devel --build-arg ALPHAVANTAGE_API_KEY=<YOUR_KEY> --build-arg GNUCASH_SRC_CHECKOUT=3.0 .
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
docker run --rm -d -e DISPLAY=<YOUR_IP>:0 gnucash:3.0-devel
```

in XQaurtz's terminal. See the
[The Containerizers' video](https://www.youtube.com/watch?v=PKyj8sbZNYw) for details.
