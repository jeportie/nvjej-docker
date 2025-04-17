#!/bin/bash

# Create and enter build directory
mkdir -p build
cd build || { echo "Failed to enter build directory"; exit 1; }

# Configure and build
cmake .. && make

# Run tests and handle results
if ctest; then
    echo "\nAll tests passed.\n"
	cd ..
	rm -rf build
else
	echo "Tests failed."
	ctest --rerun-failed --output-on-failure
	cd ..
	rm -rf build
fi

# Return to project root and clean up
# cd ..
# rm -rf build
