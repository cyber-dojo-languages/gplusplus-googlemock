#!/bin/bash
# Invoked as [bash build_pch.sh], and that ignores the shebang line, so the
# shell options have to be set here to have any effect.
set -Eeu -o pipefail

# Precompiles <gmock/gmock.h>, which is most of what a [test] press spends its
# time parsing. The .gch sits beside the header in the image's include path,
# which is where gcc looks for it, and nowhere near a kata's own files.
#
# The flags below must match the start-point makefile's CXXFLAGS. gcc does not
# fail when they disagree; it ignores the .gch and every run is merely as slow
# as it was before, which is the kind of regression nobody notices. The check at
# the end is what turns that silence into a failed build.

readonly HEADER=/usr/include/gmock/gmock.h
readonly FLAGS='-std=c++2a -Wpedantic -Wall -Wextra -O0 -fprofile-arcs -ftest-coverage'

g++ -x c++-header ${FLAGS} "${HEADER}" -o "${HEADER}.gch"
ls --format=long "${HEADER}.gch"

# Compile a throwaway source the way a kata is compiled, and ask gcc to name the
# headers it reads. A .gch it actually used is listed with a leading [!].
readonly PROBE=/tmp/pch_probe.cpp
printf '#include <gmock/gmock.h>\nint main() { return 0; }\n' > "${PROBE}"

# Held in a variable rather than piped into grep. Under pipefail, [grep -q]
# closing the pipe on its first match leaves gcc killed by SIGPIPE, and the
# whole pipeline then reports a failure that never happened.
readonly HEADERS_READ=$(g++ -Winvalid-pch -include gmock/gmock.h ${FLAGS} -H -c "${PROBE}" -o /tmp/pch_probe.o 2>&1)

if grep -q '^! .*gmock\.h\.gch' <<< "${HEADERS_READ}"; then
  echo 'PRECOMPILED HEADER CONFIRMED in use'
else
  >&2 echo 'The precompiled header was built but gcc did not use it.'
  >&2 echo 'Most likely the flags here and in the start-point makefile have drifted apart.'
  exit 42
fi

rm -f "${PROBE}" /tmp/pch_probe.o
