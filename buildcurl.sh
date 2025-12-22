#!/bin/bash

# This script builds libcurl for local use in the PHP build.
# Downloads, configures, and installs libcurl into a local dist-install directory.

set -e
set -x

if [[ $(uname -m) == "arm64" ]]; then
    arch="arm64"
elif [[ $(uname -m) == "x86_64" ]]; then
    arch="x86_64"
else
    echo "Unknown architecture"
    exit 1
fi

root_dir=$(realpath $(dirname $0))
cd $root_dir/php-$arch/

# Download curl sources if not already present
if [ ! -d "curl-*" ]; then
    curl -LO https://curl.se/download/curl-8.7.1.tar.gz
    tar -xzf curl-8.7.1.tar.gz
fi

cd curl-*/

./configure --prefix=$(pwd)/dist-install --with-ssl
make -j$(nproc)
make install

# Copier la bibliothèque dynamique à la racine du projet
cp ./dist-install/lib/libcurl*.dylib "$root_dir/libcurl.dylib"

echo "libcurl built and installed locally."
