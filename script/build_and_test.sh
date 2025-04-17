#!/bin/bash

# Exit immediately if a command exits with a non-zero status (except in tests)
set -o errexit

# Create and enter build directory
mkdir -p build
cd build || { echo "Failed to enter build directory"; exit 1; }

# Configure and build
cmake .. && make

# Run tests and handle results
if ctest; then
    echo "\nAll tests passed.\n"
else
	echo "Tests failed."
	ctest --rerun-failed --output-on-failure
fi

# Return to project root and clean up
cd ..
rm -rf build
