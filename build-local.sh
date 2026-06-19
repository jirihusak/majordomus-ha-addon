#!/bin/bash
# Local development build script
# Usage: ./build-local.sh [arch] [path-to-MajordomusControl]
#
# arch:    amd64 (default), aarch64, armv7
# source:  path to MajordomusControl directory
#          default: ../../majordomus-develop/SW/MajordomusControl  (relative to this script)

set -e

ARCH=${1:-amd64}
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="${2:-$(realpath "$SCRIPT_DIR/../../majordomus-develop/SW/MajordomusControl")}"
ADDON_DIR="$SCRIPT_DIR/majordomus-control"

if [ ! -d "$SOURCE_DIR/src" ]; then
    echo "ERROR: Source not found at: $SOURCE_DIR"
    echo "Usage: $0 [arch] [path-to-MajordomusControl]"
    exit 1
fi

echo "Source : $SOURCE_DIR"
echo "Arch   : $ARCH"
echo ""

echo "Copying source into build context..."
cp -r "$SOURCE_DIR/src"    "$ADDON_DIR/"
cp    "$SOURCE_DIR/pom.xml" "$ADDON_DIR/"

echo "Building Docker image majordomus-control-${ARCH}:dev ..."
docker build \
    --build-arg "BUILD_FROM=ghcr.io/home-assistant/${ARCH}-base:latest" \
    --platform "linux/${ARCH}" \
    -t "majordomus-control-${ARCH}:dev" \
    "$ADDON_DIR"

echo "Cleaning up build context..."
rm -rf "$ADDON_DIR/src" "$ADDON_DIR/pom.xml"

echo ""
echo "Done!  Image: majordomus-control-${ARCH}:dev"
