#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Change directory to the directory containing this script
cd "$(dirname "$0")"

# Check if the --clean, --no-build, or help flags are present in the arguments and fail on unknown arguments
CLEAN=false
NO_BUILD=false

show_help() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --clean     Save build/Makefile, delete build/ directory, re-create it, and restore the Makefile as a symlink"
    echo "  --no-build  Skip running the build command (make install) at the end"
    echo "  -h, --help  Show this help message and exit"
}

for arg in "$@"; do
    if [ "$arg" = "--clean" ]; then
        CLEAN=true
    elif [ "$arg" = "--no-build" ]; then
        NO_BUILD=true
    elif [ "$arg" = "-h" ] || [ "$arg" = "--help" ]; then
        show_help
        exit 0
    else
        echo "Error: Unknown argument '$arg'" >&2
        echo "Use -h or --help for usage information." >&2
        exit 1
    fi
done

# If --clean is present, save the Makefile, delete and re-create build/, then restore the Makefile
if [ "$CLEAN" = true ]; then
    # If build/Makefile exists and is a regular file (not a symlink), move it to repository root
    if [ -f "build/Makefile" ] && [ ! -L "build/Makefile" ]; then
        mv build/Makefile Makefile.build
    fi
    
    # Delete the build/ directory
    rm -rf build
    
    # Re-create build/
    mkdir -p build
    
    # If Makefile.build exists in the repository root, symlink it in build/
    if [ -f "Makefile.build" ]; then
        ln -sf ../Makefile.build build/Makefile
    fi
fi

if [ "$NO_BUILD" = true ]; then
    exit 0
fi

# Run the build command
cd build
exec make install -j12 2>log.txt
