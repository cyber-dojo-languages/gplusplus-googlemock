set -e
rm -f coverage.txt
make
gcovr -r . > coverage.txt
echo "Created coverage.txt"

