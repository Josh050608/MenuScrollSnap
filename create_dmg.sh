#!/bin/bash

# Script to build ScrollSnap and create a DMG installer

set -e

# Configuration
APP_NAME="ScrollSnap"
SCHEME="ScrollSnap"
BUILD_DIR="build"
DMG_NAME="ScrollSnap-Installer"
VERSION="1.0"

echo "🔨 Building ${APP_NAME}..."

# Clean previous builds
rm -rf "${BUILD_DIR}"

# Build the app
xcodebuild -project ScrollSnap.xcodeproj \
    -scheme "${SCHEME}" \
    -configuration Release \
    -derivedDataPath "${BUILD_DIR}" \
    clean build

# Find the built app
APP_PATH=$(find "${BUILD_DIR}" -name "${APP_NAME}.app" -type d | head -n 1)

if [ -z "$APP_PATH" ]; then
    echo "❌ Error: Could not find ${APP_NAME}.app"
    exit 1
fi

echo "✅ Build successful: ${APP_PATH}"
echo "📦 Creating DMG installer..."

# Create DMG using create-dmg
create-dmg \
    --volname "${APP_NAME} Installer" \
    --volicon "${APP_PATH}/Contents/Resources/AppIcon.icns" \
    --window-pos 200 120 \
    --window-size 600 400 \
    --icon-size 100 \
    --icon "${APP_NAME}.app" 175 120 \
    --hide-extension "${APP_NAME}.app" \
    --app-drop-link 425 120 \
    --no-internet-enable \
    "${DMG_NAME}.dmg" \
    "${APP_PATH}"

echo "✅ DMG created successfully: ${DMG_NAME}.dmg"
echo ""
echo "You can now distribute ${DMG_NAME}.dmg to users."
echo "They can simply drag ${APP_NAME}.app to Applications to install."
