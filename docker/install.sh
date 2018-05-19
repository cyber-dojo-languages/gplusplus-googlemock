#!/bin/bash
set -e

readonly GTEST_VERSION=1.8.0

apt-get update
apt-get install --yes wget cmake unzip

cd /usr/src
unzip googletest-release-${GTEST_VERSION}.zip
cd /usr/src/googletest-release-${GTEST_VERSION}
cmake .
make
mv googlemock/libg* /usr/lib
mv googlemock/gtest/libg* /usr/lib
cp -rf googlemock/include/gmock /usr/include
cp -rf googletest/include/gtest /usr/include

apt-get remove --yes wget cmake unzip
