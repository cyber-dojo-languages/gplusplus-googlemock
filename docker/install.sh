#!/bin/bash
set -e

readonly GMOCK_VERSION=1.7.0

cd /usr/src

apt-get update
apt-get install --yes wget cmake unzip

#WAS wget http://googlemock.googlecode.com/files/gmock-1.7.0.zip
wget http://pkgs.fedoraproject.org/repo/pkgs/gmock/gmock-${GMOCK_VERSION}.zip/073b984d8798ea1594f5e44d85b20d66/gmock-${GMOCK_VERSION}.zip
unzip gmock-${GMOCK_VERSION}.zip

cd /usr/src/gmock-${GMOCK_VERSION}
cmake DCMAKE_CXX_FLAGS='-Wno-unused-local-typedefs' .
make
mv libg* /usr/lib
cp -rf include/gmock /usr/include

cd /usr/src/gmock-${GMOCK_VERSION}/gtest
mv libg* /usr/lib
cp -rf include/gtest /usr/include

apt-get remove --yes wget cmake unzip
