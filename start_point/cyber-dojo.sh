set -e

[ -e report/coverage.txt ] && rm report/coverage.txt
mkdir -p report
make
gcovr --root . > report/coverage.txt
