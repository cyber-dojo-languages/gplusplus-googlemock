#!/bin/bash -Eeu

readonly GTEST_VERSION=1.10.0

apt-get install --yes cmake unzip

cd /usr/src
unzip googletest-release-${GTEST_VERSION}.zip
cd /usr/src/googletest-release-${GTEST_VERSION}
cmake .
make

apt-get remove --yes cmake unzip
mv lib/libg* /usr/lib
cp -rf googlemock/include/gmock /usr/include
cp -rf googletest/include/gtest /usr/include
