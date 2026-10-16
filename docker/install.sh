#!/bin/bash -Eeu

# Appends one test framework to the test_frameworks list the base image
# wrote in /versions.json, keeping any entry an earlier image added. Stops
# the build if the list is not found, rather than record nothing.
add_test_framework()
{
  local -r name="${1}"
  local -r version="${2}"
  local -r entry="{\"name\": \"${name}\", \"version\": \"${version}\"}"
  if grep --quiet '"test_frameworks": \[\]' /versions.json; then
    sed -i "s|\"test_frameworks\": \[\]|\"test_frameworks\": [${entry}]|" /versions.json
  else
    sed -i "/\"test_frameworks\": \[/s|}\]|}, ${entry}]|" /versions.json
  fi
  if ! grep --quiet --fixed-strings "${entry}" /versions.json; then
    echo "Could not add ${name} to /versions.json" >&2
    cat /versions.json >&2
    exit 1
  fi
}

# Install the newest GoogleTest release, which holds GoogleMock. GitHub
# redirects releases/latest to the newest release's tag, which is resolved
# here at build time so a rebuild picks up the next release by itself.
readonly GTEST_LATEST_URL=$(curl --silent --fail --output /dev/null --write-out '%{redirect_url}' \
  https://github.com/google/googletest/releases/latest)
readonly GTEST_TAG="${GTEST_LATEST_URL##*/}"

# An empty tag means the redirect could not be read or has changed shape,
# not that GoogleTest stopped releasing, so stop rather than install nothing.
if [ -z "${GTEST_TAG}" ]; then
  echo 'Found no GoogleTest release tag at github.com/google/googletest' >&2
  exit 1
fi

apt-get update
apt-get install --yes cmake

cd /usr/src
curl --silent --fail --location \
  "https://github.com/google/googletest/archive/refs/tags/${GTEST_TAG}.tar.gz" \
  | tar --extract --gzip
cd "googletest-${GTEST_TAG#v}"
cmake -S . -B build
cmake --build build

apt-get remove --yes cmake
mv build/lib/libg* /usr/lib
cp -rf googlemock/include/gmock /usr/include
cp -rf googletest/include/gtest /usr/include
cd /usr/src
rm -rf "googletest-${GTEST_TAG#v}"

add_test_framework GoogleMock "${GTEST_TAG#v}"
cat /versions.json
