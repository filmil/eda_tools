#! /bin/bash
set -oe pipefail
set -x

cp -R "/install/nvc" "/output"
cp -R "/lib/x86_64-linux-gnu" "/output"
