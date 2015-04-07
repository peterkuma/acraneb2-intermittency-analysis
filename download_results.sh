#!/bin/sh
set -e

REPO=
mkdir -p results
cd results

curl -O "$REPO/shortwave-intermittency-base.nc.bz2"
curl -O "$REPO/shortwave-intermittency-1h.nc.bz2"

tar xjf shortwave-intermittency-base.nc.bz2
tar xjf shortwave-intermittency-1h.nc.bz2
