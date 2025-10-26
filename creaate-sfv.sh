#!/bin/bash
# Usage: ./create-sfv.sh /path/to/release/directory

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/release"
    exit 1
fi

cd "$1" || exit 1
RELEASE_NAME=$(basename "$PWD")
SFV_FILE="${RELEASE_NAME}.sfv"

# Remove old SFV if exists
rm -f *.sfv

# Get all files except NFO and SFV
FILES=$(find . -maxdepth 1 -type f ! -name "*.nfo" ! -name "*.sfv" ! -name ".*" -printf "%f\n" | sort)

if [ -z "$FILES" ]; then
    echo "No files found to add to SFV!"
    exit 1
fi

echo "Generating SFV for $(echo "$FILES" | wc -l) files..."

# Use cksfv (more reliable for SFV format)
cksfv -b $FILES > "$SFV_FILE"

if [ -s "$SFV_FILE" ]; then
    echo "Created: $SFV_FILE ($(wc -l < $SFV_FILE) files)"
    ls -lh "$SFV_FILE"
else
    echo "Error: SFV creation failed!"
    exit 1
fi
