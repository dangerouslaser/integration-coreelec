#!/bin/bash
# Build script for CoreELEC integration for Unfolded Circle Remote 3
# Creates ARM64 binary using PyInstaller in Docker

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Build configuration
IMAGE="docker.io/unfoldedcircle/r2-pyinstaller:3.11.13"
OUTPUT_NAME="intg-coreelec"

echo "Building CoreELEC integration for ARM64..."

# Check if running on ARM64 natively or need QEMU emulation
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    PLATFORM_FLAG=""
    echo "Running on ARM64 natively"
else
    PLATFORM_FLAG="--platform=aarch64"
    echo "Running on $ARCH - using QEMU emulation for ARM64"
fi

# Run PyInstaller in Docker
docker run --rm \
    $PLATFORM_FLAG \
    --user="$(id -u):$(id -g)" \
    -v "$SCRIPT_DIR":/workspace \
    -w /workspace \
    "$IMAGE" \
    bash -c "
        pip install --user -r requirements.txt && \
        python -m PyInstaller \
            --clean \
            --onedir \
            --name $OUTPUT_NAME \
            --noconfirm \
            src/driver.py
    "

echo ""
echo "Build complete!"
echo "Output: $SCRIPT_DIR/dist/$OUTPUT_NAME/"
echo ""
echo "To deploy to the Remote:"
echo "1. Copy the dist/$OUTPUT_NAME/ folder to the Remote"
echo "2. Install via Web Configurator > Integrations > Add new > Install custom"
